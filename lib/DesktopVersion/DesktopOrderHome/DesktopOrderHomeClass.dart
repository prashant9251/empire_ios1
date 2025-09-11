import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DesktopOrderHomeClass {
  static orderDispatchUpdate(context, {billDetails, UserObj, b, d}) async {
    Myf.showBlurLoading(context);
    List billDetails = d["billDetails"];
    b["dispatch"] = b["dispatch"] == "Y" ? "N" : "Y";
    var dt = DateTime.now();
    Map<String, dynamic> obj = {};
    obj["billDetails"] = billDetails;
    obj["cu_time_milli"] = dt.millisecondsSinceEpoch;
    obj["r_time"] = dt.millisecondsSinceEpoch.toString();
    var allDispatch = "N";
    await Future.wait(billDetails.map((c) async {
      if (c["dispatch"] == "Y") {
        allDispatch = "Y";
      } else {}
    }).toList());
    obj["dispatch"] = allDispatch;
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("ORDER")
        .doc("${d["OrderID"]}")
        .update(obj)
        .then((value) {})
        .onError((error, stackTrace) {
      Myf.showMyDialog(context, "error", "$error");
    });
    Navigator.pop(context);
  }
}
