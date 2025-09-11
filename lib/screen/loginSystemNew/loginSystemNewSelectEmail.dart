import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/login_otp_verify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class LoginSystemNewSelectEmail extends StatefulWidget {
  List UserJsonList;
  String userGstin;
  LoginSystemNewSelectEmail({Key? key, required this.UserJsonList, required this.userGstin}) : super(key: key);

  @override
  State<LoginSystemNewSelectEmail> createState() => _LoginSystemNewSelectEmailState();
}

class _LoginSystemNewSelectEmailState extends State<LoginSystemNewSelectEmail> {
  var processing = false;
  final _formKey = GlobalKey<FormState>();
  var userSr = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: friendlyScreenWidth(context, constraints),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    kIsWeb ? SizedBox.shrink() : Image.asset("assets/img/otpVerifyscreen.png", fit: BoxFit.cover),
                    Text("Please Click on Your Email",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: jsmColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      child: Builder(builder: (context) {
                        userSr = 0;
                        return Column(
                          children: [
                            ...widget.UserJsonList.map((e) {
                              userSr++;
                              return Card(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      login(e);
                                    },
                                    child: ListTile(
                                      // onTap: () {
                                      //   login(e);
                                      // },

                                      leading: CircleAvatar(child: Text("$userSr")),
                                      title: Text("${e["emailadd"]}"),
                                      subtitle: Text("${e["usernm"]}"),
                                      trailing: Icon(Icons.ads_click),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        );
                      }),
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

  Future<void> login(UserLoginObj) async {
    if (processing) return;
    processing = true;
    Myf.showLoading(context, "Please wait");
    var userGstin = widget.userGstin;
    var email = UserLoginObj["emailadd"];
    var mobileNo = UserLoginObj["mobileno_user"];
    var deviceId = kIsWeb ? "desktop" : (await Myf.getId())!;

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
            "Otp Send to Email and mobile no";
            Navigator.pop(context);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => otoVerifyPage(
                          userGstin: widget.userGstin,
                          UserLoginObj: UserLoginObj,
                          msg: "Otp sent to email- $email and mobile $mobileNo",
                        )));
          }
        } else {
          Myf.snakeBar(context, "User Not Valid");
        }
      } else {
        Myf.snakeBar(context, "User Not Valid");
      }
    } catch (e) {
      Myf.snakeBar(context, "somthing went wrong ${loginUrl.substring(0, 10)}");
    }
    //print('----$res');
    processing = false;
  }
}
