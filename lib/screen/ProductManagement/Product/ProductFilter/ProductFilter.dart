import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFilter/ProductTable.dart';
import 'package:flutter/material.dart';

class ProductFilter extends StatefulWidget {
  var UserObj;
  List<ProductModel> LID_LIST;
  ProductFilter({Key? key, required this.UserObj, required this.LID_LIST}) : super(key: key);

  @override
  State<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  var ctrlSearchName = TextEditingController();

  List lid_List_ForFinalSubmit = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("PRODUCT FILTER"),
        actions: [
          ElevatedButton(
            onPressed: () => applyFilter(),
            child: Text("Apply Filter"),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(child: ProductTableSelection(LID_LIST: widget.LID_LIST)),
          StreamBuilder(
              stream: searchFilterChange.stream,
              builder: (context, snapshot) {
                var l = widget.LID_LIST;
                var selectedList = widget.LID_LIST.where((element) {
                  return "${element.selected}".contains("true");
                }).toList();
                var showWarning = "";
                if (selectedList.length >= 10) {
                  showWarning = "Please select maximum 10 Product Name tag";
                }
                if (l == null) return SizedBox.shrink();
                if (l.length > 0) {
                  lid_List_ForFinalSubmit = [];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Set the border color
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "$showWarning",
                          style: TextStyle(color: Colors.red),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start, // Align boxes to the start of each line
                          children: [
                            ...widget.LID_LIST.map((e) {
                              var label = e.qualModel!.label; //Myf.getQulObjectFromListByCode(ARR: widget.LID_LIST, hashcodeId: e);
                              if ("${e.selected}".contains("true")) {
                                lid_List_ForFinalSubmit.add(e.lID);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 3, bottom: 3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("${label}"),
                                        InkWell(
                                            onTap: () {
                                              selectIt(e, false);
                                            },
                                            child: Icon(Icons.cancel))
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.fromSize();
                }
              }),
        ]),
      ),
    );
  }

  selectIt(ProductModel d, status) {
    widget.LID_LIST.map((e) {
      if (e.qualModel!.label == d.qualModel!.label) {
        e.selected = status;
      }
    }).toList();
    // setState(() {});
    searchFilterChange.sink.add("search");
  }

  applyFilter() async {
    filterProductTag_LIDList.sink.add(lid_List_ForFinalSubmit);
    Navigator.pop(context, lid_List_ForFinalSubmit);
  }
}
