import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';

import '../../SyncData.dart';
import '../../main.dart';

class SyncScreen extends StatefulWidget {
  SyncScreen({Key? key, required this.CURRENT_USER}) : super(key: key);
  dynamic CURRENT_USER;
  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text('${widget.CURRENT_USER['SHOPNAME']}'),
        ),
        body: Container(
          width: screenWidthMobile,
          child: Column(
            children: [
              Text('SYNC YEAR:-${widget.CURRENT_USER['yearVal']}'),
              SyncdataFetch(CURRENT_USER: widget.CURRENT_USER, boolShowDetails: true),
            ],
          ),
        ),
      ),
    );
  }
}
