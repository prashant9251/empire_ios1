import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpen.dart';
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

class OfficeNotUpdatingPartyList extends StatelessWidget {
  var UserObj;

  var reqType;

  OfficeNotUpdatingPartyList({Key? key, required this.UserObj}) : super(key: key);

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
                  .collection("supuser")
                  .where("software_name", isGreaterThanOrEqualTo: "EMPIRE")
                  .where("software_name", isLessThanOrEqualTo: "EMPIRE" + '\uf8ff')
                  .where("CURRENT_YEAR_CREATETIME_MILLI", isLessThan: (DateTime.now().millisecondsSinceEpoch - 3 * 24 * 60 * 60 * 1000).toString())
                  .where("PAY", isNotEqualTo: "N")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return SelectableText("${snapshot.error}");
                if (snapshot.data == null) return SelectableText("somthing went wrong");
                var snp = snapshot.data!.docs;

                return Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child: Chip(label: Text("NOT UPDATING DATA PARTY LIST"))),
                        Flexible(
                          child: CircleAvatar(child: Text("${snp.length}")),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          dynamic d = snp[index].data();
                          d["clnt"] = d["CLNT"] ?? "";
                          int days = 0;
                          if (d["CURRENT_YEAR_CREATETIME_MILLI"] != null) {
                            days = Myf.daysCalculate(Myf.datetimeFormateFromMilli(d["CURRENT_YEAR_CREATETIME_MILLI"], format: "yyyy-MM-dd"));
                          }
                          var PAY = d["PAY"];
                          return Card(
                            color: PAY == "Y"
                                ? Colors.green
                                : PAY == "N"
                                    ? Colors.red
                                    : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () {
                                Myf.Navi(
                                    context,
                                    OfficeClientRequestOpen(
                                      obj: d,
                                      UserObj: GLB_CURRENT_USER,
                                    ));
                              },
                              title: Text(d["shopName"] ?? ""),
                              subtitle: Column(
                                children: [
                                  Text(d["ADMIN_MOBILE"] ?? ""),
                                  Text("${days}"),
                                ],
                              ),
                              trailing: Text("LS:${Myf.datetimeFormateFromMilli(d["CURRENT_YEAR_CREATETIME_MILLI"])}"),
                            ),
                          );
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
