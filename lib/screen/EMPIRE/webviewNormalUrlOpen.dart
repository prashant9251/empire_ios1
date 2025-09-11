// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../main.dart';
import 'urlData.dart';

double _currentValue = 0;

class WebviewNormalUrlOpen extends StatefulWidget {
  var hiveBox;
  var mainUrl;
  var title;
  WebviewNormalUrlOpen({Key? key, required this.mainUrl, this.title}) : super(key: key);
  @override
  State<WebviewNormalUrlOpen> createState() => _WebviewNormalUrlOpenState();
}

class _WebviewNormalUrlOpenState extends State<WebviewNormalUrlOpen> {
  var finalUrl;

  late InAppWebViewController webViewController;

  var progressbar = 0.9;

  bool NewTab = false;

  @override
  void initState() {
    super.initState();
    // EasyLoading.show(status: 'loading...');
  }

  @override
  Widget build(BuildContext context) {
    finalUrl = "${widget.mainUrl}";

    //print("---------$finalUrl");
    return WillPopScope(
      onWillPop: () async {
        pdfStatus.sink.add("");
        return _goBack(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(value: progressbar, color: jsmColor),
              Expanded(
                  child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(finalUrl)),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            useOnDownloadStart: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            minimumFontSize: 8,
                            userAgent: urldata().UserAgent,
                            supportZoom: true,
                            useShouldOverrideUrlLoading: true,
                            javaScriptEnabled: true,
                            cacheEnabled: true,
                            preferredContentMode: UserPreferredContentMode.MOBILE),
                        android: AndroidInAppWebViewOptions(
                          hardwareAcceleration: true,
                          initialScale: 200,
                          displayZoomControls: false,
                          blockNetworkLoads: false,
                          builtInZoomControls: true,
                          useWideViewPort: false,
                          databaseEnabled: true,
                          allowFileAccess: true,
                          cacheMode: AndroidCacheMode.LOAD_DEFAULT,
                          domStorageEnabled: true,
                        ),
                        ios: IOSInAppWebViewOptions()),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    androidOnPermissionRequest: (controller, origin, resources) async {
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    },
                    onReceivedServerTrustAuthRequest: (controller, challenge) async {
                      //print("====sslIssue===${challenge}");
                      // EasyLoading.dismiss();
                      return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onLoadStop: (controller, url) async {
                      webViewController = controller;

                      if (Myf.isIos()) {
                        await localhostServer.close();
                      }
                      NewTab = true;
                    },
                    onLoadError: (controller, url, code, message) async {
                      if (Myf.isIos()) {
                        // Stop the current server
                        await localhostServer.close();

                        // Try starting a new server with a different port number
                        serverPort = serverPort + 1;
                        localhostServer = InAppLocalhostServer(port: serverPort);
                        await localhostServer.start();

                        // Reload the webview with the new URL
                        await webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url.toString())));
                        // EasyLoading.dismiss();
                      }
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      //print("-----log--${consoleMessage.message}");
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      var url = navigationAction.request.url!.toString();
                      //log("-----shou-----$url");
                      if (NewTab && url.indexOf("findBill.html") < 0 && url.indexOf("ntab=NTAB") > -1) {
                        Myf.Navi(context, WebviewNormalUrlOpen(mainUrl: url));
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onPrint: (InAppWebViewController controller, Uri? uri) {},
                    onProgressChanged: (_, load) {
                      setState(() {
                        progressbar = load / 100;
                      });
                    },
                  ),
                ],
              )),
              // Positioned(top: 0, bottom: 0, right: 0, left: 0, child: )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController.canGoBack()) {
      webViewController.goBack();
    } else {
      Navigator.pop(context);
      return Future.value(false);
    }
    return false;
  }
}
