import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/complain/ComplainRegister.dart';
import 'package:empire_ios/screen/instruction/ImgSliderInsruction/ImgSliderInsruction.dart';
import 'package:empire_ios/screen/instruction/rateApplication.dart';
import 'package:empire_ios/widget/mainScreenIcon.dart';
import 'package:flutter/material.dart';

class HomeScreenInstruction extends StatelessWidget {
  HomeScreenInstruction({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImgSliderInsruction(),
      ],
    );
  }
}
