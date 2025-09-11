import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmAddFollowUp/cubit/CrmAddNewFeedBack.dart';
import 'package:empire_ios/screen/CRM/CrmAddFollowUp/cubit/CrmSelectStatusBottomModel.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingCubit.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CrmAddFollowUp extends StatefulWidget {
  OutstandingModel outstandingModel;

  List<OutstandingModel>? BROKER_FILTERED_OUTSTANDING;
  CrmAddFollowUp({Key? key, required this.outstandingModel, this.BROKER_FILTERED_OUTSTANDING}) : super(key: key);

  @override
  State<CrmAddFollowUp> createState() => _CrmAddFollowUpState();
}

class _CrmAddFollowUpState extends State<CrmAddFollowUp> {
  CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel();
  var selectedFeedBack = "";
  var ctrlStatus = TextEditingController();
  var ctrlNextFollowupDate = TextEditingController();
  DateTime? nFollowDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    crmFollowUpModel.partyCode = widget.outstandingModel.code;
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("Add New FollowUp")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Container(
              width: kIsWeb ? screenWidthMobile * .5 : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(label: Text("Billing FollowUp")),
                        if (widget.BROKER_FILTERED_OUTSTANDING != null && widget.BROKER_FILTERED_OUTSTANDING!.length > 0)
                          CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    Myf.showBlurLoading(context);
                                    Myf.toast("Please wait", context: context);
                                    CrmPdfOutstandingClass.createPdf(widget.BROKER_FILTERED_OUTSTANDING!,
                                        share: 'enotify', context: context, selectedCno: ctrlCNO.text);
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.send))),
                        if (widget.BROKER_FILTERED_OUTSTANDING != null && widget.BROKER_FILTERED_OUTSTANDING!.length > 0)
                          CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    Myf.showBlurLoading(context);
                                    Myf.toast("Please wait", context: context);
                                    CrmPdfOutstandingClass.createPdf(widget.BROKER_FILTERED_OUTSTANDING!,
                                        share: true, context: context, selectedCno: ctrlCNO.text);
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.share)))
                      ],
                    ),
                    if (widget.BROKER_FILTERED_OUTSTANDING != null && widget.BROKER_FILTERED_OUTSTANDING!.length > 0)
                      ListTile(
                        tileColor: jsmColor,
                        title: Text("Broker FollowUp for : ${widget.outstandingModel.brokerModel!.partyname}"),
                        subtitle: Text("Total : ${widget.BROKER_FILTERED_OUTSTANDING!.length}"),
                      ),
                    ListTile(
                      title: Text("M/s : ${crmFollowUpModel.partyCode}"),
                    ),
                    TextFormField(
                      onTap: () async {
                        nFollowDate = await Myf.selectDate(context);
                        if (nFollowDate != null) {
                          ctrlNextFollowupDate.text = Myf.dateFormateInDDMMYYYY(nFollowDate.toString());
                          crmFollowUpModel.nextFollowupDate = Myf.dateFormateYYYYMMDD(nFollowDate.toString(), formate: 'yyyy-MM-dd');
                        }
                      },
                      controller: ctrlNextFollowupDate,
                      readOnly: true,
                      decoration: InputDecoration(label: Text("Next Followup Date"), hintText: "Select Date", suffixIcon: Icon(Icons.date_range)),
                    ),
                    TextFormField(
                      onTap: () async {
                        var v = await CrmSelectStatus.showfollowUpTypeForSelect(context);
                        if (v == null) return;
                        ctrlStatus.text = v;
                        crmFollowUpModel.followUpType = v;
                      },
                      controller: ctrlStatus,
                      readOnly: true,
                      decoration: InputDecoration(label: Text("Status"), hintText: "Select", suffixIcon: Icon(Icons.arrow_drop_down_circle)),
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue: Myf.getCurrentloginUser(),
                      decoration: InputDecoration(label: Text("Billing Member"), hintText: "LoginUser", suffixIcon: Icon(Icons.account_box_rounded)),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        crmFollowUpModel.rmk = (value ?? "").toUpperCase();
                      },
                      maxLines: 5,
                      decoration: InputDecoration(hintText: "Remark", suffixIcon: Icon(Icons.note_alt)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Select FeedBack"),
                        IconButton(onPressed: () => CrmAddNewFeedBack.showAddFeedBackOption(context), icon: Icon(Icons.add_box)),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: fireBCollection
                          .collection("supuser")
                          .doc(GLB_CURRENT_USER["CLIENTNO"])
                          .collection("CRM")
                          .doc("DATABASE")
                          .collection("feedBack")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var snp = snapshot.data!.docs;
                        if (snp.length > 0) {
                          return Wrap(children: [
                            ...snp
                                .map((e) => ChoiceChip(
                                      selectedColor: jsmColor,
                                      label: Text("${e.id}"),
                                      selected: selectedFeedBack.contains("${e.id}"),
                                      onSelected: (value) {
                                        selectedFeedBack = e.id;
                                        crmFollowUpModel.feedBack = selectedFeedBack;
                                        setState(() {});
                                      },
                                    ))
                                .toList()
                          ]);
                        }
                        return Text("Please add new feedback");
                      },
                    ),
                    SizedBox(height: 50),
                    FloatingActionButton.extended(
                      heroTag: "folllowUpsaveButton",
                      onPressed: () async {
                        Myf.showBlurLoading(context);

                        crmFollowUpModel.date = DateTime.now().toString();
                        crmFollowUpModel.type = "billing";
                        crmFollowUpModel.user = loginUserModel.loginUser;
                        crmFollowUpModel.mTime = DateTime.now().toString();
                        crmFollowUpModel.nextFollowupDate = Myf.dateFormateYYYYMMDD(crmFollowUpModel.nextFollowupDate, formate: 'yyyy-MM-dd');
                        CrmFollowRespModel crmFollowRespModel = CrmFollowRespModel();
                        crmFollowRespModel.user = loginUserModel.loginUser;
                        crmFollowRespModel.time = DateTime.now().toString();
                        crmFollowRespModel.resp = crmFollowUpModel.rmk;
                        crmFollowRespModel.type = "in";
                        crmFollowUpModel.CrmFollowRespList = [];
                        crmFollowUpModel.CrmFollowRespList!.add(crmFollowRespModel);
                        if (widget.BROKER_FILTERED_OUTSTANDING != null && widget.BROKER_FILTERED_OUTSTANDING!.length > 0) {
                          crmFollowUpModel.brokerFollowUpId = DateTime.now().toString();
                          await Future.wait(widget.BROKER_FILTERED_OUTSTANDING!.map((e) async {
                            var id = DateTime.now().toString();
                            crmFollowUpModel.iD = id;
                            crmFollowUpModel.partyCode = e.code;
                            await fireBCollection
                                .collection("supuser")
                                .doc(GLB_CURRENT_USER["CLIENTNO"])
                                .collection("CRM")
                                .doc("DATABASE")
                                .collection("followUpList")
                                .doc(crmFollowUpModel.iD)
                                .set(crmFollowUpModel.toJson())
                                .then((value) {
                              CRM_OUTSTANDING_LIST.map((e) {
                                if (e.code == crmFollowUpModel.partyCode) {
                                  e.crmFollowUpModel = crmFollowUpModel;
                                }
                              }).toList();
                            });
                          }).toList());
                        } else {
                          var id = DateTime.now().toString();
                          crmFollowUpModel.iD = id;
                          await fireBCollection
                              .collection("supuser")
                              .doc(GLB_CURRENT_USER["CLIENTNO"])
                              .collection("CRM")
                              .doc("DATABASE")
                              .collection("followUpList")
                              .doc(crmFollowUpModel.iD)
                              .set(crmFollowUpModel.toJson())
                              .then((value) {
                            CRM_OUTSTANDING_LIST.map((e) {
                              if (e.code == crmFollowUpModel.partyCode) {
                                e.crmFollowUpModel = crmFollowUpModel;
                              }
                            }).toList();
                          });
                        }

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      label: Text("Save"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
