import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';

class Logindirect {
  static login() async {
//
    Uri uri = Uri.base;
    var url = uri.toString();
    var params = uri.queryParameters;
    var secret = Myf.getUrlParams(url, "secret");
    var access = Myf.getUrlParams(url, "access");
    var expiry = Myf.getUrlParams(url, "expiry");
    if (secret == "" || access == "" || expiry == "") {
      return;
    }
    var getDetailsUrl = "${urldata.syncDataUrlDomain}/LOGINIOS/appLoginVerificationDirect.php";
    // Data to be sent in the POST request
    var data = params;
    try {
      Dio dio = Dio();

      // Making a POST request
      var response = await dio.post(
        getDetailsUrl,
        data: FormData.fromMap(data), // Or data: data if backend accepts JSON
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );
      // Handling the response
      if (response.statusCode == 200 && !response.data.toString().contains("<br />")) {
        var json = jsonDecode(response.data);
        if (json["urlStatus"] == "success") {
          directLoginUserJson = json;
        }
        // loginUsersBox.put(json["userID"], json);
        // Myf.verify(context, UserObj)
      } else {
        print('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
