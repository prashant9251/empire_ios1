// ignore_for_file: must_be_immutable

import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

import '../../../DesktopVersion/OfficeDeshboard/OfficeDeshboardClass.dart';

class UniqueRequestCard extends StatefulWidget {
  dynamic d;

  UniqueRequestCard({Key? key, required this.d}) : super(key: key);

  @override
  State<UniqueRequestCard> createState() => _UniqueRequestCardState();
}

class _UniqueRequestCardState extends State<UniqueRequestCard> {
  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    var reqType = widget.d["reqType"].toString();
    var resolveDate = widget.d["resolveDate"];
    color = OfficeDeshboardClass.colorOnReqType(widget.d["reqType"]);

    if (resolveDate != null) {
      color = Colors.white;
    }
    var rplys = widget.d["rplys"] ?? [];
    return Card(
      color: color,
      elevation: 20,
      child: ExpansionTile(
        title: Text("${Myf.dateFormate(widget.d["DATE"])}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CLIENT : ${widget.d["CLNT"]}"),
            Text("SHOP NAME : ${widget.d["shopName"]}"),
            InkWell(
                onTap: () {
                  Myf.dialNo([widget.d["MobileNo"]], context);
                },
                child: Text(
                  "MOBILE : ${widget.d["MobileNo"]}",
                  style: TextStyle(color: Colors.blue),
                )),
            Text("NAME : ${widget.d["fname"]}"),
            Text("REF_NAME : ${widget.d["refName"]}"),
            Text("RMK : ${widget.d["remark"]}"),
            Text("${widget.d["reqType"]} : ${widget.d["response"]}", style: TextStyle(color: Colors.red)),
            widget.d["resolveDate"] != null
                ? Text("RESOLVE DATE: ${(widget.d["resolveDate"])}", style: TextStyle(color: Colors.blue))
                : SizedBox.shrink(),
            CircleAvatar(child: Text("${rplys.length}"))
          ],
        ),
        children: [
          rplys.length > 0
              ? StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    var srrply = 0;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text('SR')),
                              TableCell(child: Text('TIME')),
                              TableCell(child: Text('ANS')),
                            ],
                          ),
                          ...rplys.map((p) {
                            srrply++;
                            return TableRow(
                              children: [
                                TableCell(child: Text('${srrply}')),
                                TableCell(child: Text('${Myf.dateFormate(p["time"])}')),
                                TableCell(
                                    child: Text(
                                  '${p["ans"]}',
                                )),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  })
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
