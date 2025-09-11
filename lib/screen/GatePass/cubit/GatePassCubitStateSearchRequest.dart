import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empire_ios/Models/BlsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GatePass/GatePass.dart';
import 'package:empire_ios/screen/GatePass/GatePassModel.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitState.dart';

class GatePassCubitStateSearchRequest extends GatePassCubitState {
  static Future<GatePassModel?> serachRequest(Map<String, dynamic> reQobj) async {
    blsGatePassModel = BlsModel();

    var host = Myf.getLocalHostUrl();
    var basicAuthForLocal = Myf.getBasicAuthForLocal();

    var loginUrl = "${host}/GP/search.php?";
    // var loginUrl = "https://${ipController.text}";
    print('----$loginUrl');

    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];
    reQobj["year"] = (GLB_CURRENT_USER["yearVal"]).replaceAll("-", "");

    final dio = Dio();
    Response<dynamic>? response;
    try {
      response = await dio.post(loginUrl,
          data: reQobj,
          queryParameters: reQobj,
          options: Options(
            headers: {
              'Authorization': basicAuthForLocal,
            },
            sendTimeout: Duration(seconds: 10),
            receiveTimeout: Duration(seconds: 10),
          ));

      if (response.statusCode == 200) {
        var res = response.data.toString();
        if (res != null) {
          var json = await jsonDecode(res);
          try {
            blsGatePassModel = BlsModel.fromJson(Myf.convertMapKeysToString(json));
          } catch (e) {
            print("Error in parsing BlsModel: $e");
          }
          GatePassModel gatePassModel = GatePassModel();
          try {
            gatePassModel = GatePassModel.fromJson(Myf.convertMapKeysToString(json));
          } catch (e) {
            print("Error in parsing GatePassModel: $e");
          }

          return gatePassModel;
        } else {
          GatePassModel gatePassModel = GatePassModel(error: 'User Not Valid');
          return gatePassModel;
        }
      }
      return null;
    } catch (e) {
      print("Error: $e");
      dio.close(force: true);
      GatePassModel gatePassModel = GatePassModel(error: "${e.toString()}${response?.toString() ?? ''}");
      return gatePassModel;
    }
  }

  static Future<bool> serachRequest2(Map<String, dynamic> reQobj) async {
    ipController.text = await Myf.getPrivateNetWorkIp(GLB_CURRENT_USER);

    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];

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
//----new
  }

  static String convertToFormattedDate(String inputString) {
    // Check if the input string has the correct length (6 characters)
    if (inputString.length != 6) {
      return "";
    }
    try {
      // Extract day, month, and year components from the input string
      String day = inputString.substring(0, 2);
      String month = inputString.substring(2, 4);
      String year = "20" + inputString.substring(4, 6); // Assuming the year is always in 20XX format

      // Create a DateTime object
      DateTime dateTime = DateTime(int.parse(year), int.parse(month), int.parse(day));

      // Format the DateTime object to "yyyy-MM-dd" format
      String formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

      return formattedDate;
    } catch (e) {
      return "";
    }
  }
}
