// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, file_names, duplicate_ignore

import 'dart:convert';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/homeAgency.dart';
import 'package:empire_ios/screen/NewRegistration.dart';
import 'package:empire_ios/screen/JSM/jsmTransfer.dart';
import 'package:empire_ios/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'EMPIRE/Tradinghome.dart';

class rootHomeSubScreen extends StatefulWidget {
  rootHomeSubScreen({Key? key}) : super(key: key);

  @override
  _rootHomeSubScreenState createState() => _rootHomeSubScreenState();
}

class _rootHomeSubScreenState extends State<rootHomeSubScreen> {
  var companyName = "UNIQUE";
  late SharedPreferences prefs;
  List AccountUserList = [];
  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();

    var deviceId = await Myf.getId();
    prefs.setString("deviceId", deviceId!);
    var AccountUser = prefs.getString("AccountUser");
    AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
    AccountUserList = jsonDecode(AccountUser);
    // //print(AccountUserList);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Myf.getCurrentYearApi(context);
    return Material(
        color: Colors.white,
        child: Column(children: [
          Expanded(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Image.asset(
                    "assets/img/1024.png",
                    fit: BoxFit.contain,
                    height: 100,
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Welcome To $companyName",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: jsmColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            for (var i = 0; i < AccountUserList.length; i++)
                              Card(
                                elevation: 10,
                                child: ListTile(
                                  onTap: () async {
                                    var navVal;
                                    String software_name = AccountUserList[i]["0"]['software_name'];
                                    if (software_name.contains("JSM")) {
                                      navVal = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return JsmTransfer();
                                      }));
                                    } else {
                                      if (software_name.contains("AGENCY")) {
                                        navVal = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return Agency_Home(CURRENT_USER: [AccountUserList[i]["0"]]);
                                        }));
                                      } else {
                                        navVal = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return Trading_Home(CURRENT_USER: [AccountUserList[i]["0"]]);
                                        }));
                                      }
                                    }

                                    if (navVal != "") {
                                      getData();
                                    }
                                  },
                                  // leading: const Icon(Icons.verified_user),
                                  trailing: Text(
                                    AccountUserList[i]["0"]['software_name'],
                                    style: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                  title: Text(
                                    AccountUserList[i]["0"]['SHOPNAME'],
                                    style: TextStyle(color: HexColor(ColorHex), fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Material(
                          color: HexColor(ColorHex),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                              onTap: () => moveToHome(context),
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                width: 150,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Add Account + ",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewRegistration(),
                      )),
                  child: Text(
                    "New User Registration",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  "Support Call  11 am to 3 pm",
                  style: TextStyle(color: HexColor(ColorHex)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("uniqsoftwares.com")
              ]),
            ),
          )
        ]));
  }

  moveToHome(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const LoginPage();
      },
    ));
    getData();
  }
}
