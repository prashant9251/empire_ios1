import 'dart:convert';

import 'package:empire_ios/screen/FirebaseUserEnter/bloc/firebaseUserEnterState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../main.dart';

class FireBasUserEnterCubit extends Cubit<firebaseUserEnterState> {
  FireBasUserEnterCubit() : super(firebaseUserEnterStateIni()) {
    // getStreamFireStore();
  }
  fireStoreDatabaseUserCheck({UserObj}) async {
    try {
      await fireBCollection
          .collection("supuser")
          .doc(UserObj["CLIENTNO"])
          .collection("user")
          .where("userID", isEqualTo: UserObj["user"])
          .get()
          .then((value) async {
        var snp = value.docs;
        if (snp.length > 0) {
          await Future.wait(snp.map((e) async {
            firebaseCurrntUserObj = e.data();
            prefs!.setString("firebaseCurrntUserObj${UserObj["user"]}", jsonEncode(firebaseCurrntUserObj));
          }).toList());
          emit(firebaseUserEnterStateLoadComplete(firebaseCurrntUserObj));
        } else {
          emit(firebaseUserEnterStateError("NOF"));
        }
      });
    } catch (e) {
      var f = prefs!.getString("firebaseCurrntUserObj${UserObj["user"]}");
      if (f != null) {
        emit(firebaseUserEnterStateLoadComplete(jsonDecode(f)));
      }
    }
  }
}
