import 'dart:convert';

import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingDetails/CrmUserWorkingDetails.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingList/CrmUserExcelReport.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class CrmUserWorkingList extends StatefulWidget {
  const CrmUserWorkingList({Key? key}) : super(key: key);

  @override
  State<CrmUserWorkingList> createState() => _CrmUserWorkingListState();
}

class _CrmUserWorkingListState extends State<CrmUserWorkingList> {
  List<CrmFollowUpModel> crmFOllowUpModelList = [];
  var userList = [];
  var loading = true;

  DateTime? selectDatetTime = DateTime.now();
  var ctrlDate = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlDate.text = Myf.dateFormateYYYYMMDD(selectDatetTime.toString(), formate: "yyyy-MM-dd");
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var userSr = 0;
    return LayoutBuilder(builder: (context, constraints) {
      userSr = 0;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("Wroking User list"),
          actions: [
            IconButton(
                onPressed: () async {
                  //  crmFOllowUpModelList convert excel and download
                  List<Map<String, dynamic>> json = [];
                  String selectedDate = Myf.dateFormateYYYYMMDD(selectDatetTime.toString(), formate: "yyyy-MM-dd");
                  await getAllUserTodaysWorking(date: selectedDate);
                  crmFOllowUpModelList.forEach((element) {
                    element.CrmFollowRespList!.forEach((e) {
                      Map<String, dynamic> j = {};
                      j["TICKET DATE"] = element.date;
                      j["TICKET TYPE"] = element.type;
                      j["PARTY"] = element.partyCode;
                      j["RESPONSE"] = e.resp;
                      j["RESPONSE DATE"] = e.time;
                      j["BY USER"] = Myf.getUserNameString(e.user!);
                      json.add(j);
                    });
                  });
                  CrmUserExcelReport.jsonToExcel(json);
                },
                icon: Icon(Icons.download))
          ],
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: friendlyScreenWidth(context, constraints),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "User Working List",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: jsmColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: TextFormField(
                              onTap: () async {
                                selectDatetTime = await Myf.selectDate(context);
                                ctrlDate.text = Myf.dateFormateYYYYMMDD(selectDatetTime.toString(), formate: "yyyy-MM-dd");
                                getData();
                              },
                              readOnly: true,
                              controller: ctrlDate,
                              decoration: InputDecoration(
                                label: Text("Select Date"),
                                prefixIcon: Icon(Icons.calendar_today, color: jsmColor),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userList.length,
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final e = userList[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: jsmColor.withOpacity(0.8),
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  "${Myf.getUserNameString(e["userID"])}".toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                                ),
                                trailing: FutureBuilder<List<CrmFollowUpModel>>(
                                  future: getUserWork(e["userID"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting)
                                      return SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      );
                                    return GestureDetector(
                                      onTap: () {
                                        List<CrmFollowUpModel> crmFollowUpList = snapshot.data ?? [];
                                        Myf.Navi(context, CrmUserWorkingDetails(crmFollowUpList: crmFollowUpList));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "${snapshot.data!.length}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        if (userList.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Text(
                              "No users found for this date.",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Future<List<CrmFollowUpModel>> getUserWork(usernm) async {
    return crmFOllowUpModelList.where((element) => element.user == usernm).toList();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    String selectedDate = Myf.dateFormateYYYYMMDD(selectDatetTime.toString(), formate: "yyyy-MM-dd");
    await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("user").get().then((value) async {
      var snp = value.docs;
      userList = [];
      await Future.wait(snp.map((e) async {
        dynamic d = e.data();
        userList.add(d);
      }).toList());
      await crmSync();
      await getAllUserTodaysWorking(date: selectedDate);
      setState(() {
        loading = false;
      });
    });
  }

  getAllUserTodaysWorking({String? date}) async {
    crmFOllowUpModelList = [];
    Box CRM_BOX = await SyncLocalFunction.openBoxCheckByYearWise("CRM");

    for (var i = 0; i < CRM_BOX.length; i++) {
      dynamic d = await CRM_BOX.getAt(i);
      CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(d));
      var crmFollowRespList = crmFollowUpModel.CrmFollowRespList!.where((element) {
        if (date == null || date.isEmpty) {
          crmFollowUpModel.user = element.user;
          return true;
        }
        var dateFormateYYYYMMDD = Myf.dateFormateYYYYMMDD(element.time, formate: "yyyy-MM-dd");
        if (dateFormateYYYYMMDD == date) {
          crmFollowUpModel.user = element.user;
          return true;
        }
        return false;
      }).toList();
      if (crmFollowRespList.length > 0) {
        crmFollowUpModel.CrmFollowRespList = [...crmFollowRespList];
        crmFOllowUpModelList.add(crmFollowUpModel);
      }
    }
    CRM_BOX.close();
    return crmFOllowUpModelList;
  }
}
