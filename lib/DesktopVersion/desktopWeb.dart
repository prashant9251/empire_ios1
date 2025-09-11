// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class DeskTopWeb extends StatefulWidget {
  var url;

  var UserObj;
  DeskTopWeb({Key? key, required this.url, required this.UserObj}) : super(key: key);

  @override
  DeskTopWebState createState() => DeskTopWebState();
}

class DeskTopWebState extends State<DeskTopWeb> {
  var loading = true;
  late final PlatformWebViewController _controller;

  var databaseId;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? CircularProgressIndicator()
          : PlatformWebViewWidget(
              PlatformWebViewWidgetCreationParams(controller: _controller),
            ).build(context),
    );
  }

  void getData() async {
    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse('${widget.url}'),
        ),
      );

    loading = false;
    databaseId = Myf.databaseId(widget.UserObj);
  }
}
