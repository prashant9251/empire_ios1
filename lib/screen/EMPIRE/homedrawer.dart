import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/localRequest/getMst.dart';
import 'package:empire_ios/payNow/PayNow.dart';
import 'package:empire_ios/remark/Remark.dart';
import 'package:empire_ios/screen/BiometricLock/BiometricLock.dart';
import 'package:empire_ios/screen/SettingsScreen/SettingsScreen.dart';
import 'package:empire_ios/screen/SftNotificationMsgAdd/SftNotificationMsgAdd.dart';
import 'package:empire_ios/screen/demoExpired.dart';
import 'package:empire_ios/screen/help/mainhelp.dart';
import 'package:empire_ios/screen/test.dart';
import 'package:empire_ios/screen/verify.dart/setMPIN.dart';
import 'package:empire_ios/whatsInReels/whatsInReels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../doc_scanner/doc_scanner.dart';
import '../../main.dart';
import '../refAndEarn/refAndEarn.dart';
import 'Myf.dart';
import 'urlData.dart';
import 'webview.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Image.asset(
          "assets/img/rootHome.png",
          fit: BoxFit.cover,
        ),
        // Divider(),
        Card(
          child: ListTile(
            leading: Image(image: AssetImage("assets/img/1024.png")),
            title: const Text("UNIQUE SOFTWARES"),
            subtitle: Text("$contactEmail"),
          ),
        ),
        // Divider(),

        SizedBox(
          height: 10,
        ),
        // ListTile(
        //   leading: Icon(Icons.logout),
        //   title: Text('Logout'),
        //   onTap: () {
        //     Myf.logout(context, widget.CURRENT_USER[0]['customerDBname'], widget.CURRENT_USER[0]['login_user'], "NavClose");
        //   },
        // ),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
              // onTap: () => Myf.Navi(context, Test()),
              leading: Icon(Icons.settings),
              title: Text('gatepass'),
            )),
        ListTile(
          onTap: () => Myf.Navi(context, SettingsScreen()),
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          onTap: () => Myf.Navi(context, SetPassword(UserObj: UserObj)),
          leading: Icon(Icons.password),
          title: Text(
            'Set New Mpin',
          ),
        ),
        ListTile(
          onTap: () async {
            await DefaultCacheManager().emptyCache();
            Navigator.pop(context);
          },
          leading: Icon(Icons.cleaning_services),
          title: Text(
            'Clear Cache',
          ),
        ),

        ListTile(
          onTap: () {
            Myf.Navi(context, MainHelp());
          },
          leading: Icon(Icons.help),
          title: Text(
            'Help',
          ),
        ),
        customerCasreContactDetails(context),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
                onTap: () => Myf.Navi(context, PayNow(UserObj: UserObj)),
                leading: Icon(Icons.payment),
                title: Text(
                  "Pay Now",
                ))),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
                onTap: () => Myf.Navi(context, SftNotificationMsgAdd()),
                leading: Icon(Icons.message),
                title: Text(
                  "BroadCast MSG(Do Not Use)",
                ))),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
                onTap: () => Myf.Navi(context, whatsInReels()),
                leading: Icon(Icons.payment),
                title: Text(
                  "WHATS IN REALS",
                ))),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
                onTap: () => Myf.Navi(
                    context,
                    refAndEarn(
                      UserObj: UserObj,
                    )),
                leading: Icon(Icons.payment),
                title: Text(
                  "Refer & Earn ",
                ))),
        InDev(
            inDevUser: UserObj["login_user"],
            widget: ListTile(
              leading: Icon(Icons.payment),
              title: Text("Demo Expiry"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DemoExpired(UserObj: UserObj, showExpMsg: true),
                  ),
                );
              },
            )),

        // ListTile(
        //     onTap: () => Myf.Navi(context, Remark(UserObj: UserObj)),
        //     leading: Icon(Icons.alarm_outlined),
        //     title: Text(
        //       "My Reminders Notes ",
        //     ))
      ],
    ));
  }
}

customerCasreContactDetails(context) {
  List contactNoList = firebSoftwraesInfo["contactNoList"] ?? [];
  return Wrap(
    children: contactNoList
        .map((e) => Container(
              width: MediaQuery.of(context).size.width * .5,
              child: ListTile(
                onTap: () => Myf.dialNo([e], context),
                leading: Icon(Icons.call),
                title: Text(
                  '$e',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ))
        .toList(),
  );
}
