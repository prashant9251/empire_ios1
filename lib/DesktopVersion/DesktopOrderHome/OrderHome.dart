// ignore_for_file: must_be_immutable

import 'package:empire_ios/DesktopVersion/DesktopOrderHome/DesktopOrderHomeClass.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderHome extends StatefulWidget {
  var UserObj;

  OrderHome({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<OrderHome> createState() => _OrderHomeState();
}

class _OrderHomeState extends State<OrderHome> {
  var loading = true;
  List<dynamic> OrderList = [];
  List<DataRow> rows = [];
  int totalDispatchOrder = 0;
  int totalpendingOrder = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var totalAllOrder = OrderList.length;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      // color: Colors.white,
      child: StreamBuilder<bool>(
          stream: somthingHaschange.stream,
          builder: (context, snapshot) {
            return loading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Wrap(
                          spacing: 20,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('All Order'),
                                  StreamBuilder<Object>(
                                      stream: null,
                                      builder: (context, snapshot) {
                                        return Text('${OrderList.length}', style: TextStyle(fontSize: 30));
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Pending Order'),
                                  Text('$totalpendingOrder', style: TextStyle(fontSize: 30)),
                                ],
                              ),
                            ),
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Dispatched Order'),
                                  Text('$totalDispatchOrder', style: TextStyle(fontSize: 30)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              height: 400,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.all(10), child: Text("All Order", style: TextStyle(fontSize: 20, color: Colors.black))),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: tabled(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
          }),
    );
  }

  Widget tabled() {
    OrderList.sort((a, b) {
      return b["BK_DATE"].toString().compareTo(a["BK_DATE"]);
    });
    var snp = OrderList;
    TextStyle headStyle = TextStyle(color: Colors.black);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: DataTable(
            columnSpacing: 5,
            columns: [
              DataColumn(label: Text('Date', style: headStyle)),
              DataColumn(label: Text('OrderNo', style: headStyle), numeric: true),
              DataColumn(label: Text('Customer', style: headStyle)),
              DataColumn(label: Text('Station', style: headStyle)),
              DataColumn(label: Text('Broker', style: headStyle)),
              DataColumn(label: Text('TRANSPORT', style: headStyle)),
              DataColumn(label: Text('Dispatch', style: headStyle)),
            ],
            rows: [
              ...rows

              // Add more rows as needed
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    await loadData();
    mainHiveStreamBox!.watch().listen((event) async {
      await loadData();
    });
  }

  loadData() async {
    rows = [];
    var databaseId = Myf.databaseId(widget.UserObj);
    await Hive.openBox('${databaseId}ORDER').then((value) {
      OrderList = value.values.toList();
    });
    // OrderList.sort((a, b) {
    //   DateTime timeA = DateTime.parse(a["BK_DATE"]);
    //   DateTime timeB = DateTime.parse(b["BK_DATE"]);
    //   return timeB.compareTo(timeA);
    // });
    totalpendingOrder = OrderList.where((e) {
      return e["dispatch"] == "N";
    }).toList().length;
    totalDispatchOrder = OrderList.where((e) {
      return e["dispatch"] == "Y";
    }).toList().length;
    OrderList.map((e) {
      dynamic d = e;
      var dispatch = d["dispatch"];
      var backgroundColor = Colors.red;
      var style = TextStyle(color: Colors.black);
      if (dispatch == "Y") {
        style = TextStyle(color: Colors.black);
        backgroundColor = Colors.green;
      }
      var row = DataRow(
          color: WidgetStateColor.resolveWith((states) {
            return backgroundColor;
          }),
          cells: [
            DataCell(Row(children: [
              IconButton(onPressed: () => PdfApi.createPdfAndView(ORDER: d, context: context), icon: Icon(Icons.print)),
              Text('${d["BK_DATE"]}')
            ])),
            DataCell(CircleAvatar(child: Text('${d["OrderNo"]}', style: TextStyle(color: Colors.white)))),
            DataCell(Text('${d["partyname"]}', style: style)),
            DataCell(Text('${d["BK_STATION"]}', style: style)),
            DataCell(Text('${d["broker"]}', style: style)),
            DataCell(Text('${d["BK_TRANSPORT"]}', style: style)),
            DataCell(Chip(label: Text('${d["dispatch"]}', style: style))),
          ]);
      rows.add(row);
      List billDetails = d["billDetails"];
      if (billDetails.length > 0) {
        billDetails.map((b) {
          row = DataRow(cells: [
            DataCell(Text("")),
            DataCell(Text('${b["ID"]}')),
            DataCell(Text('${b["qualname"]}')),
            DataCell(Text('${b["qty"]}')),
            DataCell(Text('${b["rate"]}')),
            DataCell(Text('${b["pack"]}')),
            DataCell(GestureDetector(
                onTap: () async {
                  DesktopOrderHomeClass.orderDispatchUpdate(context, UserObj: widget.UserObj, b: b, billDetails: billDetails, d: d);
                },
                child: Chip(label: Text('${b["dispatch"]}')))),
          ]);
          rows.add(row);
        }).toList();
      }
      logger.d(d);
    }).toList();
    loading = false;
    somthingHaschange.sink.add(true);
  }
}
