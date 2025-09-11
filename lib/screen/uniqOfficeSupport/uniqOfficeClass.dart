import 'dart:async';

import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class UniqOfficeClass {
  static selectMobileNo(context, List userList) async {
    final Completer _companyCompleter = Completer();

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Text(
                "SELECT NO.",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              Divider(),
              SizedBox(height: 10),
              ...userList
                  .map((e) => ListTile(
                        onTap: () async {
                          _companyCompleter.complete(e);
                          Navigator.pop(context, e);
                        },
                        title: Text("${e['mobileno_user']}"),
                        subtitle: Text("${e["usernm"]}"),
                        trailing: Icon(Icons.ads_click),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
    return _companyCompleter.future;
  }
}
