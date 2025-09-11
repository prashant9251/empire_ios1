// class to build the app
// ignore_for_file: must_be_immutable

import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeCall/OfficeCall.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeCall/OfficeRecentCalls.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeCall/OfficeTodaysCall.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeNextDueCalls/OfficeNextDueCalls.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeNotUpdatingPartyList/OfficeNotUpdatingPartyList.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/YearChangePendingList/YearChangePendingList.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/YearChangePendingList/YearChangePendingListNull.dart';
import 'package:empire_ios/DesktopVersion/OfficeOldYearPartyCalls/OfficeOldYearPartyCalls.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqinstallRequest/uniqinstallRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../OfficeRequestList.dart';

class OfficeRequestTabs extends ConsumerStatefulWidget {
  var UserObj;

  OfficeRequestTabs({Key? key, required this.UserObj}) : super(key: key);

  @override
  ConsumerState<OfficeRequestTabs> createState() => _OfficeRequestTabsState();
}

class _OfficeRequestTabsState extends ConsumerState<OfficeRequestTabs> {
  @override
  void initState() {
    super.initState();

    // getData(widget.UserObj);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // appBar: AppBar(
          //   actions: [IconButton(onPressed: () => sync(), icon: Icon(Icons.sync))],
          // ),
          body: ListView(
            children: [
              StreamBuilder(
                stream: somthingHaschange.stream,
                builder: (context, snapshot) {
                  return Wrap(
                    children: [
                      // OfficeOldYearPartyCalls(UserObj: widget.UserObj),
                      OfficeNextDueCalls(),
                      OfficeCall(UserObj: widget.UserObj, reqType: "DEMO REQUIRED"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "REQUEST ACCEPTED"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "PAYMENT CALL"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "COLLECT PAYMENT"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "ISSUE"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "NEW DEVLOPMENT"),
                      OfficeCall(UserObj: widget.UserObj, reqType: "MEETING"),
                      OfficeRequestList(UserObj: widget.UserObj, reqType: "DEMO REJECTED"),
                      OfficeRecentCalls(UserObj: widget.UserObj),
                      OfficeRequestList(UserObj: widget.UserObj, reqType: "ALL"),
                      OfficeTodaysCall(UserObj: widget.UserObj),
                      OfficeNotUpdatingPartyList(UserObj: widget.UserObj),
                      UniqinstallRequest(UserObj: widget.UserObj),
                      YearChangePendingList(UserObj: widget.UserObj),
                      YearChangePendingListDone(UserObj: widget.UserObj),
                    ],
                  );
                },
              )
              // StreamBuilder<bool>(
              //     stream: somthingHaschange.stream,
              //     builder: (context, snapshot) {
              //       return Wrap(
              //         children: [
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "PAYMENT CALL", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "ISSUE", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "DEMO REQUIRED", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "NEW DEVLOPMENT", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "ALL", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "REQUEST ACCEPTED", reqList: reqList),
              //           OfficeRequestList(UserObj: widget.UserObj, reqType: "DEMO REJECTED", reqList: reqList),
              //         ],
              //       );
              //     }),
            ],
          ), // DefaultTabController
        ); // MaterialApp
      },
    );
  }

  sync() async {
    fireBCollection.collection("UserResponseReq").get(fireGetOption).then((value) {
      var snp = value.docs;
      snp.map((e) {
        dynamic d = e.data();
        OfficeRequestTabModel officeRequestTabModel = OfficeRequestTabModel.fromJson(Myf.convertMapKeysToString(d));
        if (officeRequestTabModel.resolveDate == null || officeRequestTabModel.resolveDate == "") {
          officeRequestTabModel.tktStatus = "open";
        } else {
          officeRequestTabModel.tktStatus = "close";
        }
        fireBCollection.collection("UserResponseReq").doc(e.id).update(officeRequestTabModel.toJson());
      }).toList();
    });
  }
}
