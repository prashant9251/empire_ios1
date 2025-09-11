import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/material.dart';

class OrderFormList extends StatefulWidget {
  var UserObj;

  var args;

  OrderFormList({Key? key, required this.UserObj, required this.args}) : super(key: key);

  @override
  State<OrderFormList> createState() => _OrderFormListState();
}

class _OrderFormListState extends State<OrderFormList> {
  var searchpartycode = "";
  var searchbroker = "";
  var searchFIRM = "";
  var searchcity = "";
  var searchhaste = "";
  var searchqualname = "";
  var dispatchCondition = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() {
    searchpartycode = widget.args[0]["partycode"] ?? "";
    searchbroker = widget.args[0]["broker"] ?? "";
    searchFIRM = widget.args[0]["FIRM"] ?? "";
    searchcity = widget.args[0]["city"] ?? "";
    searchhaste = widget.args[0]["haste"] ?? "";
    searchqualname = widget.args[0]["qualname"] ?? "";
    dispatchCondition = widget.args[0]["dispatchCondition"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> list = fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("ORDER");
    if (searchpartycode.isNotEmpty) {
      list = list.where("partyname", isEqualTo: searchpartycode);
    }
    if (searchbroker.isNotEmpty) {
      list = list.where("broker", isEqualTo: searchbroker);
    }
    // if (searchFIRM.isNotEmpty) {
    //   list = list.where("FIRM", isEqualTo: searchFIRM);
    // }

    list = list.orderBy("BK_DATE", descending: true);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Order List"),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: list.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return Center(child: Text("No data"));
              } else {
                var snp = snapshot.data!.docs;

                if (snp.length > 0) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snp.length,
                      itemBuilder: (context, index) {
                        dynamic d = snp[index].data();
                        List<Map<String, dynamic>> billDetails = [...d["billDetails"]];
                        return Card(
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(width: MediaQuery.of(context).size.width * .5, child: Text("${d["partyname"]}")),
                                  Text(
                                    "OrderNo : ${d["OrderNo"]}",
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date : ${Myf.dateFormate(d["BK_DATE"])}",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text("City : ${d["city"]}"),
                                  Text("STATION : ${d["BK_STATION"]}"),
                                  Text("TRANSPORT : ${d["BK_TRANSPORT"]}"),
                                  Text("BROKER : ${d["broker"]}"),
                                  Text("RMK : ${d["RMK"]}"),
                                ],
                              ),
                              children: [
                                ButtonBar(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          PdfApi.createPdfAndView(ORDER: d, context: context);
                                        },
                                        child: Icon(Icons.open_in_new)),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.red),
                                        ),
                                        onPressed: () async {
                                          Myf.deleteOrderToFirestore([d["OrderID"]], context, UserObj: widget.UserObj);
                                        },
                                        child: Icon(Icons.delete)),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(
                                        children: [
                                          TableCell(child: Text('ITEM')),
                                          TableCell(child: Text('QTY')),
                                          TableCell(child: Text('RATE')),
                                          TableCell(child: Text('PACK')),
                                          TableCell(child: Text('TYPE')),
                                        ],
                                      ),
                                      ...billDetails.map((p) {
                                        return TableRow(
                                          children: [
                                            TableCell(child: Text('${p["qualname"]}')),
                                            TableCell(child: Text('${p["qty"]}')),
                                            TableCell(child: Text('${p["rate"]}')),
                                            TableCell(child: Text('${p["pack"]}')),
                                            TableCell(child: Text('${p["ptype"]}')),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(child: Text("No data found"));
                }
              }
            },
          )
        ],
      ),
    );
  }
}
