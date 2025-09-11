import 'dart:async';

import 'package:empire_ios/Models/BLSModel.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/DetModel.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/CRM/CrmPdfSalesClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SalesTable extends StatefulWidget {
  OutstandingModel outstandingModel;

  SalesTable({Key? key, required this.outstandingModel}) : super(key: key);

  @override
  State<SalesTable> createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  var totalBillAmt = 0.0;
  List<dynamic> blsList = [];
  List<dynamic> detList = [];
  final StreamController<bool> changeStream = StreamController<bool>.broadcast();
  late LazyBox BLS_BOX;
  late LazyBox DET_BOX;

  var loading = true;
  List<DataRow> dataRow = [];
  BlsModel blsModel = BlsModel(billdetails: []);
  List<DetBillDetails> billdetBillDetails = [];

  initState() {
    super.initState();
    getData().then((value) {
      loading = false;
      changeStream.sink.add(true);
    });
  }

  Future getData() async {
    BLS_BOX = await SyncLocalFunction.openLazyBoxCheckByYearWise("BLS");
    DET_BOX = await SyncLocalFunction.openLazyBoxCheckByYearWise("DET");
    try {
      blsList = await BLS_BOX.getAt(0) ?? [];
    } catch (e) {}
    try {
      detList = await DET_BOX.getAt(0) ?? [];
    } catch (e) {}
    BLS_BOX.close();
    DET_BOX.close();
    blsList.forEach((bls) async {
      if (bls["code"] == widget.outstandingModel.code) {
        dynamic party_bls;

        party_bls = bls;
        List<dynamic> billDetails = [];
        billDetails = party_bls["billDetails"];
        blsModel.code = party_bls["code"];
        blsModel.billdetails = blsModel.billdetails ?? [];
        blsModel.brokerModel = widget.outstandingModel.brokerModel;
        blsModel.masterModel = widget.outstandingModel.masterModel;
        blsModel.crmFollowUpModel = widget.outstandingModel.crmFollowUpModel;

        billDetails.forEach((element) {
          BlsBillDetails blsBillDetails = BlsBillDetails.fromJson(Myf.convertMapKeysToString(element));
          blsModel.billdetails!.add(blsBillDetails);
        });
        totalBillAmt = 0;
        await Future.wait(blsModel.billdetails!.skip((blsModel.billdetails!.length - 100).clamp(0, blsModel.billdetails!.length)).map((e) async {
          totalBillAmt += Myf.convertToDouble(e.bamt);
          var d = DataRow(cells: [
            DataCell(Text('${e.bill}', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('${Myf.dateFormateInDDMMYYYY(e.date)}', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('${e.bamt}', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('${e.bcode}', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('${e.trnsp}', style: TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text('${e.rrno}', style: TextStyle(fontWeight: FontWeight.bold))),
          ]);
          dataRow.add(d);
          await Future.wait(detList.map((element) async {
            if (element["IDE"] == e.ide) {
              List detBillDetails = element["billDetails"];
              if (detBillDetails.length > 0)
                dataRow.add(DataRow(cells: [
                  DataCell(Text('ITEM', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataCell(Text('PCS', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataCell(Text('RATE', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataCell(Text('MTS', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataCell(Text('PCK', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataCell(Text('AMT', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 13))),
                ]));
              billdetBillDetails.clear();
              detBillDetails.forEach((element) {
                billdetBillDetails.add(DetBillDetails.fromJson(Myf.convertMapKeysToString(element)));
                var d = DataRow(cells: [
                  DataCell(Text('${element["qual"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                  DataCell(Text('${element["PCS"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                  DataCell(Text('${element["RATE"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                  DataCell(Text('${element["MTS"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                  DataCell(Text('${element["PCK"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                  DataCell(Text('${element["AMT"]}', style: TextStyle(color: Colors.black, fontSize: 13))),
                ]);
                dataRow.add(d);
              });
              e.detBillDetails = billdetBillDetails;
            }
          }).toList());
        }).toList());
      }
    });
    blsList.clear();
  }

  dispose() {
    changeStream.close();
    super.dispose();
    BLS_BOX.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: changeStream.stream,
        builder: (context, snapshot) {
          return loading
              ? Center(child: Text("please wait"))
              : Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text('SALES REPORT', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (blsModel.billdetails!.length > 0) ...[
                                  Flexible(
                                    child: IconButton(
                                        onPressed: () {
                                          Myf.showBlurLoading(context);
                                          CrmPdfSalesClass.createPdf([blsModel], share: 'enotify', context: context);
                                          Navigator.pop(context);
                                        },
                                        icon: CircleAvatar(child: Icon(Icons.send))),
                                  ),
                                  Flexible(
                                    child: IconButton(
                                        onPressed: () {
                                          Myf.showBlurLoading(context);
                                          CrmPdfSalesClass.createPdf([blsModel], share: true, context: context);
                                          Navigator.pop(context);
                                        },
                                        icon: CircleAvatar(child: Icon(Icons.share))),
                                  ),
                                  if (!kIsWeb)
                                    Flexible(
                                      child: IconButton(
                                          onPressed: () {
                                            Myf.showBlurLoading(context);
                                            CrmPdfSalesClass.createPdf([blsModel], context: context);
                                            Navigator.pop(context);
                                          },
                                          icon: CircleAvatar(child: Icon(Icons.open_in_new))),
                                    ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: StreamBuilder<bool>(
                              stream: null,
                              builder: (context, snapshot) {
                                return blsModel.billdetails!.length == 0
                                    ? Text(
                                        "No Data Found",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : DataTable(
                                        headingRowHeight: 40,
                                        headingRowColor: WidgetStateColor.resolveWith((states) => jsmColor),
                                        headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        columns: [
                                          DataColumn(label: Text('Bill')),
                                          DataColumn(label: Text('Date')),
                                          DataColumn(label: Text('Bill Amt')),
                                          DataColumn(label: Text('Broker')),
                                          DataColumn(label: Text('TRANSPORT')),
                                          DataColumn(label: Text('LRNO')),
                                        ],
                                        rows: [
                                          ...dataRow,
                                          DataRow(cells: [
                                            DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('${totalBillAmt}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                          ]),
                                          DataRow(cells: [
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                            DataCell(Text('')),
                                          ])
                                        ],
                                      );
                              }),
                        ),
                      ),
                    ],
                  ),
                );
        });
  }
}
