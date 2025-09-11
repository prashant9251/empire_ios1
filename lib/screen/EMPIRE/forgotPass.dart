import 'dart:convert';

import 'package:empire_ios/MyfCmn.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();

  var ctrlMobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Login"), backgroundColor: jsmColor),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset("assets/img/otpVerifyscreen.png", fit: BoxFit.cover),
              Text(
                "Forgot Login Details",
                style: TextStyle(color: jsmColor, fontSize: 25),
              ),
              SizedBox(height: 30),
              Container(
                child: TextFormField(
                  controller: ctrlMobile,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mobile Cannot be empty";
                    }
                    if (value.length < 10) {
                      return "Mobile number should be 10 digit";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Mobile ",
                    label: Text(" Enter Mobile No"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Material(
                color: HexColor(ColorHex),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                    onTap: () => validate(),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        "Send Login Details",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validate() {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      CallApi();
    }
  }

  void CallApi() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    var loginUrl = "https://aashaimpex.com/whatsappChatBot/UNIQUE/sendLoginDetails.php?mobileNo=${ctrlMobile.text.trim()}";
    var url = Uri.parse(loginUrl);
    try {
      var response = await http.get(url);
      var res = (response.body);
      if (res != null) {
        var resJson = jsonDecode(res);
        //print("$resJson");
        if (resJson["user"] == "valid") {
          if (resJson["msgStatus"].toString().contains("success")) {
            Navigator.pop(context);
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Success", style: TextStyle(color: Colors.blue)),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("Details Send to Your Whatsapp Mobile No Please check your whatsapp", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.pop(context);
            Myf.showMyDialog(context, "Alert", resJson["msgStatus"]);
          }
        } else {
          Navigator.pop(context);
          Myf.showMyDialog(context, "Alert", "User Not Valid");
        }
      }
    } catch (er) {}
  }
}
