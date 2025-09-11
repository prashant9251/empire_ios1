// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:empire_ios/Apis/Enotify.dart';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/QrCodeLinkRespModel.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/WhatsappContactSelectShare.dart';
import 'package:empire_ios/screen/WhatsappSendTaskListPdf/WhatsappSendTaskListPdf.dart';
import 'package:empire_ios/screen/WhatsappSendTaskListPdf/taskListPdfCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';

import '../../main.dart';

class HeadLessWebView extends StatefulWidget {
  dynamic CURRENT_USER;

  List<dynamic> urlListCall;
  HeadLessWebView({Key? key, this.CURRENT_USER, required this.urlListCall}) : super(key: key);

  @override
  State<HeadLessWebView> createState() => _HeadLessWebViewState();
}

class _HeadLessWebViewState extends State<HeadLessWebView> {
  HeadlessInAppWebView? headlessWebView;
  int currentIndex = 0;

  double progressbar = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadHeadLessWeb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("PDF SHARE"),
        actions: [
          // retry button
          IconButton(
              onPressed: () {
                loadHeadLessWeb();
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            progressbar == 1
                ? Icon(
                    Icons.done_outline_outlined,
                    size: 80,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.watch_later_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
            Text(
              "${progressbar == 1 ? "Created" : "Creating"} pdf ${pdfFileCreatedForBulkPdf.length}/${widget.urlListCall.length}",
              style: TextStyle(fontSize: 30),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progressbar,
                  color: jsmColor,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(progressbar == 1 ? "" : "Please wait"),
                  Text("${double.parse("${progressbar * 100}").toStringAsFixed(0)}%"),
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: progressbar >= 1
                    ? WidgetStateProperty.all<Color>(Colors.green) // Enabled color
                    : WidgetStateProperty.all<Color>(Colors.grey), // Disabled color
              ),
              onPressed: () {
                progressbar >= 1
                    ? pdfFileCreatedForBulkPdf.length > 0
                        ? Share.shareXFiles(pdfFileCreatedForBulkPdf)
                        : Myf.snakeBar(context, "No pdf found")
                    : null;
              },
              icon: Icon(Icons.share),
              label: Text(
                progressbar >= 1 ? "SHARE NOW " : "Pleas wait",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            progressbar == 1
                ? Card(
                    child: FutureBuilder(
                      future: EnotifyApis.getQrCodeApi(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return SizedBox.shrink();
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        dynamic snp = snapshot.data ?? {};
                        return Builder(builder: (context) {
                          if (snp["status"] == "qrcode") {
                            Uint8List decodedBytes = base64Decode(snp["data"]);
                            return ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("QR Code"),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Image.memory(
                                decodedBytes,
                                height: 200,
                                width: 200,
                              ),
                            );
                          } else if (snp["status"] == "success") {
                            QrCodeLinkRespModel qrCodeLinkRespModel = QrCodeLinkRespModel.fromJson(Myf.convertMapKeysToString(snp["data"] ?? {}));

                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Instance status "),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () async {
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.logout),
                                    onPressed: () async {
                                      Myf.snakeBar(context, "Please logout from your Device");
                                      // changeStream.add(true);
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Connected successfully",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Chip(
                                              label: Text("${qrCodeLinkRespModel.quota}"),
                                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text("Remaining "),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Chip(
                                                label: Text("${qrCodeLinkRespModel.instanceUsage}"),
                                                labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                                            Text("Credits usage"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Chip(
                                                label: Text(
                                                    "${Myf.dateFormateYYYYMMDD(qrCodeLinkRespModel.quotaValidity.toString(), formate: "dd-MMMM-yyyy")}"),
                                                labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                                            Text("Expiry date"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        });
                      },
                    ),
                  )
                : SizedBox.shrink(),
            ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                onPressed: () async {
                  List<WhatsappSendToModel> whatsappSendToModelList = [];
                  await Future.wait(widget.urlListCall.map(
                    (e) async {
                      WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel()
                        ..filePath = e["loc"]
                        ..pcode = e["code"]
                        ..pname = e["title"];
                      var ccode = e["ccode"] ?? {};
                      var bccode = e["bccode"] ?? {};
                      whatsappSendToModel.contactList = whatsappSendToModel.contactList ?? [];
                      if (ccode["MO"] != "" && ccode["MO"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = ccode["MO"]
                          ..name = ''
                          ..noType = "MO"
                          ..status = '');
                      }
                      if (ccode["PH1"] != "" && ccode["PH1"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = ccode["PH1"]
                          ..name = ''
                          ..noType = "PH1"
                          ..status = '');
                      }
                      if (ccode["PH2"] != "" && ccode["PH2"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = ccode["PH2"]
                          ..name = ''
                          ..noType = "PH2"
                          ..status = '');
                      }
                      if (ccode["FX1"] != "" && ccode["FX1"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = ccode["FX1"]
                          ..name = ''
                          ..noType = "FX1"
                          ..status = '');
                      }
                      if (bccode["MO"] != "" && bccode["MO"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = bccode["MO"]
                          ..name = ''
                          ..noType = "MO"
                          ..uType = "Broker"
                          ..status = '');
                      }

                      if (bccode["PH1"] != "" && bccode["PH1"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = bccode["PH1"]
                          ..name = ''
                          ..noType = "PH1"
                          ..uType = "Broker"
                          ..status = '');
                      }
                      if (bccode["PH2"] != "" && bccode["PH2"] != null) {
                        whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                          ..phone = bccode["PH2"]
                          ..name = ''
                          ..noType = "PH2"
                          ..uType = "Broker"
                          ..status = '');
                      }
                      if (whatsappSendToModel.contactList!.length > 0) whatsappSendToModelList.add(whatsappSendToModel);
                    },
                  ).toList());
                  await Myf.Navi(context, WhatsappContactSelectShareScreen(whatsappSendToModelList: whatsappSendToModelList, shareBy: "enotify"));
                },
                child: Text(
                  "Send Pdf Automatically",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        )),
      ),
    );
  }

  Future loadHeadLessWeb() async {
    try {
      var runingServer = await localhostServer.isRunning();
      if (!runingServer) {
        try {
          await localhostServer.start();
        } catch (e) {}
        runingServer = await localhostServer.isRunning();
      }
      if (currentIndex < widget.urlListCall.length) {
        var url = widget.urlListCall[currentIndex]["urlLink"];
        headlessWebView = HeadlessInAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          onWebViewCreated: (controller) async {
            controller.addJavaScriptHandler(
                handlerName: 'SaveToLocal',
                callback: (args) async {
                  return await Myf.SaveToLocal(args);
                });

            controller.addJavaScriptHandler(
                handlerName: 'GetFromLocal',
                callback: (args) async {
                  return await Myf.GetFromLocalInJson(args);
                });
            controller.addJavaScriptHandler(
                handlerName: 'directPdfCreateOnLoad',
                callback: (args) async {
                  var htmlContent = await controller.getHtml();
                  var title = await controller.getTitle();
                  File pdfFile = await createPdfFile(context, htmlContent, title);
                  pdfFileCreatedForBulkPdf.add(XFile(pdfFile.path));
                  widget.urlListCall[currentIndex]["loc"] = pdfFile.path;
                  widget.urlListCall[currentIndex]["title"] = title;
                  currentIndex++;
                  headlessWebView!.dispose();
                  progressChange();
                  loadHeadLessWeb();
                });
          },
          onLoadStart: (controller, url) async {},
          onLoadStop: (controller, url) async {},
        );
        if (!headlessWebView!.isRunning()) {
          await headlessWebView?.run();
        }
      } else {
        if (Platform.isIOS) {
          await localhostServer.close();
        }
      }
    } catch (e) {
      Myf.snakeBar(context, "$e");
    }
  }

  createPdfFile(BuildContext context, String? htmlContent, String? title) async {
    File? file = await Myf.createPdfhtml(context, htmlContent, title, false);
    return file;
  }

  void progressChange() {
    var totalReq = widget.urlListCall.length;
    var doneReq = pdfFileCreatedForBulkPdf.length;
    setState(() {
      progressbar = doneReq / totalReq * 1;
    });
  }
}
