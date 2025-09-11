import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class newRegistrationButton extends StatefulWidget {
  const newRegistrationButton({Key? key}) : super(key: key);

  @override
  State<newRegistrationButton> createState() => _newRegistrationButtonState();
}

class _newRegistrationButtonState extends State<newRegistrationButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Text(
        "If you are a New User\n  then Register now",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          // decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
