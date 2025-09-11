// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'expiries/expCalculation.dart';

class DemoExpired extends StatefulWidget {
  DemoExpired({Key? key, required this.UserObj, this.showExpMsg}) : super(key: key);
  dynamic UserObj;
  var showExpMsg;
  @override
  State<DemoExpired> createState() => _DemoExpiredState();
}

class _DemoExpiredState extends State<DemoExpired> {
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    Myf.verify(context, widget.UserObj);
    ExpCalculate.checkExp(widget.UserObj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text("Version Expired"),
          backgroundColor: jsmColor,
          actions: [IconButton(onPressed: () => Myf.verify(context, widget.UserObj), icon: Icon(Icons.sync))],
        ),
        body: Center(
            child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.showExpMsg != null
                    ? SftExpStatusMsg(userObj: widget.UserObj)
                    : Text(
                        "Your Package is expired",
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                Text("Call Support: ${firebSoftwraesInfo["contactNo"]}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                CachedNetworkImage(
                  imageUrl: "${firebSoftwraesInfo["upiLink"] ?? ""}",
                  httpHeaders: {
                    "Authorization": basicAuthForLocal,
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => WebView(
                //             mainUrl: "https://rzp.io/l/0MrpHrn?",
                //             CURRENT_USER: widget.UserObj,
                //           ),
                //         ));
                //   },
                //   child: Text(
                //     "Pay Now",
                //     style: TextStyle(color: Colors.black, fontSize: 25),
                //   ),
                // )
              ],
            ),
          ),
        )));
  }
}
