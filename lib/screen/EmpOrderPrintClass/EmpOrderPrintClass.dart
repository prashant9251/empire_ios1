import 'dart:io';

import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/pdfView/pdfView.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingList/CrmPdfShareClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderCheckForDoubleClass.dart';
import 'package:empire_ios/screen/WhatsappContactSelectShare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart'; // Import the conditional import file

class EmpOrderPrintClass {
  static savePdfOpen({required List<BillsModel> OrderList, required BuildContext context, pdfOprate}) async {
    List<String> shareList = [];
    List<WhatsappSendToModel> whatsappSendToModelList = [];
    var masterModel = MasterModel();
    await Future.wait(OrderList.map((ORDER) async {
      BillsModel billsModel = BillsModel.fromJson(ORDER.toJson());

      // List<BillsModel> billsList = await EmpOrderCheckForDoubleClass.checkForDouble(billsModel);
      // if (billsList.length == 0) {
      //   Myf.snakeBar(context, "somthing went wrong");
      //   return;
      // }
      //return;
      WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel();
      File? file = await createOrderPdf(billsList: [billsModel], context: context, whatsappSendToModel: whatsappSendToModel, pdfOprate: pdfOprate);
      masterModel = billsModel.masterDet!;
      // brokerModel = billsModel.b!;
      if (file != null) {
        shareList.add(file.path);
      }
      whatsappSendToModel.pname = billsModel.masterDet!.partyname;
      whatsappSendToModel.city = billsModel.masterDet!.city;
      whatsappSendToModel.pcode = billsModel.masterDet!.value;
      whatsappSendToModel.type = "order";
      whatsappSendToModel.contactList = [];
      if (billsModel.masterDet!.mO != "" && billsModel.masterDet!.mO != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.masterDet!.mO
          ..name = ''
          ..uType = "Party"
          ..noType = "MO"
          ..status = '');
      }
      if (billsModel.masterDet!.pH1 != "" && billsModel.masterDet!.pH1 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.masterDet!.pH1
          ..name = ''
          ..uType = "Party"
          ..noType = "PH1"
          ..status = '');
      }
      if (billsModel.masterDet!.pH2 != "" && billsModel.masterDet!.pH2 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.masterDet!.pH2
          ..name = ''
          ..uType = "Party"
          ..noType = "PH2"
          ..status = '');
      }
      if (billsModel.masterDet!.fX1 != "" && billsModel.masterDet!.fX1 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.masterDet!.fX1
          ..name = ''
          ..uType = "Party"
          ..noType = "FX1"
          ..status = '');
      }
      if (billsModel.brokerDet!.mO != "" && billsModel.brokerDet!.mO != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.brokerDet!.mO
          ..name = ''
          ..noType = "MO"
          ..uType = "Broker"
          ..status = '');
      }
      if (billsModel.brokerDet!.pH1 != "" && billsModel.brokerDet!.pH1 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.brokerDet!.pH1
          ..name = ''
          ..noType = "PH1"
          ..uType = "Broker"
          ..status = '');
      }
      if (billsModel.brokerDet!.pH2 != "" && billsModel.brokerDet!.pH2 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.brokerDet!.pH2
          ..name = ''
          ..noType = "PH2"
          ..uType = "Broker"
          ..status = '');
      }
      if (billsModel.brokerDet!.fX1 != "" && billsModel.brokerDet!.fX1 != null) {
        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
          ..phone = billsModel.brokerDet!.fX1
          ..name = ''
          ..noType = "FX1"
          ..uType = "Broker"
          ..status = '');
      }
      whatsappSendToModelList.add(whatsappSendToModel);
    }).toList());
    //----
    List<XFile> xShareList = [];
    try {
      shareList.forEach((element) {
        xShareList.add(XFile(element));
      });
    } catch (e) {}
    if (pdfOprate == "print") {
      if (shareList.length > 0) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => File(shareList[0]).readAsBytesSync(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No PDF bytes available")),
        );
      }
    } else if (pdfOprate == "share") {
      if (xShareList.length == 0) {
        return;
      }
      if (Myf.isAndroid() || Myf.isIos()) {
        if (shareList.length > 0) {
          await CrmPdfShareClass.selectNoToShare(
            context,
            masterModel: masterModel ?? MasterModel(),
            brokerModel: MasterModel(),
            pathList: shareList,
          );
        } else {
          Myf.snakeBar(context, "Error building in pdf");
        }
      } else {
        await Share.shareXFiles(xShareList);
      }
    } else if (pdfOprate == "enotify") {
      await Myf.Navi(context, WhatsappContactSelectShareScreen(whatsappSendToModelList: whatsappSendToModelList, shareBy: pdfOprate));
      print("ok");
    } else {
      try {
        OpenFilex.open(shareList[0]);
      } catch (err) {}
    }
  }

  static Future<File?> createOrderPdf(
      {required List<BillsModel> billsList, required BuildContext context, required WhatsappSendToModel whatsappSendToModel, pdfOprate}) async {
    List<BillDetModel> qualImgList = [];

    var partyname = "pdf";
    var bill = "";
    int sr = 0;
    double PCS = 0;
    double totAmt = 0.0;
    var pdf = pw.Document();

    await Future.wait(billsList.map((ORDER) async {
      partyname = ORDER.masterDet!.partyname!;
      bill = ORDER.vNO.toString();
      // var urlLogo = "https://seeklogo.com/images/A/atm-link-logo-5F955E13CB-seeklogo.com.png";
      final imageByteData = await rootBundle.load('assets/img/blankLogo.png');
      var imageUint8List = imageByteData.buffer.asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

      var urlPdfBackground = empOrderSettingModel.urlPdfBackground ?? "";
      if (urlPdfBackground.isNotEmpty) {
        var fileOld = await baseCacheManager.getSingleFile(urlPdfBackground);
        imageUint8List = fileOld.readAsBytesSync();
      }
      final image = pw.MemoryImage(imageUint8List);
      // final buffer = (await rootBundle.load('assets/img/mainapp.jpeg')).buffer.asUint8List();
      // final memoryImage =MemoryImage(buffer);
      List<BillDetModel>? orderProductList = ORDER.billDetails ?? [];
      MasterModel? partyObj = ORDER.masterDet;
      CompmstModel? maincompanyObj = ORDER.compmstDet;
      var recordsPerPage = empOrderSettingModel.pdfProductViewLimit ?? 15;
      int totalPages = (orderProductList.length / recordsPerPage).ceil();
      for (int page = 0; page < totalPages; page++) {
        List<pw.TableRow> rowsDetails = [];
        final currentBillDetails = orderProductList.skip(page * recordsPerPage).take(recordsPerPage).toList();
        var isLastPage = page == totalPages - 1;
        await Future.wait(currentBillDetails.map((d) async {
          PCS += Myf.convertToDouble('${d.pCS}');
          d.aMT = (Myf.convertToDouble(d.pCS!) * Myf.getPackingRate(d)).toString();
          totAmt += Myf.convertToDouble(d.aMT);
          List<ColorModel>? colorDetails = [...d.colorDetails ?? []];
          String color = "";
          if (colorDetails.length > 0) {
            qualImgList.add(d);
            await Future.wait(colorDetails.map((e) async {
              color += "${e.clName} X ${e.clQty} ,";
            }).toList());
          }
          sr++;
          // qualImgList.add(d);
          rowsDetails.add(tableRow(sr, d));

          if (color.isNotEmpty) {
            var splitColor = color.split(" ");
            rowsDetails.add(pw.TableRow(
              children: [
                pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
                pw.Container(
                    width: 70, child: pw.Text("$color", style: pw.TextStyle(fontSize: 5)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              ],
            ));
          }
        }).toList());
        //---total slab
        if (isLastPage) {
          rowsDetails.add(pw.TableRow(
            children: [
              pw.Container(
                  child: pw.Text(
                    "TOTAL",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  ),
                  decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmcategory ?? false)
                pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmDno ?? false) pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmPacking ?? false)
                pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmSets ?? false) pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              pw.Container(
                  child: pw.Text("${PCS.toInt()}", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmCut ?? false) pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmRate ?? false) pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmRmk ?? false) pw.Container(child: pw.Text(""), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
              if (empOrderSettingModel.pdfItmAmt ?? false)
                pw.Container(
                    child: pw.Text(
                      "$totAmt",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                    ),
                    decoration: pw.BoxDecoration(color: PdfColors.grey100)),
            ],
          ));
        }
        var createdBY = ORDER.cBy;
        List<String?> parts = ORDER.cBy.toString().split('@');
        createdBY = parts[0] ?? "";
        var courierBoldOblique = pw.Font.courierBoldOblique();

        pdf.addPage(pw.Page(
          margin: pw.EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          // pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Container(
                // decoration: image.bytes.length > 0
                //     ? pw.BoxDecoration(
                //         image: pw.DecorationImage(
                //           image: image,
                //           fit: pw.BoxFit.cover,
                //         ),
                //       )
                //     : null,
                child: pw.Column(children: [
              pw.Expanded(
                child: pw.Column(children: [
                  // pw.Container(
                  //     height: 65,
                  //     child: pw.Column(children: [
                  //       if (empOrderSettingModel.pdfHeaderDetails ?? true) ...[
                  //         pw.Text("!! SHREE GANESHAYA NAMAH!!",
                  //             style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : null)),
                  //         pw.Text("ORDER FORM",
                  //             style: pw.TextStyle(fontSize: 30, color: image.bytes.length > 0 ? PdfColors.black : null, font: pw.Font.courierBold())),
                  //         pw.Divider(color: PdfColor.fromHex(image.bytes.length > 0 ? "#ffffff" : "#000000")),
                  //       ]
                  //     ])),
                  pw.Container(
                      // color: PdfColor.fromHex("#eaf1f7"),
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Container(
                        height: 100,
                        // color: PdfColor.fromHex(image.bytes.length > 0 ?"ffffff0: "#000000"),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            if (empOrderSettingModel.pdfHeaderDetails ?? true)
                              pw.Container(
                                margin: pw.EdgeInsets.symmetric(horizontal: 10),
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      // width: context.page.pageFormat.availableWidth * 0.6,
                                      child: pw.Column(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Row(children: [
                                            pw.Text("${maincompanyObj!.fIRM}",
                                                style: pw.TextStyle(
                                                    font: pw.Font.timesBoldItalic(),
                                                    fontSize: 15,
                                                    color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black,
                                                    fontWeight: pw.FontWeight.bold))
                                          ]),
                                          pw.SizedBox(height: 5),
                                          pw.Container(
                                            width: context.page.pageFormat.availableWidth * 0.8,
                                            child: pw.Text(
                                              "${maincompanyObj.aDDRESS1}",
                                              style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: pw.TextOverflow.visible,
                                            ),
                                          ),
                                          pw.Container(
                                            width: context.page.pageFormat.availableWidth * 0.8,
                                            child: pw.Text(
                                              "${maincompanyObj.aDDRESS2}",
                                              style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black),
                                              softWrap: true,
                                              maxLines: 2,
                                              overflow: pw.TextOverflow.visible,
                                            ),
                                          ),
                                          pw.Row(children: [
                                            pw.Text("${maincompanyObj.cITY1}",
                                                style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black))
                                          ]),
                                          pw.Row(children: [
                                            pw.Text("${maincompanyObj.cPINNO}",
                                                style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black))
                                          ]),
                                          pw.Row(
                                            children: [
                                              pw.Text("GSTIN:-${maincompanyObj.cOMPANYGSTIN}                      ",
                                                  style: pw.TextStyle(
                                                      fontSize: 10,
                                                      color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black,
                                                      fontBold: pw.Font.helveticaBold())),
                                              pw.Text("MO:- ${maincompanyObj.mOBILE},${maincompanyObj.pHONE1},${maincompanyObj.pHONE2}",
                                                  style:
                                                      pw.TextStyle(fontSize: 8, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        )),
                    pw.Container(padding: pw.EdgeInsets.all(4), child: pw.Image(image), width: 150, height: 100)
                  ])),
                  // pw.Divider(color: PdfColor.fromHex("#000000")),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      // border: pw.Border.all(width: 1),
                      borderRadius: pw.BorderRadius.circular(4),
                      // color as grey
                      color: PdfColor.fromHex("#808080"),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                            margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                              pw.Text("ORDER FORM ",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: image.bytes.length > 0 ? PdfColors.white : PdfColors.white)),
                            ])),
                        pw.Container(
                            margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                              pw.Text("ORDER NO : ",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: image.bytes.length > 0 ? PdfColors.white : PdfColors.white)),
                              pw.Text("${ORDER.bill} ",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: image.bytes.length > 0 ? PdfColors.white : PdfColors.white))
                            ])),
                        pw.Container(
                            margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                              pw.Text("ORDER DATE : ",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: image.bytes.length > 0 ? PdfColors.white : PdfColors.white)),
                              pw.Text("${Myf.dateFormate(ORDER.date)}",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10,
                                      color: image.bytes.length > 0 ? PdfColors.white : PdfColors.white))
                            ])),
                      ],
                    ),
                  ),
                  // pw.Divider(color: PdfColor.fromHex("#000000")),
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Flexible(
                        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      summeryRow("M/S : ", "${partyObj!.partyname ?? ""} "),
                      summeryRow("", "${partyObj.aD1 ?? ""}"),
                      summeryRow("", "${partyObj.aD2 ?? ""}"),
                      summeryRow("", "${partyObj.city ?? ""} "),
                      summeryRow("", "${partyObj.pNO ?? ""} , GSTIN : ${partyObj.gST ?? ""}"),
                    ])),
                    pw.Flexible(
                        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      summeryRow("TRASNPORT: ", "${ORDER.trnsp ?? ""} "),
                      summeryRow("BOOKING: ", "${ORDER.st ?? ""} "),
                      summeryRow("BROKER: ", "${ORDER.bcode ?? ""} "),
                      summeryRow("HASTE: ", "${ORDER.haste ?? ""} "),
                    ])),
                  ]),
                  pw.Divider(color: PdfColor.fromHex("#000000")),
                  pw.Container(
                    // height: 5000,
                    child: pw.Table(children: [
                      pw.TableRow(children: [
                        pw.Container(
                            child: pw.Text("SR", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        pw.Container(
                            child: pw.Text("ITEMS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmcategory ?? false)
                          pw.Container(
                              child: pw.Text("CATEGORY", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmDno ?? false)
                          pw.Container(
                              child: pw.Text(" DNO", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmPacking ?? false)
                          pw.Container(
                              child: pw.Text("PACKING", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmSets ?? false)
                          pw.Container(
                              child:
                                  pw.Text("SETS", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        pw.Container(
                            child: pw.Text("PCS", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmCut ?? false)
                          pw.Container(
                              child: pw.Text("CUT", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmRate ?? false)
                          pw.Container(
                              child:
                                  pw.Text("RATE ", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmRmk ?? false)
                          pw.Container(
                              child: pw.Text(" RMK", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                        if (empOrderSettingModel.pdfItmAmt ?? false)
                          pw.Container(
                              child:
                                  pw.Text(" AMT", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                              decoration: pw.BoxDecoration(color: PdfColors.grey300)),
                      ]),
                      ...rowsDetails,
                    ]),
                  ),
                  pw.Divider(color: PdfColor.fromHex("#000000")),
                ]),
              ),
              if (isLastPage) ...[
                if (empOrderSettingModel.fixorderRmk != null && empOrderSettingModel.fixorderRmk != "")
                  pw.Container(
                      margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                        pw.Flexible(
                            child: pw.Text("${empOrderSettingModel.fixorderRmk} ",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique, color: PdfColors.red))),
                      ])),
                if (empOrderSettingModel.pdfPackingAtBottom ?? false)
                  pw.Container(
                      margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                        pw.Flexible(
                            child: pw.Text("PACKING:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique))),
                        pw.Flexible(
                            child: pw.Text("${ORDER.pack} ",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique)))
                      ])),
                if (empOrderSettingModel.sDhara ?? false)
                  pw.Container(
                      margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                        pw.Flexible(
                            child: pw.Text("DHARA:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique))),
                        pw.Flexible(
                            child: pw.Text("${ORDER.masterDet!.dhara ?? ""} ",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique)))
                      ])),
                pw.Container(
                  width: double.infinity,
                  child: pw.Container(
                      width: double.infinity,
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(1),
                          color: PdfColor.fromHex("#808080"),
                        ),
                        // width: 200,
                        // decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(10), border: pw.Border.all(width: 1)),
                        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                          pw.Text("BANK A/C : ${maincompanyObj!.aDDRESS3 ?? ""} ,IFSC:${maincompanyObj.aDDRESS4 ?? ""} ",
                              style: pw.TextStyle(
                                  fontSize: 11,
                                  font: pw.Font.courierBold(),
                                  decoration: pw.TextDecoration.underline,
                                  color: PdfColor.fromHex("#ffffff"))),
                        ]),
                      )),
                ),
                pw.Divider(color: PdfColor.fromHex("#000000")),
                pw.Container(
                    margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.Flexible(
                          child: pw.Text("REMARK:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique))),
                      pw.Flexible(
                          child:
                              pw.Text("${ORDER.rmk} ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique)))
                    ])),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                  pw.Container(
                      margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Text("For ",
                            style: pw.TextStyle(
                              fontSize: 15,
                            )),
                        pw.Text(" : ${maincompanyObj.fIRM}",
                            style: pw.TextStyle(
                              fontSize: 15,
                              font: pw.Font.timesBoldItalic(),
                              fontWeight: pw.FontWeight.bold,
                            ))
                      ]))
                ]),
                pw.Divider(color: PdfColor.fromHex("#000000")),
                pw.Container(
                    margin: pw.EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.Text("ORDER BY : ${createdBY!.toUpperCase()}",
                          style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black)),
                      pw.Text("ORD.GIVEN BY : ${(ORDER.orderGivenBy ?? "").toUpperCase()}",
                          style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black)),
                      pw.Text("AUTH. SIGNATORY",
                          style: pw.TextStyle(fontSize: 10, color: image.bytes.length > 0 ? PdfColors.black : PdfColors.black)),
                    ]))
              ] else ...[
                pw.Container(
                    margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                      pw.Flexible(
                          child: pw.Text("CONTINUE NEXT PAGE:",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15, font: courierBoldOblique))),
                    ])),
              ]
            ]));
          },
        ));
      }
    }).toList());

    if (qualImgList.length > 0 && empOrderSettingModel.showImgInOrder == true) {
      List<Map<String, dynamic>> qualImgMapList = [];
      await Future.wait(qualImgList.map((e) async {
        if ((e.colorDetails ?? []).length > 0) {
          await Future.wait(e.colorDetails!.map((element) async {
            if (element.url != null && element.url != "" && !element.url.toString().contains("Image_not_available")) {
              var fileOld = await baseCacheManager.getSingleFile(element.url!);
              Uint8List imageUint8List = await fileOld.readAsBytesSync();
              if (imageUint8List != null) {
                qualImgMapList.add({"qUAL": e.qUAL, "bytes": imageUint8List, "color": element.clName, "qty": element.clQty, "sr": e.sR});
              }
            }
          }).toList());
        } else {
          if (e.imageUrl != null && e.imageUrl != "" && !e.imageUrl.toString().contains("Image_not_available")) {
            var fileOld = await baseCacheManager.getSingleFile(e.imageUrl!);
            Uint8List imageUint8List = await fileOld.readAsBytesSync();
            if (imageUint8List != null) {
              qualImgMapList.add({"qUAL": e.qUAL, "bytes": imageUint8List, "sr": e.sR});
            }
          }
        }
      }).toList());
      qualImgMapList.sort((a, b) => a['sr'].compareTo(b['sr']));
      if (qualImgMapList.length > 0) {
        int imagesPerPage = 24;
        int totalPages = (qualImgMapList.length / imagesPerPage).ceil();
        for (int page = 0; page < totalPages; page++) {
          final currentImages = qualImgMapList.skip(page * imagesPerPage).take(imagesPerPage).toList();
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Column(
                  children: [
                    pw.Text("Product Images", style: pw.TextStyle(fontSize: 20, color: PdfColors.green)),
                    pw.Divider(),
                    pw.Expanded(
                        child: pw.GridView(
                            crossAxisCount: 6,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            children: currentImages.map((element) {
                              return pw.Container(
                                  padding: pw.EdgeInsets.all(10),
                                  child: pw.Column(
                                    children: [
                                      pw.Container(
                                          height: 20, child: pw.Text("${element['qUAL']}", style: pw.TextStyle(fontSize: 8, color: PdfColors.green))),
                                      pw.Image(pw.MemoryImage(element['bytes']), height: 100, width: 80, fit: pw.BoxFit.fill),
                                      if (element['color'] != null)
                                        pw.Container(
                                          height: 20,
                                          child: pw.Text("${element['color']} X ${element['qty']}",
                                              style: pw.TextStyle(fontSize: 7, color: PdfColors.black)),
                                        ),
                                    ],
                                  ));
                            }).toList())),
                  ],
                );
              },
            ),
          );
        }
      }
    }

    Uint8List pdfBytes = await pdf.save();
    var pdfName = Myf.removeSpecialCharacters("${partyname.toString()} $bill");
    if (pdfOprate == "enotify") {
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
  }

  static pw.TableRow tableRow(int sr, BillDetModel d) {
    var cUT = d.cUT;
    try {
      cUT = Myf.convertToDouble(d.cUT).toDouble().toStringAsFixed(2);
    } catch (e) {}
    return pw.TableRow(
      children: [
        pw.Container(child: pw.Text("${sr}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        pw.Container(child: pw.Text("${d.qUAL}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmcategory ?? false)
          pw.Container(child: pw.Text("${d.category}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmDno ?? false)
          pw.Container(child: pw.Text(" ${d.dno ?? ""}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmPacking ?? false)
          pw.Container(
              child: pw.Text("${Myf.nullC(d.packing)}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmSets ?? false)
          pw.Container(
              child: pw.Text("${d.pcsInSets}X${d.sets} ", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10)),
              decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        pw.Container(
            child: pw.Text("${Myf.convertToDouble(d.pCS).toInt()}", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10)),
            decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmCut ?? false)
          pw.Container(
              child: pw.Text("${cUT}", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10)),
              decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmRate ?? false)
          pw.Container(
              child: pw.Text("${Myf.getPackingRate(d).toString()} ", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10)),
              decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmRmk ?? false)
          pw.Container(child: pw.Text(" ${(d.rmk)}", style: pw.TextStyle(fontSize: 10)), decoration: pw.BoxDecoration(color: PdfColors.grey100)),
        if (empOrderSettingModel.pdfItmAmt ?? false)
          pw.Container(
              child: pw.Text("${(d.aMT)}", textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10)),
              decoration: pw.BoxDecoration(color: PdfColors.grey100)),
      ],
    );
  }

  static pw.Container summeryTotal(title, text) {
    return pw.Container(
        width: 200,
        // color: PdfColor.fromHex("#ffa500"),
        margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text(text),
        ]));
  }

  static pw.Container summeryRow(title, text) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))
        ]));
  }
}
