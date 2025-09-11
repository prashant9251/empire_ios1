// ignore_for_file: must_be_immutable

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderHomeListItemWise extends StatefulWidget {
  var UserObj;

  OrderHomeListItemWise({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<OrderHomeListItemWise> createState() => _OrderHomeListItemWiseState();
}

class _OrderHomeListItemWiseState extends State<OrderHomeListItemWise> {
  var loading = true;
  List<dynamic> OrderList = [];
  List<DataRow> rows = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: somthingHaschange.stream,
        builder: (context, snapshot) {
          return loading ? Center(child: CircularProgressIndicator()) : tabled();
        });
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
              DataColumn(label: Text('DATE', style: headStyle)),
              DataColumn(label: Text('PARTY NAME', style: headStyle)),
              DataColumn(label: Text('QTY', style: headStyle)),
              DataColumn(label: Text('RATE', style: headStyle)),
              DataColumn(label: Text('PACK', style: headStyle)),
              DataColumn(label: Text('REMARK', style: headStyle)),
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

  List transaction = [];
  List qualList = [];
  loadData() async {
    dynamic flgQualList = {};
    rows = [];
    var databaseId = Myf.databaseId(widget.UserObj);
    await Hive.openBox('${databaseId}ORDER').then((value) async {
      OrderList = await value.values.toList();
    });
    await Future.wait(OrderList.map((e) async {
      List billDetails = e["billDetails"];
      e["orderDispatch"] = e["dispatch"];
      await Future.wait(billDetails.map((b) async {
        Map<String, dynamic> obj = {...b, ...e};
        transaction.add(obj);
        // logger.i(obj["qualname"]);
        if (!flgQualList[obj["qualname"]].toString().contains("true")) {
          qualList.add(obj["qualname"]);
          flgQualList[obj["qualname"]] = true;
        }
      }).toList());
    }).toList());
    await Future.wait(qualList.map((e) async {
      var row = DataRow(cells: [
        DataCell(Row(children: [Text('${e}', style: TextStyle(fontWeight: FontWeight.bold))])),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ]);
      rows.add(row);
      List itemOrderList = transaction.where((element) {
        return element["qualname"] == e;
      }).toList();
      await Future.wait(itemOrderList.map((e) async {
        var dispatch = e["dispatch"];
        var backgroundColor = Colors.red;
        var style = TextStyle(color: Colors.black);
        if (dispatch == "Y") {
          style = TextStyle(color: Colors.white);
          backgroundColor = Colors.green;
        }
        row = DataRow(color: WidgetStateColor.resolveWith((states) => backgroundColor), cells: [
          DataCell(Row(children: [
            IconButton(onPressed: () => PdfApi.createPdfAndView(ORDER: e, context: context), icon: Icon(Icons.print)),
            Text('${e["BK_DATE"]}')
          ])),
          DataCell(Text('${e["partyname"]}', style: style)),
          DataCell(Text('${e["qty"]}', style: style)),
          DataCell(Text('${e["rate"]}/-', style: style)),
          DataCell(Text('${e["pack"]}', style: style)),
          DataCell(Text('${e["productRemark"]}', style: style)),
          DataCell(GestureDetector(
              onTap: () async {
                var billDetails = e["billDetails"];
                // DesktopOrderHomeClass.orderDispatchUpdate(context, UserObj: widget.UserObj, b: e, billDetails: billDetails, d: e);
              },
              child: Chip(label: Text('${e["dispatch"]}')))),
        ]);
        rows.add(row);
      }).toList());
    }).toList());
    loading = false;
    somthingHaschange.sink.add(true);
  }
}
