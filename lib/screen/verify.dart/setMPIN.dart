import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

import '../../main.dart';

class SetPassword extends StatefulWidget {
  SetPassword({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool isBiometricAvailable = false;
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  initState() {
    super.initState();
    if (kIsWeb == false)
      Myf.checkBioMetricIsAvailable().then((value) {
        setState(() {
          isBiometricAvailable = value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor(ColorHex),
            title: Text(
              "Set MPin ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            actions: [
              TextButton(
                  onPressed: () => directValidate(),
                  child: Text("skip", style: TextStyle(fontSize: 25, color: Colors.white, decoration: TextDecoration.underline)))
            ],
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              width: widthResponsive(context),
              alignment: Alignment.topCenter,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Do you want to set Login M-PIN ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: jsmColor, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        "Enter your M-PIN here ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Directionality(
                        // Specify direction if desired
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          autofocus: true,
                          obscureText: true,
                          controller: pinController,
                          focusNode: focusNode,
                          defaultPinTheme: defaultPinTheme,
                          validator: (value) {
                            return value!.length < 4 ? 'Pin is incorrect' : null;
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Material(
                        color: HexColor(ColorHex),
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                            onTap: () => validate(),
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              width: 150,
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                "SAVE ",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            )),
                      ),
                      Divider(),
                      isBiometricAvailable
                          ? Column(
                              children: [
                                Text("OR"),
                                InkWell(
                                    onTap: () async {
                                      await setBiomatric(context);
                                    },
                                    child: FittedBox(
                                      child: Text(
                                        "Set ${IosPlateForm ? "Face ID" : "Biometric"}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30, decoration: TextDecoration.underline),
                                      ),
                                    )),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  validate() {
    if (formKey.currentState!.validate()) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Alert"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Are you sure you want to Save "),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () async {
                  Save();
                },
              ),
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      Myf.showMyDialog(context, "Alert", "please fill Mpin");
    }
  }

  Save() async {
    await prefs!.setString("MPIN${widget.UserObj["CLIENTNO"]}", pinController.text.trim());
    Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    Myf.showMyDialogExit(context, "Saved", "successfully");
  }

  Future<void> setBiomatric(BuildContext context) async {
    await prefs!.setString("MPIN${widget.UserObj["CLIENTNO"]}", "biometric");
    Future.delayed(Duration(seconds: 1));
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  directValidate() async {
    await prefs!.setString("MPIN${widget.UserObj["CLIENTNO"]}", "skip");
    Future.delayed(Duration(seconds: 1));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
