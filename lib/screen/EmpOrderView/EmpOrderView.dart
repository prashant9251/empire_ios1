import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmpOrderView extends StatefulWidget {
  BillsModel billsModel;
  EmpOrderView({Key? key, required this.billsModel}) : super(key: key);

  @override
  State<EmpOrderView> createState() => _EmpOrderViewState();
}

class _EmpOrderViewState extends State<EmpOrderView> {
  late BillsModel billsModel;
  @override
  Widget build(BuildContext context) {
    billsModel = widget.billsModel;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Order. No ${billsModel.bill}"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text("${billsModel.masterDet!.partyname}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      "${(billsModel.masterDet!.city)}",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  Text("${Myf.dateFormate(billsModel.date)}"),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Broker : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        TextSpan(text: ' ${billsModel.bcode}', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Haste : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        TextSpan(text: ' ${billsModel.haste}', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Trasnport : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        TextSpan(text: ' ${billsModel.trnsp}', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Station : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                        TextSpan(text: ' ${billsModel.st}', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('TOTAL QTY : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 20)),
                      Chip(
                          color: WidgetStateColor.resolveWith((states) => jsmColor),
                          label: Text(' ${billsModel.totPcs}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(),
          ...billsModel.billDetails!.map((e) {
            return Card(
              color: e.select ?? false ? jsmColor : null,
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                          onTap: () => Myf.Navi(context, fullScreenImg(img_list: ["${e.imageUrl}"])),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  color: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: "${e.imageUrl}",
                                    width: screenWidthMobile * .4,
                                    height: 200,
                                    httpHeaders: {
                                      "Authorization": basicAuthForLocal,
                                    },
                                  )))),
                    ),
                    Flexible(
                      child: ListTile(
                        selected: e.select ?? false,
                        title: Row(
                          children: [
                            Chip(label: Text("${e.qUAL}")),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'QTY : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  TextSpan(text: ' ${e.pCS}', style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'Sets : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  TextSpan(text: ' ${e.sets} X ${e.pcsInSets}', style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'Rate : ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  TextSpan(text: ' ${e.rATE}', style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            Checkbox(
                                value: e.select,
                                onChanged: (value) {
                                  e.select = value;
                                  setState(() {});
                                })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
