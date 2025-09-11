import 'dart:async';

import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class CrmAddNewFeedBack {
  static showAddFeedBackOption(context) async {
    final Completer _Completer = Completer();
    var ctrlFeedBack = TextEditingController();

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
              Text(
                "Add New FeedBack",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              Divider(),
              SizedBox(height: 10),
              TextFormField(
                controller: ctrlFeedBack,
                decoration: InputDecoration(label: Text("FeedBack"), hintText: "FeedBack", suffixIcon: Icon(Icons.feedback)),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                  onPressed: () {
                    var feedBack = ctrlFeedBack.text.trim().toUpperCase();
                    // /supuser/58385/CRM/DATABASE/DAYS
                    fireBCollection
                        .collection("supuser")
                        .doc(GLB_CURRENT_USER["CLIENTNO"])
                        .collection("CRM")
                        .doc("DATABASE")
                        .collection("feedBack")
                        .doc(feedBack)
                        .set({"ID": feedBack, "feedBack": feedBack});
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
