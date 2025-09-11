import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';

class getMst {
  static Future start(Map<String, dynamic> reQobj) async {
    var host = Myf.getLocalHostUrl();
    var basicAuthForLocal = Myf.getBasicAuthForLocal();

    var loginUrl = "${host}/GP/getMst.php";
    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];
    reQobj["year"] = (GLB_CURRENT_USER["yearVal"]).replaceAll("-", "");

    try {
      final dio = Dio();
      final response = await dio
          .post(loginUrl,
              data: reQobj,
              options: Options(
                headers: {
                  'Authorization': basicAuthForLocal,
                },
              ))
          .timeout(
        Duration(seconds: empOrderSettingModel.pcReqTimeOut ?? 1),
        onTimeout: () {
          throw TimeoutException('The request has timed out.');
        },
      );
      if (response.statusCode == 200) {
        var res = response.data.toString();
        if (res != null) {
          var resobj = jsonDecode(res);
          List<dynamic> list = resobj["0"];
          await Future.wait(list.map((e) async {
            MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(e));
            try {
              int index = masterList.indexWhere((e) => e.value == masterModel.value);
              if (index != -1) {
                masterList[index] = masterModel;
              } else {
                masterList.add(masterModel);
              }
            } catch (e) {
              masterList.add(masterModel);
            }
          }).toList());
        } else {
          //print("User Not Valid");
        }
      }
      return null;
    } on TimeoutException catch (e) {
      //print('Request timed out: $e');
      // Handle the timeout error accordingly
    } on DioException catch (e) {
      //print('Request failed: ${e.message}');
      // Handle other types of Dio errors accordingly
    } catch (e) {
      //print('Unexpected error: $e');
      // Handle any other errors
    }
  }
}
