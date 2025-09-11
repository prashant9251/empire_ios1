import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmpOrderproductScanner extends StatefulWidget {
  const EmpOrderproductScanner({Key? key}) : super(key: key);

  @override
  State<EmpOrderproductScanner> createState() => _EmpOrderproductScannerState();
}

class _EmpOrderproductScannerState extends State<EmpOrderproductScanner> {
  var barcodeResult = TextEditingController();
  var navigatorPop = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("Scanner")),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: barcodeResult,
            builder: (context, value, child) {
              return Text("${barcodeResult.text}");
            },
          ),
          Container(
            height: 200,
            child: Text("aa"),
          )
        ],
      ),
    );
  }
}
