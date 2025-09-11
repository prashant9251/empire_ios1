import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/addNewUniqueClientRequest/addNewUniqueClientRequest.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqueRequestList/UniqueRequestCard.dart';
import 'package:flutter/material.dart';

class UniqueRequestList extends StatefulWidget {
  var UserObj;

  UniqueRequestList({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<UniqueRequestList> createState() => _UniqueRequestListState();
}

class _UniqueRequestListState extends State<UniqueRequestList> {
  var reqTypeSelected = "";
  @override
  Widget build(BuildContext context) {
    var list = fireBCollection.collection("UserResponseReq").orderBy("m_time", descending: true);
    if (reqTypeSelected != "") {
      list = fireBCollection.collection("UserResponseReq").where("reqType", isEqualTo: reqTypeSelected).orderBy("m_time", descending: true);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("REQUEST LIST"),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton(
                value: reqTypeSelected,
                hint: Text("Select Req Type"),
                items: ["", "ISSUE", "NEW INSTALL", "NEW DEVLOPMENT", "PAYMENT CALL", "ONLY QUERY"]
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (var val) {
                  // setYear(val);
                  reqTypeSelected = val.toString();
                  setState(() {});
                }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: list.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error in Req search order"));
              } else if (!snapshot.hasData) {
                return Center(child: Text("No data"));
              } else {
                var snp = snapshot.data!.docs;

                if (snp.length > 0) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snp.length,
                      itemBuilder: (context, index) {
                        dynamic d = snp[index].data();
                        return UniqueRequestCard(d: d);
                      });
                } else {
                  return Center(child: Text("No data found"));
                }
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "addRequestListFromUniqueRequestList",
          onPressed: () {
            Myf.Navi(
                context,
                AddNewUniqueClientRequest(
                  userDataObj: {},
                  UserObj: widget.UserObj,
                ));
          },
          label: Text("Add New Request")),
    );
  }
}
