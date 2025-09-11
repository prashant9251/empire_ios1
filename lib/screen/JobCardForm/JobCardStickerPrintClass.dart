import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:empire_ios/Models/JobCardReportModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List?> jobCardStickerInBytes(List<JobCardReportModel?> jobCardReportModelList, List<JobCardReportModel> docsList) async {
  final pdf = pw.Document();
  var pty_designNo = "";
  var barcodeString =
      "${jobCardReportModelList.first?.trackCno ?? ''}-${jobCardReportModelList.first?.trackType ?? ''}-${jobCardReportModelList.first?.trackVno ?? ''}";
  List<pw.Widget> sticketChildren = [];
  sticketChildren = await Future.wait(docsList.map(
    (e) async {
      List<JobCardReportModel?>? jobCardReportModelComponetList = jobCardReportModelList.where((item) {
        if (pty_designNo.isEmpty) {
          pty_designNo = item!.pty_designNo ?? '';
        }
        return item?.component == e.component;
      }).toList();
      jobCardReportModelComponetList.sort((a, b) => a!.createTime!.compareTo(b!.createTime!));
      // return pw.Text(e.component ?? '');

      return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 5, left: 5, top: 5),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(e.component ?? '', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ...jobCardReportModelComponetList.where((e) => e != null && e.stageName != null).map((e) {
              var style = pw.TextStyle(fontSize: 8);
              if (Myf.convertToDouble(e!.PEND_PCS ?? "0") > 0) {
                style = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.black);
              }
              return pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 30,
                        child: pw.Text(
                          RegExp(r'\(([^)]+)\)').firstMatch(e.stageName!)?.group(1) ?? '',
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 30,
                        child: pw.Text(
                          "-${Myf.dateFormateYYYYMMDD(e.date, formate: "dd/MM/")}",
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 20,
                        child: pw.Text(
                          "-${Myf.convertToDouble(e.pcs).toInt()}",
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 50,
                        child: pw.Text(
                          "-${e.qual!}",
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 20,
                        child: pw.Text(
                          "-${e.rate!}",
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                    pw.WidgetSpan(
                      child: pw.Container(
                        width: 70,
                        child: pw.Text(
                          "-${e.refPartyName!}",
                          style: style,
                          maxLines: 1,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            pw.Divider(),
          ]));
    },
  ).toList());
  pdf.addPage(
    pw.Page(
      orientation: pw.PageOrientation.portrait,
      pageFormat: PdfPageFormat(6 * PdfPageFormat.inch, 4 * PdfPageFormat.inch),
      build: (pw.Context context) {
        var textStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6);
        return pw.Container(
            margin: const pw.EdgeInsets.only(left: 12, right: 10),
            padding: const pw.EdgeInsets.all(10),
            child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Container(
                        margin: const pw.EdgeInsets.only(right: 10, top: 5, left: 5),
                        child: pw.SvgImage(
                            svg: Barcode.qrCode().toSvg(
                          '${barcodeString}', // Barcode content
                          width: 30, // Width of the barcode
                          height: 30, // Height of the barcode
                        ))),
                    pw.Text(" JC- ${jobCardReportModelList.first!.trackVno}",
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                    pw.SizedBox(width: 2),
                    pw.Text("P-${pty_designNo}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  ]),
                  pw.Divider(),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(left: 5),
                    child: pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 30,
                              child: pw.Text(
                                "STAGE",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 30,
                              child: pw.Text(
                                "DATE",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 20,
                              child: pw.Text(
                                "PCS",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 50,
                              child: pw.Text(
                                "-QUAL",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 20,
                              child: pw.Text(
                                "-RATE",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 70,
                              child: pw.Text(
                                "-PARTY",
                                style: textStyle,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...sticketChildren,
                ])));
      },
    ),
  );

  final bytes = await pdf.save();
  return bytes;
}

Future<Uint8List?> jobCardSmallStickerInBytes(List<JobCardReportModel?> jobCardReportModelList, List<JobCardReportModel> docsList) async {
  final pdf = pw.Document();
  var pty_designNo = "";
  var barcodeString =
      "${jobCardReportModelList.first?.trackCno ?? ''}-${jobCardReportModelList.first?.trackType ?? ''}-${jobCardReportModelList.first?.trackVno ?? ''}";

  var style = pw.TextStyle(fontSize: 8);

  if (docsList.isNotEmpty) {
    if (Myf.convertToDouble(docsList[0].PEND_PCS ?? "0") > 0) {
      style = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.black);
    }
  }
  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(5),
      pageFormat: PdfPageFormat(73.0 * PdfPageFormat.mm, 45.0 * PdfPageFormat.mm),
      build: (pw.Context context) {
        var textStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6);
        return pw.Center(
          child: pw.Container(
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 2)),
            child: pw.Container(
                child: pw.Container(
                    child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Container(
                    margin: const pw.EdgeInsets.only(right: 10, top: 5, left: 5),
                    child: pw.SvgImage(
                        svg: Barcode.qrCode().toSvg(
                      '${barcodeString}', // Barcode content
                      width: 30, // Width of the barcode
                      height: 30, // Height of the barcode
                    ))),
                pw.Text(" JC- ${jobCardReportModelList.first!.trackVno}",
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                pw.SizedBox(width: 2),
                pw.Text("P-${pty_designNo}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
              ]),
              pw.Divider(),
              if (docsList.length > 0) ...[
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 5),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 30,
                            child: pw.Text(
                              "VNO",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 30,
                            child: pw.Text(
                              "STAGE",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 30,
                            child: pw.Text(
                              "DATE",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 20,
                            child: pw.Text(
                              "PCS",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 50,
                            child: pw.Text(
                              "-QUAL",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 20,
                            child: pw.Text(
                              "-RATE",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Container(
                            width: 70,
                            child: pw.Text(
                              "-PARTY",
                              style: textStyle,
                              maxLines: 1,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(left: 5),
                  child: pw.Text(
                    docsList[0].component ?? '',
                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Container(
                    margin: const pw.EdgeInsets.only(left: 5),
                    child: pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 30,
                              child: pw.Text(
                                "-${docsList[0].vno}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 30,
                              child: pw.Text(
                                RegExp(r'\(([^)]+)\)').firstMatch(docsList[0].stageName!)?.group(1) ?? '',
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 30,
                              child: pw.Text(
                                "-${Myf.dateFormateYYYYMMDD(docsList[0].date, formate: "dd/MM/")}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 20,
                              child: pw.Text(
                                "-${Myf.convertToDouble(docsList[0].pcs).toInt()}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 50,
                              child: pw.Text(
                                "-${docsList[0].qual!}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 20,
                              child: pw.Text(
                                "-${docsList[0].rate!}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                          pw.WidgetSpan(
                            child: pw.Container(
                              width: 70,
                              child: pw.Text(
                                "-${docsList[0].refPartyName!}",
                                style: style,
                                maxLines: 1,
                                overflow: pw.TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ]
            ]))),
          ),
        );
      },
    ),
  );
  final bytes = await pdf.save();
  return bytes;
}
