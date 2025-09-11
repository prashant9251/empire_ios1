import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

import 'EMPIRE/Myf.dart';

class FireClass {
  static updateUserDetails(context, {required UserObj, required updatingObj}) async {
    Myf.showBlurLoading(context);
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("user")
        .doc(UserObj["login_user"])
        .update(updatingObj)
        .then((value) {})
        .onError(
      (error, stackTrace) {
        //print(error);
      },
    );
    Navigator.pop(context);
  }
}
