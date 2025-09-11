import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingState.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/CrmPartyOutstanding.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CrmOutstandingFollowupCubit extends Cubit<CrmOutstandingState> {
  String followUpType = "";
  var ctrlSearch = TextEditingController();
  var ctrlBrokerName = TextEditingController();
  var ctrlHaste = TextEditingController();
  DateTime? fromDate;
  var ctrlfromDate = TextEditingController();
  DateTime? toDate;
  var ctrltoDate = TextEditingController();
  BuildContext context;
  int filterDays = 0;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? snp;
  List<OutstandingModel> OUTSTANDING = [];

  var list;
  late LazyBox crm_outstanding_box;
  CrmOutstandingFollowupCubit(this.context) : super(CrmOutstandingStateIni()) {}
  void getData() async {
    emit(CrmOutstandingStateLoadWidget(Center(child: CircularProgressIndicator())));
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    crm_outstanding_box = await Hive.openLazyBox("${databasId}crm_outstanding_box");

    list = await getList();
    loadPartys();
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

  void loadPartys() async {
    snp = list.docs;
    Widget w = getPartyList();
    emit(CrmOutstandingStateLoadWidget(w));
  }

  Widget getPartyList() {
    Future.delayed(Duration(milliseconds: 500));
    emit(CrmOutstandingStateLoadLengthParty());
    if (snp!.length > 0) {
      return ListView.builder(
        itemCount: snp!.length,
        itemBuilder: (context, index) {
          dynamic d = snp![index].data();
          CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(d));
          if (ctrlSearch.text.isNotEmpty) {
            if (crmFollowUpModel.partyCode!.startsWith(ctrlSearch.text.toUpperCase().trim())) {
              return listCard(crmFollowUpModel);
            } else {
              return SizedBox.shrink();
            }
          } else {
            return listCard(crmFollowUpModel);
          }
        },
      );
    } else {
      return Text("No $followUpType found".toUpperCase());
    }
  }

  Widget listCard(CrmFollowUpModel crmFollowUpModel) {
    return FutureBuilder(
      future: getOutstandingDetails(crmFollowUpModel),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            // Myf.Navi(context, CrmPartyOutstanding(outstandingModel: outstandingModel));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${Myf.abbreviateName(crmFollowUpModel.partyCode!)}"), backgroundColor: jsmColor),
                  title: Text("${crmFollowUpModel.partyCode}", style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                          color: MaterialStateColor.resolveWith((states) => crmFollowUpColor(followUpType)),
                          label: Text("${crmFollowUpModel.followUpType}", style: TextStyle(color: Colors.white))),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.phone_android, size: 15),
                            Text("Mo:${crmFollowUpModel.masterModel!.mO}"),
                            IconButton(onPressed: () => null, icon: Icon(Icons.call), iconSize: 15),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.phone_android, size: 15),
                            Text("Ph1:${crmFollowUpModel.masterModel!.pH1}"),
                            IconButton(onPressed: () => null, icon: Icon(Icons.call), iconSize: 15),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.contact_emergency, size: 15),
                            Text("Broker:", style: TextStyle(color: Colors.blueGrey)),
                            Text("${crmFollowUpModel.masterModel!.broker}", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.phone_circle, size: 15),
                            Text("Contact:"),
                            IconButton(onPressed: () => null, icon: Icon(Icons.call), iconSize: 15),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        // height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.profile_circled, size: 15),
                            Flexible(child: Text("By:", style: TextStyle(color: Colors.blueGrey))),
                            Flexible(child: Text("${(crmFollowUpModel.user)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.calendar, size: 15),
                            Text("Last FollowUp:", style: TextStyle(color: Colors.blueGrey)),
                            Text("${Myf.dateFormate("")}", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.calendar, size: 15),
                            Text("Next FollowUp:", style: TextStyle(color: Colors.blueGrey)),
                            Text("${Myf.dateFormateYYYYMMDD(crmFollowUpModel.nextFollowupDate, formate: 'dd-MM-yyyy')}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getOutstandingDetails(CrmFollowUpModel crmFollowUpModel) async {
    dynamic d = await crm_outstanding_box.get(crmFollowUpModel.partyCode);
    MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(d));
    crmFollowUpModel.masterModel = masterModel;
    return crmFollowUpModel;
  }
}
