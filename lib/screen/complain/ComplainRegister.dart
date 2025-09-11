import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class ComplainRegistration extends StatefulWidget {
  ComplainRegistration({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<ComplainRegistration> createState() => _ComplainRegistrationState();
}

class _ComplainRegistrationState extends State<ComplainRegistration> {
  final _formKey = GlobalKey<FormState>();

  var ctrlEmailAddress = TextEditingController();
  var ctrlmobile = TextEditingController();
  var ctrlComplainRegistration = TextEditingController();

  var ctrlattachName = TextEditingController(text: "Attach Screen shot");
  var FilePath = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlEmailAddress.text = widget.UserObj["emailadd"] ?? '';
    ctrlmobile.text = widget.UserObj["mobileno_user"] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("Support")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Please Enter your details ",
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
                controller: ctrlComplainRegistration,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Problem Cannot be empty";
                  }
                  return null;
                },
                onChanged: (value) {
                  // userProblem = value;
                },
                decoration: inputDecoration("Your Problem ", "Your Problem "),
              ),
              Card(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text("Attachment"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ctrlattachName.text),
                    ],
                  ),
                  trailing: IconButton(onPressed: () => selectImg(), icon: Icon(Icons.attach_file_outlined)),
                ),
              ),
              Text(
                "Take problem screen shot and attach here",
                style: TextStyle(color: Colors.blue),
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
              SizedBox(height: 10),
              Text(
                "Our team will contact you as soon  as possible",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              firebSoftwraesInfo["contactNo"] == null
                  ? SizedBox.shrink()
                  : Text(
                      "${firebSoftwraesInfo["supportIconMsg"]}",
                      textAlign: TextAlign.center,
                    )
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

  void save() async {
    Myf.showLoading(context, "please wait");
    Map<String, dynamic> obj = {};
    obj["email"] = ctrlEmailAddress.text.trim().toLowerCase();
    obj["mobile"] = ctrlmobile.text.trim().toLowerCase();
    obj["ComplainRegistration"] = ctrlComplainRegistration.text.trim().toLowerCase();
    obj["clnt"] = widget.UserObj["CLIENTNO"];
    var msg = ctrlComplainRegistration.text;
    msg +=
        '''\n
From  Shop Name : ${widget.UserObj["SHOPNAME"]}
Email :-${obj["email"]}
Mobile : -${obj["mobile"]}
Client No : ${widget.UserObj["CLIENTNO"]}
    ''';
    var sub = """New Issue From   \nShop Name : ${widget.UserObj["SHOPNAME"]} \nClient No : ${widget.UserObj["CLIENTNO"]}""";

    var ctEmail = firebaseCurrntSupUserObj["contactEmail"] != null ? firebaseCurrntSupUserObj["contactEmail"] : contactEmail;
    await Myf.sendFileEmail("$ctEmail", FilePath, sub, msg);
    Navigator.pop(context);
    // fireBCollection.collection("ComplainRegistration").doc().set(obj).then((value) {
    //   Myf.showMyDialogExit(context, "Send", "successfully");
    // });
  }

  selectImg() async {
    var f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (f != null) {
      ctrlattachName.text = f.name;
      FilePath = f.path;
      setState(() {});
    }
  }
}
