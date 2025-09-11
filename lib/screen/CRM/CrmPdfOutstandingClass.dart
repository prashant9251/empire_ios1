import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/HideUnhideModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingCubit.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingList/CrmPdfShareClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/WhatsappContactSelectShare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart'; // Import the conditional import file

class CrmPdfOutstandingClass {
  static createPdf(List<OutstandingModel> outstandingModel, {share, required BuildContext context, required String selectedCno}) async {
    var cssContent = "";
    try {
      cssContent += await rootBundle.loadString("assets$assethtmlFolder$assethtmlSubFolder/css/style.css");
      cssContent += await rootBundle.loadString("assets$assethtmlFolder$assethtmlSubFolder/4.1.1/bootstrap.min.css");
      cssContent += await rootBundle.loadString("assets$assethtmlFolder$assethtmlSubFolder/1.10.4/jquery-ui.css");
    } catch (e) {}
    List<String> shareList = [];
    List<WhatsappSendToModel> whatsappSendToModelList = [];

    try {
      await Future.wait(outstandingModel.map((otg) async {
        OutstandingModel otgModel = OutstandingModel.fromJson(Myf.convertMapKeysToString(otg.toJson()));
        WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel();
        File? file =
            await createHtmlPdfProcess(cssContent, otgModel, share: share, whatsappSendToModel: whatsappSendToModel, selectedCno: selectedCno);
        if (file != null) {
          shareList.add(file.path);
        }
        MasterModel masterModel = otgModel.masterModel ?? MasterModel();
        MasterModel brokermodel = otgModel.brokerModel ?? MasterModel();
        whatsappSendToModel.pname = masterModel.partyname;
        whatsappSendToModel.city = masterModel.city;
        whatsappSendToModel.pcode = masterModel.value;
        whatsappSendToModel.contactList = [];

        if (masterModel.mO != "" && masterModel.mO != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.mO
            ..name = ''
            ..noType = "MO"
            ..status = '');
        }
        if (masterModel.pH1 != "" && masterModel.pH1 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.pH1
            ..name = ''
            ..noType = "PH1"
            ..status = '');
        }
        if (masterModel.pH2 != "" && masterModel.pH2 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.pH2
            ..name = ''
            ..noType = "PH2"
            ..status = '');
        }
        if (masterModel.fX1 != "" && masterModel.fX1 != null) {
          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
            ..phone = masterModel.fX1
            ..name = ''
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
            masterModel: outstandingModel.first.masterModel ?? MasterModel(),
            brokerModel: outstandingModel.first.brokerModel ?? MasterModel(),
            pathList: shareList,
          );
        } else {
          Myf.snakeBar(context, "Error building in pdf");
        }
      } else {
        ShareResult result = await SharePlus.instance.share(ShareParams(
          files: xShareList,
        ));
        if (result.status == ShareResultStatus.success) {
          if (outstandingModel.length == 1) {
            //save only if single outstanding
            Myf.saveLastPdfSentDate(context, outstandingModel.first.masterModel!);
          }
        } else {
          Myf.snakeBar(context, "Error sharing file");
        }
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

  static Future<File?> createHtmlPdfProcess(String cssContent, OutstandingModel outstandingModel,
      {share, required WhatsappSendToModel whatsappSendToModel, required String selectedCno}) async {
    List COMPMST = [];
    try {
      LazyBox compmst_lazyBox = await SyncLocalFunction.openLazyBoxCheck("COMPMST");
      var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
      if (!compmst_lazyBox.isOpen) {
        compmst_lazyBox = await SyncLocalFunction.openLazyBoxCheck("COMPMST");
      }
      COMPMST = await compmst_lazyBox.get("${databasId}COMPMST", defaultValue: []) as List<dynamic>;
      if (compmst_lazyBox.isOpen) {
        compmst_lazyBox.close();
      }
    } catch (e) {
      print("Error: $e");
      SyncLocalFunction.closeOpenBox("COMPMST");
    }
    CompmstModel compmstModel = CompmstModel();
    COMPMST.where((element) => element['CNO'] == selectedCno).forEach((element) {
      compmstModel = CompmstModel.fromJson(Myf.convertMapKeysToString(element));
    });
    Map<String, dynamic> inArryrcompmst = {};

    // final crmOutstanding = (empOrderSettingModel.hideUnhideSection ?? HideUnhideSectionModel(sections: {})).sections['crmOutstanding'];
    try {
      final pdf = pw.Document();
      var pdfName = "OS ${outstandingModel.masterModel!.partyname!}";

      final billdetails = outstandingModel.billdetails ?? [];
      // await Future.wait(billdetails.map((e) async {
      //   inArryrcompmst.putIfAbsent(e.cNO ?? "", () => COMPMST.firstWhere((element) => element['CNO'] == e.cNO, orElse: () => {}));
      // }).toList());
      var totalBillAmt = 0.0;
      var pAMT = 0.0;
      var rAMT = 0.0;

      const recordsPerPage = 25;
      int totalPages = (billdetails.length / recordsPerPage).ceil();
      for (int page = 0; page < totalPages; page++) {
        final currentBillDetails = billdetails.skip(page * recordsPerPage).take(recordsPerPage).toList();
        try {
          pdf.addPage(
            pw.Page(
              margin: pw.EdgeInsets.all(10),
              build: (context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
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
                      margin: const pw.EdgeInsets.all(1),
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            if (compmstModel.cNO != null && compmstModel.cNO != "") ...[
                              pw.Text('${compmstModel.fIRM}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(
                                  '${compmstModel.aDDRESS1!} ${compmstModel.aDDRESS2!} ${compmstModel.cITY1!} ${compmstModel.sTATE1!} ${compmstModel.cPINNO!}'),
                              pw.Text('Phone: ${compmstModel.pHONE1!} ${compmstModel.pHONE2!} ${compmstModel.mOBILE!} Email: ${compmstModel.eMAIL!}'),
                            ] else
                              pw.Text('${GLB_CURRENT_USER['SHOPNAME']}', style: pw.TextStyle(fontSize: 24)),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              width: double.infinity,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('SALE OUTSTANDING REPORT', style: pw.TextStyle(color: PdfColor.fromHex("#588c7e"), fontSize: 12)),
                                  pw.SizedBox(height: 2),
                                  pw.Text('M/s : ${outstandingModel.masterModel!.partyname!}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  pw.Text(
                                      '${outstandingModel.masterModel!.aD1!}${outstandingModel.masterModel!.aD2!}${outstandingModel.masterModel!.city!}'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    if (currentBillDetails.isNotEmpty)
                      pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey),
                        children: [
                          pw.TableRow(
                            decoration: pw.BoxDecoration(color: PdfColor.fromHex("#588c7e")),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('Date', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('Bill', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('Firm', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                              ),
                              if (empOrderSettingModel.sRmk == true)
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text('Remark', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                                ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('Days', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text('PendAmt', style: pw.TextStyle(color: PdfColors.white, fontSize: 15)),
                              ),
                            ],
                          ),
                          ...currentBillDetails.where((b) {
                            inArryrcompmst.putIfAbsent(b.cNO ?? "", () => COMPMST.firstWhere((element) => element['CNO'] == b.cNO, orElse: () => {}));

                            return b.showSelect!;
                          }).map((b) {
                            final days = Myf.daysCalculate(b.dATE);
                            pAMT += Myf.convertToDouble(b.pAMT);
                            return pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(Myf.dateFormateInDDMMYYYY(b.dATE), style: const pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(truncateText(b.bILL ?? '', 15), style: const pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(truncateText(b.fRM ?? '', 15), style: const pw.TextStyle(fontSize: 9)),
                                ),
                                if (empOrderSettingModel.sRmk == true)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(5),
                                    child: pw.Text(truncateText(b.l1R ?? '', 15), style: const pw.TextStyle(fontSize: 9)),
                                  ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text('$days', style: const pw.TextStyle(fontSize: 9)),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text('${b.pAMT ?? 0.0}/-', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 9)),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    if (page == totalPages - 1)
                      pw.Column(children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text('Total: ${pAMT}/-', style: const pw.TextStyle(fontSize: 20)),
                          ],
                        ),
                        ...inArryrcompmst.entries.map((e) {
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(height: 10),
                              pw.Text('A/c ${e.value['FIRM']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text('${e.value['ADDRESS3']}'),
                              pw.Text('${e.value['ADDRESS4']}'),
                            ],
                          );
                        }).toList(),
                      ]),
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
