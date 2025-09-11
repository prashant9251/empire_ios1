// ignore: file_names
// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, file_names, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/NotificationService/NotificationService.dart';
import 'package:empire_ios/screen/BiometricLock/BiometricLock.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/JSM/jsmTransfer.dart';
import 'package:empire_ios/screen/loginSystemNew/loginSystemNew.dart';
import 'package:empire_ios/screen/verify.dart/setMPIN.dart';
import 'package:empire_ios/screen/verify.dart/verifyScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class rootHome extends StatefulWidget {
  rootHome({Key? key}) : super(key: key);

  @override
  _rootHomeState createState() => _rootHomeState();
}

class _rootHomeState extends State<rootHome> {
  final StreamController<bool> boolnewRegStream = StreamController<bool>.broadcast();

  var companyName = "UNIQUE";
  late SharedPreferences prefs;
  List AccountUserList = [];
  Future<void> getData() async {
    // Myf.contactPermission();
    prefs = await SharedPreferences.getInstance();
    var deviceId = kIsWeb ? "desktop" : await Myf.getId();
    prefs.setString("deviceId", deviceId!);
    var AccountUser = await prefs.getString("AccountUser");
    AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
    AccountUserList = await jsonDecode(AccountUser);
    if (AccountUserList.length > 0) {
      boolnewRegStream.sink.add(false);
    } else {
      boolnewRegStream.sink.add(true);
    }
    // //print(AccountUserList);
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // cmn.getCurrentYearApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          // color: Colors.white,
          body: SafeArea(
        child: Center(
          child: Container(
            width: friendlyScreenWidth(context, constraints),
            child: Column(children: [
              Expanded(
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        ...Myf.MainAppIcon(context),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: getData(),
                                  builder: (context, snapshot) {
                                    return Column(
                                      children: [
                                        if (directLoginUserJson["userID"] != null) accountCard(directLoginUserJson),
                                        ...AccountUserList.map(
                                          (e) {
                                            return accountCard(e);
                                          },
                                        ).toList(),
                                      ],
                                    );
                                  }),
                              const SizedBox(
                                height: 100,
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                  onTap: () => goTOLogin(context),
                                  child: AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    width: 150,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: HexColor(ColorHex),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Text(
                                      "Add Account + ",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  )),
                              SizedBox(height: 10),
                              Myf.checkForAppUpdate(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      // StreamBuilder<bool>(
                      //     stream: boolnewRegStream.stream,
                      //     builder: (context, snapshot) {
                      //       bool? d = snapshot.data;
                      //       return d.toString().contains("true")
                      //           ? InkWell(
                      //               onTap: () => Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => NewRegistration(),
                      //                   )),
                      //               child: newRegistrationButton(),
                      //             )
                      //           : SizedBox.shrink();
                      //     }),
                      // Text("Support Call  11 am to 3 pm", style: TextStyle(color: HexColor(ColorHex))),

                      // kIsWeb
                      //     ? SizedBox.shrink()
                      //     : IosPlateForm
                      //         ? AssetsUpdate()
                      //         : SizedBox.shrink(),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => Myf.copyAllAssetsToDirectory(context, myUniqueApp.path, DateTime.now().millisecondsSinceEpoch),
                        child: Text("uniqsoftwares.com"),
                      ),
                      Text("$serverPort")
                    ]),
                  ),
                ),
              )
            ]),
          ),
        ),
      ));
    });
  }

  Widget accountCard(account) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: Icon(Icons.ads_click),
          onTap: () async {
            var navVal;
            String software_name = account["0"]['software_name'];

            if (account["0"]['CLIENTNO'] == "111" ||
                account["0"]['CLIENTNO'] == "58385" ||
                account["0"]['CLIENTNO'] == "100" ||
                account["0"]['CLIENTNO'] == "100" ||
                account["0"]['CLIENTNO'] == "85785" ||
                account["0"]['CLIENTNO'] == "73335" ||
                account["0"]['CLIENTNO'] == "51035" ||
                account["0"]['CLIENTNO'] == "50660") {
              // Do something
            } else {
              // checking if other client then it will stop
              if (kDebugMode) {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text("Debug Mode is ON Please close the app"),
                      ),
                    );
                  },
                );
                return;
              }
            }
            if (software_name.contains("JSM")) {
              navVal = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return JsmTransfer();
              }));
            } else {
              var MPIN = await prefs.getString("MPIN${account["0"]["CLIENTNO"]}");
              if (MPIN.toString().contains("skip")) {
                navVal = await Myf.goToHome(navVal, context, account["0"]);
              } else if (MPIN.toString().contains("biometric")) {
                navVal = await Myf.Navi(context, BiometricLock(UserObj: account["0"]));
              } else if (MPIN != null && MPIN.toString().isNotEmpty) {
                navVal = await Myf.Navi(context, VerifyScreen(UserObj: account["0"]));
              } else {
                navVal = await Myf.Navi(context, SetPassword(UserObj: account["0"]));
              }
            }
            if (navVal != "") {
              setState(() {});
            }
            // getData();
          },
          // leading: const Icon(Icons.verified_user),
          subtitle: Text(
            account["0"]['software_name'],
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          trailing: TextButton(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(jsmColor)),
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Alert"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Are you sure you want to logout"),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Yes'),
                          onPressed: () async {
                            await Myf.logout(context, account["0"]['customerDBname'], account["0"]['login_user'], "");
                            await prefs.setString("MPIN${account["0"]["CLIENTNO"]}", "");
                            setState(() {});
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
          title: Text(
            account["0"]['SHOPNAME'].toString().toUpperCase(),
            style: TextStyle(color: HexColor(ColorHex), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  goTOLogin(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const LoginSystemNew();
      },
    ));
    // getData();
    setState(() {});
  }

  void getfirebaseCurrntUserObj(UserObj) {
    fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("user").where("userID", isEqualTo: UserObj["user"]).get().then((event) {
      var snp = event.docs;
      snp.map((e) {
        var obj = e.data();
        prefs.setString("firebaseCurrntUserObj${UserObj["user"]}", jsonEncode(obj));
      }).toList();
    });
  }
}
