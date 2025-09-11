import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

class UniqinstallRequest extends StatefulWidget {
  var UserObj;

  UniqinstallRequest({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<UniqinstallRequest> createState() => _UniqinstallRequestState();
}

class _UniqinstallRequestState extends State<UniqinstallRequest> {
  var list;
  @override
  Widget build(BuildContext context) {
    list = fireBCollection.collection("newInstallReq").orderBy("reqTime", descending: true).limit(100).snapshots();
    return LayoutBuilder(builder: (context, constraints) {
      var screenWidth = ScreenWidth(context);
      if (constraints.maxWidth < 600) {
        screenWidth = ScreenWidth(context);
      } else if (constraints.maxWidth < 1200) {
        screenWidth = ScreenWidth(context) / 2;
      } else {
        screenWidth = ScreenWidth(context) / 4;
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        height: 400,
        width: screenWidth,
        child: StreamBuilder<QuerySnapshot>(
          stream: list,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: SelectableText("Error in Req search order ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: SelectableText("No data"));
            } else {
              var snp = snapshot.data!.docs;
              if (snp.length > 0) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child: Chip(label: Text("New Request Last 100"))),
                        Flexible(
                          child: CircleAvatar(child: Text("${snp.length}")),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snp.length,
                          itemBuilder: (context, index) {
                            dynamic d = snp[index].data();
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                elevation: 20,
                                child: ListTile(
                                  title: updatableWidget(d, "software_name", textWidget: Text("${d["software_name"]}")),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      updatableWidget(d, "email", textWidget: Text("EMAIL : ${d["email"]}")),
                                      Chip(
                                        label:
                                            GestureDetector(onTap: () => Myf.dialNo([d["mobile"]], context), child: Text("MOBILE : ${d["mobile"]}")),
                                      ),
                                      updatableWidget(d, "ACTYPE", textWidget: Text("ACTYPE : ${d["ACTYPE"]}")),
                                      updatableWidget(d, "shopName", textWidget: Text("shopName : ${d["shopName"]}")),
                                      updatableWidget(d, "gstin", textWidget: Text("gstin : ${d["gstin"]}")),
                                      updatableWidget(d, "address", textWidget: Text("address : ${d["address"]}")),
                                      updatableWidget(d, "refByCode", textWidget: Text("refByCode : ${d["refByCode"]}")),
                                      updatableWidget(d, "reqTime", textWidget: Text("reqTime : ${d["reqTime"]}")),
                                      updatableWidget(d, "status", textWidget: Text("status : ${d["status"]}")),
                                      !"${d["status"]}".contains("rejected")
                                          ? Row(
                                              children: [
                                                !"${d["status"]}".contains("accepted")
                                                    ? ElevatedButton(onPressed: () => contacted(d, "accepted"), child: Text("Accept"))
                                                    : SizedBox.shrink(),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                    onPressed: () => contacted(d, "rejected"),
                                                    child: Text("Rejected", style: TextStyle(color: Colors.white)))
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return Center(child: Text("No data found"));
              }
            }
          },
        ),
      );
    });
  }

  Widget updatableWidget(d, key, {textWidget}) {
    return GestureDetector(
        onTap: () {
          var ctrl = TextEditingController();
          ctrl.text = d[key];
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(key),
                content: TextFormField(
                  controller: ctrl,
                  decoration: InputDecoration(label: Text(key)),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Map<Object, Object?> obj = {};
                      obj[key] = ctrl.text.trim().toUpperCase();
                      fireBCollection.collection("newInstallReq").doc(d["ID"]).update(obj);
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: textWidget);
  }

  contacted(d, status) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Are you sure you want to accept this client"),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () async {
                if (status.toString().contains("accepted")) {
                  await requestToSave(context, d);
                } else {
                  await fireBCollection
                      .collection("newInstallReq")
                      .doc(d["ID"])
                      .update({"status": "$status", "${status}By": widget.UserObj["login_user"]});
                  Navigator.pop(context);
                }
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<List> requestToSave(context, d) async {
    dynamic userData;
    var url = "https://aashaimpex.com/admin/createNewUser.php";

    Map<String, dynamic> requestBody = {
      "sftName": "${d["software_name"]}",
      "sftType": "${d["ACTYPE"]}",
      "shop_Name": "${d["shopName"]}",
      "gstin": "${d["gstin"]}",
      "address": "${d["address"]}",
      "email": "${d["email"]}",
      "mobileNo": "${d["mobile"]}",
      "sft": "", //SQL_
      "ios": "1",
      "userLimit": "",
      "subAdminId": "APP REGISTRATION",
      "refBy": "${d["refByCode"]}",
      "rmk": "",
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );
      if (response.statusCode == 200) {
        dynamic resJson = jsonDecode(response.body);
        userData = resJson;
        logger.d(resJson);
        if (resJson["CLNT"] != null && resJson["CLNT"] != "") {
          logger.i(userData);
          requestBody["ADDED_CLNT"] = resJson["Client Id"];
          requestBody["CLNT"] = requestBody["refBy"];
          await addRefCreditToExistingUser(requestBody, context);
          await fireBCollection.collection("newInstallReq").doc(d["ID"]).update({"status": "accepted"});
        } else {
          showSimpleNotification(Text("Gstin Already registed "), background: Colors.red);
        }
      } else {
        Myf.snakeBar(context, "No data found");
      }
    } catch (error) {}
    return userData;
  }

  static addRefCreditToExistingUser(Map<String, dynamic> requestBody, context) async {
    await fireBCollection.collection("references").where("gstin", isEqualTo: requestBody["gstin"]).get().then((value) async {
      var snp = value.docs;
      //--- check this gstin already Exits or not
      if (snp.length > 0) {
      } else {
        requestBody["date"] = DateTime.now().toString();
        requestBody["time"] = DateTime.now().toString();
        requestBody["ID"] = requestBody["gstin"]!;
        requestBody["refAmt"] = 500;
        await fireBCollection.collection("references").doc(requestBody["gstin"]).set(requestBody);
        //-----adding response to
        Map<String, dynamic> obj = {};
        DateTime now = DateTime.now();
        String formattedDate = "${now.year.toString().padLeft(4, '0')}-"
            "${now.month.toString().padLeft(2, '0')}-"
            "${now.day.toString().padLeft(2, '0')}T"
            "${now.hour.toString().padLeft(2, '0')}:"
            "${now.minute.toString().padLeft(2, '0')}";
        obj["fname"] = requestBody["shop_Name"];
        obj["shopName"] = requestBody["shop_Name"];
        obj["DATE"] = formattedDate;
        obj["ID"] = now.toString();
        obj["reqType"] = "REQUEST ACCEPTED";
        obj["MobileNo"] = requestBody["mobileNo"];
        obj["user"] = "NEW USER";
        obj["CLNT"] = requestBody["ADDED_CLNT"];
        obj["refName"] = requestBody["refBy"];
        obj["remark"] = "";
        obj["tktStatus"] = 'open';
        obj["response"] = "ONLINE REGISTRATION REQUEST ACCEPTED $formattedDate";
        obj["m_time"] = DateTime.now().millisecondsSinceEpoch.toString();
        await fireBCollection.collection("UserResponseReq").doc(now.toString()).set(obj);
        Myf.showSnakeBarOnTop("User Reference saved successfully");
        Navigator.pop(context);
      }
    });
  }
}
