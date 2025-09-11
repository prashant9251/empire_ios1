import 'dart:convert';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/AddNewproduct.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductCard.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/shareOption.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class ProductJsonList extends StatefulWidget {
  var UserObj;
  var QUAL_LIST_PRE;
  ProductJsonList({Key? key, required this.UserObj, this.QUAL_LIST_PRE}) : super(key: key);

  @override
  State<ProductJsonList> createState() => _ProductJsonListState();
}

class _ProductJsonListState extends State<ProductJsonList> {
  List<dynamic> QUL_LIST = [];
  List<dynamic> QUL_LIST_MAIN = [];

  var loading = true;

  var searchCtrl = TextEditingController();

  var searchMainCtrl = TextEditingController();
  var searchFabrics = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Product"),
        actions: [
          StreamBuilder(
            stream: shareButtonBool.stream,
            builder: (context, snapshot) {
              var boolShowShare = snapshot.data.toString().contains("true");
              return boolShowShare
                  ? badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -1, end: -1),
                      showBadge: true,
                      ignorePointer: false,
                      onTap: () {},
                      badgeContent: Text("${tempSelectImglist.length}"),
                      badgeAnimation: badges.BadgeAnimation.scale(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
                        loopAnimation: false,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                      ),
                      child: ElevatedButton.icon(
                          label: Text("Share"),
                          onPressed: () {
                            ShareOption.showModelShare(context, productList: tempSelectImglist);
                          },
                          icon: Icon(Icons.share)),
                    )
                  //
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (tempSelectImglist.length > 0) {
            tempSelectImglist = [];
            shareImgObjList.sink.add(tempSelectImglist);
            shareButtonBool.sink.add(false);
            return false;
          }
          return true;
        },
        child: Column(
          children: [
            Card(
                color: Color.fromARGB(255, 221, 212, 212),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(29.5)),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {});
                    },
                    controller: searchCtrl,
                    decoration: const InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
                  ),
                )),
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        if (searchCtrl.text.isNotEmpty) {
                          QUL_LIST = QUL_LIST_MAIN.where((element) {
                            return element["label"].toString().toUpperCase().startsWith(searchCtrl.text.toUpperCase().trim());
                          }).toList();
                        } else {
                          QUL_LIST = QUL_LIST_MAIN;
                        }

                        return ListView.builder(
                          itemCount: QUL_LIST.length, // add one to the itemCount to display a loading indicator at the end
                          itemBuilder: (BuildContext context, int index) {
                            var ID = "${QUL_LIST[index]["value"].toString().toUpperCase().trim()}";
                            QUL_LIST[index]["ID"] = ID;
                            var QUL_OBJ = imgFirebaseObjById[QUL_LIST[index]["ID"]];
                            Map<dynamic, dynamic> QO = QUL_LIST[index];
                            if (QUL_OBJ != null) {
                              Map<dynamic, dynamic> QO = Map.from(QUL_OBJ);
                              Map<dynamic, dynamic> QOI = Map.from(QUL_LIST[index]);
                              QO.addAll(QOI);
                            }
                            if (QUL_LIST[index]["label"].toString().toUpperCase().contains(searchCtrl.text.trim().toUpperCase())) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.pop(context, QO);
                                  },
                                  child: ProductCard(UserObj: widget.UserObj, QulObj: QO));
                            } else {
                              Text("No data Found");
                            }
                          },
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    //print("====================${widget.QUAL_LIST_PRE}");
    if (widget.QUAL_LIST_PRE == null) {
      var databasId = await Myf.databaseId(widget.UserObj);
      var Qul = await Myf.GetFromLocal(["${databasId}QUL"], HiveBox: currentHiveBox);
      QUL_LIST_MAIN = [];
      if (Qul != null) {
        QUL_LIST_MAIN = await jsonDecode(Qul);
        try {} catch (e) {}
      }
    } else {
      QUL_LIST_MAIN = await (widget.QUAL_LIST_PRE);
    }
    QUL_LIST = QUL_LIST_MAIN;

    setState(() {
      loading = false;
    });
  }
}
