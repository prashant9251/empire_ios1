// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore, unnecessary_null_comparison, avoid_print, empty_catches, camel_case_types

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'EMPIRE/Myf.dart';

class otoVerifyPage extends StatefulWidget {
  var UserLoginObj;
  var userGstin;

  var msg;
  otoVerifyPage({Key? key, required this.UserLoginObj, required this.userGstin, required this.msg}) : super(key: key);

  @override
  _otoVerifyPageState createState() => _otoVerifyPageState();
}

// ignore: duplicate_ignore
class _otoVerifyPageState extends State<otoVerifyPage> {
  var processing = false;
  late SharedPreferences prefs;
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();
  var deviceId = "";
  var userGstin = '';
  var mobileNo = '';
  var email = "";
  var OTP = "";
  List AccountUserList = [];
  late ProgressDialog progressDialog;
  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      verify();
    }
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    userGstin = widget.userGstin;
    email = widget.UserLoginObj["emailadd"];
    mobileNo = widget.UserLoginObj["mobileno_user"];
    deviceId = kIsWeb ? "desktop" : (await _getId())!;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      message: null,
      title: null,
    );
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: friendlyScreenWidth(context, constraints),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      kIsWeb
                          ? SizedBox.shrink()
                          : Image.asset(
                              "assets/img/otpVerifyscreen.png",
                              fit: BoxFit.cover,
                            ),
                      Text(
                        "Welcome To $companyName",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: jsmColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        child: Column(
                          children: [
                            Text("${widget.msg}"),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "OTP No. Cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                OTP = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter OTP No.",
                                labelText: "OTP No.",
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            GestureDetector(
                              onTap: () => moveToHome(context),
                              child: Material(
                                color: HexColor(ColorHex),
                                borderRadius: BorderRadius.circular(8),
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  width: 150,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Verify",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  Future<void> verify() async {
    if (processing) return;

    processing = true;
    progressDialog.setTitle(const Text("Loading"));
    progressDialog.setMessage(const Text("Please wait"));
    progressDialog.show();
    var loginUrl =
        "${urldata.syncDataUrlDomain}/LOGINIOS/appLoginVerification.php?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&OTP=$OTP&DID=$deviceId";
    //print('----$loginUrl');
    var res = '[]';
    try {
      var url = Uri.parse(loginUrl);
      var response = await http.get(url);
      res = (response.body);
      progressDialog.dismiss();
      // //print('----$res');
      if (res != null) {
        var resJson = jsonDecode(res);
        var user = resJson['user'];
        if (user == "valid") {
          var OTP = resJson['OTP'];
          if (OTP == "verify") {
            var AccountUser = prefs.getString("AccountUser");
            AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
            AccountUserList = jsonDecode(AccountUser);
            saveToAccountList(AccountUserList, resJson);
          } else {
            snakeBar("User Not Valid");
          }
        } else {
          snakeBar("User Not Valid");
        }
      } else {
        snakeBar("User Not Valid");
      }
    } catch (e) {
      snakeBar("somthing went wrong");
    }
    processing = false;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // Unique ID on Android
    }
  }

  snakeBar(text) {
    progressDialog.dismiss();
    Navigator.pop(context);
    Myf.showMsg(context, "Alert", text);
  }

  Future saveToAccountList(List AccountUserList, resJson) async {
    bool foundUser = false;
    for (var i = 0; i < AccountUserList.length; i++) {
      var customerDBname = AccountUserList[i]['0']['customerDBname'];
      if (customerDBname == resJson['0']['customerDBname']) {
        //print("$customerDBname${resJson['0']['customerDBname']}");
        foundUser = true;
        AccountUserList.removeWhere((item) => item['0']['customerDBname'] == customerDBname);
      }
    }
    //print(AccountUserList);
    if (!foundUser || AccountUserList.isEmpty) {
      await Myf.saveValToSavedPref(resJson['0'], "MPIN", "");
      AccountUserList.add(resJson);
    }
    await prefs.setString("AccountUser", jsonEncode(AccountUserList));
    Navigator.of(context).popUntil((route) => route.isFirst);
    // await Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => const rootHome()));
  }
}
