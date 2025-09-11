import 'dart:io';

import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JsmTransfer extends StatefulWidget {
  const JsmTransfer({Key? key}) : super(key: key);

  @override
  State<JsmTransfer> createState() => _JsmTransferState();
}

class _JsmTransferState extends State<JsmTransfer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(title: Text("App change")),
      body: InkWell(
        onTap: () => downloadApp(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              " Please download New app from App store ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            Image.asset("assets/img/jsmnew.png"),
            ElevatedButton(onPressed: () => downloadApp(), child: Text("Download Jsm App ")),
            Text("and Uninstall Current App")
          ],
        ),
      ),
    );
  }

  downloadApp() {
    var url = "https://apps.apple.com/us/app/jsm-app/id6444143921";
    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=com.uniq.jsm_ios";
    }

    // launchUrl(Uri.parse(url));
  }
}
