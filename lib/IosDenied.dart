// ignore_for_file: must_be_immutable

import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyfCmn.dart';
import 'screen/EMPIRE/Myf.dart';

class IosDenied extends StatefulWidget {
  IosDenied({Key? key, required this.CURRENT_USER}) : super(key: key);
  List CURRENT_USER;
  @override
  State<IosDenied> createState() => _IosDeniedState();
}

class _IosDeniedState extends State<IosDenied> {
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Myf.verify(context, widget.CURRENT_USER[0]);
    return Scaffold(
        body: Center(
            child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You Have Not IOS  Permission", style: TextStyle(color: Colors.grey, fontSize: 25)),
          Text("Contact:$contactForPayment"),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    )));
  }
}
