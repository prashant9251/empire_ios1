import 'package:empire_ios/DesktopVersion/DesktopHome.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboard.dart';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/searchUniqueUser/searchUniqueUser.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqinstallRequest/uniqinstallRequest.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqueRequestList/uniqueRequestList.dart';
import 'package:flutter/material.dart';

class uniqOfficeSupport extends StatefulWidget {
  var UserObj;

  uniqOfficeSupport({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<uniqOfficeSupport> createState() => _uniqOfficeSupportState();
}

class _uniqOfficeSupportState extends State<uniqOfficeSupport> {
  @override
  Widget build(BuildContext context) {
    return int.parse("${widget.UserObj["uniqOfficeUserAccess"]}") == 0
        ? SizedBox.shrink()
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InDevPrashant(
                      UserObj: widget.UserObj,
                      widget: InkWell(
                        onTap: () {
                          Myf.Navi(context, WebView(mainUrl: "https://aashaimpex.com/admin/searchUser.php?ntab=NTAB", CURRENT_USER: widget.UserObj));
                        },
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                size: 50,
                              ),
                              Text(
                                "PRASHANT",
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => Myf.Navi(context, OfficeDeshBoard(UserObj: widget.UserObj)),
                          icon: Icon(
                            Icons.search,
                            size: 50,
                          ),
                        ),
                        Text("Search Admin User")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
