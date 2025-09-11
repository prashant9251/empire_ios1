import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/OutstandingReport/OutstandingReport.dart';
import 'package:empire_ios/screen/Search/PartyNameSearch/PartyNameSearch.dart';
import 'package:flutter/material.dart';

class OutstandingForm extends StatefulWidget {
  const OutstandingForm({Key? key}) : super(key: key);

  @override
  State<OutstandingForm> createState() => _OutstandingFormState();
}

class _OutstandingFormState extends State<OutstandingForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("OutstandingForm"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PartyNameSearch(
              atype: "1",
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle button press
              Myf.Navi(context, OutstandingReport());
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
