import 'dart:convert';
import 'dart:io';

import 'package:empire_ios/DesktopVersion/desktopWeb.dart';
import 'package:empire_ios/pdfView/pdfView.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static void createPdfAndView({required dynamic ORDER, required BuildContext context}) async {
    kIsWeb ? null : Myf.showBlurLoading(context);
    File? f;
    if ("${ORDER["ACTYPE"]}".contains("AGENCY")) {
      f = await createOrderPdfAgency(ORDER: ORDER, Builcontext: context);
    } else {
      f = await createOrderPdf(ORDER: ORDER, context: context);
    }
    kIsWeb ? null : Navigator.pop(context);

    kIsWeb ? null : openFile(context, f!);
  }

  static Future<File?> createOrderPdfAgency({required dynamic ORDER, required BuildContext Builcontext}) async {
    List<dynamic> orderProductList = ORDER["billDetails"];
    dynamic partyObj = ORDER["partyObj"];
    dynamic maincompanyObj = ORDER["maincompanyObj"];
    dynamic ccdObj = ORDER["ccdObj"];

    // dynamic maincompanyObj = {};
    kIsWeb ? null : Myf.showBlurLoading(Builcontext);
    final pdf = pw.Document();
    int sr = 0;
    double PCS = 0;
    // final buffer = (await rootBundle.load('assets/img/mainapp.jpeg')).buffer.asUint8List();
    // final memoryImage =MemoryImage(buffer);
    pdf.addPage(pw.Page(
      build: (context) => pw.Column(children: [
        pw.Expanded(
          child: pw.Column(children: [
            pw.Container(
                height: 80,
                // color: PdfColor.fromHex("#000000"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Row(children: [pw.Text("${maincompanyObj["FIRM"]}", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["ADDRESS1"]},${maincompanyObj["ADDRESS2"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["CITY1"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["CPINNO"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("GSTIN:-${maincompanyObj["COMPANY_GSTIN"]}                      ", style: pw.TextStyle(fontSize: 10)),
                            pw.Text("WHATSAPP NO:- ${maincompanyObj["MOBILE"]}", style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    // pw.Image(pw.MemoryImage(buffer), width: 100)
                  ],
                )),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("ORDER FORM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                summeryRow("ORDER NO : ", "${ORDER["OrderNo"]} "),
                summeryRow("ORDER DATE : ", "${Myf.dateFormate(ORDER["BK_DATE"])}"),
              ],
            ),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Container(
                width: MediaQuery.of(Builcontext).size.width * .5,
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  summeryRow("CUSTOMER : ", "${ORDER["partyname"]} "),
                  summeryRow("", "${partyObj["AD1"]},${partyObj["AD2"]} "),
                  summeryRow("", "${ORDER["city"]} "),
                  summeryRow("", "${partyObj["PNO"]} , GSTIN : ${ORDER["GST"] ?? partyObj["GST"]}"),
                ]),
              ),
              pw.Container(width: 1, height: 50, color: PdfColor.fromHex("#000000")),
              pw.Container(
                width: MediaQuery.of(Builcontext).size.width * .5,
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  summeryRow("SUPPLIER : ", "${ORDER["ccd"]} "),
                  summeryRow("", "${ccdObj["AD1"]},${ccdObj["AD2"]} "),
                  summeryRow("", "${ccdObj["city"]} "),
                  summeryRow("", "${ccdObj["PNO"]} , GSTIN : ${ccdObj["GST"]}"),
                ]),
              )
            ]),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                summeryRow("BOOKING : ", "${ORDER["BK_STATION"]} "),
                summeryRow("TRANSPORT", "${ORDER["BK_TRANSPORT"]}"),
              ]),
              // pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              //   summeryRow("SUPPLIER : ", "${ORDER["ccd"]} "),
              //   summeryRow("", "${ccdObj["AD1"]},${ccdObj["AD2"]} "),
              // ]),
            ]),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Container(
              height: 900,
              child: pw.Table.fromTextArray(
                context: context,
                border: null,

                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                // cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerRight,
                  6: pw.Alignment.centerRight,
                },
                headers: ["SR", "PRODUCT NAME", "PCS", "RATE", "PACK", "RMK"],
                data: orderProductList.map((d) {
                  sr += 1;
                  PCS = Myf.convertToDouble('${d["qty"]}');
                  return [
                    "${sr}",
                    "${d["qualname"]}",
                    "${d["qty"]}",
                    "${d["rate"]}",
                    "${(d["ptype"])}",
                    "${(d["productRemark"])}",
                  ];
                }).toList(),
              ),
            ),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Container(
                child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  // pw.Text("Summery", style: pw.TextStyle(fontSize: 20)),
                  pw.Text("ORDER REMARK", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Container(
                    width: 200,
                    height: 100,
                    decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(10)),
                    child: pw.Text("${ORDER["rmk"] ?? ""} "),
                  )
                ]),
                pw.Container(
                    // height: 200,
                    // color: PdfColor.fromHex("#808080"),
                    child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    summeryTotal("COUNT : ", "${sr} "),
                    pw.Container(width: 200, child: pw.Divider(color: PdfColor.fromHex("#000000"))),
                    summeryTotal("PCS : ", "${PCS} "),
                  ],
                )),
              ],
            )),
          ]),
        ),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          summeryRow("REMARK: ", "${ORDER["RMK"]} "),
          pw.Container(
              margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("For : ", style: pw.TextStyle(fontSize: 15)),
                pw.Text(" : ${maincompanyObj["FIRM"]}",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ))
              ]))
        ]),
        pw.Divider(color: PdfColor.fromHex("#000000")),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("CHECKED BY${ORDER["confirmedBy"]}", style: pw.TextStyle(fontSize: 10)),
          pw.Text("ORDER BY", style: pw.TextStyle(fontSize: 10)),
          pw.Text("AUTH. SIGNATORY", style: pw.TextStyle(fontSize: 10)),
        ])
      ]),
    ));
    var f = await saveDocument(Builcontext, name: "ORDER NO-${ORDER["OrderNo"]} .pdf", pdf: pdf);
    Navigator.pop(Builcontext);
    return f;
  }

  static Future<File?> createOrderPdf({required dynamic ORDER, required BuildContext context}) async {
    List<dynamic> orderProductList = ORDER["billDetails"];
    dynamic partyObj = ORDER["partyObj"];
    dynamic maincompanyObj = ORDER["maincompanyObj"];

    // dynamic maincompanyObj = {};
    kIsWeb ? null : Myf.showBlurLoading(context);
    final pdf = pw.Document();
    int sr = 0;
    double PCS = 0;
    // final buffer = (await rootBundle.load('assets/img/mainapp.jpeg')).buffer.asUint8List();
    // final memoryImage =MemoryImage(buffer);
    pdf.addPage(pw.Page(
      build: (context) => pw.Column(children: [
        pw.Expanded(
          child: pw.Column(children: [
            pw.Container(
                height: 80,
                // color: PdfColor.fromHex("#000000"),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Row(children: [pw.Text("${maincompanyObj["FIRM"]}", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["ADDRESS1"]},${maincompanyObj["ADDRESS2"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["CITY1"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(children: [pw.Text("${maincompanyObj["CPINNO"]}", style: pw.TextStyle(fontSize: 10))]),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("GSTIN:-${maincompanyObj["COMPANY_GSTIN"]}                      ", style: pw.TextStyle(fontSize: 10)),
                            pw.Text("WHATSAPP NO:- ${maincompanyObj["MOBILE"]}", style: pw.TextStyle(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                    // pw.Image(pw.MemoryImage(buffer), width: 100)
                  ],
                )),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("ORDER FORM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                summeryRow("ORDER NO : ", "${ORDER["OrderNo"]} "),
                summeryRow("ORDER DATE : ", "${Myf.dateFormate(ORDER["BK_DATE"])}"),
              ],
            ),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                summeryRow("M/S : ", "${partyObj["partyname"]} "),
                summeryRow("", "${partyObj["AD1"]},${partyObj["AD2"]} "),
                summeryRow("", "${ORDER["city"]} "),
                summeryRow("", "${partyObj["PNO"]} , GSTIN : ${partyObj["GST"]}"),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                summeryRow("TRASNPORT: ", "${ORDER["BK_TRANSPORT"]} "),
                summeryRow("BOOKING: ", "${ORDER["BK_STATION"]} "),
                summeryRow("BROKER: ", "${ORDER["broker"]} "),
                summeryRow("HASTE: ", "${ORDER["haste"]} "),
              ]),
            ]),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Container(
              height: 900,
              child: pw.Table.fromTextArray(
                context: context,
                border: null,

                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                // cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerRight,
                  6: pw.Alignment.centerRight,
                },
                headers: ["SR", "PRODUCT NAME", "PCS", "RATE", "PACK", "RMK"],
                data: orderProductList.map((d) {
                  sr += 1;
                  PCS = double.parse('${d["qty"]}');
                  return [
                    "${sr}",
                    "${d["qualname"]}",
                    "${d["qty"]}",
                    "${d["rate"]}",
                    "${(d["ptype"])}",
                    "${(d["productRemark"])}",
                  ];
                }).toList(),
              ),
            ),
            pw.Divider(color: PdfColor.fromHex("#000000")),
            pw.Container(
                child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  // pw.Text("Summery", style: pw.TextStyle(fontSize: 20)),
                  pw.Text("ORDER REMARK", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Container(
                    width: 200,
                    height: 100,
                    decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(10)),
                    child: pw.Text("${ORDER["rmk"] ?? ""} "),
                  )
                ]),
                pw.Container(
                    // height: 200,
                    // color: PdfColor.fromHex("#808080"),
                    child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    summeryTotal("COUNT : ", "${sr} "),
                    pw.Container(width: 200, child: pw.Divider(color: PdfColor.fromHex("#000000"))),
                    summeryTotal("PCS : ", "${PCS} "),
                  ],
                )),
              ],
            )),
          ]),
        ),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          summeryRow("REMARK: ", "${ORDER["RMK"]} "),
          pw.Container(
              margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text("For : ", style: pw.TextStyle(fontSize: 15)),
                pw.Text(" : ${maincompanyObj["FIRM"]}",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ))
              ]))
        ]),
        pw.Divider(color: PdfColor.fromHex("#000000")),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("CHECKED BY${ORDER["confirmedBy"]}", style: pw.TextStyle(fontSize: 10)),
          pw.Text("ORDER BY", style: pw.TextStyle(fontSize: 10)),
          pw.Text("AUTH. SIGNATORY", style: pw.TextStyle(fontSize: 10)),
        ])
      ]),
    ));
    var f = await saveDocument(context, name: "ORDER NO-${ORDER["OrderNo"]} .pdf", pdf: pdf);
    kIsWeb ? null : Navigator.pop(context);
    return f;
  }

  static pw.Container summeryTotal(title, text) {
    return pw.Container(
        width: 200,
        // color: PdfColor.fromHex("#ffa500"),
        margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)), pw.Text(text)]));
  }

  static pw.Container summeryRow(title, text) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
          pw.Text(text, style: pw.TextStyle(fontSize: 8))
        ]));
  }

  static Future<File?> saveDocument(BuildContext context, {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    if (kIsWeb) {
      final base64String = base64Encode(bytes);
      final dataUrl = 'data:application/pdf;base64,$base64String';
      await Myf.Navi(
          context,
          DeskTopWeb(
            url: (dataUrl),
            UserObj: {},
          ));
      return null;
    }
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/$name");
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(context, File pdfFile) async {
    // final url = pdfFile.path;
    // await OpenFile.open(url);

    Myf.Navi(context, PdfView(pdfFile: XFile(pdfFile.path)));
  }
}
