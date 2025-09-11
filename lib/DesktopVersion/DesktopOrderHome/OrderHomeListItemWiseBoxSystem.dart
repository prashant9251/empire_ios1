// ignore_for_file: must_be_immutable

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderHomeListItemWiseBox extends StatefulWidget {
  var UserObj;

  OrderHomeListItemWiseBox({Key? key, this.UserObj}) : super(key: key);

  @override
  State<OrderHomeListItemWiseBox> createState() => _OrderHomeListItemWiseBoxState();
}

class _OrderHomeListItemWiseBoxState extends State<OrderHomeListItemWiseBox> {
  List<dynamic> OrderList = [];

  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: somthingHaschange.stream,
        builder: (context, snapshot) {
          return loading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Wrap(
                      children: [
                        ...qualList
                            .map((e) => OrderHomeListItemWiseBoxSystem(UserObj: widget.UserObj, Ordertransaction: transaction, qualname: e))
                            .toList(),
                      ],
                    ),
                  ],
                );
        });
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
    transaction = [];
    qualList = [];
    dynamic flgQualList = {};
    var databaseId = await Myf.databaseId(widget.UserObj);

    await Hive.openBox('${databaseId}ORDER').then((value) async {
      OrderList = await value.values.toList();
      await Future.wait(OrderList.map((e) async {
        List billDetails = e["billDetails"];
        e["orderDispatch"] = e["dispatch"];
        await Future.wait(billDetails.map((b) async {
          Map<String, dynamic> obj = {...b, ...e};
          transaction.add(obj);
          if (!flgQualList[obj["qualname"]].toString().contains("true")) {
            qualList.add(obj["qualname"]);
            flgQualList[obj["qualname"]] = true;
          }
        }).toList());
      }).toList());
      // logger.d(qualList);
    });
    qualList.sort((a, b) {
      return ((a)).compareTo((b));
    });
    loading = false;
    somthingHaschange.sink.add(true);
  }
}

class OrderHomeListItemWiseBoxSystem extends StatefulWidget {
  var UserObj;
  List Ordertransaction;

  var qualname;

  OrderHomeListItemWiseBoxSystem({Key? key, required this.UserObj, required this.Ordertransaction, required this.qualname}) : super(key: key);

  @override
  State<OrderHomeListItemWiseBoxSystem> createState() => _OrderHomeListItemWiseBoxSystemState();
}

class _OrderHomeListItemWiseBoxSystemState extends State<OrderHomeListItemWiseBoxSystem> {
  var loading = true;
  List<DataRow> rows = [];

  List snp = [];

  @override
  Widget build(BuildContext context) {
    loading = false;
    snp = [];
    snp = widget.Ordertransaction.where((d) {
      return d["qualname"] == widget.qualname && d["dispatch"] == "N";
    }).toList();
    return snp.length == 0
        ? SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            width: kIsWeb ? MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width,
            height: 400,
            child: Column(
              children: [
                Chip(label: Text("${widget.qualname}")),
                StreamBuilder(
                    stream: somthingHaschange.stream,
                    builder: (context, snapshot) {
                      return loading ? Center(child: CircularProgressIndicator()) : tabled();
                    }),
              ],
            ),
          );
  }

  Widget tabled() {
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
              ...snp.map((e) {
                if (e["qualname"] == "BLACK BERRY") {}
                return DataRow(cells: [
                  DataCell(Row(children: [
                    IconButton(onPressed: () => PdfApi.createPdfAndView(ORDER: e, context: context), icon: Icon(Icons.print)),
                    Text('${e["BK_DATE"]}')
                  ])),
                  DataCell(Text('${e["partyname"]}')),
                  DataCell(Text('${e["qty"]}')),
                  DataCell(Text('${e["rate"]}/-')),
                  DataCell(Text('${e["pack"]}')),
                  DataCell(Text('${e["productRemark"]}')),
                  DataCell(GestureDetector(
                      onTap: () async {
                        List billDetails = [...e["billDetails"]];
                        var allDispatch = "N";
                        billDetails = await Future.wait(billDetails.map((c) async {
                          if (c["qualname"] == e["qualname"]) {
                            c["dispatch"] = c["dispatch"] == "Y" ? "N" : "Y";
                          }
                          if (c["dispatch"] == "Y") {
                            allDispatch = "Y";
                          } else {}
                          return c;
                        }).toList());
                        var dt = DateTime.now();
                        Map<String, dynamic> obj = {};
                        obj["billDetails"] = billDetails;
                        obj["cu_time_milli"] = dt.millisecondsSinceEpoch;
                        obj["r_time"] = dt.millisecondsSinceEpoch.toString();

                        obj["dispatch"] = allDispatch;
                        await fireBCollection
                            .collection("supuser")
                            .doc(widget.UserObj["CLIENTNO"])
                            .collection("ORDER")
                            .doc("${e["OrderID"]}")
                            .update(obj);
                      },
                      child: Chip(label: Text('${e["dispatch"]}')))),
                ]);
              }).toList(),

              // Add more rows as needed
            ],
          ),
        ),
      ),
    );
  }
}
