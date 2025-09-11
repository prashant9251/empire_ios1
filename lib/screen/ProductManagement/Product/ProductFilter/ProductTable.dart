import 'dart:async';

import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class ProductTableSelection extends StatefulWidget {
  List<ProductModel> LID_LIST;

  ProductTableSelection({Key? key, required this.LID_LIST}) : super(key: key);

  @override
  State<ProductTableSelection> createState() => _ProductTableSelectionState();
}

class _ProductTableSelectionState extends State<ProductTableSelection> {
  var ctrlSearchName = TextEditingController();
  var ctrlFromRate = TextEditingController();
  var ctrlToRate = TextEditingController();
  var ctrlSearchMainScreen = TextEditingController();
  var ctrlOrderBy = TextEditingController(text: "");
  var ctrlSearchFabric = TextEditingController();

  var ctrlCategory = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Color.fromARGB(255, 217, 214, 214), borderRadius: BorderRadius.circular(29.5)),
                      child: TextFormField(
                        onChanged: (value) {
                          searchFilterChange.sink.add("search");
                        },
                        controller: ctrlSearchName,
                        decoration: InputDecoration(icon: Icon(Icons.search), hintText: "PRODUCT NAME", border: InputBorder.none),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Color.fromARGB(255, 244, 242, 242), borderRadius: BorderRadius.circular(29.5)),
                      child: TextFormField(
                        onChanged: (value) {
                          searchFilterChange.sink.add("search");
                        },
                        controller: ctrlSearchMainScreen,
                        decoration: InputDecoration(hintText: "MAIN SCREEN", border: InputBorder.none),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Color.fromARGB(255, 244, 242, 242), borderRadius: BorderRadius.circular(29.5)),
                      child: TextFormField(
                        onChanged: (value) {
                          searchFilterChange.sink.add("search");
                        },
                        controller: ctrlSearchFabric,
                        decoration: InputDecoration(hintText: "FABRICS", border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text("Extra filters"),
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 217, 214, 214), borderRadius: BorderRadius.circular(29.5)),
                          child: TextFormField(
                            onChanged: (value) {
                              searchFilterChange.sink.add("search");
                            },
                            controller: ctrlFromRate,
                            decoration: InputDecoration(icon: Icon(Icons.search), hintText: "FROM RATE", border: InputBorder.none),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 244, 242, 242), borderRadius: BorderRadius.circular(29.5)),
                          child: TextFormField(
                            onChanged: (value) {
                              searchFilterChange.sink.add("search");
                            },
                            controller: ctrlToRate,
                            decoration: InputDecoration(hintText: "TO RATE", border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 217, 214, 214), borderRadius: BorderRadius.circular(29.5)),
                          child: TextFormField(
                            onChanged: (value) {
                              searchFilterChange.sink.add("search");
                            },
                            controller: ctrlCategory,
                            decoration: InputDecoration(icon: Icon(Icons.search), hintText: "CATEGORY", border: InputBorder.none),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 244, 242, 242), borderRadius: BorderRadius.circular(29.5)),
                          child: Text("ORDER BY"),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 217, 214, 214), borderRadius: BorderRadius.circular(29.5)),
                          child: StreamBuilder(
                              stream: searchFilterChange.stream,
                              builder: (context, snapshot) {
                                return DropdownButton(
                                    value: ctrlOrderBy.text,
                                    hint: Text("Select Req"),
                                    items: [
                                      "",
                                      "label",
                                      "S1",
                                      "S2",
                                      "S3",
                                      "FS",
                                    ]
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (var val) {
                                      ctrlOrderBy.text = val.toString();
                                      searchFilterChange.sink.add("search");
                                    });
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        StreamBuilder<Object>(
            stream: searchFilterChange.stream,
            builder: (context, snapshot) {
              var LID_LIST = widget.LID_LIST.where((element) => element.qualModel!.label != null).toList();
              if (ctrlSearchName.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return "${element.qualModel!.label}".startsWith(ctrlSearchName.text.toUpperCase());
                }).toList();
              }
              if (ctrlSearchMainScreen.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return "${element.qualModel!.mainScreen}".startsWith(ctrlSearchMainScreen.text.toUpperCase());
                }).toList();
              }
              if (ctrlSearchFabric.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return "${element.qualModel!.baseQual}".startsWith(ctrlSearchFabric.text.toUpperCase());
                }).toList();
              }
              if (ctrlCategory.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return "${element.qualModel!.category}".startsWith(ctrlCategory.text.toUpperCase());
                }).toList();
              }

              if (ctrlFromRate.text.isNotEmpty && ctrlToRate.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return Myf.toIntVal("${element.qualModel!.s1}") >= Myf.toIntVal(ctrlFromRate.text) &&
                      Myf.toIntVal("${element.qualModel!.s1}") <= Myf.toIntVal(ctrlToRate.text);
                }).toList();
              } else if (ctrlFromRate.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return Myf.toIntVal("${element.qualModel!.s1}") >= Myf.toIntVal(ctrlFromRate.text);
                }).toList();
              } else if (ctrlToRate.text.isNotEmpty) {
                LID_LIST = LID_LIST.where((element) {
                  return Myf.toIntVal("${element.qualModel!.s1}") <= Myf.toIntVal(ctrlToRate.text);
                }).toList();
              }
              if (ctrlOrderBy.text.isNotEmpty) {
                if (ctrlOrderBy.text == "FS") {
                  LID_LIST.sort(
                    (a, b) {
                      int aVal = int.parse(Myf.nullC(a.qualModel!.finishStock) == "" ? "0" : a.qualModel!.finishStock!);
                      int bVal = int.parse(Myf.nullC(b.qualModel!.finishStock) == "" ? "0" : b.qualModel!.finishStock!);
                      return bVal.compareTo(aVal);
                    },
                  );
                } else {
                  LID_LIST.sort(
                    (a, b) {
                      return a.qualModel!.toJson()["${ctrlOrderBy.text}"].toString().compareTo(b.qualModel!.toJson()["${ctrlOrderBy.text}"]);
                    },
                  );
                }
              } else {
                LID_LIST.sort(
                  (a, b) {
                    return a.qualModel!.label.toString().compareTo("${b.qualModel!.label}");
                  },
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    border: TableBorder.all(color: Colors.grey),
                    columnSpacing: 1,
                    // horizontalMargin: 2,
                    sortAscending: true,
                    // showCheckboxColumn: false, // Hide the header checkbox
                    columns: [
                      DataColumn(
                        label: Container(child: Text('Stock(FS)')),
                      ),
                      DataColumn(
                        label: Container(child: Text('Name Tag')),
                      ),
                      DataColumn(
                        label: Text('MAIN SCREEN'),
                      ),
                      DataColumn(
                        label: Text('FABRIC'),
                      ),
                      DataColumn(
                        label: Text('CATEGORY'),
                      ),
                      DataColumn(
                        label: Text('RATE1(S1)'),
                      ),
                      DataColumn(
                        label: Text('RATE2(S2)'),
                      ),
                      DataColumn(
                        label: Text('RATE3(S3)'),
                      ),
                    ],
                    rows: LID_LIST.map((e) {
                      return DataRow(
                        selected: "${e.selected}".contains("true"),
                        onSelectChanged: (value) => selectIt(e, value),
                        cells: [
                          DataCell(Text(
                            "${e.qualModel!.finishStock}",
                            style: colorBaseOnStock("${e.qualModel!.finishStock}"),
                          )),
                          DataCell(Text("${e.qualModel!.label}")),
                          DataCell(Text("${e.qualModel!.mainScreen}".toString())),
                          DataCell(Text("${e.qualModel!.baseQual}")),
                          DataCell(Text("${e.qualModel!.category}")),
                          DataCell(Text("${e.qualModel!.s1}")),
                          DataCell(Text("${e.qualModel!.s2}")),
                          DataCell(Text("${e.qualModel!.s3}")),
                        ],
                      );
                    }).toList()),
              );
            }),
      ],
    );
  }

  selectIt(ProductModel d, status) async {
    var labelID = d.lID;
    var selectedList = widget.LID_LIST.where((element) {
      return "${element.selected}".contains("true");
    }).toList();
    await Future.wait(widget.LID_LIST.map((e) async {
      var ID = e.lID;
      if (ID == labelID) {
        e.selected = selectedList.length >= 10 ? false : !"${e.selected}".contains("true");
      }
    }).toList());
    selectedList = (widget.LID_LIST.where((element) {
      return "${element.selected}".contains("true");
    }).toList());

    searchFilterChange.sink.add("search");
    filterProductTagList.sink.add(widget.LID_LIST);
  }

  TextStyle colorBaseOnStock(e) {
    double stock = Myf.convertToDouble(e);
    if (stock <= 0) {
      return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    }
    return TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
  }
}
