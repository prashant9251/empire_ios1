import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GatePass/GatePassModel.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitState.dart';

class GatePassCubitStateGpUpdateRequest extends GatePassCubitState {
  static Future<bool> gpUpdate2(Map<String, dynamic> reQobj) async {
    reQobj["gpDate"] = Myf.dateFormateYYYYMMDD(DateTime.now().toString());
    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];
    reQobj["year"] = (GLB_CURRENT_USER["yearVal"]).replaceAll("-", "");

    //-----new
    Map<String, dynamic> obj = {};
    obj["ID"] = "GATEPASS";
    obj["request"] = reQobj;
    obj["response"] = {};
    obj["type"] = "in";
    try {
      fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("pc_conn")
          .doc("req")
          .collection("gatepass")
          .doc(GLB_CURRENT_USER["login_user"])
          .delete()
          .then((value) {
        fireBCollection
            .collection("supuser")
            .doc(GLB_CURRENT_USER["CLIENTNO"])
            .collection("pc_conn")
            .doc("req")
            .collection("gatepass")
            .doc(GLB_CURRENT_USER["login_user"])
            .update(obj)
            .onError((error, stackTrace) {
          fireBCollection
              .collection("supuser")
              .doc(GLB_CURRENT_USER["CLIENTNO"])
              .collection("pc_conn")
              .doc("req")
              .collection("gatepass")
              .doc(GLB_CURRENT_USER["login_user"])
              .set(obj);
        });
      });
      return true;
    } catch (e) {
      return false;
    }
    logger.d(obj);
//----new
  }

  static Future<GatePassModel?> gpUpdate(Map<String, dynamic> reQobj) async {
    var host = Myf.getLocalHostUrl();
    var basicAuthForLocal = Myf.getBasicAuthForLocal();

    var loginUrl = "$host/GP/gpUpdate.php";
    //print('----$loginUrl');
    reQobj["gpDate"] = Myf.dateFormateYYYYMMDD(DateTime.now().toString(), formate: 'yyyy-MM-dd hh:mm a');
    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];

    try {
      final dio = Dio();
      final response = await dio.post(loginUrl,
          data: reQobj,
          options: Options(
            headers: {
              'Authorization': basicAuthForLocal,
            },
          ));

      if (response.statusCode == 200) {
        var res = response.data.toString();
        //print(res);
        if (res != null) {
          GatePassModel gatePassModel = GatePassModel.fromJson(jsonDecode(res));
          return gatePassModel;
        } else {
          //print("User Not Valid");
        }
      }
      return null;
    } catch (e) {
      //print(e);
      return null;
    }
  }
}
