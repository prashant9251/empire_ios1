import 'package:empire_ios/Models/HideUnhideModel.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Showhideunhidesettings extends StatefulWidget {
  String reportName;
  Showhideunhidesettings({Key? key, required this.reportName}) : super(key: key);

  @override
  State<Showhideunhidesettings> createState() => _ShowhideunhidesettingsState();
}

class _ShowhideunhidesettingsState extends State<Showhideunhidesettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Hide/Unhide"),
      ),
      body: Container(
        width: widthResponsive(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: hideUnhideSettings.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(hideUnhideSettings[index].caption),
                    trailing: Switch(
                      value: hideUnhideSettings[index].view,
                      onChanged: (value) {
                        setState(() {
                          hideUnhideSettings[index].view = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
