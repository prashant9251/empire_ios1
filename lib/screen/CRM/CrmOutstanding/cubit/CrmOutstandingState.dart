import 'dart:async';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

abstract class CrmOutstandingState {}

class CrmOutstandingStateIni extends CrmOutstandingState {}

class CrmOutstandingStateLoadWidget extends CrmOutstandingState {
  Widget widget;
  CrmOutstandingStateLoadWidget(this.widget);
}

class CrmOutstandingStateLoadBrokerParty extends CrmOutstandingState {
  Widget widget;
  CrmOutstandingStateLoadBrokerParty(this.widget);
}

class CrmOutstandingStateLoadBrokerPartyOutstanding extends CrmOutstandingState {
  Widget widget;
  CrmOutstandingStateLoadBrokerPartyOutstanding(this.widget);
}

class CrmOutstandingStateLoadLengthParty extends CrmOutstandingState {}

class CrmOutstandingStateSelectDays extends CrmOutstandingState {
  static selectDays(context) async {
    final Completer<int> _Completer = Completer<int>();
    var daysList = [0, 30, 60, 90, 120, 150, 180];

    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CRM")
        .doc("DATABASE")
        .collection("DAYS")
        .get()
        .then((value) {
      var snp = value.docs;
      if (snp.length > 0) {
        daysList = [];
        snp.map((e) {
          dynamic d = e.data();
          var day = Myf.convertToDouble(d["days"]);
          daysList.add(day.toInt());
        }).toList();
      } else {
        daysList.map((e) => addnewDays(days: "$e")).toList();
      }
    });
    daysList.sort((a, b) {
      return a.compareTo(b);
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("SELECT > DAYS", style: TextStyle(fontSize: 25, color: jsmColor)),
                  CircleAvatar(child: IconButton(onPressed: () => addNewDays(context), icon: Icon(Icons.add)))
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              ...daysList
                  .map((days) => ListTile(
                        onTap: () async {
                          _Completer.complete(days);
                          daysList = [];
                          Navigator.pop(context, days);
                        },
                        leading: Chip(label: Text("${days}")),
                        subtitle: Divider(),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
    return _Completer.future;
  }

  static void addnewDays({required String days}) {
    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("CRM")
        .doc("DATABASE")
        .collection("DAYS")
        .doc("$days")
        .set({"ID": "$days", "days": "$days"});
  }

  static addNewDays(context) async {
    var ctrlDays = TextEditingController();
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text("Add New Days", style: TextStyle(color: Colors.redAccent)),
      content: TextFormField(controller: ctrlDays, decoration: InputDecoration(label: Text("Days"))),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              var days = ctrlDays.text.trim().toUpperCase();
              addnewDays(days: days);
              Navigator.pop(context);
            },
            child: const Text('Save')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'))
      ],
    ).show(context);
  }
}
