import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/MyfCmn.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class NewRegistration extends StatefulWidget {
  const NewRegistration({Key? key}) : super(key: key);

  @override
  State<NewRegistration> createState() => _NewRegistrationState();
}

class _NewRegistrationState extends State<NewRegistration> {
  var ctrlMsg = TextEditingController();
  var ctrlShopGstin = TextEditingController();
  var ctrlemail = TextEditingController();
  var ctrlMobile = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var ctrlSftName = TextEditingController(text: "Select Your Softwares");
  var ctrlSftType = TextEditingController(text: "Select Type");
  var ctrlShopName = TextEditingController();

  var ctrlRefBy = TextEditingController();

  var ctrlShopAddress = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlMsg.text = prefs!.getString("msg") ?? "";
    ctrlemail.text = prefs!.getString("email") ?? "";
    ctrlMobile.text = prefs!.getString("mobile") ?? "";
    ctrlShopGstin.text = prefs!.getString("yourSoftwaresName") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      message: null,
      title: null,
    );
    var softwareList = ["Select Your Softwares", "EMPIRE TRADING", "EMPIRE AGENCY"];
    Map<String, List<String>> softwareTypeList = {
      "EMPIRE TRADING": ["Select Type", "TRADING"],
      "EMPIRE AGENCY": ["Select Type", "AGENCY", "ADAT"],
    };
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("New Registration"),
      ),
      body: Center(
        child: Container(
          width: widthResponsive(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: jsmColor,
                          ),
                        ),
                      ),
                      Text(
                        "Please register with below details, our team will check your details and get back to you.",
                        style: TextStyle(
                          color: jsmColor,
                          letterSpacing: 1,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                      isExpanded: true,
                      padding: EdgeInsets.all(5),
                      value: ctrlSftName.text,
                      hint: Text("Select Your Softwares"),
                      items: softwareList
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (var val) {
                        // setYear(val);
                        ctrlSftName.text = val.toString();
                        setState(() {});
                      }),
                  ctrlSftName.text.indexOf("Select Your Softwares") < 0
                      ? DropdownButton(
                          isExpanded: true,
                          padding: EdgeInsets.all(5),
                          value: ctrlSftType.text,
                          hint: Text("Select Type"),
                          items: softwareTypeList["${ctrlSftName.text}"]!
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (var val) {
                            // setYear(val);
                            ctrlSftType.text = val.toString();
                            setState(() {});
                          })
                      : SizedBox.shrink(),
                  ctrlSftType.text.indexOf("Select Type") < 0
                      ? Column(
                          children: [
                            TextFormField(
                              controller: ctrlShopName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return " Shop Name Cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // userAccounting softwares Shop Name = value;
                              },
                              decoration: inputDecoration("Your Shop Name ", "Your Shop Name "),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: ctrlShopAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Shop Full Address Cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {},
                              decoration: inputDecoration("Your Shop Full Address ", "Your Shop Full Address "),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: ctrlShopGstin,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "GSTIN NO. Cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                prefs!.setString("userGstin", value);
                              },
                              decoration: inputDecoration("Your GSTIN NO. ", "Your GSTIN NO. "),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: ctrlemail,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email Cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // userEmail = value;
                              },
                              decoration: inputDecoration("Email", "Email"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: ctrlMobile,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Mobile Cannot be empty";
                                } else if (value.length > 10) {
                                  return "Mobile no. should be 10 digit";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // userMobile = value;
                                prefs!.setString("mobileNo", value);
                              },
                              decoration: inputDecoration("Mobile", "Mobile"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InDev(
                              inDevUser: "58385",
                              widget: TextFormField(
                                controller: ctrlRefBy,
                                onChanged: (value) {
                                  // userRefer By  = value;
                                },
                                decoration: inputDecoration("Ref By ", "Ref By"),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                      "Register now",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  requestSent
                      ? Center(
                          child: Text("Request already sent \n We will get in touch with you soon",
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                        )
                      : SizedBox.fromSize()
                ],
              ),
            ),
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

  Future<void> submit() async {
    progressDialog.setTitle(const Text("Loading"));
    progressDialog.setMessage(const Text("Please wait"));
    progressDialog.show();
    var id = "${ctrlShopGstin.text.trim().toUpperCase()}";
    var dt = await DateTime.now();
    Map<String, dynamic> obj = {};
    obj["ID"] = id;
    obj["email"] = ctrlemail.text.trim().toLowerCase();
    obj["mobile"] = ctrlMobile.text.trim();
    obj["software_name"] = ctrlSftName.text.trim().toUpperCase();
    obj["ACTYPE"] = ctrlSftType.text.trim().toUpperCase();
    obj["reqTime"] = dt.toString();
    obj["shopName"] = ctrlShopName.text.toString().trim().toUpperCase();
    obj["gstin"] = ctrlShopGstin.text..toString().trim().toUpperCase();
    obj["address"] = ctrlShopAddress.text.toString().trim().toUpperCase();
    obj["refByCode"] = ctrlRefBy.text.toString().trim().toUpperCase();
    obj["status"] = "";

    await fireBCollection.collection("newInstallReq").doc(id).set(obj).then((value) => null);
    Navigator.pop(context);
    Myf.showMyDialogExit(context, "Request sent successfully", "Our team will contact you soon");
  }

  validate() async {
    prefs!.setString("msg", ctrlMsg.text);
    prefs!.setString("email", ctrlemail.text);
    prefs!.setString("mobile", ctrlMobile.text);
    prefs!.setString("yourSoftwaresName", ctrlShopGstin.text);

    if (_formKey.currentState!.validate()) {
      submit();
    }
  }
}
