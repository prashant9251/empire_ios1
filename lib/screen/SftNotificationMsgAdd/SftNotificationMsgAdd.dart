import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/instruction/InstructionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SftNotificationMsgAdd extends StatefulWidget {
  const SftNotificationMsgAdd({Key? key}) : super(key: key);

  @override
  State<SftNotificationMsgAdd> createState() => _SftNotificationMsgAddState();
}

class _SftNotificationMsgAddState extends State<SftNotificationMsgAdd> {
  InstructionModel instructionModel = InstructionModel(id: DateTime.now().toString());

  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Broadcast msg"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                onChanged: (value) {
                  instructionModel.title = value;
                },
                decoration: InputDecoration(hintText: "title"),
              ),
              TextFormField(
                onChanged: (value) {
                  instructionModel.msg = value;
                },
                decoration: InputDecoration(hintText: "msg"),
              ),
              ElevatedButton.icon(onPressed: () => validate(), icon: Icon(Icons.save), label: Text("Save"))
            ],
          ),
        ),
      ),
    );
  }

  validate() async {
    if (_formkey.currentState!.validate()) {
      save();
    }
  }

  void save() async {
    instructionModel.cTime = DateTime.now().toString();
    fireBCollection
        .collection("softwares")
        .doc("$firebaseSoftwaresName")
        .collection("broadcast")
        .doc(instructionModel.id)
        .set(instructionModel.toJson());
  }
}
