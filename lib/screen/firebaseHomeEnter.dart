import 'package:empire_ios/screen/rootHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirebaseGetSoftwaresInfo extends StatelessWidget {
  FirebaseGetSoftwaresInfo({Key? key}) : super(key: key);
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return rootHome();
  }
}
