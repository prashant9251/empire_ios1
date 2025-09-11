import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final _formKey = GlobalKey<FormState>();

  var ctrlEmailAddress = TextEditingController();
  var ctrlmobile = TextEditingController();
  var ctrlfeedback = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlEmailAddress.text = widget.UserObj["emailadd"];
    ctrlmobile.text = widget.UserObj["mobileno_user"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("YOUR FEED BACK")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "YOUR FEEDBACK",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: ctrlEmailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email Cannot be empty";
                  }
                  return null;
                },
                onChanged: (value) {
                  // userEmail = value;
                },
                decoration: inputDecoration("Email ", "Email "),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: ctrlmobile,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Mobile Cannot be empty";
                  }
                  return null;
                },
                onChanged: (value) {
                  // userMobile = value;
                },
                decoration: inputDecoration("Mobile ", "Mobile "),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 10,
                controller: ctrlfeedback,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "FEEDBACK Cannot be empty";
                  }
                  return null;
                },
                onChanged: (value) {
                  // userFEEDBACK = value;
                },
                decoration: inputDecoration("YOUR FEEDBACK ", "YOUR FEEDBACK "),
              ),
              SizedBox(height: 10),
              Material(
                color: HexColor(ColorHex),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                    onTap: () => validate(),
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        "SEND",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(hint, label) {
    return InputDecoration(
      hintText: hint,
      label: Text(label),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  validate() {
    if (_formKey.currentState!.validate()) {
      save();
    }
  }

  void save() {
    Myf.showLoading(context, "please wait");
    Map<String, dynamic> obj = {};
    obj["email"] = ctrlEmailAddress.text.trim().toLowerCase();
    obj["mobile"] = ctrlmobile.text.trim().toLowerCase();
    obj["feedback"] = ctrlfeedback.text.trim().toLowerCase();
    obj["clnt"] = widget.UserObj["CLIENTNO"];
    fireBCollection.collection("feedback").doc().set(obj).then((value) {
      Navigator.pop(context);
      Myf.showMyDialogExit(context, "Send", "successfully");
    });
  }
}
