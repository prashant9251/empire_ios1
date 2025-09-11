import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/verify.dart/setMPIN.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  var MPIN = "";
  var isBiometricAvailable = false;
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MPIN = prefs!.getString("MPIN${widget.UserObj["CLIENTNO"]}")!;
    //print(MPIN);
    if (MPIN.isEmpty) {
      Myf.Navi(context, SetPassword(UserObj: widget.UserObj));
    }
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
        fontSize: 60,
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
                "Please Verify",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              alignment: Alignment.topCenter,

              width: widthResponsive(context),
              // width: friendlyScreenWidth(context, constraints),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // kIsWeb
                      //     ? SizedBox.shrink()
                      //     : Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 20),
                      //         padding: const EdgeInsets.symmetric(horizontal: 10),
                      //         child: Image.asset("assets/img/verify.png"),
                      //       ),
                      Text(
                        "Please Enter your MPIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: HexColor(ColorHex), fontWeight: FontWeight.bold),
                      ),
                      // Divider(height: 20),
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
                            return value == MPIN ? null : 'Pin is incorrect';
                          },
                          // onClipboardFound: (value) {
                          //   debugPrint('onClipboardFound: $value');
                          //   pinController.setText(value);
                          // },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            if (pin == MPIN) {
                              validate();
                            }
                          },
                          onChanged: (value) {
                            if (value == MPIN) {
                              validate();
                            }
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
                                "Verify ",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      isBiometricAvailable
                          ? Column(
                              children: [
                                const Text(
                                  "Or",
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('${IosPlateForm ? "Face ID" : "Biometric"}  Authentication', style: TextStyle(fontSize: 20, color: jsmColor)),
                                const SizedBox(
                                  height: 10,
                                ),
                                IconButton(
                                  iconSize: 60,
                                  icon: const Icon(Icons.fingerprint),
                                  onPressed: () async {
                                    Myf.authenticate(context, UserObj: widget.UserObj);
                                  },
                                ),
                              ],
                            )
                          : SizedBox.shrink()
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
      var navVal;
      goHome(navVal);
    }
  }

  void goHome(navVal) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Myf.goToHome(navVal, context, widget.UserObj);
  }
}
