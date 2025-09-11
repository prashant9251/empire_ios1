import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/CrmOutstanding.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingCubit.dart';
import 'package:empire_ios/screen/CRM/CrmOutstandingFollowup/CrmOutstandingFollowup.dart';
import 'package:empire_ios/screen/CRM/CrmOutstandingFollowup/cubit/CrmOutstandingFollowupCubit.dart';
import 'package:empire_ios/screen/CRM/CrmUserWorkingList/CrmUserWorkingList.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<OutstandingModel> CRM_OUTSTANDING_LIST = [];
// late Box CRM_OUTSTANDING_BOX;
LazyBox? MST_MAIN_BOX;
double totalOfProgress = 0.0;
double runingOfProgress = 0.0;
double finalRefereshProgress = 0.0;
late BuildContext mcontext;
final StreamController<bool> refereshStreamProgress = StreamController<bool>.broadcast();
var refereshIsruning = false;

class CrmHome extends StatefulWidget {
  const CrmHome({Key? key}) : super(key: key);

  @override
  State<CrmHome> createState() => _CrmHomeState();
}

class _CrmHomeState extends State<CrmHome> {
  var databasId = "";

  var crmlastRefreshTime = "";

  int currentTimestamp = 0;

  bool loading = true;

  var totalSale = "0.0";
  var todaysSale = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mcontext = context;
    getData().then((value) => null);
  }

  List<IconData> randomIcons = [
    Icons.today,
    Icons.remember_me,
    Icons.inventory_outlined,
    Icons.do_not_disturb_off_outlined,
    Icons.domain_verification_sharp,
    Icons.send,
    Icons.unarchive,
    // Add more icons as needed
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var yesNo = await Myf.yesNoShowDialod(context, title: "Alert", msg: "Are you sure you want to exit");
        if (!yesNo) return false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("${loginUserModel.sHOPNAME}"),
          actions: [
            IconButton(onPressed: () => referesh(), icon: Icon(Icons.sync)),
            IconButton(onPressed: () => Myf.Navi(context, CrmUserWorkingList()), icon: Icon(Icons.table_chart)),
          ],
        ),
        body: loading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Please wait"),
                ],
              ))
            : SafeArea(
                child: ListView(
                children: [
                  StreamBuilder<bool>(
                      stream: refereshStreamProgress.stream,
                      builder: (context, snapshot) {
                        var intpersent = (finalRefereshProgress * 100).toInt();
                        return Column(
                          children: [
                            LinearProgressIndicator(
                              value: finalRefereshProgress,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Myf.dateFormate(crmlastRefreshTime)),
                              ],
                            )
                          ],
                        );
                      }),
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.alarm_sharp, color: Colors.blueGrey, size: 30),
                              SizedBox(width: 10),
                              Text(
                                "Billing Followup",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: fireBCollection
                                .collection("supuser")
                                .doc(GLB_CURRENT_USER["CLIENTNO"])
                                .collection("CRM")
                                .doc("DATABASE")
                                .collection("followUpType")
                                .orderBy("ID", descending: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              var snp = snapshot.data!.docs;
                              if (snp.length > 0) {
                                var sr = 1;
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () => Myf.Navi(
                                              context,
                                              BlocProvider(
                                                create: (context) => CrmOutstandingFollowupCubit(context),
                                                child: CrmOutstandingFollowup(followUpType: "TODAYS"),
                                              )),
                                          child: billingFollowupCard(title: "TODAYS", icon: Icon(randomIcons[0], color: jsmColor, size: 40))),
                                      ...snp.map((e) {
                                        sr++;
                                        return billingFollowupCard(title: "${e.id}", icon: Icon(randomIcons[sr], color: jsmColor, size: 40));
                                      }).toList(),
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                          stream: refereshStreamProgress.stream,
                          builder: (context, snapshot) {
                            return billingNotFollowupCard(title: "Not Follow Up Yet", icon: Icon(Icons.pending, color: jsmColor, size: 40));
                          }),
                      billingFollowupCard(title: "All OverDue", icon: Icon(Icons.abc, color: Colors.green, size: 40)),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (loginUserModel.loginUser!.contains("ADMIN"))
                    Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          // width: screenWidthMobile * .60,
                          decoration: BoxDecoration(
                            color: jsmColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Total Sales",
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                              Text("$totalSale/-", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                          // width: screenWidthMobile * .60,
                          decoration: BoxDecoration(
                            color: jsmColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Todays Sales",
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                              Text("$todaysSale/-", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                ],
              )),
      ),
    );
  }

  Widget billingFollowupCard({icon = const Icon(Icons.today), callsCount = 0, required title}) {
    var qry = fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CRM")
        .doc("DATABASE")
        .collection("followUpList")
        .where("flwType", isEqualTo: title)
        .where("tktClose", isNotEqualTo: true);
    if (title.contains("TODAYS")) {
      var todayDate = Myf.dateFormateYYYYMMDD(DateTime.now().toString(), formate: 'yyyy-MM-dd');
      qry = fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("CRM")
          .doc("DATABASE")
          .collection("followUpList")
          .where("nFDate", isEqualTo: todayDate)
          .where("tktClose", isNotEqualTo: true);
    }

    return StreamBuilder<QuerySnapshot>(
        stream: qry.snapshots(),
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () async {
              if (title == "All OverDue") {
                await Myf.Navi(context, BlocProvider(create: (context) => CrmOutstandingCubit(context), child: CrmOutstanding()));
                refereshStreamProgress.sink.add(true);
              } else {
                await Myf.Navi(
                    context, BlocProvider(create: (context) => CrmOutstandingCubit(context, followUpType: title), child: CrmOutstanding()));
                refereshStreamProgress.sink.add(true);
              }
            },
            child: Container(
              height: 150,
              width: 150,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: jsmColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.hasError) Text("${snapshot.error}", style: TextStyle(color: Colors.red)),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    CircularProgressIndicator()
                  else if (title == "All OverDue")
                    icon
                  else
                    FutureBuilder(
                      future: null,
                      builder: (context, s) {
                        var snp = snapshot.data == null ? [] : snapshot.data!.docs;
                        return Text(
                          "${snp.length}",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 30),
                        );
                      },
                    ),
                  SizedBox(height: 10),
                  Text(
                    "$title",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget billingNotFollowupCard({icon = const Icon(Icons.today), callsCount = 0, required title}) {
    return FutureBuilder(
        future: getNotFollowupList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          return GestureDetector(
            onTap: () async {
              await Myf.Navi(context, BlocProvider(create: (context) => CrmOutstandingCubit(context, notFollow: true), child: CrmOutstanding()));
              refereshStreamProgress.sink.add(true);
              // crmSync().then((value) {
              // });
            },
            child: Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: jsmColor),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream: null,
                      builder: (context, s) {
                        return Text(
                          "${snapshot.data}",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 30),
                        );
                      },
                    ),
                    Text(
                      "$title",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future getData() async {
    setState(() {
      loading = true;
    });
    LazyBox TIME_BOX = await SyncLocalFunction.openLazyBoxCheckByYearWise("TIME");
    var timeArr = await TIME_BOX.getAt(0);
    await TIME_BOX.close();
    totalSale = (timeArr[0]["TOT_SALES"] ?? "0.0").toString();
    todaysSale = (timeArr[0]["TD_SALES"] ?? "0.0").toString();
    try {
      databasId = await Myf.databaseId(GLB_CURRENT_USER);
      await crmSync().then((value) async {
        await SyncLocalFunction.openLazyBoxCheck("MST").then((box_MST) async {
          MST_MAIN_BOX = box_MST;
          crmlastRefreshTime = await hiveMainBox.get("${databasId}crmlastRefreshTime") ?? "";
          CRM_OUTSTANDING_LIST.clear();
          refereshStreamProgress.sink.add(true);
          await referesh().then((value) {
            if (!mounted) return;
            setState(() {
              loading = false;
            });
          });
        });
      });
    } on Exception catch (e) {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future getNotFollowupList() async {
    Box CRM_BOX = await SyncLocalFunction.openBoxCheckByYearWise("CRM");
    var length = 0;
    await crmSync().then((value) async {
      var crmOutstandingList = await Future.wait(CRM_OUTSTANDING_LIST.map((e) async {
        try {
          dynamic d = await CRM_BOX.values.firstWhere((ele) => ele["pcode"] == e.code && (ele["tktClose"] != true));
          CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(d));
          e.crmFollowUpModel = crmFollowUpModel;
        } catch (err) {
          e.crmFollowUpModel = CrmFollowUpModel();
        }
        return e;
      }).toList());
      length = crmOutstandingList.where((e) => e.crmFollowUpModel!.partyCode == null).length;
    });
    await CRM_BOX.close();
    return length;
  }
}

Future referesh() async {
  // CRM_OUTSTANDING_BOX = await SyncLocalFunction.openBoxCheckByYearWise("CRM_OUTSTANDING_BOX");
  if (refereshIsruning) {
    Myf.snakeBar(mcontext, "Please wait refreshing is runing");
    return;
  }
  refereshIsruning = true;
  var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
  await SyncLocalFunction.openLazyBoxCheckByYearWise("OUTSTANDING").then((box_outstanding) async {
    await box_outstanding.get("${databasId}OUTSTANDING").then((OUTSTANDING) async {
      await box_outstanding.close();
      runingOfProgress = 0;
      finalRefereshProgress = 0;
      CRM_OUTSTANDING_LIST.clear();
      for (var i = 0; i < OUTSTANDING.length; i++) {
        OutstandingModel outstandingModel = await OutstandingModel.fromJson(Myf.convertMapKeysToString(OUTSTANDING[i]));
        outstandingModel = await getMasteDetails(outstandingModel);

        if (outstandingModel.PAMT! > 0 && outstandingModel.masterModel!.aTYPE == "1") {
          CRM_OUTSTANDING_LIST.add(outstandingModel);
        }
      }
      OUTSTANDING.clear();
      refereshIsruning = false;
      refereshStreamProgress.sink.add(true);
      // });
    });
  });
}

getMasteDetails(OutstandingModel outstandingModel) async {
  dynamic master = await getMasterModerByCode(outstandingModel.code);
  MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(master));
  if (masterModel.broker != null && masterModel.broker != "") {
    dynamic broker = await getMasterModerByCode(masterModel.broker);
    MasterModel brokerModel = MasterModel.fromJson(Myf.convertMapKeysToString(broker));
    outstandingModel.brokerModel = brokerModel;
  }
  outstandingModel.masterModel = masterModel;
  var PAMT = 0.0;
  var billDetail = outstandingModel.billdetails ?? [];
  outstandingModel.billdetails = await billDetail.where((bill) {
    var pAmt = Myf.convertToDouble(bill.pAMT);
    PAMT += pAmt;
    var days = Myf.daysCalculate(bill.dATE);
    bill.days = days;
    return true;
  }).toList();
  outstandingModel.PAMT = PAMT;
  return outstandingModel;
}

Future getMasterModerByCode(String? code) async {
  if (code != null && code != "") {
    dynamic d = {};
    try {
      d = await MST_MAIN_BOX!.get(code) ?? {};
      // MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(d));
      return d;
    } catch (e) {
      return {};
    }
  } else {
    return {};
  }
}

Future crmSync() async {
  var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);
  var localSyncTime = (await hiveMainBox.get("${databaseId}CRM") ?? "0").toString();
  var dt = await DateTime.now();
  Box CRM_BOX = await SyncLocalFunction.openBoxCheckByYearWise("CRM");
  await fireBCollection
      .collection("supuser")
      .doc(GLB_CURRENT_USER["CLIENTNO"])
      .collection("CRM")
      .doc("DATABASE")
      .collection("followUpList")
      .get()
      .then((value) async {
    var snp = value.docs;
    if (snp.length > 0) {
      await Future.wait(snp.map((e) async {
        dynamic d = e.data();
        await CRM_BOX.put(e.id, d);
      }).toList());
      // await CRM_BOX.compact();
      snp.clear();
      await hiveMainBox.put("${databaseId}CRM", dt);
    }
  });
}
