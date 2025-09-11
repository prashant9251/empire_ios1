// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Apis/Enotify.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpenCard.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/JsonViewer.dart';
import 'package:empire_ios/screen/expiries/expCalculation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:ndialog/ndialog.dart';

import '../../screen/EMPIRE/Myf.dart';
import '../../screen/uniqOfficeSupport/addNewUniqueClientRequest/addNewUniqueClientRequest.dart';
import 'OfficeDeshboardClass.dart';

class OfficeClientRequestOpen extends StatefulWidget {
  var obj;

  var UserObj;
  OfficeClientRequestOpen({Key? key, required this.obj, required this.UserObj}) : super(key: key);

  @override
  State<OfficeClientRequestOpen> createState() => _OfficeClientRequestOpenState();
}

class _OfficeClientRequestOpenState extends State<OfficeClientRequestOpen> {
  dynamic userDataObj;
  final StreamController<bool> refreshScreen = StreamController<bool>.broadcast();
  List? userData = [];
  List snp = [];

  var ctrlRmk = TextEditingController();
  dynamic fireUserdetails = {};

  List<dynamic> userList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    fireBCollection
        .collection("UserResponseReq")
        .where("CLNT", isEqualTo: widget.obj["clnt"])
        .orderBy("DATE", descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.length > 0) {
        snp = event.docs;
      }
      if (mounted) {
        setState(() {});
      }
    });
    fireBCollection.collection("supuser").doc(widget.obj["clnt"]).get().then((value) {
      if (value.exists) {
        fireUserdetails = value.data();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: SelectableText(
          "CLIENT REQUEST",
          style: TextStyle(letterSpacing: 5),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: SelectableText(
                "Call Scripts",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: jsmColor),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: fireBCollection.collection("softwares").doc("EMPIRE").collection("callScript").snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!asyncSnapshot.hasData || (asyncSnapshot.data as QuerySnapshot).docs.isEmpty) {
                    return Center(child: Text("No Call Scripts Available"));
                  }
                  List<DocumentSnapshot> snp = (asyncSnapshot.data as QuerySnapshot).docs;
                  return Column(
                    children: [
                      ...snp.map(
                        (e) {
                          dynamic d = e.data();
                          return ListTile(
                            title: Text(
                              "${d["title"]}",
                              style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor, fontSize: 18),
                            ),
                            subtitle: Divider(
                              thickness: 2,
                              color: jsmColor,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var actDate = userDataObj["Activetiondate"];
                                    DateTime? expiryDate;
                                    if (actDate != null && actDate is String && actDate.isNotEmpty) {
                                      try {
                                        expiryDate = DateTime.parse(actDate).add(Duration(days: 365));
                                      } catch (e) {
                                        expiryDate = null;
                                      }
                                    }
                                    var d2 = d["description"]
                                        .toString()
                                        .replaceAll("\$expiryDate", "${Myf.dateFormateInDDMMYYYY(expiryDate.toString()) ?? "______________"}");
                                    int daysFromNotUpdating = 0;
                                    if (fireUserdetails["CURRENT_YEAR_CREATETIME_MILLI"] != null) {
                                      daysFromNotUpdating = Myf.daysCalculate(
                                          Myf.datetimeFormateFromMilli(fireUserdetails["CURRENT_YEAR_CREATETIME_MILLI"], format: "yyyy-MM-dd"));
                                    }
                                    d2 = d2.replaceAll("\$days", "${daysFromNotUpdating}");

                                    return AlertDialog(
                                      title: Text("${d["title"]}", style: TextStyle(fontSize: 25, color: jsmColor)),
                                      content: SelectableText("${d2}", style: TextStyle(fontSize: 20)),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        },
                      ).toList(),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          "Pricing Call Script",
                          style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor, fontSize: 18),
                        ),
                        onTap: () {
                          Myf.launchurl(Uri.parse("https://uniqsoftwares.com/pricing"));
                        },
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          "App use",
                          style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor, fontSize: 18),
                        ),
                        onTap: () {
                          Myf.launchurl(Uri.parse("https://uniqsoftwares.com/gallery2/"));
                        },
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Wrap(
              children: [
                Container(
                  width: kIsWeb ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
                  child: StreamBuilder<bool>(
                      stream: refreshScreen.stream,
                      builder: (context, snapshot) {
                        if (userData!.length == 0) {
                          return SizedBox.shrink();
                        } else {
                          userDataObj = userData![0];
                          userList = userData![0]["billDetails"];
                          var admin_mobile = userDataObj["admin_mobile"];
                          var admin_email = userDataObj["admin_email"];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                "User Details",
                                style: TextStyle(fontSize: 25, color: jsmColor, fontWeight: FontWeight.bold, letterSpacing: 5),
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: SelectableText("${userDataObj["shopName"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onLongPress: () {
                                                  Clipboard.setData(ClipboardData(text: userDataObj["clnt"]));
                                                  Myf.toast("Copied to clipboard", context: context);
                                                },
                                                child: SelectableText("CLIENT : ${userDataObj["clnt"]}")),
                                            SelectableText("Address", style: TextStyle(fontWeight: FontWeight.bold)),
                                            SelectableText("GSTIN: ${userDataObj["GSTIN"]}"),
                                            Container(
                                              width: 300,
                                              child: SelectableText(
                                                "${userDataObj["ADDRESS"]}",
                                                style: TextStyle(color: jsmColor, fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Myf.dialNo([userDataObj["admin_mobile"]], context);
                                                },
                                                child: SelectableText(
                                                  "MOBILE : ${userDataObj["admin_mobile"]}",
                                                  style: TextStyle(color: Colors.blue),
                                                )),
                                            Divider(thickness: 8, color: Colors.black),
                                            SelectableText("iosPermission : ${userDataObj["iosPermission"]}"),
                                            SelectableText("software_name : ${userDataObj["software_name"]}"),
                                            SelectableText("userLimit : ${userDataObj["userLimit"]}"),
                                            SelectableText("Demo Days : ${userDataObj["demoExpiryDays"]}"),
                                            SelectableText("Days Validity after PAY : ${userDataObj["sftExpiryDays"]}"),
                                            SelectableText("SQL : ${userDataObj["sft"]}"),
                                            SelectableText("StorageType  : ${userDataObj["StorageType"]}"),
                                            SelectableText("REF BY  : ${userDataObj["refBy"]}"),
                                            Chip(
                                                backgroundColor: userDataObj["BLOCK"] == "0" ? Colors.grey : Colors.red,
                                                label: SelectableText("BLOCK STATUS : ${userDataObj["BLOCK"]}")),
                                            GestureDetector(
                                              onTap: () {
                                                var userActivityUrl =
                                                    "https://aashaimpex.com/userActivity.php?ntab=NTAB&usernm=${userDataObj["clnt"]}";
                                                Myf.launchurl(Uri.parse(userActivityUrl));
                                              },
                                              child: Chip(
                                                backgroundColor: userDataObj["PAY"] == "Y" ? Colors.green : Colors.red,
                                                label: Column(
                                                  children: [
                                                    Text(
                                                      "PAY : ${userDataObj["PAY"]}",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    SelectableText("ACT DATE : ${Myf.dateFormateInDDMMYYYY(userDataObj["Activetiondate"])}"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            FutureBuilder<Map<String, dynamic>>(
                                              future: ExpCalculate.expiryStatusForDesktop(userDataObj),
                                              builder: (context, snapshot) {
                                                var snp = snapshot.data == null ? {"msg": ""} : {};
                                                return snp["msg"] != ""
                                                    ? Chip(
                                                        label: SelectableText("${snp["msg"]}"),
                                                        backgroundColor: Colors.red[300],
                                                      )
                                                    : SizedBox.shrink();
                                              },
                                            ),
                                            GestureDetector(
                                                onTap: () async {
                                                  var ctrlContactDetail = TextEditingController();
                                                  await NAlertDialog(
                                                    dialogStyle: DialogStyle(titleDivider: true),
                                                    title: SelectableText(
                                                      "Contact Details",
                                                    ),
                                                    content: TextFormField(
                                                      controller: ctrlContactDetail,
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () async {
                                                            await fireBCollection
                                                                .collection("supuser")
                                                                .doc(userDataObj["clnt"])
                                                                .collection("database")
                                                                .doc("1")
                                                                .update({"contactDetails": "${ctrlContactDetail.text.toUpperCase().trim()}"});
                                                            Navigator.pop(context);
                                                          },
                                                          child: const SelectableText('ok'))
                                                    ],
                                                  ).show(context);
                                                },
                                                child: Text("CONTACT: +")),
                                            StreamBuilder<DocumentSnapshot>(
                                                stream: fireBCollection.collection("supuser").doc(userDataObj["clnt"]).snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  }
                                                  if (snapshot.data!.exists) {
                                                    dynamic d = snapshot.data!.data();
                                                    return Container(
                                                        padding: EdgeInsets.all(3),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 2,
                                                          ),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  fireBCollection.collection("supuser").doc(userDataObj["clnt"]).update({
                                                                    "PAY": "N",
                                                                  });
                                                                  Myf.toast("Updated Current Year Create Time", context: context);
                                                                },
                                                                child: Text(
                                                                  "L U: ${(d["CURRENT_YEAR_CREATETIME"])}",
                                                                  style: TextStyle(
                                                                      color: Colors.red,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 18,
                                                                      decoration: TextDecoration.underline),
                                                                )),
                                                            SelectableText("${d["contactDetails"]}"),
                                                            SelectableText("Year:-${d["year"]}"),
                                                            SelectableText("PcVersion:-${d["pcVersion"] ?? ""}"),
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return JsonViewer(jsonString: d);
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(Icons.newspaper_rounded)),
                                                          ],
                                                        ));
                                                  } else {
                                                    return SizedBox.shrink();
                                                  }
                                                })
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // width: 500,
                                child: Column(
                                  children: [
                                    Divider(color: jsmColor, thickness: 2),
                                    SelectableText(
                                      "Current User",
                                      style: TextStyle(fontSize: 20, color: jsmColor),
                                    ),
                                    Container(
                                      // width: screenWidthMobile * .5,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: 0,
                                          columns: [
                                            DataColumn(label: SelectableText('UserName')),
                                            DataColumn(label: SelectableText('Mobile')),
                                            DataColumn(label: SelectableText('Email')),
                                            DataColumn(label: SelectableText('Action')),
                                          ],
                                          rows: [
                                            ...userList.map(
                                              (e) {
                                                var userIsadmin = false;
                                                if (e['mobileno_user'] == admin_mobile && e['emailadd'] == admin_email) {
                                                  userIsadmin = true;
                                                }
                                                return DataRow(
                                                    color: WidgetStateColor.resolveWith((states) => userIsadmin ? Colors.grey : Colors.white),
                                                    cells: [
                                                      DataCell(SelectableText('${e["usernm"]}')),
                                                      DataCell(GestureDetector(
                                                          onLongPress: () {
                                                            Clipboard.setData(ClipboardData(text: e["mobileno_user"]));
                                                            Myf.toast("Copied to clipboard", context: context);
                                                          },
                                                          onTap: () {
                                                            Myf.dialNo([e["mobileno_user"]], context);
                                                          },
                                                          child: Chip(label: SelectableText('${e["mobileno_user"]}')))),
                                                      DataCell(GestureDetector(
                                                          onTap: () async {
                                                            var res = await EnotifyApis.sendContact("91${e["mobileno_user"]}");
                                                            Myf.toast(res.toString(), context: context);
                                                          },
                                                          child: Text(
                                                            '${e["emailadd"]}',
                                                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                                                          ))),
                                                      DataCell(Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                Clipboard.setData(ClipboardData(text: e["mobileno_user"])).then((_) {
                                                                  // Show a Snackbar or Toast to indicate success
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: SelectableText('Mobile No Copied to clipboard!')),
                                                                  );
                                                                });
                                                              },
                                                              icon: Icon(Icons.copy)),
                                                          IconButton(
                                                              onPressed: () {
                                                                fireBCollection
                                                                    .collection("supuser")
                                                                    .doc(userDataObj["clnt"])
                                                                    .collection("user")
                                                                    .doc(e["usernm"])
                                                                    .get()
                                                                    .then((event) {
                                                                  dynamic d = event.data();
                                                                  Myf.Navi(context, JsonViewer(jsonString: d));
                                                                });
                                                              },
                                                              icon: Icon(Icons.newspaper_outlined)),
                                                        ],
                                                      )),
                                                    ]);
                                              },
                                            ).toList(),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: kIsWeb ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width,
                  child: Column(
                    // shrinkWrap: true,
                    children: [
                      SelectableText(
                        "Response",
                        style: TextStyle(fontSize: 25, color: jsmColor, fontWeight: FontWeight.bold, letterSpacing: 5),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: kIsWeb ? null : NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.all(5),
                          itemCount: snp.length,
                          itemBuilder: (context, index) {
                            dynamic d = snp[index].data();
                            var color = Colors.white;
                            var reqType = d["reqType"].toString();
                            var resolveDate = d["resolveDate"];
                            color = OfficeDeshboardClass.colorOnReqType(reqType);
                            if (resolveDate != null) {
                              color = Colors.white;
                            }
                            return OfficeClientRequestOpenCard(d: d, UserObj: widget.UserObj);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "addNewRequestFromOfficeClientRequestOpen",
          onPressed: () {
            dynamic userDataObj = userData![0];
            userDataObj["req_mobileno_user"] = userDataObj["billDetails"][0]["mobileno_user"];
            userDataObj["req_usernm"] = userDataObj["billDetails"][0]["usernm"];

            Myf.Navi(
                context,
                AddNewUniqueClientRequest(
                  userDataObj: userDataObj,
                  UserObj: widget.UserObj,
                ));
          },
          label: Text("Add New Request")),
    );
  }

  Future<void> getData() async {
    userData = await OfficeDeshboardClass.getData(context, term: widget.obj["clnt"], clnt: widget.obj["clnt"]);
    if (userData!.length > 0) {
      dynamic userDataObj = userData![0];
      fireBCollection.collection("supuser").doc(widget.obj["clnt"]).update(
        {
          "PAY": "${userDataObj["PAY"]}",
          "software_name": "${userDataObj["software_name"]}",
        },
      ).then((value) {});
    }
    refreshScreen.sink.add(true);
  }
}
