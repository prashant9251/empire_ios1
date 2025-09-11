import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricLock extends StatefulWidget {
  dynamic UserObj;

  BiometricLock({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<BiometricLock> createState() => _BiometricLockState();
}

class _BiometricLockState extends State<BiometricLock> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Myf.authenticate(context, UserObj: widget.UserObj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text(' ${IosPlateForm ? "Face ID" : "Biometric"} Lock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(' ${IosPlateForm ? "Face ID" : "Biometric"} Lock Screen'),
            IconButton(
              iconSize: 100,
              icon: const Icon(Icons.fingerprint),
              onPressed: () async {
                Myf.authenticate(context, UserObj: widget.UserObj);
              },
            ),
          ],
        ),
      ),
    );
  }
}
