import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboard.dart';
import 'package:empire_ios/Models/ResponseSuggetionsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../screen/EMPIRE/Myf.dart';

class OfficeDeshboardClass {
  static Future<List?> getData(context, {term = '', clnt, recorslimit = "100", softwareName = '', PAY = ''}) async {
    var userData = [];
    var url = "${urldata.syncDataUrlDomain}/offsupport/searchUserFetch.php";

    Map<String, String> requestBody = {
      'dateOrder': 'DESC',
      'recordLimit': '${recorslimit}',
      'duetype': '',
      'usernm': '',
      'mobileNo': '',
      'email': '',
      'softwareName': '$softwareName',
      'block': '',
      'clnt': clnt ?? '',
      'company_access_like': '',
      'PAY': '$PAY',
      'searchInAll': '${term.toString().trim()}',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request successful, handle response
        var resJson = await jsonDecode(response.body);
        userData = resJson;
        // logger.i(userData);
        return userData;
      } else {
        Myf.snakeBar(context, "No data found");
        // Request failed, handle error
        return [];
      }
    } catch (error) {
      // Error occurred, handle exception
      return null;
    }
  }

  static Color colorOnReqType(reqType) {
    var color = Colors.white;

    switch (reqType) {
      case "ISSUE":
        color = Colors.red[200]!;
        break;
      case "MEETING":
        color = Colors.indigo[200]!;
        break;
      case "NEW INSTALL":
        color = Colors.blue[200]!;
        break;
      case "NEW DEVLOPMENT":
        color = Colors.grey[400]!;
        break;
      case "PAYMENT CALL":
        color = Colors.amber[200]!;
        break;
      case "ONLY QUERY":
        color = Colors.brown[200]!;
        break;
      case "DEMO REQUIRED":
        color = Colors.green;
        break;
      case "COLLECT PAYMENT":
        color = jsmColor;
        break;
      case "REQUEST ACCEPTED":
        color = Colors.amber;
        break;
      default:
    }
    return color;
  }

  static colorOnPayType(e) {
    var color = Colors.white;
    switch (e["PAY"]) {
      case "N":
        color = Colors.red[200]!;
        break;
      default:
    }
    return color;
  }

  static getResposeSelection(context, ResponseSuggetionsModel responseSuggetionsModel) {
    var complater = Completer<ResponseSuggetionsModel>();
    List<ResponseSuggetionsModel> responnsSuggetionList = responseSuggetions.where(
      (element) {
        return element.issueType == responseSuggetionsModel.issueType;
      },
    ).toList();

    var changeStream = StreamController<bool>.broadcast();
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: .6,
      builder: (context) {
        var srResponse = 0;
        return Container(
          height: ScreenHeight(context) * .6,
          width: screenWidthMobile,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Type of Response",
                    style: TextStyle(fontSize: 25),
                  ),
                  IconButton(
                      onPressed: () async {
                        await addNewResponseSuggetions(context, ResponseSuggetionsModel(issueType: responseSuggetionsModel.issueType));
                        responnsSuggetionList = responseSuggetions.where(
                          (element) {
                            return element.issueType == responseSuggetionsModel.issueType;
                          },
                        ).toList();
                        changeStream.sink.add(true);
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              Expanded(
                  child: StreamBuilder<bool>(
                      stream: changeStream.stream,
                      builder: (context, snapshot) {
                        return ListView(
                          children: [
                            for (var item in responnsSuggetionList)
                              ListTile(
                                onTap: () {
                                  complater.complete(item);
                                  Navigator.pop(context);
                                },
                                title: Text("${srResponse++}-${item.desc}"),
                                trailing: IconButton(
                                  onPressed: () {
                                    addNewResponseSuggetions(context, item);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ),
                          ],
                        );
                      }))
            ],
          ),
        );
      },
    );
    return complater.future;
  }

  static addNewResponseSuggetions(context, ResponseSuggetionsModel responseSuggetionsModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add New Response"),
            content: Container(
              width: ScreenHeight(context) * .7,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 5,
                    initialValue: responseSuggetionsModel.desc,
                    onChanged: (val) {
                      responseSuggetionsModel.desc = val;
                    },
                    validator: (value) => value!.isEmpty ? "Enter Description" : null,
                    decoration: InputDecoration(
                        hintText: "Description", labelText: "Description", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                  TextFormField(
                    maxLines: 5,
                    initialValue: responseSuggetionsModel.solution,
                    onChanged: (val) {
                      responseSuggetionsModel.solution = val;
                    },
                    decoration: InputDecoration(
                        hintText: "Solution", labelText: "Solution", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                  FloatingActionButton.extended(
                      backgroundColor: jsmColor,
                      onPressed: () {
                        fireBCollection
                            .collection("softwares")
                            .doc("EMPIRE")
                            .collection("responseSuggetions")
                            .doc(responseSuggetionsModel.id)
                            .set(responseSuggetionsModel.toMap())
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      label: Text(
                        "SAVE",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
