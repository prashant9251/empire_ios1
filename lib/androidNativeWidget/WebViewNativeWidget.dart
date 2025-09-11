import 'package:empire_ios/UniqWebView/UniqWebView.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef WebViewNativeCallBack = void Function(WebViewNativeController controller);

class WebViewNativeWidget extends StatefulWidget {
  const WebViewNativeWidget({Key? key, this.webViewNativeCallBack}) : super(key: key);

  final WebViewNativeCallBack? webViewNativeCallBack;
  @override
  State<WebViewNativeWidget> createState() => _WebViewNativeWidgetState();
}

class _WebViewNativeWidgetState extends State<WebViewNativeWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "plugin/uniq_webview",
        onPlatformViewCreated: _onPlatFormCreated,
      );
    }
    return Text("Erro in uniq widget");
  }

  void _onPlatFormCreated(int id) {
    if (widget.webViewNativeCallBack == null) {
      return;
    }
    widget.webViewNativeCallBack!(WebViewNativeController._(id));
  }
}

class WebViewNativeController {
  late BuildContext context;
  WebViewNativeController._(int id) : _channel = MethodChannel("plugin/uniq_webview_$id");
  final MethodChannel _channel;

  Future<Future<List?>> loadurl(String url, {required context}) async {
    this.context = context;
    _channel.setMethodCallHandler(callBackHandlerFromNative);
    return _channel.invokeListMethod("loadUrl", url).then((value) => null).catchError((onError) {});
  }

  Future<Future<List?>> createPdf() async {
    return _channel.invokeListMethod("createPdf", null).then((value) => null).catchError((onError) {});
  }

  Future callBackHandlerFromNative(MethodCall call) async {
    //get value from android
    switch (call.method) {
      case "shouldOverrideUrlLoading":
        var url = call.arguments;
        Myf.Navi(context, UniqWebView(mainUrl: url, CURRENT_USER: GLB_CURRENT_USER));
        break;
      default:
    }
  }
}
