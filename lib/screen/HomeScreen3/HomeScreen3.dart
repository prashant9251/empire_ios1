import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/extraComanIcon.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/expiries/expCalculation.dart';
import 'package:empire_ios/widget/mainScreenIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen3 extends StatefulWidget {
  dynamic UserObj;

  HomeScreen3({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<HomeScreen3> createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {
  Future<void> getData() async {
    Map<String, dynamic> expiryObj = await ExpCalculate.expiryStatusForDesktop(widget.UserObj);
    if (expiryObj["expiry"].toString().contains("Y")) {
      Myf.gotoExpiredPage(context, widget.UserObj);
    }
    //----ios permission check
    String iosPermission = widget.UserObj['iosPermission'];
    if (IosPlateForm == true) {
      if (!iosPermission.contains("1")) {
        Myf.gotoIosPermissionDenied(context, widget.UserObj);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    Myf.verify(context, widget.UserObj);
  }

  @override
  Widget build(BuildContext context) {
    GLB_CURRENT_USER = widget.UserObj;
    loginUserModel = LoginUserModel.fromJson(GLB_CURRENT_USER);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("GATE PASS SYSTEM"),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExtraComanIcon(UserObj: widget.UserObj),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
