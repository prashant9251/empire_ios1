import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/payNow/RazorpayOrderResponse.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/material.dart';

import '../screen/EMPIRE/Myf.dart';
import 'package:http/http.dart' as http;

class PayNow extends StatefulWidget {
  var UserObj;

  PayNow({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<PayNow> createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> {
  // final _razorpay = Razorpay();
  double ctrlbasePrice = 1.0;
  double ctrladdExtraUserPrice = 1000.0;
  double ctrladdExtraUserFinalAmt = 0.0;
  double ctrlFinalAmt = 0.0;

  var razorpayApiKey = "rzp_live_jVg77kUYiLaXbo";
  var secretKeyHere = "HlBVKrgz6TTBXC0kBrqz1V70";

  late RazorpayOrderResponse razorpayOrderResponse;

  @override
  void initState() {
    super.initState();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    ctrlbasePrice = Myf.convertToDouble(widget.UserObj["subscriptionTAmt"]);
    ctrlFinalAmt = Myf.convertToDouble(widget.UserObj["subscriptionTAmt"]); // calculatePrice();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _razorpay.clear();
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   //print("Payment success:\t $response");
  //   saveTransactionId(response);
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Do something when payment fails
  //   Myf.snakeBar(context, "Payment error:\t $response");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet was selected
  //   //print("Payment wallet:\t $response");
  //   Myf.snakeBar(context, "Payment wallet:\t ${response}");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Pay Now"),
        actions: [
          IconButton(
              onPressed: () async {
                await Myf.verify(context, widget.UserObj);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.sync))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("payments").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return Center(child: Text("${snapshot.error}"));
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  paymentOrderCard(),
                ],
              );
            }),
      ),
    );
  }

  Padding paymentOrderCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Plan Details",
                style: TextStyle(color: jsmColor, fontSize: 25),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(color: jsmColor, fontSize: 18),
                  ),
                  Text(
                    "${ctrlbasePrice.toInt()}/-",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Validity ",
                    style: TextStyle(color: jsmColor, fontSize: 18),
                  ),
                  Text(
                    "1 Year",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(color: jsmColor, thickness: 2),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Final Payable ",
                    style: TextStyle(color: jsmColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${ctrlFinalAmt.toInt()}/-",
                    style: TextStyle(color: jsmColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => createOrder(),
              child: Container(
                height: 60,
                color: jsmColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pay Now ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> createOrder() async {
    var headers = {'Content-Type': 'application/json', 'Authorization': 'Basic cnpwX2xpdmVfalZnNzdrVVlpTGFYYm86SGxCVktyZ3o2VFRCWEMwa0JycXoxVjcw'};
    var data = json.encode({
      "amount": ctrlFinalAmt * 100,
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
      razorpayOrderResponse = RazorpayOrderResponse.fromJson(response.data);
      paynow();
    } else {
      //print(response.statusMessage);
    }
  }

  void paynow() {
    // _razorpay.open(getTurboPaymentOptions());
  }

  Map<String, Object> getTurboPaymentOptions() {
    return {
      'key': '$razorpayApiKey',
      'amount': "${ctrlFinalAmt * 100}",
      'currency': 'INR',
      'prefill': {'contact': '${widget.UserObj["mobileno_user"]}', 'email': '${widget.UserObj["emailadd"]}'},
      'theme': {'color': '#0CA72F'},
      'send_sms_hash': true,
      'retry': {'enabled': false, 'max_count': 4},
      'order_id': '${razorpayOrderResponse.id}',
      'disable_redesign_v15': false,
      'experiments.upi_turbo': true,
      'ep': 'https://api-web-turbo-upi.ext.dev.razorpay.in/test/checkout.html?branch=feat/turbo/tpv'
    };
  }

  // void saveTransactionId(PaymentSuccessResponse response) async {
  //   Myf.showLoading(context, "Please wait");
  //   var deviceId = (await Myf.getId())!;
  //   var headers = {'Content-Type': 'application/json'};
  //   Map<String, dynamic>? obj = {};
  //   obj["mobileno_user"] = widget.UserObj["mobileno_user"];
  //   obj["GSTIN"] = widget.UserObj["GSTIN"];
  //   obj["emailadd"] = widget.UserObj["emailadd"];
  //   obj["CLIENTNO"] = widget.UserObj["CLIENTNO"];
  //   obj["paymentId"] = response.paymentId;
  //   obj["signature"] = response.signature;
  //   obj["deviceId"] = (await Myf.getId())!;
  //   obj["mobileno_user"] = widget.UserObj["mobileno_user"];
  //   obj["SHOPNAME"] = widget.UserObj["SHOPNAME"];
  //   obj["login_user"] = widget.UserObj["login_user"];
  //   obj["paidAmt"] = ctrlFinalAmt;
  //   obj["publicIp"] = await Myf.getPublicIPAddress();
  //   obj["time"] = await DateTime.now().toString();

  //   var body = json.encode(obj);
  //   var loginUrl = "${urldata.syncDataUrlDomain}/rzpay/saveTransactionId.php";
  //   var res = '[]';
  //   var url = Uri.parse(loginUrl);
  //   try {
  //     var response = await http.post(url, body: body, headers: headers);
  //     if (response.statusCode == 200) {
  //       res = (response.body);
  //       var resJson = jsonDecode(res);
  //       if (resJson.length > 0) {
  //         await Myf.verify(context, widget.UserObj);
  //         Navigator.pop(context);
  //         Navigator.popUntil(context, (route) => route.isFirst);
  //       } else {
  //         Navigator.pop(context);
  //         Myf.showMsg(context, "Alert", "User Not Valid");
  //       }
  //     } else {
  //       Myf.snakeBar(context, "User Not Valid");
  //     }
  //   } catch (e) {
  //     Myf.snakeBar(context, " ${loginUrl.substring(0, 10)}");
  //   }
  // }
}
