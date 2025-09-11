import 'package:flutter/material.dart';

class InDev extends StatefulWidget {
  InDev({Key? key, required this.inDevUser, required this.widget}) : super(key: key);
  var inDevUser;
  Widget widget;
  @override
  State<InDev> createState() => _InDevState();
}

class _InDevState extends State<InDev> {
  @override
  Widget build(BuildContext context) {
    return widget.inDevUser.toString().contains("58385") ||
            widget.inDevUser.toString().contains("111") ||
            widget.inDevUser.toString().contains("51035") ||
            widget.inDevUser.toString().contains("100") ||
            widget.inDevUser.toString().contains("prashant3009")
        ? widget.widget
        : SizedBox.shrink();
  }
}

class InDevPrashant extends StatefulWidget {
  InDevPrashant({Key? key, required this.UserObj, required this.widget}) : super(key: key);
  var UserObj;
  Widget widget;
  @override
  State<InDevPrashant> createState() => _InDevPrashantState();
}

class _InDevPrashantState extends State<InDevPrashant> {
  @override
  Widget build(BuildContext context) {
    return widget.UserObj["login_user"].toString().contains("prashant3009") && widget.UserObj["CLIENTNO"] == "111"
        ? widget.widget
        : SizedBox.shrink();
  }
}
