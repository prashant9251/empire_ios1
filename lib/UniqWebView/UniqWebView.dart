import 'package:empire_ios/androidNativeWidget/WebViewNativeWidget.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class UniqWebView extends StatefulWidget {
  var mainUrl;
  dynamic CURRENT_USER;
  UniqWebView({Key? key, required this.mainUrl, required this.CURRENT_USER}) : super(key: key);

  @override
  State<UniqWebView> createState() => _UniqWebViewState();
}

class _UniqWebViewState extends State<UniqWebView> {
  late WebViewNativeController controller;
  void _displayWevViewCreated(WebViewNativeController controller) async {
    this.controller = controller;
    var UrlLinkUser = await Myf.UrlLinkUser(widget.CURRENT_USER, widget.mainUrl);
    var finalUrl = "${widget.mainUrl}$UrlLinkUser";
    controller.loadurl(finalUrl, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
      ),
      body: WebViewNativeWidget(
        webViewNativeCallBack: _displayWevViewCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.createPdf(),
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
