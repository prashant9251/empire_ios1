import 'package:empire_ios/screen/demoExpired.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';

class ExpCalculate {
  static Future<Map<String, dynamic>> expiryStatusForDesktop(dynamic UserObj) async {
    var softwareExp = "N";
    var actDate = UserObj["Activetiondate"];
    var demoDays = UserObj["expiryDays"] ?? UserObj["demoExpiryDays"] ?? "1";
    var sftDays = UserObj["sftExpiryDays"];
    var PayStatus = UserObj["PAY"];
    var msg = "";
    final expdt = await DateFormat('yyyy-MM-dd hh:mm').parse(actDate);
    final ActDateNew = await DateTime(expdt.year, expdt.month, expdt.day);
    final now = await DateTime.now();
    final tillTodaysdifference = await daysBetween(ActDateNew, now);
    int demoExpDays = await int.parse("${demoDays}");
    int sftExpDays = int.parse("${sftDays}");
    int demoExpInDays = demoExpDays - tillTodaysdifference;
    int sftExpInDays = sftExpDays - tillTodaysdifference;
    if (demoExpInDays > 0 && PayStatus != "Y") {
      msg = "Application will be expired in $demoExpInDays Days";
    }
    //------if pay =Y hai to  niche vali condition
    if (sftExpInDays > 0 && sftExpInDays <= 10 && PayStatus == "Y") {
      msg = "Application Validity will be expired in $sftExpInDays Days  \n please recharge your account now ";
    }
    if (demoExpInDays <= 0 && sftExpInDays <= 0) {
      msg = "ApplicationExpired";
    }
    if (demoExpInDays <= 0 && PayStatus == "N") {
      softwareExp = "Y";
    }
    if (sftExpInDays <= 0 && PayStatus == "Y") {
      softwareExp = "Y";
    }
    return {"expiry": softwareExp, "msg": msg};
  }

  static Future<String> checkExp(dynamic UserObj) async {
    var softwareExp = UserObj["PAY"];
    var actDate = UserObj["Activetiondate"];
    var demoDays = UserObj["expiryDays"];
    var sftDays = UserObj["sftExpiryDays"];
    var PayStatus = UserObj["PAY"];

    final expdt = await DateFormat('yyyy-MM-dd hh:mm').parse(actDate);
    final ActDateNew = await DateTime(expdt.year, expdt.month, expdt.day);
    final now = await DateTime.now();
    final tillTodaysdifference = await daysBetween(ActDateNew, now);
    int demoExpDays = await int.parse("${demoDays}");
    int demoExpInDays = demoExpDays - tillTodaysdifference;
    if (demoExpInDays > 0 && PayStatus != "Y") {
      sftExpStatus.sink.add("Your  Application will be expired in $demoExpInDays Days");
    }

    //------if pay =Y hai to  niche vali condition
    int sftExpDays = int.parse("${sftDays}");
    int sftExpInDays = sftExpDays - tillTodaysdifference;
    if (sftExpInDays > 0 && sftExpInDays <= 10 && PayStatus == "Y") {
      sftExpStatus.sink.add("Your Application Validity will be expired in $sftExpInDays Days  \n please recharge your account now ");
    }
    if (demoExpInDays <= 0 && PayStatus == "N") {
      softwareExp = "Y";
    }
    if (sftExpInDays <= 0 && PayStatus == "Y") {
      softwareExp = "Y";
    }
    return softwareExp;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}

class SftExpStatusMsg extends StatelessWidget {
  final dynamic userObj;
  final bool? showPayNowButton;

  SftExpStatusMsg({Key? key, required this.userObj, this.showPayNowButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: sftExpStatus.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.contains("syncing")) {
            return SizedBox.fromSize();
          } else {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DemoExpired(UserObj: userObj, showExpMsg: true),
                  ),
                );
              },
              child: Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            '${snapshot.data.toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pay now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    showPayNowButton != null
                        ? ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DemoExpired(UserObj: userObj, showExpMsg: false),
                              ),
                            ),
                            child: Text("Pay Now"),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            );
          }
        } else {
          return SizedBox.fromSize();
        }
      },
    );
  }
}
