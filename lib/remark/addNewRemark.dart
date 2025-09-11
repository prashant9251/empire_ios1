import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/widget/selectDatetime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../NotificationService/NotificationService.dart';

class addNewRemark extends StatefulWidget {
  var UserObj;

  var exitsingNotes;

  var preFilledPbj;

  addNewRemark({Key? key, required this.UserObj, this.exitsingNotes, this.preFilledPbj}) : super(key: key);

  @override
  State<addNewRemark> createState() => _addNewRemarkState();
}

class _addNewRemarkState extends State<addNewRemark> {
  var ctrlTitle = TextEditingController();
  var ctrlMsg = TextEditingController();
  var ctrlReminderDate = TextEditingController();

  String id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remind me on"),
                  Row(
                    children: [
                      Text("${Myf.dateFormate(ctrlReminderDate.text)}"),
                      IconButton(
                          onPressed: () async {
                            var time = await selectDatetime.selectDate(context);
                            if (time != null) {
                              ctrlReminderDate.text = "${time.toString()}";
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.alarm_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 24),
                controller: ctrlTitle,
                keyboardType: TextInputType.multiline, // Set the keyboard type to multiline
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 8),
                  hintText: "Title",
                  label: ctrlTitle.text.isNotEmpty ? Text("Title") : null,
                  border: InputBorder.none, // Remove the border
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLines: null, // Allow multiline input
                      keyboardType: TextInputType.multiline, // Set the keyboard type to multiline
                      style: TextStyle(fontSize: 20),
                      controller: ctrlMsg,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        hintText: "Notes",
                        border: InputBorder.none, // Remove the border
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton(heroTag: "addnewremarksavebtn", onPressed: () => validate(), child: Text("Save")),
            Divider()
          ],
        ),
      ),
    );
  }

  validate() async {
    if (ctrlTitle.text.isEmpty) {
      showSimpleNotification(Text("Enter Notes please"), background: Colors.red[300]);

      return;
    }
    save();
  }

  void save() async {
    id = id == "" ? DateTime.now().toString() : id;
    Map<String, dynamic> obj = {};
    obj["ID"] = id;
    obj["title"] = ctrlTitle.text.trim();
    obj["notes"] = ctrlMsg.text.trim();
    obj["m_time"] = DateTime.now().millisecondsSinceEpoch.toString();
    obj["date"] = DateTime.now().toString();
    obj["rmdate"] = ctrlReminderDate.text;
    obj["user"] = widget.UserObj["login_user"];
    obj["form"] = widget.preFilledPbj == null ? "" : widget.preFilledPbj["form"] ?? "";
    obj["url"] = widget.preFilledPbj == null ? "" : widget.preFilledPbj["url"] ?? "";

    // obj["rmdate"] != null && obj["rmdate"] != ""
    //     ? NotificationService().showNotificationOnTime(obj["ID"].hashCode, "${obj["title"]}", "${obj["notes"]}", time: DateTime.parse(obj["rmdate"]))
    //     : null;

    fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("RMK").doc(id).set(obj);
    Navigator.pop(context);
  }

  void getData() async {
    if (widget.exitsingNotes != null) {
      dynamic d = widget.exitsingNotes;
      ctrlTitle.text = d["title"];
      ctrlMsg.text = d["notes"];
      ctrlReminderDate.text = d["rmdate"] ?? "";
      id = d["ID"];
    } else if (widget.preFilledPbj != null) {
      ctrlTitle.text = widget.preFilledPbj["title"];
    }
  }
}
