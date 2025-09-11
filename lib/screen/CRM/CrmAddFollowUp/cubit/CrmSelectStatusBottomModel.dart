import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class CrmSelectStatus {
  static showfollowUpTypeForSelect(context) async {
    final Completer<String> _Completer = Completer<String>();

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Row(
                children: [
                  Text("Select Status", style: TextStyle(fontSize: 25, color: jsmColor)),
                  IconButton(onPressed: () => showAddfollowUpType(context), icon: Icon(Icons.add_box_sharp))
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
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
                    return Column(
                      children: [
                        ...snp
                            .map((e) => ListTile(
                                  onTap: () {
                                    _Completer.complete(e.id);
                                    Navigator.pop(context, e.id);
                                  },
                                  title: Text("${e.id}"),
                                ))
                            .toList()
                      ],
                    );
                  } else {
                    return Text("Please add New Status");
                  }
                },
              )
            ],
          ),
        );
      },
    );
    return _Completer.future;
  }

  static showAddfollowUpType(context) async {
    final Completer _Completer = Completer();
    var ctrlStatus = TextEditingController();

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Text("Add New Status", style: TextStyle(fontSize: 25, color: jsmColor)),
              Divider(),
              SizedBox(height: 10),
              TextFormField(
                controller: ctrlStatus,
                decoration: InputDecoration(label: Text("Enter Status")),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    var status = ctrlStatus.text.trim().toUpperCase();
                    fireBCollection
                        .collection("supuser")
                        .doc(GLB_CURRENT_USER["CLIENTNO"])
                        .collection("CRM")
                        .doc("DATABASE")
                        .collection("followUpType")
                        .doc(status)
                        .set({"ID": status, "status": status});
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.save),
                  label: Text("Save"))
            ],
          ),
        );
      },
    );
    return _Completer.future;
  }
}
