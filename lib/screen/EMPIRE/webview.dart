// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/UniqWebView/UniqWebView.dart';
import 'package:empire_ios/functions/htmlToPdf.dart';
import 'package:empire_ios/remark/Remark.dart';
import 'package:empire_ios/remark/addNewRemark.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/webviewHeadless.dart';
import 'package:empire_ios/screen/ProductManagement/editImage.dart';
import 'package:empire_ios/screen/WhatsappContactSelectShare.dart';
import 'package:empire_ios/screen/complain/ComplainRegister.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:empire_ios/screen/orderForm/OrderFormList/OrderFormList.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart';

import '../../main.dart';
import 'urlData.dart';

double _currentValue = 0;

class WebView extends StatefulWidget {
  var hiveBox;
  var mainUrl;
  dynamic CURRENT_USER;
  WebView({Key? key, required this.mainUrl, required this.CURRENT_USER, this.hiveBox}) : super(key: key);
  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> with WidgetsBindingObserver {
  final StreamController<bool> somthingChangeInWebviewStream = StreamController<bool>.broadcast();
  bool _isSearching = false;
  var _searchQuery = TextEditingController();
  var databaseId = "";
  String pdfSystemForAndroid = firebaseCurrntUserObj["pdfSystemForAndroid"] ?? "";
  String Mobile = "";
  String partyEmail = "";
  var generatedPdfFilePath;
  final htmlContent = "";
  var css = "";
  var finalUrl;
  var UrlLinkUser = "";
  double progressbar = 0;
  InAppWebViewController? webController;
  var zoomFactor = 200;
  var NewTab = false;
  bool runingServer = true;
  String ErroMsg = "";
  var title = "";
  File? filePdfForShare;

  var lastUpdatetime = "";

  var preFilledPbj = {};

  var shareText = "Hello Sir";

  List getBoxDataList = [];

  List getExtraProductImageFileList = [];
  final progressStream = StreamController<double>.broadcast();

  bool BillpdfLoaded = false;

  late SendPort sendPort;
  var receivePort = ReceivePort();
  var whatsappSendToModelList = <WhatsappSendToModel>[];

  Future<void> getData() async {
    GLB_CURRENT_USER = widget.CURRENT_USER;
    databaseId = Myf.databaseId(widget.CURRENT_USER);
    UrlLinkUser = await Myf.UrlLinkUser(widget.CURRENT_USER, widget.mainUrl);
    lastUpdatetime = await Myf.getValFromSavedPref(widget.CURRENT_USER, "lastUpdatetime");
    if (await Myf.isAndroid()) {
      runingServer = await localhostServer.isRunning();
      if (!runingServer) {
        try {
          await localhostServer.start();
          runingServer = await localhostServer.isRunning();
        } catch (e) {
          //print(e);
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Mobile = Myf.getUrlParams(widget.mainUrl, "mobileNo")!;
    partyEmail = Myf.getUrlParams(widget.mainUrl, "partyEmail")!;
    getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // webController!.reload();
    } else if (state == AppLifecycleState.inactive) {
      // webController!.reload();
    } else if (state == AppLifecycleState.resumed) {
      // webController!.reload();
    }
  }

  var isGoBackPress = false;
  @override
  Widget build(BuildContext context) {
    finalUrl = "${widget.mainUrl}$UrlLinkUser";
    //print("---------$finalUrl");
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        pdfStatus.sink.add("");
        if (!isGoBackPress) {
          isGoBackPress = true;
          await _goBack(context);
          isGoBackPress = false;
        }
      },
      child: Scaffold(
        // endDrawer: Drawer(
        //   child: Remark(UserObj: widget.CURRENT_USER, preFilledPbj: preFilledPbj),
        // ),
        onEndDrawerChanged: (isOpened) async {
          preFilledPbj["title"] = await webController!.getTitle();
          preFilledPbj["form"] = getFileNameFromUrl(widget.mainUrl);
          preFilledPbj["url"] = finalUrl;
        },
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
          backgroundColor: jsmColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder(
                  stream: progressStream.stream,
                  builder: (context, snapshot) {
                    return LinearProgressIndicator(value: progressbar, color: jsmColor);
                  }),
              if (ErroMsg.isNotEmpty && ErroMsg.length > 0) Text(ErroMsg) else SizedBox.shrink(),
              Expanded(
                child: runingServer
                    ? UrlLinkUser.isNotEmpty && UrlLinkUser.length > 0
                        ? Stack(
                            children: [
                              InAppWebView(
                                initialUrlRequest: URLRequest(url: WebUri(finalUrl)),
                                initialSettings: InAppWebViewSettings(
                                  allowContentAccess: true,
                                  allowFileAccess: true,
                                  allowFileAccessFromFileURLs: true,
                                  allowUniversalAccessFromFileURLs: true,
                                  javaScriptCanOpenWindowsAutomatically: true,
                                  minimumFontSize: 8,
                                  userAgent: urldata().UserAgent,
                                  supportZoom: true,
                                  useShouldOverrideUrlLoading: true,
                                  javaScriptEnabled: true,
                                  cacheEnabled: true,
                                  preferredContentMode: UserPreferredContentMode.MOBILE,
                                  cacheMode: CacheMode.LOAD_DEFAULT,
                                  useOnDownloadStart: true,
                                  allowsInlineMediaPlayback: true, //this add new last
                                  sharedCookiesEnabled: true, //this add new last
                                  isFraudulentWebsiteWarningEnabled: true, //this add new last
                                  useWideViewPort: false,
                                  builtInZoomControls: true,
                                  displayZoomControls: false,
                                  databaseEnabled: true,
                                  domStorageEnabled: true,
                                  useHybridComposition: false,
                                  hardwareAcceleration: true,
                                  initialScale: int.parse("${widget.CURRENT_USER["WEB"] ?? "200"}"),
                                  blockNetworkLoads: false,
                                ),
                                onWebViewCreated: (controller) async {
                                  await setCookies(widget.mainUrl, "login_user", "prashant3009");
                                  webController = controller;
                                  webController!.addJavaScriptHandler(
                                      handlerName: 'getSharedprefVal',
                                      callback: (args) async {
                                        if (args.length > 0) {
                                          var v = await Myf.getValFromSavedPref(GLB_CURRENT_USER, args[0]);
                                          return v;
                                        }
                                      });
                                  webController!.addJavaScriptHandler(
                                      handlerName: 'saveSharedprefVal',
                                      callback: (args) async {
                                        if (args.length > 0) {
                                          var v = await Myf.saveValToSavedPref(GLB_CURRENT_USER, args[0], args[1]);
                                          return v;
                                        }
                                      });
                                  webController!.addJavaScriptHandler(
                                      handlerName: 'getUpiLink',
                                      callback: (args) async {
                                        return await Myf.GetFromLocal(args, HiveBox: currentHiveBox);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'getCurrentUserFromFlutter',
                                      callback: (args) async {
                                        return widget.CURRENT_USER; //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'Android',
                                      callback: (args) {
                                        if (finalUrl.toString().indexOf("jsonSyncToIndexeddb") > -1) {
                                          jsonSyncToIndexeddb(args);
                                        }
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'passMobileNoEmail',
                                      callback: (args) async {
                                        if (args.length > 0) {
                                          Mobile = args[0] ?? "";
                                          partyEmail = args[1] ?? "";
                                          somthingChangeInWebviewStream.sink.add(true);
                                          // logger.d(args);
                                        }
                                        return true;
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'SaveToLocal',
                                      callback: (args) async {
                                        return await Myf.SaveToLocal(args, HiveBox: currentHiveBox);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'GetFromLocal',
                                      callback: (args) async {
                                        return await Myf.GetFromLocalInJson(args);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'Android',
                                      callback: (args) {
                                        if (finalUrl.indexOf("jsonSyncToIndexeddb") > -1) {
                                          jsonSyncToIndexeddb(args);
                                        }
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'shareText',
                                      callback: (args) async {
                                        Myf.shareText(args); //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'sendShareTextToApp',
                                      callback: (args) async {
                                        shareText = args[0] ?? ""; //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'dialNo',
                                      callback: (args) async {
                                        Myf.dialNo(args, context); //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'createTempFlutterPdf',
                                      callback: (args) async {
                                        // createTempPdf(); //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'openComplainRegistration',
                                      callback: (args) async {
                                        Myf.Navi(context, ComplainRegistration(UserObj: widget.CURRENT_USER)); //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'openProductList',
                                      callback: (args) async {
                                        List<dynamic> l = args[0];
                                        List LID_LIST = [];
                                        await Future.wait(l.map((e) async {
                                          var id = "${e["value"].toString().toUpperCase().hashCode}";
                                          // if (LID_LIST.length < 10) {
                                          LID_LIST.add(id);
                                          // }
                                        }).toList());
                                        filterProductTagList.sink.add(LID_LIST);
                                        Navigator.pop(context);
                                        // Myf.Navi(context, ProductFirebaseList(UserObj: widget.CURRENT_USER)); //------share text
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'bulkPdfStartCreateShare',
                                      callback: (args) async {
                                        List<dynamic> urlListgetedForBulkPdf = args[0];
                                        pdfFileCreatedForBulkPdf = [];
                                        Myf.Navi(context, HeadLessWebView(CURRENT_USER: widget.CURRENT_USER, urlListCall: urlListgetedForBulkPdf));
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'CreateOrderFormHtmlToPdf',
                                      callback: (args) async {
                                        // //print("=========${args[0]}");
                                        PdfApi.createPdfAndView(ORDER: args[0], context: context);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'saveOrderToFirestore',
                                      callback: (args) async {
                                        var o = await Myf.saveOrderToFirestore(args, context, UserObj: widget.CURRENT_USER);
                                        PdfApi.createPdfAndView(ORDER: o, context: context);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'openOrderList',
                                      callback: (args) async {
                                        await Myf.Navi(context, OrderFormList(UserObj: widget.CURRENT_USER, args: args));
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'showtoast',
                                      callback: (args) async {
                                        Myf.toast(args[0], context: context);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'syncDatabyFlutter',
                                      callback: (args) async {
                                        await Myf.startServerSync(context, UserObj: widget.CURRENT_USER);
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'getBoxData',
                                      callback: (args) async {
                                        var key = args[1];
                                        var databaseIdCurrent = await Myf.databaseIdCurrent(widget.CURRENT_USER);
                                        getBoxDataList = [];
                                        try {
                                          var b = await Hive.openBox("${databaseIdCurrent}$key");
                                          getBoxDataList = await b.values.toList();
                                          await b.close();
                                        } catch (e) {}
                                        return await getBoxDataList;
                                      });

                                  controller.addJavaScriptHandler(
                                      handlerName: 'getExtraProductImageFile',
                                      callback: (args) async {
                                        getExtraProductImageFileList = [];
                                        getExtraProductImageFileList = args[0];
                                        await Future.wait(getExtraProductImageFileList.map((e) async {
                                          var url = e["url"];
                                          var f = await baseCacheManager.getSingleFile(url);
                                          e["cachePath"] = await f.path;
                                        }).toList());
                                        // logger.d(getExtraProductImageFileList);
                                        somthingChangeInWebviewStream.sink.add(true);
                                      });

                                  controller.addJavaScriptHandler(
                                      handlerName: 'viewImageByLink',
                                      callback: (args) async {
                                        Myf.Navi(context, fullScreenImg(img_list: [args[0]]));
                                      });
                                  controller.addJavaScriptHandler(
                                      handlerName: 'WhatsappContactSelectShareScreen',
                                      callback: (args) async {
                                        title = await webController!.getTitle() ?? "";
                                        filePdfForShare = await createPdfFile(context, true);
                                        WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel()
                                          ..filePath = filePdfForShare!.path
                                          ..pcode = title
                                          ..pname = title;
                                        args.map((e) {
                                          whatsappSendToModel.contactList!.add(WhatsappSendToContactModel()
                                            ..phone = e["PH2"]
                                            ..name = ''
                                            ..noType = "PH2"
                                            ..status = '');
                                          whatsappSendToModelList.add(whatsappSendToModel);
                                        });
                                      });
                                },
                                onPermissionRequest: (controller, request) async {
                                  return PermissionResponse(
                                    resources: request.resources,
                                    action: PermissionResponseAction.GRANT,
                                  );
                                },
                                onReceivedServerTrustAuthRequest: (controller, challenge) async {
                                  // //print("====sslIssue===${challenge}");
                                  // EasyLoading.dismiss();
                                  return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                                },
                                onLoadStop: (controller, url) async {
                                  webController = controller;

                                  // css = await Myf.getCss(url.toString().toUpperCase());
                                  // await controller.injectCSSCode(source: css);
                                  if (Myf.isIos()) {
                                    if (localhostServer.isRunning()) {
                                      await localhostServer.close();
                                    }
                                  }
                                  NewTab = true;
                                  // var pdf = await webController?.ios.createPdf();
                                  //webController?.printCurrentPage();
                                  // EasyLoading.dismiss();
                                },
                                onLoadError: (controller, url, code, message) async {
                                  //print("-----err--$message $code");
                                  ErroMsg = message;
                                  ErroMsg += " Please Restart App ";
                                },
                                onConsoleMessage: (controller, consoleMessage) {
                                  // //print("-----log--${consoleMessage.message}");
                                  //print(consoleMessage);
                                },
                                shouldOverrideUrlLoading: (controller, navigationAction) async {
                                  var url = navigationAction.request.url!.toString();

                                  if (NewTab && url.indexOf("PDFBILLTYPE=findBill") < 0 && url.indexOf("ntab=NTAB") > -1) {
                                    Myf.Navi(context, WebView(mainUrl: url, CURRENT_USER: widget.CURRENT_USER));
                                    return await NavigationActionPolicy.CANCEL;
                                  }
                                  return await NavigationActionPolicy.ALLOW;
                                },
                                onProgressChanged: (_, load) {
                                  setState(() {
                                    progressbar = load / 100;
                                  });
                                },
                              ),
                              pdfLoader(),
                            ],
                          )
                        : Center(child: const Text("somthing went wrong restart app "))
                    : Center(child: Text("Sorry port is close Please restart app to open port again")),
              ),
              // Positioned(top: 0, bottom: 0, right: 0, left: 0, child: )
            ],
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
            stream: somthingChangeInWebviewStream.stream,
            builder: (context, snapshot) {
              // //print("=======mobile========${Mobile}");
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  partyEmail.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            heroTag: "shareEmailDirect${++srrr}",
                            onPressed: () async {
                              if (IosPlateForm) {
                                filePdfForShare = await createPdfFile(context, true);
                                Myf.sendFileEmail(partyEmail, filePdfForShare!.path, "$title", "$title");
                              } else {
                                title = await webController!.getTitle() ?? "";
                                // Myf.showLoading(context, "Creating pdf...");
                                // var p =
                                // await webController!.printCurrentPageDirectShare(mobile: "91$Mobile", sendType: "email", email: partyEmail);
                                // Myf.popScreen(context);
                                // filePdfForShare = File(p);
                                Myf.sendFileEmail(partyEmail, filePdfForShare!.path, "$title", "$title");
                              }
                            },
                            child: Icon(
                              Icons.email,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  Mobile.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: FloatingActionButton(
                            heroTag: "shareDirectText${++srrr}",
                            onPressed: () async {
                              String url = "whatsapp://send?phone=91$Mobile&text=$shareText";
                              launchUrl(Uri.parse(url));
                            },
                            child: Icon(Icons.message),
                          ),
                        )
                      : SizedBox.shrink(),
                  Myf.isAndroid() && Mobile.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: FloatingActionButton(
                            heroTag: "shareDirect${++srrr}",
                            onPressed: () async {
                              // if (filePdfForShare == null) {
                              filePdfForShare = await createPdfFile(context, true);
                              Myf.shareOnlyAndroidWhatsApp(filePdfForShare!.path, "91$Mobile");
                            },
                            child: Image.asset("assets/img/whatsapp.png"),
                            backgroundColor: Colors.white,
                          ),
                        )
                      : SizedBox.shrink(),
                  FloatingActionButton(
                    heroTag: "sharePdf${++srrr}",
                    onPressed: () async {
                      pdfSystemForAndroid = firebaseCurrntUserObj["pdfSystemForAndroid"] ?? "";
                      if (Myf.isAndroid()) {
                        title = await webController!.getTitle() ?? "";
                        // Myf.showLoading(context, "Creating pdf...");
                        // var p =
                        var v = await webController!.printCurrentPage();

                        // Myf.popScreen(context);
                        // filePdfForShare = File(p);
                        // await Share.shareXFiles([await XFile(filePdfForShare!.path)]);
                      } else {
                        filePdfForShare = await createPdfFile(context, true);
                        SharePlus.instance.share(ShareParams(
                          title: title,
                          files: [XFile(filePdfForShare!.path)],
                        ));
                      }
                    },
                    child: const Icon(
                      Icons.picture_as_pdf_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.pink,
                  ),
                ],
              );
            }),
      ),
    );
  }

  // Future<File?>
  createPdfFile(BuildContext context, bool showLoader) async {
    Myf.isAndroid()
        ? showLoader
            ? pdfStatus.sink.add("creating pdf...")
            : null
        : null;
    title = (await webController!.getTitle())!;
    final htmlContent = await webController!.getHtml();
    File? file = await Myf.createPdfhtml(context, htmlContent, title, showLoader, url: finalUrl);
    return file;
  }

  StreamBuilder<String> pdfLoader() {
    return StreamBuilder<String>(
      stream: pdfStatus.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return Container(
                color: Colors.black.withOpacity(0.7),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${snapshot.data}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    // CircularProgressIndicator(),
                  ],
                )));
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Center creatingPdfShowLoading(AsyncSnapshot<String> snapshot) {
    return Center(
      child: Card(
        elevation: 20,
        color: Colors.grey[500],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, // red as border color
            ),
            borderRadius: BorderRadius.circular(5), // radius of 10
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${snapshot.data}", style: TextStyle(fontSize: 45, color: Colors.white)),
              Text("Please Wait", style: TextStyle(fontSize: 20, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Future _goBack(BuildContext context) async {
    if (webController != null) {
      if (await webController!.canGoBack()) {
        await webController!.goBack();
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void appBarActionCall(List args) {
    //print(args);
  }

  void onSelected(int item) async {
    //print(item);
    switch (item) {
      case 0:
        await webController!.evaluateJavascript(source: "selectBoxReport();");
        break;
      case 1:
        await webController!.evaluateJavascript(source: "showhideUnhide();");
        break;
      case 2:
        await webController!.printCurrentPage();
        break;
      case 3:
        await takeScreenShot();
        break;
      case 4:
        await Myf.startServerSync(context, UserObj: widget.CURRENT_USER);
        break;
      case 5:
        Restart.restartApp();
        break;
      case 6:
        // Uint8List? w = await webController!.ios.createPdf();
        // await Myf.savePdfToFile(w);
        // return;
        if (await Myf.isIos()) {
          filePdfForShare = await createPdfFile(context, true);
          OpenFilex.open(filePdfForShare!.path);
        } else if (await Myf.isAndroid()) {
          title = await webController!.getTitle() ?? "";
          // Myf.showLoading(context, "Creating pdf...");
          // var p =
          // await webController!.printCurrentPageDirectShare(mobile: "91$Mobile", sendType: "view");
          // Myf.popScreen(context);
          // OpenFilex.open(p);
        }
        break;
      case 8:
        preFilledPbj["title"] = await webController!.getTitle();
        preFilledPbj["form"] = getFileNameFromUrl(widget.mainUrl);
        preFilledPbj["url"] = finalUrl;
        Myf.Navi(context, addNewRemark(UserObj: widget.CURRENT_USER, preFilledPbj: preFilledPbj));
        break;
      case 7:
        var calc = SimpleCalculator(
          hideExpression: false,
          hideSurroundingBorder: true,
          autofocus: true,
          value: _currentValue,
          onChanged: (key, value, expression) {
            setState(() {
              _currentValue = value ?? 0;
            });
          },
          onTappedDisplay: (value, details) {},
          theme: const CalculatorThemeData(
            borderColor: Colors.black,
            borderWidth: 2,
            operatorColor: Color.fromARGB(255, 88, 140, 126),
            commandColor: Color.fromARGB(255, 88, 140, 126),
            numStyle: TextStyle(fontSize: 50, color: Colors.black),
          ),
        );
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
            });
        break;
      case 9:
        List<XFile> newXfileList = await renameListOfFile();
        if (await Myf.isIos()) {
          filePdfForShare = await createPdfFile(context, true);
          SharePlus.instance.share(ShareParams(
            files: [...newXfileList, XFile(filePdfForShare!.path)],
          ));
        } else {
          List<String> filePaths = newXfileList.map((xFile) => (xFile.path)).toList();

          title = await webController!.getTitle() ?? "";
          // Myf.showLoading(context, "Creating pdf...");
          // var p =
          // await webController!.printCurrentPageDirectShare(mobile: "91$Mobile", sendType: "whatsapp", extraFileListForShare: filePaths);
          // Myf.popScreen(context);
          // await Share.shareXFiles([...newXfileList, await XFile(p)]);
        }
        break;
      case 10:
        filePdfForShare = await createPdfFile(context, true);
        SharePlus.instance.share(ShareParams(
          files: [XFile(filePdfForShare!.path)],
        ));
        break;
      case 11:
        await Myf.cacheClear(context: context, CURRENT_USER: widget.CURRENT_USER, webController: webController);
        break;
      default:
    }
  }

  // void iosPdf() async {
  //   var d = await webController!.createPdf(
  //       pdfConfiguration: PDFConfiguration(
  //     rect: InAppWebViewRect(
  //       x: 0,
  //       y: 0,
  //       width: 1000,
  //       height: 1000,
  //     ),
  //   ));
  //   File f = await Myf.saveAsPdf(d!, "fileName");
  //   Share.shareXFiles([XFile(f.path)]);
  // }

  // void androidPdf() async {
  //   var d = await webController!.createPdf(
  //       pdfConfiguration: PDFConfiguration(
  //     rect: InAppWebViewRect(
  //       x: 0,
  //       y: 0,
  //       width: 1000,
  //       height: 1000,
  //     ),
  //   ));
  //   File f = await Myf.saveAsPdf(d!, "fileName");
  //   OpenFilex.open(f.path);
  // }

  renameListOfFile() async {
    List<XFile> neqFileLst = [];
    await Future.wait(getExtraProductImageFileList.map((e) async {
      var cachePath = e["cachePath"];
      File f = await buildPDFImageClass.copyWithNewName("${e["qual"]}", cachePath);
      neqFileLst.add(XFile(f.path));
    }).toList());
    return neqFileLst;
  }

  void jsonSyncToIndexeddb(List args) {
    prefs!.setString("lastUpdatetime", args[0]['lastUpdatetime']);
    Navigator.of(context).pop(args[0]['lastUpdatetime']);
  }

  _createFileFromBase64(String base64content, String fileName) async {
    var bytes = base64Decode(base64content.replaceAll('\n', ''));
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
    ));
    // await OpenFile.open("${output.path}/$fileName.pdf");
    setState(() {});
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              setState(() {
                _isSearching = false;
              });
              return;
            }
            _clearSearchQuery();
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () async {
            // webController!.findAllAsync(find: _searchQuery.text);
            setState(() {
              webController!.findNext(forward: false);
            });
            // setState(() {});
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () async {
            setState(() {
              webController!.findNext(forward: true);
            });
          },
        )
      ];
    }

    return _action();
  }

  List<Widget> _action() {
    return <Widget>[
      IconButton(
          onPressed: () async {
            await Myf.startServerSync(context, UserObj: widget.CURRENT_USER);
          },
          icon: const Icon(Icons.sync_outlined, color: Colors.white)),
      IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
      barCodeIcon(),
      PopupMenuButton<int>(
        color: Colors.white,
        onSelected: (item) => onSelected(item),
        itemBuilder: (context) => [
          const PopupMenuItem<int>(
            value: 0,
            child: Text(
              'SELECT',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text(
              'HIDE/UNHIDE',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text(
              'PRINT SCREEN',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const PopupMenuItem<int>(
            value: 3,
            child: Text(
              'SCREEN SHOT',
              style: TextStyle(color: Colors.black),
            ),
          ),
          PopupMenuItem<int>(
            value: 4,
            child: Text(
              'SYNC ${widget.CURRENT_USER["yearVal"]} YEAR',
              style: TextStyle(color: Colors.black),
            ),
          ),
          PopupMenuItem<int>(
            value: 5,
            child: Text(
              'RESTART APPLICATION',
              style: TextStyle(color: Colors.black),
            ),
          ),
          PopupMenuItem<int>(
            value: 6,
            child: Text(
              'VIEW PDF & DOWNLOAD',
              style: TextStyle(color: Colors.black),
            ),
          ),
          // PopupMenuItem<int>(
          //   onTap: () async {
          //     await Myf.Navi(context, WhatsappContactSelectShareScreen(whatsappSendToModelList: whatsappSendToModelList, shareBy: "enotify"));
          //   },
          //   child: Text(
          //     'SEND PDF AUTOMATICALLY',
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
          PopupMenuItem<int>(
            value: 7,
            child: Text(
              'CALCULATOR',
              style: TextStyle(color: Colors.black),
            ),
          ),
          PopupMenuItem<int>(
            value: 9,
            enabled: getExtraProductImageFileList.length > 0 ? true : false,
            child: getExtraProductImageFileList.length > 0
                ? Text(
                    'PDF WITH ${getExtraProductImageFileList.length == 0 ? "" : getExtraProductImageFileList.length} PHOTO',
                    style: TextStyle(color: Colors.black),
                  )
                : null,
          ),
          PopupMenuItem<int>(
            value: 10,
            child: Text(
              'PDF GENERATE',
              style: TextStyle(color: Colors.black),
            ),
          ),
          PopupMenuItem<int>(
            value: 11,
            child: Text(
              'TROUBLESHOOT',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )
    ];
  }

  Widget barCodeIcon() {
    if (widget.mainUrl.toString().contains("PCSSTOCK_FRMReport") && loginUserModel.oRDERFORMENABLE == "1") {
      return IconButton(
        icon: const Icon(Icons.qr_code, color: Colors.white),
        onPressed: () async {
          String barcodeScanRes;
          if (Myf.isAndroid()) {
            barcodeScanRes = await AndroidChennal.invokeMethod('startScane', []);
            // barcodeScanRes = await Myf.Navi(context, EmpOrderproductScanner());
            if (barcodeScanRes == null || barcodeScanRes == "") return;
          } else {
            barcodeScanRes = await BarCodeScaneGoogleMlKit.startScane() ?? "";
            if (barcodeScanRes == null || barcodeScanRes == "") return;
          }
          barcodeScanRes = barcodeScanRes.trim();
          await webController!.evaluateJavascript(source: "loadBarCode('$barcodeScanRes');");
        },
      );
    }
    return SizedBox.shrink();
  }

  void _clearSearchQuery() {
    //print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  takeScreenShot() async {
    Uint8List? imageInUnit8List = await webController!.takeScreenshot();
    ; // store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List!);
    SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
    ));
  }

  void updateSearchQuery(String newQuery) async {
    if (newQuery.isNotEmpty) {
      await webController!.findAllAsync(find: newQuery);
    }
    //print("search query " + newQuery);
  }

  _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YEAR:-${widget.CURRENT_USER['yearVal']}',
          style: TextStyle(fontSize: 8),
        ),
        Text(
          '${widget.CURRENT_USER["SHOPNAME"]}',
          style: TextStyle(fontSize: 8),
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                'L.S:- ${lastUpdatetime}',
                style: TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void saveTaskToFirebase() async {
    Map<String, dynamic> taskObj = {};
    taskObj["title"] = await webController!.getTitle();
    taskObj["sr"] = 1;
    taskObj["type"] = "menual";
    taskObj["loc"] = "";
    taskObj["sentBy"] = widget.CURRENT_USER["login_user"];
    taskObj["user_mo"] = widget.CURRENT_USER["mobileno_user"];
    Myf.savePdfHistoryToFireBase(UserObj: widget.CURRENT_USER, taskID: Myf.dateFormateInDDMMYYYY(DateTime.now().toString()), taskObj: taskObj);
  }

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }
    return '';
  }

  setCookies(url, c_name, c_value) async {
    CookieManager cookieManager = CookieManager.instance();
    // Example cookie
    await cookieManager.setCookie(
      url: WebUri(url),
      name: '$c_name',
      value: '$c_value',
      domain: url,
      path: '/',
      expiresDate: DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch,
      isSecure: true,
      isHttpOnly: false,
    );
  }
}

// Future<void> printCurrentPageDirectShare({mobile, email, sendType, extraFileListForShare}) async {
//   Map<String, dynamic> args = <String, dynamic>{};
//   args["mobile"] = mobile;
//   args["email"] = email;
//   args["sendType"] = sendType;
//   args["extraFileListForShare"] = extraFileListForShare;
  // await _channel?.invokeMethod('printCurrentPageDirectShare', args);
// }

  // Future<void> printCurrentPageDirectShare({mobile, email, sendType, extraFileListForShare}) async {
//   Map<String, dynamic> args = <String, dynamic>{};
//   args["mobile"] = mobile ?? '';
//   args["email"] = email ?? '';
//   args["sendType"] = sendType ?? '';
//   args["extraFileListForShare"] = extraFileListForShare ?? [];
  // final printJobControllerPlatform = await platform.printCurrentPageDirectShare(settings: args);
// }


