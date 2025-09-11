import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpenCard.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboardClass.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestList.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OfficeCall extends StatelessWidget {
  var UserObj;

  var reqType;

  OfficeCall({Key? key, required this.UserObj, required this.reqType}) : super(key: key);

  var todayDate = DateTime.now().toString();
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
          child: StreamBuilder<QuerySnapshot>(
              stream: fireBCollection
                  .collection("UserResponseReq")
                  .where("reqType", isEqualTo: reqType)
                  .where("tktStatus", isEqualTo: "open")
                  .orderBy("m_time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Text("${snapshot.error}");
                if (snapshot.data == null) return Text("somthing went wrong");
                var snp = snapshot.data!.docs;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(child: Chip(label: Text("$reqType"))),
                          Flexible(
                            child: CircleAvatar(child: Text("${snp.length}")),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          dynamic d = snp[index].data();
                          OfficeRequestTabModel officeRequestTabModel = OfficeRequestTabModel.fromJson(Myf.convertMapKeysToString(d));
                          var color = Colors.white;
                          var reqType = d["reqType"].toString();
                          var resolveDate = d["resolveDate"];
                          color = OfficeDeshboardClass.colorOnReqType(d["reqType"]);

                          if (resolveDate != null) {
                            color = Colors.white;
                          } else {
                            // pendingRequestCount++;
                          }
                          List<Rplys> rplys = officeRequestTabModel.rplys ?? [];
                          rplys = rplys.where((element) {
                            return element.type == "cmt";
                          }).toList();

                          rplys.sort((a, b) {
                            DateTime dateTime1 = DateTime.parse(a.time!);
                            DateTime dateTime2 = DateTime.parse(b.time!);
                            return dateTime2.compareTo(dateTime1);
                          });

                          return officeReqTab(d, context, color, rplys, UserObj, officeRequestTabModel);
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
}
