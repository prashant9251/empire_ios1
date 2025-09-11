import 'dart:async';

import 'package:empire_ios/Models/StateCode.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

selectStateCode(context) async {
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
              "SELECT STATE",
              style: TextStyle(fontSize: 25, color: jsmColor),
            ),
            Divider(),
            SizedBox(height: 10),
            ...stateCode.entries.map((state) {
              return ListTile(
                onTap: () async {
                  _companyCompleter.complete(state);
                  Navigator.pop(context, state);
                },
                leading: CircleAvatar(child: Text(state.key)),
                title: Text("${state.value["name"]}"),
              );
            }).toList(),
          ],
        ),
      );
    },
  );
  return _companyCompleter.future;
}

var stateCode = {
  "01": {"code": "01", "name": "Jammu and Kashmir"},
  "02": {"code": "02", "name": "Himachal Pradesh"},
  "03": {"code": "03", "name": "Punjab"},
  "04": {"code": "04", "name": "Chandigarh"},
  "05": {"code": "05", "name": "Uttarakhand"},
  "06": {"code": "06", "name": "Haryana"},
  "07": {"code": "07", "name": "Delhi"},
  "08": {"code": "08", "name": "Rajasthan"},
  "09": {"code": "09", "name": "Uttar Pradesh"},
  "10": {"code": "10", "name": "Bihar"},
  "11": {"code": "11", "name": "Sikkim"},
  "12": {"code": "12", "name": "Arunachal Pradesh"},
  "13": {"code": "13", "name": "Nagaland"},
  "14": {"code": "14", "name": "Manipur"},
  "15": {"code": "15", "name": "Mizoram"},
  "16": {"code": "16", "name": "Tripura"},
  "17": {"code": "17", "name": "Meghalaya"},
  "18": {"code": "18", "name": "Assam"},
  "19": {"code": "19", "name": "West Bengal"},
  "20": {"code": "20", "name": "Jharkhand"},
  "21": {"code": "21", "name": "Orissa"},
  "22": {"code": "22", "name": "Chhattisgarh"},
  "23": {"code": "23", "name": "Madhya Pradesh"},
  "24": {"code": "24", "name": "Gujarat"},
  "25": {"code": "25", "name": "Daman and Diu"},
  "26": {"code": "26", "name": "Dadra and Nagar Haveli"},
  "27": {"code": "27", "name": "Maharashtra"},
  "29": {"code": "29", "name": "Karnataka"},
  "30": {"code": "30", "name": "Goa"},
  "31": {"code": "31", "name": "Lakshadweep"},
  "32": {"code": "32", "name": "Kerala"},
  "33": {"code": "33", "name": "Tamil Nadu"},
  "34": {"code": "34", "name": "Puducherry"},
  "35": {"code": "35", "name": "Andaman and Nicobar Islands"},
  "36": {"code": "36", "name": "Telangana"},
  "37": {"code": "37", "name": "Andhra Pradesh (Before bifurcation)"},
  "39": {"code": "39", "name": "Arunachal Pradesh (Before bifurcation)"},
  "40": {"code": "40", "name": "Assam (Before bifurcation)"},
  "41": {"code": "41", "name": "Bihar (Before bifurcation)"},
  "42": {"code": "42", "name": "Chhattisgarh (Before bifurcation)"},
  "43": {"code": "43", "name": "Goa (Before bifurcation)"},
  "44": {"code": "44", "name": "Gujarat (Before bifurcation)"},
  "45": {"code": "45", "name": "Haryana (Before bifurcation)"},
  "46": {"code": "46", "name": "Himachal Pradesh (Before bifurcation)"},
  "47": {"code": "47", "name": "Jharkhand (Before bifurcation)"},
  "48": {"code": "48", "name": "Karnataka (Before bifurcation)"},
  "49": {"code": "49", "name": "Kerala (Before bifurcation)"},
  "50": {"code": "50", "name": "Madhya Pradesh (Before bifurcation)"},
  "51": {"code": "51", "name": "Maharashtra (Before bifurcation)"},
  "52": {"code": "52", "name": "Manipur (Before bifurcation)"},
  "53": {"code": "53", "name": "Meghalaya (Before bifurcation)"},
  "54": {"code": "54", "name": "Mizoram (Before bifurcation)"},
  "55": {"code": "55", "name": "Nagaland (Before bifurcation)"},
  "56": {"code": "56", "name": "Odisha (Before bifurcation)"},
  "57": {"code": "57", "name": "Punjab (Before bifurcation)"},
  "58": {"code": "58", "name": "Rajasthan (Before bifurcation)"},
  "59": {"code": "59", "name": "Sikkim (Before bifurcation)"},
  "60": {"code": "60", "name": "Tamil Nadu (Before bifurcation)"},
  "61": {"code": "61", "name": "Telangana (Before bifurcation)"},
  "62": {"code": "62", "name": "Tripura (Before bifurcation)"},
  "63": {"code": "63", "name": "Uttar Pradesh (Before bifurcation)"},
  "64": {"code": "64", "name": "Uttarakhand (Before bifurcation)"},
  "65": {"code": "65", "name": "West Bengal (Before bifurcation)"}
};
