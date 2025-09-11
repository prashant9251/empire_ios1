// ignore_for_file: must_be_immutable

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpen.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../screen/EMPIRE/Myf.dart';
import '../OfficeDeshboardClass.dart';

class OfficeRequestList extends StatefulWidget {
  var UserObj;

  var reqType;

  OfficeRequestList({Key? key, required this.UserObj, this.reqType}) : super(key: key);

  @override
  State<OfficeRequestList> createState() => _OfficeRequestListState();
}

class _OfficeRequestListState extends State<OfficeRequestList> {
  var list;
  var loading = true;
  var ctrlSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.reqType == "ALL"
            ? fireBCollection.collection("UserResponseReq").orderBy("m_time", descending: true).limit(100).snapshots()
            : fireBCollection
                .collection("UserResponseReq")
                .where("reqType", isEqualTo: widget.reqType)
                .orderBy("m_time", descending: true)
                .limit(200)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return SelectableText("${snapshot.error}");
          if (snapshot.data == null) return SelectableText("somthing went wrong");
          var snp = snapshot.data!.docs;
          if (snp.length == 0) {
            return Center(
              child: SelectableText("No ${widget.reqType} Request Found"),
            );
          }
          return Container(
            height: 400,
            width: kIsWeb ? MediaQuery.of(context).size.width / 4 : MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(child: Chip(label: Text("${widget.reqType}"))),
                      Flexible(
                        child: CircleAvatar(child: Text("${snp.length}")),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 300,
                  width: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    itemCount: snp.length,
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
                      return officeReqTab(d, context, color, rplys, widget.UserObj, officeRequestTabModel);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void getData() async {}
}

GestureDetector officeReqTab(d, BuildContext context, Color color, List<Rplys> rplys, UserObj, OfficeRequestTabModel officeRequestTabModel) {
  return GestureDetector(
    onTap: () {
      d["clnt"] = d["CLNT"];
      Myf.Navi(
          context,
          OfficeClientRequestOpen(
            obj: d,
            UserObj: UserObj,
          ));
    },
    child: Card(
      color: color,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text("${officeRequestTabModel.shopName}")),
                Flexible(child: Text("${officeRequestTabModel.mobileNo}", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text("CLNT: ${d["CLNT"]}")),
                Flexible(child: Text("${officeRequestTabModel.dATE}")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  "NEXT FOLLOW",
                  style: TextStyle(fontSize: 10),
                )),
                Flexible(
                    child: Text(
                  "${Myf.dateFormateInDDMMYYYY(officeRequestTabModel.flwDate ?? '')}",
                  style: TextStyle(color: Colors.red, fontSize: 10),
                )),
                Flexible(
                    child: Text(
                  "${officeRequestTabModel.refName}",
                  style: TextStyle(color: Colors.red, fontSize: 10),
                )),
              ],
            ),
            Container(
                width: 400,
                child: rplys.length > 0
                    ? Container(
                        width: 400,
                        // height: 300,
                        child: Bubble(
                          margin: BubbleEdges.only(top: 10),
                          alignment: Alignment.topRight,
                          nip: BubbleNip.rightBottom,
                          color: Color.fromRGBO(225, 255, 199, 1.0),
                          child: Container(
                            width: 400,
                            // height: 300,
                            child: Column(
                              children: [
                                SelectableText(
                                  '${rplys[0].ans}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${Myf.dateFormate(rplys[0].time)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  'By: ${rplys[0].user ?? ""}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Chip(
                        label: SelectableText(
                          "${officeRequestTabModel.response}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
          ],
        ),
      ),
    ),
  );
}
