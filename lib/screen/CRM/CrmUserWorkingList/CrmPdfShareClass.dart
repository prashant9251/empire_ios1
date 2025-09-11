import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CrmPdfShareClass {
  static selectNoToShare(context, {required MasterModel masterModel, required MasterModel brokerModel, required List<String> pathList}) async {
    final Completer _Completer = Completer();
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: context,
      builder: (context) {
        return PopScope(
          onPopInvoked: (didPop) {
            try {
              _Completer.complete();
            } catch (e) {}
          },
          child: Container(
            height: ScreenHeight(context) * .5,
            margin: EdgeInsets.only(top: 5, left: 10),
            child: ListView(
              children: [
                Text(
                  "Share  To",
                  style: TextStyle(fontSize: 25, color: jsmColor),
                ),
                if (masterModel.partyname != null && masterModel.partyname != "") ...[
                  Divider(),
                  if (masterModel.mO != null && masterModel.mO != "") card("${masterModel.mO}", pathList[0], "MO", _Completer),
                  if (masterModel.pH1 != null && masterModel.pH1 != "") card("${masterModel.pH1}", pathList[0], "PH1", _Completer),
                  if (masterModel.pH2 != null && masterModel.pH2 != "") card("${masterModel.pH2}", pathList[0], "PH2", _Completer),
                ],
                if (brokerModel.partyname != null && brokerModel.partyname != "") ...[
                  Divider(),
                  Padding(padding: const EdgeInsets.all(8.0), child: Text("Brokers No...", style: TextStyle(fontSize: 18))),
                  if (brokerModel.mO != null && brokerModel.mO != "") card("${brokerModel.mO}", pathList[0], "MO", _Completer),
                  if (brokerModel.pH1 != null && brokerModel.pH1 != "") card("${brokerModel.pH1}", pathList[0], "PH1", _Completer),
                  if (brokerModel.pH2 != null && brokerModel.pH2 != "") card("${brokerModel.pH2}", pathList[0], "PH2", _Completer),
                ],
                Divider(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      List<XFile> xShareList = [];
                      pathList.forEach((element) {
                        xShareList.add(XFile(element));
                      });
                      ShareResult result = await SharePlus.instance.share(ShareParams(
                        files: xShareList,
                      ));
                      if (result.status == ShareResultStatus.success) {
                        if (pathList.length == 1) Myf.saveLastPdfSentDate(context, masterModel);
                        _Completer.complete();
                      } else {
                        Myf.snakeBar(context, "Error sharing file");
                      }
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text("Share", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jsmColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
    return _Completer.future;
  }

  static Widget card(String mo, String path, String title, Completer completer) => Card(
        color: Colors.grey[200],
        child: ListTile(
          onTap: () {
            completer.complete();
            Myf.shareOnlyAndroidWhatsApp(path, "91$mo");
          },
          title: Text(title),
          subtitle: Text(mo),
          trailing: IconButton(
            onPressed: () {
              completer.complete();
              String url = "whatsapp://send?phone=91$mo&text=Hello";
              launchUrl(Uri.parse(url));
            },
            icon: Icon(Icons.message),
          ),
        ),
      );
}
