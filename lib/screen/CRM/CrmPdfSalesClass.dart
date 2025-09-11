import 'dart:io';

import 'package:empire_ios/Models/BLSModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingList/CrmPdfShareClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/WhatsappContactSelectShare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart'; // Import the conditional import file

class CrmPdfSalesClass {
  static createPdf(List<BlsModel> blsModelList, {share, required BuildContext context}) async {
    List<String> shareList = [];
    List<WhatsappSendToModel> whatsappSendToModelList = [];

    try {
      await Future.wait(blsModelList.map((blsModel) async {
        WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel();
        File? file = await createHtmlPdfProcess(blsModel, share: share, whatsappSendToModel: whatsappSendToModel);
        if (file != null) {
          shareList.add(file.path);
        }
        MasterModel masterModel = blsModel.masterModel ?? MasterModel();
        MasterModel brokermodel = blsModel.brokerModel ?? MasterModel();
        whatsappSendToModel.pname = masterModel.partyname;
        whatsappSendToModel.city = masterModel.city;
        whatsappSendToModel.pcode = masterModel.value;
        whatsappSendToModel.contactList = [];

        if (masterModel.mO != "" && masterModel.mO != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.mO
            ..name = ''
            ..uType = "Party"
            ..noType = "MO"
            ..status = '');
        }
        if (masterModel.pH1 != "" && masterModel.pH1 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.pH1
            ..uType = "Party"
            ..name = ''
            ..noType = "PH1"
            ..status = '');
        }
        if (masterModel.pH2 != "" && masterModel.pH2 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.pH2
            ..name = ''
            ..uType = "Party"
            ..noType = "PH2"
            ..status = '');
        }
        if (masterModel.fX1 != "" && masterModel.fX1 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.fX1
            ..name = ''
            ..uType = "Party"
            ..noType = "FX1"
            ..status = '');
        }
        if (brokermodel.mO != "" && brokermodel.mO != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = brokermodel.mO
            ..name = ''
            ..noType = "MO"
            ..uType = "Broker"
            ..status = '');
        }
        if (brokermodel.pH1 != "" && brokermodel.pH1 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = brokermodel.pH1
            ..name = ''
            ..noType = "PH1"
            ..uType = "Broker"
            ..status = '');
        }
        if (brokermodel.pH2 != "" && brokermodel.pH2 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = brokermodel.pH2
            ..name = ''
            ..noType = "PH2"
            ..uType = "Broker"
            ..status = '');
        }
        if (whatsappSendToModel.contactList!.length > 0) whatsappSendToModelList.add(whatsappSendToModel);
      }).toList());
    } catch (e) {}
    List<XFile> xShareList = [];
    shareList.forEach((element) {
      xShareList.add(XFile(element));
    });

    if (share == true) {
      if (xShareList.length == 0) {
        return;
      }
      if (Myf.isAndroid() || Myf.isIos()) {
        if (shareList.length > 0) {
          await CrmPdfShareClass.selectNoToShare(
            context,
            masterModel: blsModelList.first.masterModel ?? MasterModel(),
            brokerModel: blsModelList.first.brokerModel ?? MasterModel(),
            pathList: shareList,
          );
        } else {
          Myf.snakeBar(context, "Error building in pdf");
        }
      } else {
        await SharePlus.instance.share(
          ShareParams(
            sharePositionOrigin: null,
            downloadFallbackEnabled: false,
            files: xShareList,
          ),
        );
      }
    } else if (share == "enotify") {
      await Myf.Navi(context, WhatsappContactSelectShareScreen(whatsappSendToModelList: whatsappSendToModelList, shareBy: share));
    } else {
      OpenFilex.open(shareList[0]);
    }
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static Future<File?> createHtmlPdfProcess(BlsModel blsModel, {share, required WhatsappSendToModel whatsappSendToModel}) async {
    try {
      final pdf = pw.Document();
      var pdfName = "SALES ${blsModel.masterModel!.partyname!}";

      final billdetails = blsModel.billdetails ?? [];
      var totalBillAmt = 0.0;
      var rows = <pw.TableRow>[];
      billdetails.where((b) => b.showSelect!).map((b) {
        totalBillAmt += Myf.convertToDouble(b.bamt);
        var tableRow = pw.TableRow(
          children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(Myf.dateFormateInDDMMYYYY(b.date), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(truncateText(b.bill ?? '', 15), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(truncateText(b.frm ?? '', 15), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(truncateText(b.bamt ?? '', 15), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(truncateText(b.trnsp ?? '', 15), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: pw.EdgeInsets.all(5),
                child: pw.Text(truncateText(b.rrno ?? '', 15),
                    textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)))
          ],
        );
        rows.add(tableRow);
        if ((b.detBillDetails ?? []).length > 0)
          rows.add(pw.TableRow(
            children: [
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Item Name', style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Pcs', style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Rate', style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Mts', style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Pck', style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text('Amt',
                      textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, color: PdfColors.orange900, fontWeight: pw.FontWeight.bold)))
            ],
          ));
        (b.detBillDetails ?? []).forEach((det) {
          var tableRow = pw.TableRow(
            children: [
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(" - ${det.qual}", 15), style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(det.pcs ?? '', 15), style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(det.rate ?? '', 15), style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(det.mts ?? '', 15), style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(det.pck ?? '', 15), style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
              pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(truncateText(det.amt ?? '', 15),
                      textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, color: PdfColors.black))),
            ],
          );
          rows.add(tableRow);
        });
      }).toList();
      const recordsPerPage = 25;
      int totalPages = (rows.length / recordsPerPage).ceil();
      for (int page = 0; page < totalPages; page++) {
        final subRows = rows.skip(page * recordsPerPage).take(recordsPerPage).toList();

        try {
          pdf.addPage(
            pw.Page(
              margin: pw.EdgeInsets.all(10),
              build: (context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(), // Empty container to align the text to the right
                        pw.Text('Page ${page + 1} of $totalPages', style: pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColor.fromHex("#588c7e"), width: 3),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      margin: pw.EdgeInsets.all(1),
                      child: pw.Padding(
                        padding: pw.EdgeInsets.all(20),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('${GLB_CURRENT_USER['SHOPNAME']}', style: pw.TextStyle(fontSize: 24)),
                            pw.SizedBox(height: 5),
                            pw.Text('SALE REPORT', style: pw.TextStyle(color: PdfColor.fromHex("#588c7e"), fontSize: 18)),
                            pw.SizedBox(height: 10),
                            pw.Text('M/s : ${blsModel.masterModel!.partyname!}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('${blsModel.masterModel!.aD1!}'),
                            pw.Text('${blsModel.masterModel!.aD2!}'),
                            pw.Text('${blsModel.masterModel!.city!}'),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    if (subRows.isNotEmpty)
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        children: [
                          pw.TableRow(
                            decoration: pw.BoxDecoration(color: PdfColor.fromHex("#588c7e")),
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5), child: pw.Text('Date', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5), child: pw.Text('Bill', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5), child: pw.Text('Firm', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text('Bill Amt', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text('Transport', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5), child: pw.Text('LrNo', style: pw.TextStyle(color: PdfColors.white, fontSize: 15))),
                            ],
                          ),
                          ...subRows,
                        ],
                      ),
                    if (page == totalPages - 1)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text('Total Bill Amount: ${totalBillAmt}/-', style: pw.TextStyle(fontSize: 20)),
                        ],
                      ),
                  ],
                );
              },
            ),
          );
        } catch (e) {
          //print(e);
        }
      }

      Uint8List pdfBytes = await pdf.save();
      if (share == "enotify") {
        whatsappSendToModel.fileBytes = pdfBytes;
        whatsappSendToModel.fileName = '$pdfName.pdf';
        whatsappSendToModel.fileExtension = 'pdf';
        return null;
      }
      if (kIsWeb) {
        viewPdf(pdfBytes, fileName: '$pdfName.pdf');
        return null;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$pdfName.pdf');
        await file.writeAsBytes(pdfBytes);
        return file;
      }
    } catch (e) {
      return null;
    }
  }
}
