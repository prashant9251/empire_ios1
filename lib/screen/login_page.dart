// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore, unnecessary_null_comparison, avoid_print, empty_catches, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/forgotPass.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/login_otp_verify.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// ignore: duplicate_ignore
class _LoginPageState extends State<LoginPage> {
  bool changeButton = false;
  var companyName = "UNIQUE";
  // ignore: non_constant_identifier_names
  final _formKey = GlobalKey<FormState>();
  String deviceId = "";

  var userGstin;
  var mobileNo;
  var email;
  TextEditingController userGstinCtrl = TextEditingController();
  TextEditingController mobileNoCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  late ProgressDialog progressDialog;
  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      login();
    }
  }

  Future<void> getData() async {
    prefs = await SharedPreferences.getInstance();
    userGstinCtrl.text = await prefs!.getString("userGstin") == null ? "" : await prefs!.getString("userGstin")!;
    emailCtrl.text = await prefs!.getString("email") == null ? "" : await prefs!.getString("email")!;
    mobileNoCtrl.text = await prefs!.getString("mobileNo") == null ? "" : await prefs!.getString("mobileNo")!;
    setState(() {});
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
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset("assets/img/otpVerifyscreen.png", fit: BoxFit.cover),
            Text("Welcome To $companyName",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: jsmColor)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: userGstinCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Gstin Cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      userGstin = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Your Gstin ",
                      labelText: "Gstin ",
                    ),
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email Cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Your Email Address ",
                      labelText: "Email ",
                    ),
                  ),
                  TextFormField(
                    controller: mobileNoCtrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mobile No. Cannot be empty";
                      } else if (value.length < 10) {
                        return "Mobile No length should be atleast 10";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      mobileNo = value;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Mobile No.",
                      labelText: "Mobile No.",
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    color: HexColor(ColorHex),
                    borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
                    child: InkWell(
                        onTap: () => moveToHome(context),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          width: changeButton ? 50 : 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )),
                  ),
                  SizedBox(height: 30),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                        onPressed: () => Myf.Navi(context, ForgotPass()),
                        child: Text(
                          "Forgot my login Details??",
                        ))
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> login() async {
    prefs!.setString("userGstin", userGstinCtrl.text.trim());
    prefs!.setString("email", emailCtrl.text.trim());
    prefs!.setString("mobileNo", mobileNoCtrl.text.trim());
    progressDialog.setTitle(const Text("Loading"));
    progressDialog.setMessage(const Text("Please wait"));
    progressDialog.show();
    userGstin = userGstinCtrl.text;
    email = emailCtrl.text;
    mobileNo = mobileNoCtrl.text;
    deviceId = (await _getId())!;

    var loginUrl =
        "${urldata.syncDataUrlDomain}/LOGINIOS/appLoginVerification.php?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&DID=$deviceId";
    var res = '[]';
    //print(loginUrl);
    try {
      var url = Uri.parse(loginUrl);
      var response = await http.get(url);
      res = (response.body);
      //print('----$res');
      if (res != null) {
        var resJson = jsonDecode(res);
        var user = resJson['user'];
        if (user == "valid") {
          var OTP = resJson['OTP'];
          if (OTP == "sent") {
            prefs!.setString("userGstin", userGstin);
            prefs!.setString("email", email);
            prefs!.setString("mobileNo", mobileNo);
            // Navigator.pop(context);
            // await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const otoVerifyPage()));
          }
        } else {
          snakeBar("User Not Valid");
        }
      } else {
        snakeBar("User Not Valid");
      }
    } catch (e) {
      snakeBar("somthing went wrong ${loginUrl.substring(0, 10)}");
    }
    //print('----$res');
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
}
