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

class OfficeTodaysCall extends StatelessWidget {
  var UserObj;

  OfficeTodaysCall({Key? key, required this.UserObj}) : super(key: key);

  var todayDate = DateTime.now().toString();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
      height: 400,
      width: kIsWeb ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: fireBCollection
              .collection("UserResponseReq")
              .where("flwDate", isEqualTo: Myf.dateFormateYYYYMMDD(todayDate, formate: "yyyy-MM-dd"))
              .orderBy("m_time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            var snp = snapshot.data!.docs;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(child: Chip(label: Text("Today Calls"))),
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
                      var resolveDate = officeRequestTabModel.resolveDate;
                      color = OfficeDeshboardClass.colorOnReqType(officeRequestTabModel.reqType);

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
  }
}
