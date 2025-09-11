import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

var ctrlFromDate = TextEditingController();
var ctrlToDate = TextEditingController();
var ctrlcRD = TextEditingController();
var ctrlCompanyName = TextEditingController();
var ctrlCopanyCno = TextEditingController();
var ctrlPartyname = TextEditingController();
var ctrlBrokerName = TextEditingController();
var initialExpand = false;
var shoOnlyTodayDue = true;

class TodaysDueListCubit extends Cubit<TodaysDueListState> {
  var changeStream = StreamController<bool>.broadcast();
  ScreenshotController screenshotController = ScreenshotController();
  BuildContext context;
  List<OutstandingModel> OUTSTANDING_LIST = [];
  List<OutstandingModel> FILTERED_OUTSTANDING = [];
  List<OutstandingModel> selectedOutstanding = [];
  LazyBox? MST_MAIN_BOX;

  var formKey = GlobalKey<FormState>();

  TodaysDueListCubit(this.context) : super(TodaysDueListInitial());

  getData() async {
    var st = prefs!.getString("GLB_CURRENT_USER");
    GLB_CURRENT_USER = jsonDecode(st ?? "{}");
    ctrlcRD.text = await Myf.getValFromSavedPref(GLB_CURRENT_USER, "outstandingDhara");
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    await SyncLocalFunction.openLazyBoxCheck("MST").then((box_MST) async {
      MST_MAIN_BOX = box_MST;
      await SyncLocalFunction.openLazyBoxCheckByYearWise("OUTSTANDING").then((box_outstanding) async {
        await box_outstanding.get("${databasId}OUTSTANDING").then((OUTSTANDING) async {
          for (var i = 0; i < OUTSTANDING.length; i++) {
            OutstandingModel outstandingModel = await OutstandingModel.fromJson(Myf.convertMapKeysToString(OUTSTANDING[i]));
            outstandingModel = await getMasteDetails(outstandingModel);
            if (outstandingModel.PAMT! > 0 && outstandingModel.masterModel!.aTYPE == "1") {
              OUTSTANDING_LIST.add(outstandingModel);
            }
          }
        });
      });
    });

    loadData();
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
    var text = ctrlToDate.text.isEmpty ? Myf.dateFormateYYYYMMDD(DateTime.now().toString()) : Myf.dateFormateYYYYMMDD((ctrlToDate.text));

    outstandingModel.billdetails = await billDetail.where((bill) {
      var pAmt = Myf.convertToDouble(bill.pAMT);
      PAMT += pAmt;
      var days = Myf.daysCalculate(bill.dATE, date2: DateTime.parse(text));
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

  void loadData() async {
    emit(TodaysDueListLoadWidget(Center(child: CircularProgressIndicator())));
    await Future.delayed(Duration(milliseconds: 100));
    var dhara = int.tryParse(ctrlcRD.text) ?? 0;
    FILTERED_OUTSTANDING = OUTSTANDING_LIST
        .map((e) {
          e.allbilldetails = e.billdetails;
          e.billdetails = e.billdetails?.where((detail) {
            var days = Myf.daysCalculate(detail.dATE);
            detail.days = days;
            if (dhara == 0) {
              dhara = int.tryParse(e.masterModel!.cRD!) ?? 0;
              e.masterModel!.cRD = dhara.toString();
            }

            DateTime billDate = DateTime.parse(Myf.dateFormateYYYYMMDD(detail.dATE!));
            DateTime now = DateTime.now();
            DateTime monday = now.subtract(Duration(days: now.weekday - 1));
            DateTime sunday = monday.add(Duration(days: 6));
            var thisWeekMonday = Myf.dateFormateYYYYMMDD(monday.subtract(Duration(days: 1)).toString());
            var thisWeekSunday = Myf.dateFormateYYYYMMDD(sunday.add(Duration(days: 0)).toString());
            var bilDateAfterAddDays = billDate.add(Duration(days: dhara - 1));
            if (bilDateAfterAddDays.isAfter(DateTime.parse(thisWeekMonday)) &&
                bilDateAfterAddDays.isBefore(DateTime.parse(thisWeekSunday)) &&
                detail.dT.toString().toUpperCase().trim() == "OS") {
              detail.dueType = "This Week Due";
            } else if (days > dhara && detail.dT.toString().toUpperCase().trim() == "OS") {
              detail.dueType = "Overdue";
            } else if (days < dhara && detail.dT.toString().toUpperCase().trim() == "OS") {
              detail.dueType = "Upcoming";
            } else {
              detail.dueType = "Other";
            }
            return !(detail.tYPE!.toUpperCase() == 'XX' && int.tryParse(detail.vNO!)! < 100000);
          }).toList();
          return e;
        })
        .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
        .toList();

    if (ctrlCopanyCno.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails?.where((detail) {
              return detail.cNO!.toUpperCase() == (ctrlCopanyCno.text.toUpperCase());
            }).toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }
    if (ctrlPartyname.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails?.where((detail) {
              return e.masterModel!.partyname!.toUpperCase() == (ctrlPartyname.text.toUpperCase());
            }).toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }
    if (ctrlBrokerName.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails?.where((detail) {
              return (detail.bCODE ?? "").toUpperCase() == (ctrlBrokerName.text.toUpperCase());
            }).toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }
    if (ctrlFromDate.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING.where((element) {
        return element.billdetails!.any((bill) {
          DateTime billDate = DateTime.parse(Myf.dateFormateYYYYMMDD(bill.dATE!));
          DateTime fromDate = DateTime.parse(Myf.dateFormateYYYYMMDD(ctrlFromDate.text));
          return billDate.isAfter(fromDate) || billDate.isAtSameMomentAs(fromDate);
        });
      }).toList();
    }
    if (ctrlToDate.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING.where((element) {
        return element.billdetails!.any((bill) {
          DateTime billDate = DateTime.parse(Myf.dateFormateYYYYMMDD(bill.dATE!));
          DateTime toDate = DateTime.parse(Myf.dateFormateYYYYMMDD(ctrlToDate.text));
          return billDate.isBefore(toDate) || billDate.isAtSameMomentAs(toDate);
        });
      }).toList();
    }
    if (shoOnlyTodayDue) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING.where((element) {
        return element.billdetails!.any((bill) {
          return bill.dueType == "This Week Due";
        });
      }).toList();
    }
    // if (ctrlFromDate.text.isNotEmpty) {
    //   FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
    //       .map((e) {
    //         e.allbilldetails = e.billdetails;
    //         e.billdetails = e.billdetails?.where((detail) {
    //           DateTime billDate = DateTime.parse(Myf.dateFormateYYYYMMDD(detail.dATE!));
    //           DateTime fromDate = DateTime.parse(Myf.dateFormateYYYYMMDD(ctrlFromDate.text));
    //           return (billDate.isAfter(fromDate) || billDate.isAtSameMomentAs(fromDate));
    //         }).toList();
    //         return e;
    //       })
    //       .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
    //       .toList();
    // }
    // if (ctrlToDate.text.isNotEmpty) {
    //   FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
    //       .map((e) {
    //         e.allbilldetails = e.billdetails;
    //         e.billdetails = e.billdetails?.where((detail) {
    //           DateTime billDate = DateTime.parse(Myf.dateFormateYYYYMMDD(detail.dATE!));
    //           DateTime toDate = DateTime.parse(Myf.dateFormateYYYYMMDD(ctrlToDate.text));
    //           return (billDate.isBefore(toDate) || billDate.isAtSameMomentAs(toDate));
    //         }).toList();
    //         return e;
    //       })
    //       .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
    //       .toList();
    // }

    Widget widget = getTable();
    emit(TodaysDueListLoadWidget(widget));
    changeStream.sink.add(true);
  }

  Widget getTable() {
    if (FILTERED_OUTSTANDING.isEmpty) {
      return Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            OutstandingModel outstandingModel = FILTERED_OUTSTANDING[index];
            List<Billdetails> OverdueBills = (outstandingModel.billdetails ?? []).where((bill) {
              return bill.dueType == "Overdue";
            }).toList();
            List<Billdetails> DueTodayBills = (outstandingModel.billdetails ?? []).where((bill) {
              return bill.dueType == "Due Today";
            }).toList();
            List<Billdetails> thisWeekDueBill = (outstandingModel.billdetails ?? []).where((bill) {
              return bill.dueType == "This Week Due";
            }).toList();
            List<Billdetails> UpcomingBills = (outstandingModel.billdetails ?? []).where((bill) {
              return bill.dueType == "Upcoming";
            }).toList();
            List<Billdetails> otherBills = (outstandingModel.billdetails ?? []).where((bill) {
              return bill.dueType == "Other";
            }).toList();
            return partyOutstandingCard(outstandingModel, OverdueBills, DueTodayBills, thisWeekDueBill, UpcomingBills, otherBills);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: FILTERED_OUTSTANDING.length),
    );
  }

  Card partyOutstandingCard(OutstandingModel outstandingModel, List<Billdetails> OverdueBills, List<Billdetails> DueTodayBills,
      List<Billdetails> thisWeekDueBill, List<Billdetails> UpcomingBills, List<Billdetails> otherBills) {
    return Card(
      color: Color(0xFFeff5f3),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "${outstandingModel.code.toString()}\n",
                          style: TextStyle(color: jsmColor),
                        ),
                        TextSpan(
                          text: "City: ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "${outstandingModel.masterModel!.city.toString()}\n",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextSpan(
                          text: "Broker: ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "${outstandingModel.masterModel!.broker.toString()}\n",
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextSpan(
                          text: "(Dhara-",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: "${outstandingModel.masterModel!.cRD} Days)",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: fireBCollection
                              .collection("supuser")
                              .doc(GLB_CURRENT_USER["CLIENTNO"])
                              .collection("EMP_MST")
                              .doc(outstandingModel.masterModel!.value!)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return SizedBox.shrink();
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox.shrink();
                            }
                            var data = snapshot.data;
                            if (data == null || !data.exists) {
                              return SizedBox.shrink();
                            }
                            dynamic snp = data.data();
                            var date = Myf.dateFormateYYYYMMDD(snp["lastPdfSent"], formate: "dd/MM/yyyy hh:mm a");
                            return Text("LastPdfSend\n$date");
                          }),
                      Wrap(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<bool>(
                              stream: changeStream.stream,
                              builder: (context, snapshot) {
                                return GFCheckbox(
                                    onChanged: (value) {
                                      if (value) {
                                        selectedOutstanding.add(outstandingModel);
                                      } else {
                                        selectedOutstanding.remove(outstandingModel);
                                      }
                                      changeStream.sink.add(true);
                                    },
                                    value: selectedOutstanding.contains(outstandingModel),
                                    type: GFCheckboxType.square,
                                    inactiveIcon: null);
                              }),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    CrmPdfOutstandingClass.createPdf([outstandingModel],
                                        share: "enotify", context: context, selectedCno: ctrlCopanyCno.text);
                                  },
                                  icon: Icon(Icons.send))),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    CrmPdfOutstandingClass.createPdf([outstandingModel],
                                        share: true, context: context, selectedCno: ctrlCopanyCno.text);
                                  },
                                  icon: Icon(Icons.share))),
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  onPressed: () {
                                    CrmPdfOutstandingClass.createPdf([outstandingModel],
                                        share: false, context: context, selectedCno: ctrlCopanyCno.text);
                                  },
                                  icon: Icon(Icons.view_comfortable))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (OverdueBills.length > 0)
              ExpansionTile(
                initiallyExpanded: initialExpand,
                title: Text(
                  "Overdue (${OverdueBills.length} Bills)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(1.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(.9),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.redAccent.shade100),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("PAMT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("DAYS", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...OverdueBills.map(
                        (e) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.bILL.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.dATE.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.pAMT.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.days.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (thisWeekDueBill.length > 0)
              ExpansionTile(
                initiallyExpanded: initialExpand,
                title: Text(
                  "This Week Due (${thisWeekDueBill.length} Bills)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(1.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(.9),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.blueAccent.shade100),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("PAMT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("DAYS", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...thisWeekDueBill.map(
                        (e) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.bILL.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.dATE.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.pAMT.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.days.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (DueTodayBills.length > 0)
              ExpansionTile(
                initiallyExpanded: initialExpand,
                title: Text(
                  "Today Due (${DueTodayBills.length} Bills)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orangeAccent,
                  ),
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(1.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(.9),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.orangeAccent.shade100),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("PAMT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("DAYS", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...DueTodayBills.map(
                        (e) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.bILL.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.dATE.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.pAMT.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.days.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (UpcomingBills.length > 0)
              ExpansionTile(
                initiallyExpanded: initialExpand,
                title: Text(
                  "Upcoming (${UpcomingBills.length} Bills)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(1.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(.9),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.green.shade100),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("PAMT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("DAYS", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...UpcomingBills.map(
                        (e) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.bILL.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Myf.dateFormateYYYYMMDD(e.dATE.toString(), formate: "dd-MM-yyyy")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.pAMT.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.days.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (otherBills.length > 0)
              ExpansionTile(
                initiallyExpanded: initialExpand,
                title: Text(
                  "Other (${otherBills.length}) Entry",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.7),
                      1: FlexColumnWidth(1.8),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(.9),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("PAMT", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("DAYS", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...otherBills.map(
                        (e) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.bILL.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.dATE.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.pAMT.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.days.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void selectAll(bool bool) {
    if (bool) {
      selectedOutstanding = List.from(FILTERED_OUTSTANDING);
    } else {
      selectedOutstanding.clear();
    }
    changeStream.sink.add(true);
  }
}

abstract class TodaysDueListState {}

class TodaysDueListInitial extends TodaysDueListState {}

class TodaysDueListLoadWidget extends TodaysDueListState {
  Widget widget;
  TodaysDueListLoadWidget(this.widget);
}
