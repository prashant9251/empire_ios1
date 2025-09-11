import 'dart:async';

import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingCubit.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OutstandingTable extends StatefulWidget {
  OutstandingModel outstandingModel;

  OutstandingTable({Key? key, required this.outstandingModel}) : super(key: key);

  @override
  State<OutstandingTable> createState() => _OutstandingTableState();
}

class _OutstandingTableState extends State<OutstandingTable> {
  var selectAll = true;

  bool showSelected = false;

  var totalBillAmt = 0.0;

  var rAMT = 0.0;

  var pAMT = 0.0;

  final StreamController<bool> showCheckBoxStream = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    totalBillAmt = 0.0;
    pAMT = 0.0;
    rAMT = 0.0;
    return Container(
      // padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  child: Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text('SALES OUTSTANDING', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: IconButton(
                          onPressed: () {
                            Myf.showBlurLoading(context);
                            CrmPdfOutstandingClass.createPdf([widget.outstandingModel],
                                share: 'enotify', context: context, selectedCno: ctrlCNO.text);
                            Navigator.pop(context);
                          },
                          icon: CircleAvatar(child: Icon(Icons.send))),
                    ),
                    Flexible(
                      child: IconButton(
                          onPressed: () {
                            Myf.showBlurLoading(context);
                            CrmPdfOutstandingClass.createPdf([widget.outstandingModel], share: true, context: context, selectedCno: ctrlCNO.text);
                            Navigator.pop(context);
                          },
                          icon: CircleAvatar(child: Icon(Icons.share))),
                    ),
                    if (!kIsWeb)
                      Flexible(
                        child: IconButton(
                            onPressed: () {
                              Myf.showBlurLoading(context);
                              CrmPdfOutstandingClass.createPdf([widget.outstandingModel], context: context, selectedCno: ctrlCNO.text);
                              Navigator.pop(context);
                            },
                            icon: CircleAvatar(child: Icon(Icons.open_in_new))),
                      ),
                    Flexible(
                      child: IconButton(
                          onPressed: () {
                            showCheckBoxStream.sink.add(true);
                          },
                          icon: CircleAvatar(child: Icon(Icons.select_all))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<bool>(
                  stream: showCheckBoxStream.stream,
                  builder: (context, snapshot) {
                    totalBillAmt = 0.0;
                    pAMT = 0.0;
                    rAMT = 0.0;
                    bool showCheckBox = snapshot.data ?? false;
                    if (showSelected) widget.outstandingModel.billdetails = widget.outstandingModel.billdetails!.where((e) => e.showSelect!).toList();
                    return DataTable(
                      showCheckboxColumn: showCheckBox,
                      headingRowHeight: 40,
                      headingRowColor: WidgetStateColor.resolveWith((states) => jsmColor),
                      headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      columns: [
                        if (showCheckBox)
                          DataColumn(
                              label: Checkbox(
                            onChanged: (value) async {
                              selectAll = value ?? true;
                              await Future.wait(widget.outstandingModel.billdetails!.map((e) async {
                                e.showSelect = selectAll;
                              }).toList());
                              showCheckBoxStream.sink.add(true);
                            },
                            value: selectAll,
                          )),
                        DataColumn(label: Text('Bill')),
                        DataColumn(label: Text('Date')),
                        DataColumn(numeric: true, label: Text('PendAmt')),
                        DataColumn(numeric: true, label: Text('Days')),
                        DataColumn(label: Text('Broker')),
                        DataColumn(label: Text('Rmk')),
                      ],
                      rows: [
                        ...widget.outstandingModel.billdetails!.map((e) {
                          totalBillAmt += Myf.convertToDouble(e.gRSAMT);
                          pAMT += Myf.convertToDouble(e.pAMT);
                          rAMT += Myf.convertToDouble(e.rECAMT);
                          var days = Myf.daysCalculate(e.dATE);
                          return DataRow(cells: [
                            if (showCheckBox)
                              DataCell(Checkbox(
                                onChanged: (value) {
                                  e.showSelect = value;
                                  showCheckBoxStream.sink.add(true);
                                },
                                value: e.showSelect,
                              )),
                            DataCell(Text('${e.bILL}')),
                            DataCell(Text('${Myf.dateFormateInDDMMYYYY(e.dATE)}')),
                            DataCell(Text('${Myf.convertToDouble(e.pAMT).toStringAsFixed(2)}')),
                            DataCell(Text('${days}')),
                            DataCell(Text('${e.bCODE}')),
                            DataCell(Text('${e.l1R}')),
                          ]);
                        }).toList(),
                        DataRow(cells: [
                          if (showCheckBox)
                            DataCell(ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: jsmColor),
                                onPressed: () {
                                  showSelected = true;
                                  showCheckBoxStream.sink.add(false);
                                },
                                child: Text(
                                  "Load",
                                  style: TextStyle(color: Colors.white),
                                ))),
                          DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                          DataCell(Text('')),
                          DataCell(Text('${pAMT.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                          DataCell(Text('', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                          DataCell(Text('', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                          DataCell(Text('')),
                        ]),
                        DataRow(cells: [
                          if (showCheckBox) DataCell(Text('')),
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
  }
}
