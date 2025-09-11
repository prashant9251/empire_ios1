import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:empire_ios/payNow/RazorpayOrderResponse.dart';

Future<dynamic> createOrderRazorPay({amt}) async {
  var headers = {'Content-Type': 'application/json', 'Authorization': 'Basic cnpwX2xpdmVfalZnNzdrVVlpTGFYYm86SGxCVktyZ3o2VFRCWEMwa0JycXoxVjcw'};
  var data = json.encode({
    "amount": amt * 100,
    "currency": "INR",
    "receipt": "Receipt no. 1",
    "notes": {"notes_key_1": "Tea, Earl Grey, Hot", "notes_key_2": "Tea, Earl Grey… decaf."}
  });
  var dio = Dio();
  var response = await dio.request(
    'https://api.razorpay.com/v1/orders',
    options: Options(
      method: 'POST',
      headers: headers,
    ),
    data: data,
  );

  if (response.statusCode == 200) {
    RazorpayOrderResponse razorpayOrderResponse = RazorpayOrderResponse.fromJson(response.data);
  } else {
    //print(response.statusMessage);
  }
}
