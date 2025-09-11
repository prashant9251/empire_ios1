import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/FireUserModel.dart';
import 'package:empire_ios/auth.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Tradinghome.dart';
import 'package:empire_ios/screen/EMPIRE/homeAgency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseSupUserEnter extends StatelessWidget {
  FirebaseSupUserEnter({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  Widget build(BuildContext context) {
    //print(UserObj["CLIENTNO"]);
    return StreamBuilder<QuerySnapshot>(
      stream: fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("database").where("ID", isEqualTo: "1").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return screenMsg(
            UserObj: UserObj,
            widget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading "),
                  Text("Please wait ", style: TextStyle(color: jsmColor)),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return screenMsg(UserObj: UserObj, widget: Center(child: Text("FB ERROR")));
        } else if (!snapshot.hasData) {
          return screenMsg(UserObj: UserObj, widget: Center(child: Text("FB LOGIN ISSUE")));
        } else if (snapshot.hasData) {
          var snp = snapshot.data!.docs;
          firebaseCurrntSupUserObj = {};
          snp.map((e) {
            firebaseCurrntSupUserObj = e.data();
            // //print(firebaseCurrntSupUserObj["CURRENT_YEAR_URL"]);
          }).toList();
          return FirebaseUserEnter(UserObj: UserObj);
        } else {
          return screenMsg(UserObj: UserObj, widget: Center(child: Text("please wait Login process")));
        }
      },
    );
  }

  Widget screenMsg({required UserObj, required Center widget}) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("${UserObj["SHOPNAME"]}"),
        ),
        body: widget);
  }
}

class FirebaseUserEnter extends StatefulWidget {
  FirebaseUserEnter({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;

  @override
  State<FirebaseUserEnter> createState() => _FirebaseUserEnterState();
}

class _FirebaseUserEnterState extends State<FirebaseUserEnter> {
  @override
  Widget build(BuildContext context) {
    //print(widget.UserObj["CLIENTNO"]);
    return StreamBuilder<QuerySnapshot>(
      stream: fireBCollection
          .collection("supuser")
          .doc(widget.UserObj["CLIENTNO"])
          .collection("user")
          .where("userID", isEqualTo: widget.UserObj["user"])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return screenMsg(
            UserObj: widget.UserObj,
            widget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading "),
                  Text("Please wait ", style: TextStyle(color: jsmColor)),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return screenMsg(UserObj: widget.UserObj, widget: Center(child: Text("FB ERROR")));
        } else if (!snapshot.hasData) {
          return screenMsg(UserObj: widget.UserObj, widget: Center(child: Text("FB LOGIN ISSUE")));
        } else if (snapshot.hasData) {
          var snp = snapshot.data!.docs;
          firebaseCurrntUserObj = {};
          snp.map((e) {
            firebaseCurrntUserObj = e.data();
            fireUserModel = FireUserModel.fromJson(firebaseCurrntUserObj);
          }).toList();
          if (snp.length > 0) {
            hiveBoxOpenedMap.clear();
            GLB_CURRENT_USER = {...widget.UserObj};
            prefs!.setString("GLB_CURRENT_USER", jsonEncode(GLB_CURRENT_USER));
            // Myf.userDetailsUpdateToFirebase(firebaseCurrntSupUserObj: firebaseCurrntSupUserObj, UserObj: widget.UserObj);
            String software_name = widget.UserObj['software_name'];
            if (firebaseCurrntUserObj['LFolder'] != null && firebaseCurrntUserObj['LFolder'] != "") {
              lFolder = "${firebaseCurrntUserObj['LFolder']}";
            } else {
              lFolder = "${widget.UserObj['LFolder']}";
            }
            // if (kIsWeb) {
            //   return DesktopHome(UserObj: widget.UserObj);
            // } else {
            if (software_name.contains("AGENCY")) {
              assethtmlSubFolder = "agency";
              return Agency_Home(CURRENT_USER: [widget.UserObj]);
            } else {
              assethtmlSubFolder = "uniquesoftwares";
              return Trading_Home(CURRENT_USER: [widget.UserObj]);
            }
            // }
            // return rootHome();
          } else {
            firebaseAuthfunction.createUserInFirebase(widget.UserObj);
            return screenMsg(UserObj: widget.UserObj, widget: Center(child: Text("please wait Login process")));
          }
        } else {
          return screenMsg(UserObj: widget.UserObj, widget: Center(child: Text("please wait Login process")));
        }
      },
    );
  }

  Widget screenMsg({required UserObj, required Center widget}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("${UserObj["SHOPNAME"]}"),
      ),
      body: widget,
    );
  }
}
