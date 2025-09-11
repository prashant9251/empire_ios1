import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpen.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class OfficeNextDueCalls extends StatefulWidget {
  const OfficeNextDueCalls({Key? key}) : super(key: key);

  @override
  State<OfficeNextDueCalls> createState() => _OfficeNextDueCallsState();
}

class _OfficeNextDueCallsState extends State<OfficeNextDueCalls> {
  var loading = true;
  List clntList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // call dio request
    // dio Requist to fetchClient no list
    diaoRequest();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = ScreenWidth(context);
        if (constraints.maxWidth < 600) {
          screenWidth = ScreenWidth(context);
        } else if (constraints.maxWidth < 1200) {
          screenWidth = ScreenWidth(context) / 2;
        } else {
          screenWidth = ScreenWidth(context) / 4;
        }
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
          height: 400,
          width: screenWidth,
          child: StreamBuilder(
              stream: null,
              builder: (context, snapshot) {
                var snp = clntList;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(child: Chip(label: Text("Next Due Calls"))),
                          Flexible(
                            child: CircleAvatar(child: Text("${snp.length}")),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          dynamic d = snp[index];
                          return StreamBuilder<QuerySnapshot>(
                              stream: fireBCollection
                                  .collection("UserResponseReq")
                                  .where("CLNT", isEqualTo: d["clnt"])
                                  .where("reqType", isEqualTo: "PAYMENT CALL")
                                  .where("tktStatus", isEqualTo: "open")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                                if (snapshot.hasError) return Text("${snapshot.error}");
                                if (snapshot.data == null) return Text("somthing went wrong");
                                var snp = snapshot.data!.docs;
                                return Card(
                                  color: Colors.lightGreen,
                                  child: ListTile(
                                    onTap: () {
                                      Myf.Navi(
                                          context,
                                          OfficeClientRequestOpen(
                                            obj: d,
                                            UserObj: GLB_CURRENT_USER,
                                          ));
                                    },
                                    title: Text(d["shopName"]),
                                    trailing: Text(d["clnt"]),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (snp.length > 0)
                                          Container(
                                              decoration:
                                                  BoxDecoration(border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                              child: Text("${snp.length > 0 ? "PAYMENT CALL CREATED" : ""}")),
                                        Text("Expiry in ${d["expiryIn"] ?? ""} Days"),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        itemCount: snp.length,
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  void diaoRequest() async {
    // dio request

    Dio dio = Dio();
    var response = await dio.get('https://aashaimpex.com/admin/nextDue.php');

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.data);
      clntList = json;
      setState(() {
        loading = false;
      });
    }
  }
}
