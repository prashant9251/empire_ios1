import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../EMPIRE/Myf.dart';

class AddNewUserAdmin extends StatefulWidget {
  AddNewUserAdmin({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;

  @override
  State<AddNewUserAdmin> createState() => _AddNewUserAdminState();
}

class _AddNewUserAdminState extends State<AddNewUserAdmin> {
  var ctrlEMail = TextEditingController();
  var ctrlName = TextEditingController();
  var ctrlMobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("ADD NEW USER "),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            child: Column(
              children: [
                TextFormField(
                  controller: ctrlName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name Cannot be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Your Name ",
                    labelText: "Name ",
                  ),
                ),
                TextFormField(
                  controller: ctrlEMail,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email Cannot be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Your Email ",
                    labelText: "Email ",
                  ),
                ),
                TextFormField(
                  controller: ctrlMobile,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mobile Cannot be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Your Mobile ",
                    labelText: "Mobile ",
                  ),
                ),
                SizedBox(height: 15),
                Container(width: double.infinity, child: ElevatedButton.icon(onPressed: () => null, icon: Icon(Icons.save), label: Text("SAVE")))
              ],
            ),
          ),
        ],
      ),
    );
  }

  request() async {
    var deviceId = await Myf.getId();
    var userGstin = widget.UserObj["GSTIN"];
    var email = widget.UserObj["emailadd"];
    var mobileNo = widget.UserObj["mobileno_user"];
    var OTP = widget.UserObj["CUOTP"];

    dynamic obj = {
      'NewNameuser': ctrlName.text.trim(),
      'NewEmailadd': ctrlEMail.text.trim(),
      'NewMobileNo': ctrlMobile.text.trim(),
      'NEWGSTIN': userGstin,
      'AGSTIN': userGstin,
      'OTP': OTP,
      'Aemail': email,
      'AmobileNo': mobileNo,
      'login_user': widget.UserObj["login_user"]
    };
    var loginUrl = "${urldata.adminUserListUrl}?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&OTP=$OTP&DID=$deviceId";
    //print('----$loginUrl');
    var res = '[]';
    try {
      var url = Uri.parse(loginUrl);
      var response = await http.get(url);
      res = (response.body);
      if (res != null) {
        var userList = await jsonDecode(res);
        //print('----$userList');
      } else {
        //print("User Not Valid");
      }
    } catch (e) {}
  }
}
