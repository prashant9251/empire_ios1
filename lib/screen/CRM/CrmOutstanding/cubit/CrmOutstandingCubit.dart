import 'dart:async';
import 'dart:ui';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/AgEmpOrderAcGroup/AgEmpOrderAcGroup.dart';
import 'package:empire_ios/screen/CRM/CrmAddFollowUp/CrmAddFollowUp.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingState.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/CrmPartyOutstanding.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/OutstandingTable.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/SalesTable.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

final StreamController<bool> crmOustandingChangeStream = StreamController<bool>.broadcast();
var ctrlCNO = TextEditingController();

class CrmOutstandingCubit extends Cubit<CrmOutstandingState> {
  var boolOverDueByMasteDays = false;
  var isdispose = false;
  var ctrlSearch = TextEditingController();
  var ctrlBrokerName = TextEditingController();
  var ctrlFirmName = TextEditingController();
  var ctrlHaste = TextEditingController();
  DateTime? fromDate;
  var ctrlfromDate = TextEditingController();
  DateTime? toDate;
  var ctrltoDate = TextEditingController();
  BuildContext context;
  int filterDays = 0;
  List<OutstandingModel> FILTERED_OUTSTANDING = [];
  var followUpType = "";
  var loadFirstTime = false;
  List<OutstandingModel> FILTERED_OUTSTANDING_MAIN = [];
  List<OutstandingModel> selectedForShareOutstanding = [];
  List<OutstandingModel> selectablebrokerPartyList = [];
  var notFollow;
  late Box CRM_BOX;
  var databasId = "";

  var boolselectAll = false;
  CrmOutstandingCubit(this.context, {followUpType, this.notFollow}) : super(CrmOutstandingStateIni()) {
    this.followUpType = followUpType ?? "";
  }

  getData() async {
    databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    ctrlFirmName.text = prefs!.getString("S_FIRM$databasId") ?? "";
    ctrlCNO.text = prefs!.getString("S_CNO$databasId") ?? "";

    CRM_BOX = await SyncLocalFunction.openBoxCheckByYearWise("CRM");
    if (!isdispose) emit(CrmOutstandingStateLoadWidget(Center(child: CircularProgressIndicator())));
    if (notFollow == true) {
      FILTERED_OUTSTANDING_MAIN = await CRM_OUTSTANDING_LIST.where((element) => element.crmFollowUpModel!.partyCode == null).toList();
    } else {
      FILTERED_OUTSTANDING_MAIN = CRM_OUTSTANDING_LIST.toList();
    }

    await crmFollowUpAttechWithOutstanding();
    loadBrokerList();
  }

  Future<void> crmFollowUpAttechWithOutstanding() async {
    if (followUpType.isNotEmpty) {
      List<OutstandingModel> FILTERED_OUTSTANDING_FOLLOW_UP = [];
      var list = await getList();
      var snp = list.docs;
      if (snp.length > 0) {
        await Future.wait(snp.map((e) async {
          dynamic crmFollowUp = e.data();
          CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(crmFollowUp));
          try {
            OutstandingModel outstandingModel = CRM_OUTSTANDING_LIST.firstWhere((element) => element.code == crmFollowUpModel.partyCode);
            outstandingModel.crmFollowUpModel = crmFollowUpModel;
            FILTERED_OUTSTANDING_FOLLOW_UP.add(outstandingModel);
          } catch (e) {
            OutstandingModel outstandingModel = OutstandingModel();
            outstandingModel.code = crmFollowUpModel.partyCode;
            outstandingModel = await getMasteDetails(outstandingModel);
            outstandingModel.crmFollowUpModel = crmFollowUpModel;
            FILTERED_OUTSTANDING_FOLLOW_UP.add(outstandingModel);
          }
          return true;
        }).toList());
        FILTERED_OUTSTANDING_MAIN = FILTERED_OUTSTANDING_FOLLOW_UP.toList();
        FILTERED_OUTSTANDING_FOLLOW_UP.clear();
      } else {
        FILTERED_OUTSTANDING_MAIN = [];
      }
    }
  }

  void loadBrokerList() async {
    Widget w = await getBrokerList();
    if (!isdispose) emit(CrmOutstandingStateLoadWidget(w));
    await Future.delayed(Duration(milliseconds: 200));
    if (!isdispose && !loadFirstTime) emit(CrmOutstandingStateLoadBrokerParty(brokerPartyListWidget(FILTERED_OUTSTANDING, MasterModel())));
    loadFirstTime = true;
  }

  Future<Widget> getBrokerList() async {
    if (!isdispose) emit(CrmOutstandingStateLoadLengthParty());
    FILTERED_OUTSTANDING = [];
    for (var e in FILTERED_OUTSTANDING_MAIN) {
      OutstandingModel newOtg = OutstandingModel.fromJson(Myf.convertMapKeysToString(e.toJson()));
      FILTERED_OUTSTANDING.add(newOtg);
    }
    // !(billDetails.TYPE.toUpperCase() == 'XX' && billDetails.VNO < 100000)
    FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
        .map((e) {
          e.allbilldetails = e.billdetails;
          e.billdetails = e.billdetails?.where((detail) => !(detail.tYPE!.toUpperCase() == 'XX' && int.tryParse(detail.vNO!)! < 100000)).toList();
          return e;
        })
        .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
        .toList();

    if (boolOverDueByMasteDays) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails
                ?.where(
                  (detail) =>
                      (detail.days! > Myf.toIntVal(e.masterModel!.cRD!)) ||
                      (detail.dT!.toUpperCase().contains("CN") ||
                          detail.tYPE!.toUpperCase().contains("B") ||
                          detail.tYPE!.toUpperCase().contains("C")),
                )
                .toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    } else if (filterDays > 0) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails
                ?.where(
                  (detail) =>
                      detail.days! > filterDays ||
                      (detail.dT!.toUpperCase().contains("CN") ||
                          detail.tYPE!.toUpperCase().contains("B") ||
                          detail.tYPE!.toUpperCase().contains("C")),
                )
                .toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }

    logger.d("------FILTERED_OUTSTANDING.length-1--${FILTERED_OUTSTANDING.length}");
    if (ctrlCNO.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails?.where((detail) => detail.cNO == ctrlCNO.text).toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }
    logger.d("------FILTERED_OUTSTANDING.length--${FILTERED_OUTSTANDING.length}");
    if (ctrlSearch.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING.where((element) {
        return element.code!.startsWith(ctrlSearch.text.toUpperCase().trim());
      }).toList();
    }
    if (ctrlBrokerName.text.isNotEmpty) {
      FILTERED_OUTSTANDING = FILTERED_OUTSTANDING
          .map((e) {
            e.allbilldetails = e.billdetails;
            e.billdetails = e.billdetails
                ?.where(
                  (detail) =>
                      detail.bCODE == ctrlBrokerName.text ||
                      (detail.dT!.toUpperCase().contains("CN") ||
                          detail.tYPE!.toUpperCase().contains("B") ||
                          detail.tYPE!.toUpperCase().contains("C")),
                )
                .toList();
            return e;
          })
          .where((e) => e.billdetails != null && e.billdetails!.isNotEmpty)
          .toList();
    }
    // FILTERED_OUTSTANDING.sort((a, b) => (a.brokerModel?.value ?? "").compareTo(b.brokerModel?.value ?? ""));
    Map<String, MasterModel> brokerList = {};
    for (var e in FILTERED_OUTSTANDING) {
      var billDetail = [...?e.billdetails];

      await Future.wait(
        billDetail.map((detail) async {
          dynamic broker = await getMasterModerByCode(detail.bCODE);
          MasterModel brokerModel = MasterModel.fromJson(Myf.convertMapKeysToString(broker));
          e.brokerModel = brokerModel;
          brokerList.putIfAbsent(detail.bCODE ?? "", () => brokerModel);
          return detail; // Ensure you return the detail if needed
        }).toList(),
      );
    }
    brokerList = Map.fromEntries(
      brokerList.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return ListView.builder(
        itemBuilder: (context, index) {
          var key = brokerList.keys.elementAt(index);
          MasterModel brokerModel = brokerList[key] ?? MasterModel();

          var brokerPartyList = <OutstandingModel>[];

          for (var e in FILTERED_OUTSTANDING) {
            var filteredDetails = (e.billdetails ?? []).where((detail) => detail.bCODE == key);

            if (filteredDetails.isNotEmpty) {
              // Create a deep copy of the current OutstandingModel
              var newOtg = OutstandingModel.fromJson(Myf.convertMapKeysToString(e.toJson()));
              // Assign the filtered bill details to the new object
              newOtg.billdetails = [...filteredDetails];

              // Add the new object to brokerPartyList without affecting FILTERED_OUTSTANDING
              brokerPartyList.add(newOtg);
            }
          }

          return Card(
            color: jsmColor,
            child: ExpansionTile(
              initiallyExpanded: ctrlSearch.text.isNotEmpty,
              onExpansionChanged: (value) {
                var deviceType = getDeviceType(MediaQuery.of(context).size);
                selectablebrokerPartyList = brokerPartyList;

                switch (deviceType) {
                  case DeviceScreenType.desktop:
                    if (!isdispose) emit(CrmOutstandingStateLoadBrokerParty(brokerPartyListWidget(brokerPartyList, brokerModel)));
                    break;
                  case DeviceScreenType.tablet:
                    if (!isdispose) emit(CrmOutstandingStateLoadBrokerParty(brokerPartyListWidget(brokerPartyList, brokerModel)));
                    break;
                  default:
                }
              },
              children: [
                ScreenTypeLayout.builder(
                  mobile: (BuildContext context) => Column(
                    children: [
                      if (brokerModel.value != null && brokerModel.value!.isNotEmpty) brokerDetailCard(brokerModel, context),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: brokerPartyList.length,
                        itemBuilder: (context, index) {
                          return listCard(brokerPartyList.elementAt(index));
                        },
                      )
                    ],
                  ),
                  desktop: (BuildContext context) => SizedBox.shrink(),
                  tablet: (BuildContext context) => SizedBox.shrink(),
                )
              ],
              title: Text(
                "${key}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    " ${brokerPartyList.length}",
                    style: TextStyle(color: Colors.white),
                  ),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.filter_alt, color: Colors.black),
                            title: Text("Filter"),
                            onTap: () {
                              ctrlBrokerName.text = key;
                              loadBrokerList();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.inventory_outlined, color: Colors.black),
                            title: Text("Broker Follow Up"),
                            onTap: () {
                              takeBrokerFollowUp(key, context);
                            },
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: brokerList.length);
    // var length = FILTERED_OUTSTANDING.length;
    // if (FILTERED_OUTSTANDING.length > 0) {
    //   return ListView.builder(
    //     itemCount: length > 500 ? 500 : length,
    //     itemBuilder: (context, index) {
    //       var outstandingModel = FILTERED_OUTSTANDING[index];
    //       return listCard(outstandingModel);
    //     },
    //   );
    // } else {
    //   return Text("No Data Found");
    // }
  }

  Container brokerDetailCard(MasterModel brokerModel, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: jsmColor,
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Broker:${brokerModel.value ?? ""}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          if (brokerModel.mO != null && brokerModel.mO!.isNotEmpty)
            GestureDetector(
              onTap: () => Myf.dialNo([brokerModel.mO], context),
              child: Text(
                "MO: ${brokerModel.mO}",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          if (brokerModel.pH1 != null && brokerModel.pH1!.isNotEmpty)
            GestureDetector(
              onTap: () => Myf.dialNo([brokerModel.pH1], context),
              child: Text(
                "PH1: ${brokerModel.pH1}",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          if (brokerModel.pH2 != null && brokerModel.pH2!.isNotEmpty)
            GestureDetector(
              onTap: () => Myf.dialNo([brokerModel.pH2], context),
              child: Text(
                "PH2: ${brokerModel.pH2}",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
        ],
      ),
    );
  }

  void takeBrokerFollowUp(String key, BuildContext context) {
    ctrlBrokerName.text = key;
    List<OutstandingModel>? BROKER_FILTERED_OUTSTANDING = [];
    if (ctrlBrokerName.text.isNotEmpty) {
      BROKER_FILTERED_OUTSTANDING = FILTERED_OUTSTANDING.where((element) => element.brokerModel!.value == ctrlBrokerName.text).toList();
    }
    if (BROKER_FILTERED_OUTSTANDING.length > 0) {
      Myf.Navi(
          context, CrmAddFollowUp(outstandingModel: BROKER_FILTERED_OUTSTANDING.first, BROKER_FILTERED_OUTSTANDING: BROKER_FILTERED_OUTSTANDING));
    }
  }

  Widget brokerPartyListWidget(List<OutstandingModel> brokerPartyList, MasterModel brokerModel) {
    return Card(
      child: Column(
        children: [
          if (brokerModel.value != null && brokerModel.value!.isNotEmpty)
            Stack(
              children: [
                if (brokerModel.value != null && brokerModel.value!.isNotEmpty) brokerDetailCard(brokerModel, context),
                Positioned(
                  right: 0,
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.alarm_add_rounded),
                    onPressed: () {
                      takeBrokerFollowUp(brokerModel.value ?? "", context);
                    },
                  ),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              itemCount: brokerPartyList.length,
              itemBuilder: (context, index) {
                return listCard(brokerPartyList.elementAt(index));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget listCard(OutstandingModel outstandingModel) {
    var followUpColor = crmFollowUpColor(outstandingModel.crmFollowUpModel!.followUpType);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: partyOutstandingListWidget(outstandingModel),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getList() async {
    if (followUpType.contains("TODAYS")) {
      var todayDate = Myf.dateFormateYYYYMMDD(DateTime.now().toString(), formate: 'yyyy-MM-dd');
      return await fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("CRM")
          .doc("DATABASE")
          .collection("followUpList")
          .where("nFDate", isEqualTo: todayDate)
          .where("tktClose", isNotEqualTo: true)
          .get();
    }
    return await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CRM")
        .doc("DATABASE")
        .collection("followUpList")
        .where("flwType", isEqualTo: followUpType)
        .where("tktClose", isNotEqualTo: true)
        .get();
  }

  Widget partyOutstandingListWidget(OutstandingModel outstandingModel) {
    // MasterModel masterModel = outstandingModel.masterModel!;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              // color: jsmColor,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white38,
              ),
              child: Container(
                child: ListTile(
                    title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Text(
                            "${outstandingModel.masterModel!.value ?? ""} ${outstandingModel.masterModel!.city ?? ""}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        if (outstandingModel.masterModel != null)
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                if (outstandingModel.masterModel != null) Myf.dialNo([outstandingModel.masterModel!.mO], context);
                              },
                              child: Text(
                                ",MO: ${outstandingModel.masterModel!.mO ?? ""}",
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        if (outstandingModel.masterModel != null)
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                if (outstandingModel.masterModel != null) Myf.dialNo([outstandingModel.masterModel!.pH1], context);
                              },
                              child: Text(
                                ",PH1: ${outstandingModel.masterModel!.pH1 ?? ""}",
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        if (outstandingModel.masterModel != null)
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                if (outstandingModel.masterModel != null) Myf.dialNo([outstandingModel.masterModel!.pH2], context);
                              },
                              child: Text(
                                ",PH2: ${outstandingModel.masterModel!.pH2 ?? ""}",
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<bool>(
                      stream: crmOustandingChangeStream.stream,
                      builder: (context, snapshot) {
                        return Checkbox(
                          value: outstandingModel.isSelected ?? false,
                          onChanged: (value) {
                            outstandingModel.isSelected = value;
                            selectIt(outstandingModel);
                            crmOustandingChangeStream.sink.add(true);
                          },
                        );
                      }),
                  IconButton(
                      onPressed: () async {
                        await Myf.Navi(context, CrmPartyOutstanding(outstandingModel: outstandingModel));
                        Myf.showBlurLoading(context);
                        await getData();
                        Myf.popScreen(context);
                      },
                      icon: Icon(Icons.open_in_new)),
                ],
              ),
            )
          ],
        ),
        Container(
          width: getValueForScreenType(context: context, mobile: null, tablet: null, desktop: screenWidthMobile * .8),
          child: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                var otg = OutstandingModel.fromJson(Myf.convertMapKeysToString(outstandingModel.toJson()));
                return SingleChildScrollView(child: OutstandingTable(outstandingModel: otg));
              }),
        )
      ],
    );
  }

  void selectIt(OutstandingModel outstandingModel) {
    if (outstandingModel.isSelected == true) {
      selectedForShareOutstanding.add(outstandingModel);
    } else {
      selectedForShareOutstanding.remove(outstandingModel);
    }
  }

  void selectAll() {
    if (boolselectAll) {
      selectedForShareOutstanding.clear();
      for (var e in selectablebrokerPartyList) {
        e.isSelected = true;
        selectedForShareOutstanding.add(e);
      }
    } else {
      for (var e in selectablebrokerPartyList) {
        e.isSelected = false;
        selectedForShareOutstanding.remove(e);
      }
    }
    crmOustandingChangeStream.sink.add(true);
  }
}
