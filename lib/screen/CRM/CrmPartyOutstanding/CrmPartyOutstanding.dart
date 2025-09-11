import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmAddFollowUp/CrmAddFollowUp.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/OutstandingTable.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/SalesTable.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ShowHideUnhideSettings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class CrmPartyOutstanding extends StatefulWidget {
  OutstandingModel outstandingModel;
  CrmPartyOutstanding({Key? key, required this.outstandingModel}) : super(key: key);

  @override
  State<CrmPartyOutstanding> createState() => _CrmPartyOutstandingState();
}

class _CrmPartyOutstandingState extends State<CrmPartyOutstanding> {
  final StreamController<bool> followUpListFetch = StreamController<bool>.broadcast();
  var totalOpenTicket = 0;
  late OutstandingModel outstandingModel;
  var loading = true;
  @override
  void initState() {
    super.initState();
    outstandingModel = widget.outstandingModel;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final isDesktop = width > 1200;
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: jsmColor,
            title: Text("${outstandingModel.code}"),
            actions: [],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Container(
                        width: isDesktop ? screenWidthMobile * .5 : null,
                        child: Column(
                          children: [
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              child: Container(
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
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: jsmColor,
                                            child: Icon(Icons.account_circle, color: Colors.white, size: 30),
                                            radius: 25,
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Text(
                                              "${outstandingModel.code}",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: jsmColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 18),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              "${outstandingModel.masterModel!.aD1}, ${outstandingModel.masterModel!.aD2}, ${outstandingModel.masterModel!.city}, ${outstandingModel.masterModel!.pNO}",
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(height: 28, thickness: 1.2),
                                      // Contact Row with icons and better spacing
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.phone_android, color: Colors.green, size: 20),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.masterModel!.mO], context);
                                              },
                                              child: Text(
                                                "Mo: ${outstandingModel.masterModel!.mO}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 20),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.phone, color: Colors.orange, size: 20),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.masterModel!.pH1], context);
                                              },
                                              child: Text(
                                                "Ph1: ${outstandingModel.masterModel!.pH1}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.orange[800],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 20),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.phone, color: Colors.orange, size: 20),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.masterModel!.pH2], context);
                                              },
                                              child: Text(
                                                "Ph2: ${outstandingModel.masterModel!.pH2}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.orange[800],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 18),
                                      // Broker Row with avatar and pill
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey.withOpacity(0.15),
                                            child: Icon(Icons.contact_mail, color: Colors.grey, size: 20),
                                            radius: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Broker:",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.grey.withOpacity(0.15),
                                              Colors.grey.withOpacity(0.05),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.person, color: Colors.grey, size: 18),
                                            SizedBox(width: 6),
                                            Text(
                                              "${outstandingModel.masterModel!.broker}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 14),
                                      if (outstandingModel.brokerModel != null) ...[
                                        Wrap(
                                          children: [
                                            Icon(CupertinoIcons.phone_circle, color: Colors.teal, size: 20),
                                            SizedBox(width: 6),
                                            GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.brokerModel!.mO], context);
                                              },
                                              child: Text(
                                                "B.Mo: ${outstandingModel.brokerModel!.mO ?? ""}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Icon(CupertinoIcons.phone_circle, color: Colors.teal, size: 20),
                                            SizedBox(width: 6),
                                            GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.brokerModel!.pH1], context);
                                              },
                                              child: Text(
                                                "B.PH1: ${outstandingModel.brokerModel!.pH1 ?? ""}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Icon(CupertinoIcons.phone_circle, color: Colors.teal, size: 20),
                                            SizedBox(width: 6),
                                            GestureDetector(
                                              onTap: () {
                                                Myf.dialNo([outstandingModel.brokerModel!.pH2], context);
                                              },
                                              child: Text(
                                                "B.PH2: ${outstandingModel.brokerModel!.pH2 ?? ""}",
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: isDesktop ? screenWidthMobile * .5 : null,
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: <Widget>[
                                    ButtonsTabBar(
                                      // width: layoutInfoModel.width! * .5,
                                      backgroundColor: jsmColor,
                                      unselectedBackgroundColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      unselectedLabelStyle: TextStyle(
                                        color: jsmColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      unselectedBorderColor: Colors.blue,
                                      // contentCenter: true,
                                      tabs: [
                                        Tab(text: 'OUTSTANDING'),
                                        Tab(text: 'SALES'),
                                      ],
                                    ),
                                    Divider(),
                                    Container(
                                      height: 450,
                                      child: TabBarView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          StreamBuilder<Object>(
                                              stream: null,
                                              builder: (context, snapshot) {
                                                var otg = OutstandingModel.fromJson(Myf.convertMapKeysToString(outstandingModel.toJson()));
                                                return SingleChildScrollView(child: OutstandingTable(outstandingModel: otg));
                                              }),
                                          StreamBuilder<Object>(
                                              stream: null,
                                              builder: (context, snapshot) {
                                                var otg = OutstandingModel.fromJson(Myf.convertMapKeysToString(outstandingModel.toJson()));
                                                return SingleChildScrollView(child: SalesTable(outstandingModel: otg));
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: isDesktop ? screenWidthMobile * .5 : null,
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: followUpListFetch.stream,
                                builder: (context, snapshot) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        badges.Badge(
                                          badgeContent: Text('$totalOpenTicket'),
                                          child: Text("My Follow Up", style: TextStyle(fontSize: 30)),
                                        ),
                                        IconButton(
                                            onPressed: () => Myf.Navi(context, CrmAddFollowUp(outstandingModel: outstandingModel)),
                                            icon: Icon(Icons.add_alarm_outlined))
                                      ],
                                    ),
                                  );
                                }),
                            StreamBuilder<QuerySnapshot>(
                                stream: fireBCollection
                                    .collection("supuser")
                                    .doc(GLB_CURRENT_USER["CLIENTNO"])
                                    .collection("CRM")
                                    .doc("DATABASE")
                                    .collection("followUpList")
                                    .where("pcode", isEqualTo: outstandingModel.code)
                                    .orderBy("date", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  var snp = snapshot.data!.docs;
                                  if (snp.length > 0) {
                                    totalOpenTicket = 0;
                                    snp.map((e) {
                                      dynamic d = e.data();
                                      if (d["tktClose"] == false) {
                                        totalOpenTicket += 1;
                                        followUpListFetch.sink.add(true);
                                      }
                                    }).toList();
                                    return Container(
                                        height: 1000,
                                        child: ListView.builder(
                                          physics: isDesktop ? null : NeverScrollableScrollPhysics(),
                                          itemCount: snp.length,
                                          itemBuilder: (context, index) {
                                            dynamic d = snp[index].data();
                                            CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(d));
                                            CrmFollowRespModel crmFollowRespModel = CrmFollowRespModel();

                                            var ctrlNextFollowupDate = TextEditingController();
                                            ctrlNextFollowupDate.text = Myf.dateFormateInDDMMYYYY(crmFollowUpModel.nextFollowupDate);

                                            DateTime? nFollowDate = DateTime.now();
                                            return Card(
                                              child: Container(
                                                child: ExpansionTile(
                                                  initiallyExpanded: (crmFollowUpModel.tktClose ?? false == true) ? false : true,
                                                  title: Text("${Myf.dateFormate(crmFollowUpModel.date)}"),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Chip(
                                                          color: WidgetStateColor.resolveWith(
                                                              (states) => crmFollowUpColor(crmFollowUpModel.followUpType)),
                                                          label: Text(
                                                            "${crmFollowUpModel.followUpType}",
                                                            style: TextStyle(color: Colors.white),
                                                          )),
                                                      Icon(Icons.arrow_drop_down_circle),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${crmFollowUpModel.rmk}"),
                                                      if (crmFollowUpModel.brokerFollowUpId != null && crmFollowUpModel.brokerFollowUpId != "")
                                                        Text("Broker FollowUp"),
                                                      RichText(
                                                          text: TextSpan(children: [
                                                        if (crmFollowUpModel.tktClose ?? false == true)
                                                          TextSpan(
                                                              text: "Ticket Closed on:${Myf.dateFormate(crmFollowUpModel.tktclosedDate)} :",
                                                              style: TextStyle(
                                                                  color: Colors.black, fontSize: 10, decoration: TextDecoration.lineThrough))
                                                        else ...[
                                                          TextSpan(text: "Next follow up :", style: TextStyle(color: Colors.black)),
                                                          TextSpan(
                                                              text:
                                                                  "${Myf.dateFormateYYYYMMDD(crmFollowUpModel.nextFollowupDate, formate: 'dd-MM-yyyy')}",
                                                              style: TextStyle(color: jsmColor)),
                                                        ]
                                                      ]))
                                                    ],
                                                  ),
                                                  children: [
                                                    ...crmFollowUpModel.CrmFollowRespList!.map((e) {
                                                      if (e.type == "in") {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Flexible(
                                                              child: Bubble(
                                                                color: jsmColor,
                                                                margin: BubbleEdges.only(top: 10),
                                                                nip: BubbleNip.leftTop,
                                                                child: Column(
                                                                  children: [
                                                                    Text('${e.resp}'),
                                                                    Text('${Myf.dateFormate(e.time)}',
                                                                        style: TextStyle(fontSize: 8, color: Colors.white)),
                                                                    Text('By:${(Myf.getUserNameString(e.user.toString()))}',
                                                                        style: TextStyle(
                                                                            fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else if (e.type == "out") {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Flexible(
                                                              child: Bubble(
                                                                margin: BubbleEdges.only(top: 10),
                                                                nip: BubbleNip.rightCenter,
                                                                color: Color.fromRGBO(225, 255, 199, 1.0),
                                                                child: Column(
                                                                  children: [
                                                                    Text('${e.resp}', textAlign: TextAlign.right),
                                                                    Text(
                                                                      '${Myf.dateFormate(e.time)}',
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(fontSize: 8),
                                                                    ),
                                                                    Text(
                                                                      'By:${(Myf.getUserNameString(e.user.toString()))}',
                                                                      textAlign: TextAlign.right,
                                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else if (e.type == "change") {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Flexible(
                                                              child: Bubble(
                                                                margin: BubbleEdges.only(top: 10),
                                                                nip: BubbleNip.rightCenter,
                                                                color: Color.fromRGBO(225, 255, 199, 1.0),
                                                                child: Text(
                                                                  '${e.resp}',
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(fontSize: 9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else if (e.type == "tktClose") {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Flexible(
                                                              child: Bubble(
                                                                margin: BubbleEdges.only(top: 10),
                                                                nip: BubbleNip.no,
                                                                color: Color.fromRGBO(212, 234, 244, 1.0),
                                                                child: Text(
                                                                  '${e.resp}',
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(fontSize: 9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else if (e.type == "followUpchange") {
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Flexible(
                                                              child: Bubble(
                                                                margin: BubbleEdges.only(top: 10),
                                                                nip: BubbleNip.no,
                                                                color: Color.fromRGBO(76, 174, 220, 1),
                                                                child: Text(
                                                                  '${e.resp}',
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(fontSize: 9),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return SizedBox.shrink();
                                                      }
                                                    }).toList(),
                                                    if (crmFollowUpModel.tktClose != true)
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                              height: 40,
                                                              child: TextFormField(
                                                                onChanged: (value) {
                                                                  crmFollowRespModel.followUpType = crmFollowUpModel.followUpType;
                                                                  crmFollowRespModel.user = loginUserModel.loginUser;
                                                                  crmFollowRespModel.resp = value.toUpperCase();
                                                                  crmFollowRespModel.time = DateTime.now().toString();
                                                                  crmFollowRespModel.type = "out";
                                                                },
                                                                decoration: InputDecoration(
                                                                    label: Text("Comment"),
                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton.icon(
                                                              onPressed: () {
                                                                if (crmFollowRespModel.resp == null || crmFollowRespModel.resp == "") return;
                                                                crmFollowUpModel.CrmFollowRespList!.add(crmFollowRespModel);
                                                                crmFollowUpModel.mTime = DateTime.now().toString();
                                                                saveFollowUp(crmFollowUpModel);
                                                              },
                                                              icon: Icon(Icons.save),
                                                              label: Text("Save"))
                                                        ],
                                                      ),
                                                    if (crmFollowUpModel.tktClose != true)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Flexible(
                                                              child: Container(
                                                            margin: EdgeInsets.only(left: 10),
                                                            height: 40,
                                                            child: TextFormField(
                                                              onTap: () async {
                                                                nFollowDate = await Myf.selectDate(context);
                                                                if (nFollowDate != null) {
                                                                  bool yesNo = await Myf.yesNoShowDialod(context,
                                                                      msg: "Do you want to change followUp Date??", title: "Alert");
                                                                  if (!yesNo) return;
                                                                  CrmFollowRespModel followUpDateChangeModel = CrmFollowRespModel();
                                                                  followUpDateChangeModel.followUpType = "${crmFollowUpModel.followUpType}";
                                                                  followUpDateChangeModel.user = "${loginUserModel.loginUser}";
                                                                  followUpDateChangeModel.time = DateTime.now().toString();
                                                                  followUpDateChangeModel.resp =
                                                                      "FollowUp Date Change From ${Myf.dateFormate(crmFollowUpModel.nextFollowupDate)} to ${Myf.dateFormate(nFollowDate)} on  ${Myf.dateFormate(followUpDateChangeModel.time)} by ${Myf.getCurrentloginUser()}";
                                                                  followUpDateChangeModel.type = "followUpchange";
                                                                  crmFollowUpModel.CrmFollowRespList!.add(followUpDateChangeModel);
                                                                  crmFollowUpModel.nextFollowupDate =
                                                                      Myf.dateFormateYYYYMMDD(nFollowDate.toString(), formate: 'yyyy-MM-dd');
                                                                  crmFollowUpModel.mTime = DateTime.now().toString();
                                                                  // if(crmFollowUpModel.brokerFollowUpId!=null && crmFollowUpModel.brokerFollowUpId!=""){}
                                                                  saveFollowUp(crmFollowUpModel);
                                                                }
                                                              },
                                                              controller: ctrlNextFollowupDate,
                                                              readOnly: true,
                                                              decoration:
                                                                  InputDecoration(hintText: ("Follow Date"), prefixIcon: Icon(Icons.date_range)),
                                                            ),
                                                          )),
                                                          Flexible(
                                                              child: StreamBuilder<QuerySnapshot>(
                                                                  stream: fireBCollection
                                                                      .collection("supuser")
                                                                      .doc(GLB_CURRENT_USER["CLIENTNO"])
                                                                      .collection("CRM")
                                                                      .doc("DATABASE")
                                                                      .collection("followUpType")
                                                                      .snapshots(),
                                                                  builder: (context, snapshot) {
                                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                                      return Center(child: CircularProgressIndicator());
                                                                    }
                                                                    var snp = snapshot.data!.docs;
                                                                    if (snp.length > 0) {
                                                                      return DropdownButton(
                                                                          value: crmFollowUpModel.followUpType,
                                                                          hint: Text("Select Req Type"),
                                                                          items: snp.map((e) {
                                                                            return DropdownMenuItem(
                                                                              child: Text(e.id),
                                                                              value: e.id,
                                                                            );
                                                                          }).toList(),
                                                                          onChanged: (var val) async {
                                                                            bool yesNo = await Myf.yesNoShowDialod(context,
                                                                                msg: "Do you want to change followUp type??", title: "Alert");
                                                                            if (!yesNo) return;
                                                                            CrmFollowRespModel crmFollowRespModelTktClose = CrmFollowRespModel();
                                                                            crmFollowRespModelTktClose.followUpType =
                                                                                "${crmFollowUpModel.followUpType}";
                                                                            crmFollowRespModelTktClose.user = "${loginUserModel.loginUser}";
                                                                            crmFollowRespModelTktClose.time = DateTime.now().toString();
                                                                            crmFollowRespModelTktClose.resp =
                                                                                "FollowUpType Change From ${crmFollowUpModel.followUpType} to $val on  ${Myf.dateFormate(crmFollowRespModelTktClose.time)} by ${Myf.getCurrentloginUser()}";
                                                                            crmFollowRespModelTktClose.type = "change";
                                                                            crmFollowUpModel.followUpType = val.toString();
                                                                            crmFollowUpModel.CrmFollowRespList!.add(crmFollowRespModelTktClose);

                                                                            crmFollowUpModel.mTime = DateTime.now().toString();
                                                                            saveFollowUp(crmFollowUpModel);
                                                                          });
                                                                    }
                                                                    return SizedBox.shrink();
                                                                  }))
                                                        ],
                                                      ),
                                                    if (crmFollowUpModel.tktClose != true)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          ElevatedButton(
                                                              onPressed: () async {
                                                                bool yesNo = await Myf.yesNoShowDialod(context,
                                                                    msg: "Are you sure you want to close this ticket??", title: "Alert");
                                                                if (!yesNo) return;
                                                                crmFollowUpModel.tktclosedDate = DateTime.now().toString();
                                                                crmFollowUpModel.tktClose = true;
                                                                crmFollowUpModel.CrmFollowRespList!.add(crmFollowRespModel);
                                                                CrmFollowRespModel crmFollowRespModelTktClose = CrmFollowRespModel();
                                                                crmFollowRespModelTktClose.followUpType = "${crmFollowUpModel.followUpType}";
                                                                crmFollowRespModelTktClose.user = "${loginUserModel.loginUser}";
                                                                crmFollowRespModelTktClose.resp =
                                                                    "Ticket close on ${Myf.dateFormate(crmFollowUpModel.tktclosedDate)} by ${Myf.getCurrentloginUser()}";
                                                                crmFollowRespModelTktClose.time = crmFollowUpModel.tktclosedDate;
                                                                crmFollowRespModelTktClose.type = "tktClose";
                                                                crmFollowUpModel.CrmFollowRespList!.add(crmFollowRespModelTktClose);

                                                                crmFollowUpModel.mTime = DateTime.now().toString();
                                                                saveFollowUp(crmFollowUpModel);
                                                              },
                                                              child: Text("Ticket Close")),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ));
                                  } else {
                                    return Center(child: Text("No data Found"));
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void saveFollowUp(CrmFollowUpModel crmFollowUpModel) async {
    if (crmFollowUpModel.brokerFollowUpId != null && crmFollowUpModel.brokerFollowUpId != "") {
      await fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("CRM")
          .doc("DATABASE")
          .collection("followUpList")
          .where("bFlwUpId", isEqualTo: crmFollowUpModel.brokerFollowUpId)
          .get()
          .then((value) async {
        var snp = value.docs;
        await Future.wait(snp.map((e) async {
          dynamic d = e.data();
          crmFollowUpModel.iD = e.id;
          crmFollowUpModel.partyCode = d["pcode"];
          await fireBCollection
              .collection("supuser")
              .doc(GLB_CURRENT_USER["CLIENTNO"])
              .collection("CRM")
              .doc("DATABASE")
              .collection("followUpList")
              .doc(crmFollowUpModel.iD)
              .update(crmFollowUpModel.toJson());
        }).toList());
      });
    } else {
      fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("CRM")
          .doc("DATABASE")
          .collection("followUpList")
          .doc(crmFollowUpModel.iD)
          .update(crmFollowUpModel.toJson());
    }
  }
}

Color crmFollowUpColor(String? followUpType) {
  var c = Colors.amber;
  switch (followUpType) {
    case "FOLLOW-UP":
      c = Colors.green;
      break;
    case "DISCUSSION":
      c = Colors.blue;
      break;
    case "DONT-FOLLOW-UP":
      c = Colors.cyan;
      break;
    case "UNFOLLOW-UP":
      c = Colors.deepPurple;
      break;
    default:
  }
  return c;
}
