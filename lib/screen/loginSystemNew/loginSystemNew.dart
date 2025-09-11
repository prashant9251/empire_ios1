import 'dart:async';
import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:empire_ios/screen/EMPIRE/webviewNormalUrlOpen.dart';
import 'package:empire_ios/screen/loginSystemNew/loginSystemNewSelectEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

import '../EMPIRE/forgotPass.dart';
import '../NewRegistration.dart';
import '../newRegistration/newRegistrationButton.dart';

class LoginSystemNew extends StatefulWidget {
  const LoginSystemNew({Key? key}) : super(key: key);

  @override
  State<LoginSystemNew> createState() => _LoginSystemNewState();
}

class _LoginSystemNewState extends State<LoginSystemNew> {
  var processing = false;
  final StreamController<bool> loadingStream = StreamController<bool>.broadcast();
  var ctrlGstin = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var ctrlMobileNo = TextEditingController();

  bool? termsConditiCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var screenWidth = ScreenWidth(context);
      if (constraints.maxWidth < 600) {
        screenWidth = ScreenWidth(context);
      } else if (constraints.maxWidth < 1200) {
        screenWidth = ScreenWidth(context);
      } else {
        screenWidth = ScreenWidth(context) * .6;
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: screenWidth,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    kIsWeb ? SizedBox.shrink() : Image.asset("assets/img/otpVerifyscreen.png", fit: BoxFit.cover),
                    Text("Welcome To $companyName",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: jsmColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: ctrlGstin,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Gstin Cannot be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter Your Gstin ",
                              labelText: "Gstin ",
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: ctrlMobileNo,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mobile No. Cannot be empty";
                              } else if (value.length < 10) {
                                return "Mobile No length should be atleast 10";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter Mobile No.",
                              labelText: "Mobile No.",
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Myf.Navi(context, WebviewNormalUrlOpen(mainUrl: "https://aashaimpex.com/termsCondition.html"));
                                  },
                                  child: Text("Terms conditions", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline))),
                              Checkbox(
                                  value: termsConditiCheck,
                                  onChanged: (value) {
                                    termsConditiCheck = value;
                                    setState(() {});
                                  }),
                            ],
                          ),
                          FloatingActionButton.extended(
                            heroTag: "loginbtn",
                            label: Text("Login"),
                            onPressed: () {
                              validate();
                            },
                          ),
                          SizedBox(height: 30),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            ElevatedButton(
                                onPressed: () => Myf.Navi(context, ForgotPass()),
                                child: Text(
                                  "Forgot my login Details??",
                                ))
                          ]),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(children: [
                                SizedBox(height: 20),
                                InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewRegistration(),
                                        ));
                                    getData();
                                  },
                                  child: newRegistrationButton(),
                                ),
                                // Text("Support Call  11 am to 3 pm", style: TextStyle(color: HexColor(ColorHex))),
                                SizedBox(height: 10),
                              ]),
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
        ),
      );
    });
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      if (processing == true) {
        return;
      }

      termsConditiCheck == true
          ? login()
          : showSimpleNotification(Text("Please check Terms conditions box if you want to proceed"), background: Colors.redAccent);
      ;
    }
  }

  Future<void> login() async {
    processing = true;
    prefs!.setString("userGstin", ctrlGstin.text.trim());
    prefs!.setString("mobileNo", ctrlMobileNo.text.trim());
    Myf.showLoading(context, "Please wait");
    var userGstin = ctrlGstin.text;
    var mobileNo = ctrlMobileNo.text;
    var deviceId = kIsWeb ? "desktop" : (await Myf.getId())!;

    var loginUrl =
        "${urldata.syncDataUrlDomain}/LOGINIOS/NewLoginSystem/selectUserSearchApp.php?userGstin=$userGstin&mobileNo=$mobileNo&DID=$deviceId";
    var res = '[]';
    //print(loginUrl);
    var url = Uri.parse(loginUrl);
    try {
      var response = await http.get(url);
      res = (response.body);
      if (res != null) {
        var resJson = await jsonDecode(res);
        if (resJson.length > 0) {
          Navigator.of(context).pop();
          Myf.Navi(context, LoginSystemNewSelectEmail(userGstin: userGstin, UserJsonList: resJson));
        } else {
          Navigator.of(context).pop();
          Myf.showMsg(context, "Alert", "User Not Valid");
        }
      } else {
        Myf.snakeBar(context, "User Not Valid");
      }
    } catch (e) {
      Myf.snakeBar(context, " ${loginUrl.substring(0, 10)}");
    }
    processing = false;
  }

  Future<void> getData() async {
    ctrlGstin.text = await prefs!.getString("userGstin") == null ? "" : await prefs!.getString("userGstin")!;
    ctrlMobileNo.text = await prefs!.getString("mobileNo") == null ? "" : await prefs!.getString("mobileNo")!;
    setState(() {});
  }
}
