import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class DesktopLoginSystem extends StatefulWidget {
  const DesktopLoginSystem({Key? key}) : super(key: key);

  @override
  State<DesktopLoginSystem> createState() => _DesktopLoginSystemState();
}

class _DesktopLoginSystemState extends State<DesktopLoginSystem> {
  var ctrlGstin = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var ctrlMobileNo = TextEditingController();
  var loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * .5,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Icon(
                          Icons.login,
                          size: 60,
                        ),
                        Text("Welcome To Unique softwares",
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: ctrlGstin,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Gstin Cannot be empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Enter Your Gstin ",
                                  labelText: "Gstin ",
                                ),
                              ),
                              TextFormField(
                                controller: ctrlMobileNo,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Mobile No. Cannot be empty";
                                  } else if (value.length < 10) {
                                    return "Mobile No length should be atleast 10";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Enter Mobile No.",
                                  labelText: "Mobile No.",
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Material(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                    onTap: () => validate(),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      width: 150,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    )),
                              ),
                              SizedBox(height: 30),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                // ElevatedButton(
                                //     onPressed: () => Myf.Navi(context, ForgotPass()),
                                //     child: Text(
                                //       "Forgot my login Details??",
                                //     ))
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      login();
    }
  }

  Future<void> login() async {
    prefs!.setString("userGstin", ctrlGstin.text.trim());
    prefs!.setString("mobileNo", ctrlMobileNo.text.trim());
    Myf.showLoading(context, "Please wait");
    var userGstin = ctrlGstin.text;
    var mobileNo = ctrlMobileNo.text;
    await fireBCollection
        .collection("supuser")
        .where("GSTIN", isEqualTo: userGstin)
        .where("mobileno_user", isEqualTo: mobileNo)
        .limit(1)
        .get()
        .then((value) {
      var snp = value.docs;
      snp.map((e) async {
        dynamic d = e.data();
        Navigator.pop(context);
        prefs!.setString("DesktopLoginUser", await jsonEncode(d));
        gotoDeskBoard();
      }).toList();
    });
  }

  getData() async {
    ctrlGstin.text = await prefs!.getString("userGstin") == null ? "" : await prefs!.getString("userGstin")!;
    ctrlMobileNo.text = await prefs!.getString("mobileNo") == null ? "" : await prefs!.getString("mobileNo")!;
    var loginUser = await prefs!.getString("DesktopLoginUser") ?? "{}";
    // widget. = await jsonDecode(loginUser);
    // if (widget.["GSTIN"] != null) {
    //   gotoDeskBoard();
    // }
    setState(() {
      loading = false;
    });
  }

  void gotoDeskBoard() {
    Navigator.popUntil(context, (route) => route.isFirst);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DesktopHome(UserObj: widget),
    //     ));
  }
}
