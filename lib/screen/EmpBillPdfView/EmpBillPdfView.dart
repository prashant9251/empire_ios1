import 'dart:io';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:empire_ios/Models/BlsModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/DetModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/pdfView/pdfView.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart'; // Import the conditional import file

class EmpBillPdfView extends StatefulWidget {
  bool? directPrint;
  BlsModel blsModel;
  EmpBillPdfView({Key? key, this.directPrint, required this.blsModel}) : super(key: key);

  @override
  State<EmpBillPdfView> createState() => _EmpBillPdfViewState();
}

class _EmpBillPdfViewState extends State<EmpBillPdfView> {
  Uint8List? pdfBytes = null;
  var loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: empBillFormate(),
        builder: (context, snapshot) {
          pdfBytes = snapshot.data as Uint8List?;
          print("gatePassModel.${pdfBytes?.length}");
          return PdfView(bytes: pdfBytes, directPrint: widget.directPrint);
        });
  }

  Future<Uint8List?> empBillFormate() async {
    try {
      BlsModel blsModel = widget.blsModel;
      Uint8List digiSignbytes = Uint8List(0);
      var digiSignUrl = empOrderSettingModel.digiSignUrl ?? "";
      try {
        if (digiSignUrl.isNotEmpty) {
          var fileOld = await baseCacheManager.getSingleFile(digiSignUrl);
          Uint8List imageUint8List = await fileOld.readAsBytesSync();
          if (imageUint8List != null) {
            digiSignbytes = imageUint8List;
            print(digiSignbytes.length);
          }
        }
      } catch (e) {}
      var pdfName = "Bill";
      var pdf = pw.Document();
      blsModel.billdetails!.map((blsBillDetails) {
        var billType = blsBillDetails.series;
        if (((blsBillDetails.series)!.toUpperCase().toUpperCase()).indexOf('SALE') > -1 &&
            ((blsBillDetails.type)!.toUpperCase()).indexOf('S') > -1 &&
            ((blsBillDetails.series)!.toUpperCase()).indexOf('RETURN') < 0) {
          billType = "TAX INVOICE";
        }
        double grossAmt = ((Myf.convertToDouble(blsBillDetails.grsamt)));
        var taxablevalue = grossAmt;
        if (Myf.convertToDouble(blsBillDetails.la1amt) != 0) {
          taxablevalue = taxablevalue + Myf.convertToDouble(blsBillDetails.la1amt);
        }
        if (Myf.convertToDouble(blsBillDetails.la2amt) != 0) {
          taxablevalue = taxablevalue + Myf.convertToDouble(blsBillDetails.la2amt);
        }
        if (Myf.convertToDouble(blsBillDetails.la3amt) != 0) {
          taxablevalue = taxablevalue + Myf.convertToDouble(blsBillDetails.la3amt);
        }
        var pSr = 1;
        var limitRecord = 15;

        for (int i = 0; i < blsBillDetails.detBillDetails!.length; i += limitRecord) {
          List<DetBillDetails> detBillDetails = blsBillDetails.detBillDetails!
              .sublist(i, (i + limitRecord > blsBillDetails.detBillDetails!.length) ? blsBillDetails.detBillDetails!.length : i + limitRecord);
          bool isLastPage = (i + limitRecord >= blsBillDetails.detBillDetails!.length);
          // Add your PDF page creation code here using detBillDetails
          var timesBold = pw.Font.timesBold();
          var times = pw.Font.times();
          pdf.addPage(
            pw.Page(
              theme: pw.ThemeData.withFont(
                base: times,
                bold: timesBold,
              ),
              textDirection: pw.TextDirection.ltr,
              margin: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              pageFormat: PdfPageFormat.a4,
              build: (context) {
                return pw.Container(
                  height: PdfPageFormat.a4.height,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          child: pw.Column(children: [
                        pw.Column(children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text(
                              "DEX",
                              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Expanded(
                              child: pw.Center(
                                child: pw.Text(
                                  "!! Shree Ganeshaya Namah !!",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ),
                            pw.Text(
                              "PHONE: ${blsModel.compmstModel!.mOBILE ?? ""},${blsModel.compmstModel!.pHONE1 ?? ""},${blsModel.compmstModel!.pHONE2 ?? ""}",
                              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ]),
                          pw.Text(
                            "${blsModel.compmstModel!.fIRM ?? ""}",
                            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, font: timesBold),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text("GSTIN: ${blsModel.compmstModel!.cOMPANYGSTIN ?? ""} Place of Supply: ${blsModel.compmstModel!.sTATE1 ?? ""}"),
                            pw.Text("${blsModel.compmstModel!.oTHERRMK ?? ""}", textAlign: pw.TextAlign.center),
                            pw.Text("PAN.NO: ${blsModel.compmstModel!.pANNO ?? ""}"),
                          ]),
                          pw.Text(
                            "${blsModel.compmstModel!.aDDRESS1 ?? ""},${blsModel.compmstModel!.aDDRESS2 ?? ""},${blsModel.compmstModel!.cITY1 ?? ""},${blsModel.compmstModel!.sTATE1 ?? ""},${blsModel.compmstModel!.cPINNO ?? ""}",
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            "$billType",
                            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: timesBold),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 8),
                        ]),
                        pw.Divider(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 4,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("M/S: ${blsModel.masterModel!.partyname ?? ""}", style: pw.TextStyle(font: timesBold)),
                                  pw.Text("${blsModel.masterModel!.aD1 ?? ""}"),
                                  pw.Text(
                                      "${blsModel.masterModel!.aD2 ?? ""},${blsModel.masterModel!.city ?? ""}- ${blsModel.masterModel!.pNO ?? ""}"),
                                  pw.Text("GSTIN: ${blsModel.masterModel!.gST ?? ""}"),
                                ],
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("BILL NO.: ${blsBillDetails.bill ?? ""}"),
                                  pw.Text("CHALLAN: ${blsBillDetails.chln ?? ""}"),
                                  pw.Text("DATE: ${Myf.dateFormateInDDMMYYYY(blsBillDetails.date) ?? ""}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("Consignee: ${blsBillDetails.haste ?? ""}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(height: 5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text("AGENT: ${blsModel.brokerModel!.partyname ?? ""}"),
                                  pw.Text(
                                      "ADDRESS:  ${blsModel.brokerModel!.aD1 ?? ""}, ${blsModel.brokerModel!.aD2 ?? ""}, ${blsModel.brokerModel!.city ?? ""}, ${blsModel.brokerModel!.pNO ?? ""} PHONE.: ${blsModel.brokerModel!.mO ?? ""},${blsModel.brokerModel!.pH1 ?? ""},${blsModel.brokerModel!.pH2 ?? ""}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(height: 5),
                        pw.Column(children: [
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text("L.R.NO:${blsBillDetails.rrno ?? ""}"),
                            pw.Text("L.R.DATE:${Myf.dateFormateInDDMMYYYY(blsBillDetails.rrdet) ?? ""}"),
                            pw.Text("WEIGHT:${blsBillDetails.wgt ?? ""}"),
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text("TRASPORT:${blsBillDetails.trnsp ?? ""}"),
                            pw.Text("CASE NO:${blsBillDetails.csno ?? ""}x ${blsBillDetails.prcl ?? ""}"),
                            pw.Text("FREIGHT:${blsBillDetails.frt ?? ""}"),
                          ]),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text("STATION:${blsBillDetails.plc ?? ""}"),
                            pw.Text(""),
                          ])
                        ]),
                        pw.Divider(height: 2),
                        pw.Table(
                          tableWidth: pw.TableWidth.max,
                          border: pw.TableBorder.symmetric(inside: pw.BorderSide(width: 0.5, color: PdfColors.grey)),
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text("Sr."),
                                pw.Text("Particulars"),
                                pw.Text("HSN Code"),
                                pw.Text("Pack"),
                                pw.Text("PCS"),
                                pw.Text("Cut"),
                                pw.Text("Mtr"),
                                pw.Text("Rate"),
                                pw.Text("Amount"),
                              ],
                            ),
                            ...detBillDetails.map((e) {
                              return pw.TableRow(
                                children: [
                                  pw.Text("${pSr++}"),
                                  pw.Text(e.qual ?? ""),
                                  pw.Text(e.hsn ?? ""),
                                  pw.Text(e.pck ?? ""),
                                  pw.Text(Myf.convertToDouble(e.pcs ?? "").toInt().toString()),
                                  pw.Text(Myf.convertToDouble(e.cut ?? "").toStringAsFixed(2).toString()),
                                  pw.Text(Myf.convertToDouble(e.mts ?? "").toStringAsFixed(2).toString()),
                                  pw.Text(Myf.convertToDouble(e.rate ?? "").toStringAsFixed(2).toString()),
                                  pw.Text(Myf.convertToDouble(e.amt ?? "").toStringAsFixed(2).toString()),
                                ],
                              );
                            }).toList(),
                          ],
                        )
                      ])),
                      if (!isLastPage)
                        pw.Text("Continued Next Page....", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))
                      else ...[
                        pw.Divider(height: 2),
                        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                          pw.Text("Bank A/C No.:  ${blsModel.compmstModel!.aDDRESS3 ?? ""} - IFSC Code: -  ${blsModel.compmstModel!.aDDRESS4 ?? ""}"),
                          pw.Text("Remark:  ${blsBillDetails.rmk ?? ""}"),
                        ]),
                        pw.Divider(height: 2),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("SUB TOTAL:"),
                            pw.Text("${Myf.convertToDouble(blsBillDetails.tpcs)}"),
                            pw.Text("${Myf.convertToDouble(blsBillDetails.grsamt).toStringAsFixed(2)}/-"),
                          ],
                        ),
                        pw.Divider(height: 2),
                        // addless1
                        if (Myf.convertToDouble(blsBillDetails.la1rate) != 0)
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                  "${(blsBillDetails.la1rmk)} -> ${(blsBillDetails.la1qty)} X ${(blsBillDetails.la1rate)}% : ${(Myf.convertToDouble(blsBillDetails.la1amt))}"),
                            ],
                          ),
                        if (Myf.convertToDouble(blsBillDetails.la2rate) != 0)
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                  "${(blsBillDetails.la2rmk)} -> ${(blsBillDetails.la2qty)} X ${(blsBillDetails.la2rate)}% : ${(Myf.convertToDouble(blsBillDetails.la2amt))}"),
                            ],
                          ),
                        if (Myf.convertToDouble(blsBillDetails.la3rate) != 0)
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                  "${(blsBillDetails.la3rmk)} -> ${(blsBillDetails.la3qty)} X ${(blsBillDetails.la3rate)}% : ${(Myf.convertToDouble(blsBillDetails.la3amt))}"),
                            ],
                          ),
                        if (blsBillDetails.vtamt != null && blsBillDetails.vtamt != "" && Myf.convertToDouble(blsBillDetails.vtamt) != 0)
                          if (Myf.toIntVal(blsBillDetails.stc ?? "0") != Myf.toIntVal(blsModel.compmstModel!.cOMPANYGSTIN!.substring(0, 2)))
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                if (Myf.toIntVal(blsBillDetails.vtret ?? "0") != 0)
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text(
                                          "IGST @  ${Myf.convertToDouble(blsBillDetails.vtret ?? "0")}% on Taxable Value  $taxablevalue = ${Myf.convertToDouble(blsBillDetails.vtamt ?? "0").toStringAsFixed(2)}"),
                                    ],
                                  )
                                else
                                  pw.SizedBox.fromSize(),
                              ],
                            )
                          else
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                if (Myf.toIntVal(blsBillDetails.vtret ?? "0") != 0)
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text(
                                          "CGST @  ${Myf.convertToDouble(blsBillDetails.vtret ?? "0")}% on Taxable Value  $grossAmt = ${Myf.convertToDouble(blsBillDetails.vtamt).toStringAsFixed(2)}"),
                                    ],
                                  ),
                                if (Myf.toIntVal(blsBillDetails.advtret ?? "0") != 0)
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text(
                                          "SGST @  ${Myf.convertToDouble(blsBillDetails.advtret ?? "0")}% on Taxable Value  $grossAmt = ${Myf.convertToDouble(blsBillDetails.advtamt).toStringAsFixed(2)}"),
                                    ],
                                  )
                              ],
                            ),
                        if (Myf.convertToDouble(blsBillDetails.tdsamt) != 0)
                          pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Text(
                                    "${billType == 'TAX INVOICE' ? 'TCS' : 'TDS'} @ ${blsBillDetails.tdsrate ?? ""} : ${Myf.convertToDouble(blsBillDetails.tdsamt).toStringAsFixed(2)}",
                                    style: pw.TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        pw.Divider(height: 2),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text("TOTAL:"),
                            pw.Text("${Myf.convertToDouble(blsBillDetails.bamt).toStringAsFixed(2)}/-"),
                          ],
                        ),
                      ],
                      pw.Divider(height: 2),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("For:"),
                          pw.Text(" ${blsModel.compmstModel!.fIRM ?? ""}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          if (digiSignbytes.length > 0)
                            pw.Image(
                              pw.MemoryImage(digiSignbytes),
                              height: 40,
                              width: 100,
                            )
                        ],
                      ),
                      pw.Text(
                        "Terms & Conditions:",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Bullet(
                          text: "SUBJECT TO SURAT JURISDICTION.",
                          margin: pw.EdgeInsets.only(left: 0),
                          padding: pw.EdgeInsets.only(left: 0),
                          style: pw.TextStyle(fontSize: 8)),
                      pw.Bullet(
                          text: "GOODS ARE INSURED WITH ICICI LOMBARD GENERAL INSURANCE COMPANY LTD. POLICY NO.- 2001/253494275 / 01 / 000",
                          margin: pw.EdgeInsets.only(left: 0),
                          padding: pw.EdgeInsets.only(left: 0),
                          style: pw.TextStyle(fontSize: 8)),
                      pw.Bullet(
                          text: "COMPLAINTS, IF ANY REGARDING THIS INVOICE MUST BE INFORMED IN WRITING WITHIN 48 HOURS",
                          margin: pw.EdgeInsets.only(left: 0),
                          padding: pw.EdgeInsets.only(left: 0),
                          style: pw.TextStyle(fontSize: 8)),
                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Text("Checked By:"),
                        pw.Text("Delivered By:"),
                        pw.Text("Auth. Signatory"),
                      ]),
                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                          pw.Text("IRN.:${blsBillDetails.i ?? ""}"),
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                            pw.Text("E-Way BILL NO.:${blsBillDetails.ewb ?? ""} "),
                            pw.Text(" Transporter ID:${blsBillDetails.transport_id ?? ""}"),
                          ]),
                          if ((blsBillDetails.ewb ?? "").isNotEmpty)
                            pw.SvgImage(
                                svg: Barcode.code39().toSvg(
                              '${blsBillDetails.ewb ?? ""}', // Barcode content
                              width: 160, // Width of the barcode
                              height: 50, // Height of the barcode
                            )),
                        ]),
                        pw.Column(children: [
                          if ((blsBillDetails.envQr ?? "").isNotEmpty)
                            pw.SvgImage(
                                svg: Barcode.qrCode().toSvg(
                              '${blsBillDetails.envQr ?? ""}', // Barcode content
                              width: 100, // Width of the barcode
                              height: 100, // Height of the barcode
                            )),
                        ]),
                      ]),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }).toList();

      var pdfBytes = await pdf.save();

      return pdfBytes;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
