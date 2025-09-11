// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:empire_ios/DesktopVersion/DesktopOrderHome/DesktopOrderHomeDrawer.dart';
import 'package:empire_ios/DesktopVersion/DesktopOrderHome/OrderHomeListItemWise.dart';
import 'package:empire_ios/DesktopVersion/DesktopOrderHome/OrderHomeListItemWiseBoxSystem.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../screen/EMPIRE/Myf.dart';

class DesktopOrderHome extends StatefulWidget {
  var UserObj;
  DesktopOrderHome({Key? key, required this.UserObj}) : super(key: key);
  @override
  State<DesktopOrderHome> createState() => _DesktopOrderHomeState();
}

class _DesktopOrderHomeState extends State<DesktopOrderHome> {
  final StreamController<int> searchFilterChange = StreamController<int>.broadcast();
  var currentIndex = 0;

  bool loading = true;
  @override
  void initState() {
    super.initState();
    searchFilterChange.stream.listen((event) {
      setState(() {
        currentIndex = event;
      });
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Align(alignment: Alignment.centerLeft, child: Text("ORDER HOME")),
      ),
      drawer: DesktopOrderHomeDrawer(searchFilterChange: searchFilterChange),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    child: buildWidget(),
                  ),
                )
              ],
            )),
    );
  }

  Widget buildWidget() {
    switch (currentIndex) {
      case 0:
        return OrderHomeListItemWiseBox(UserObj: widget.UserObj);
      case 1:
        return OrderHomeListItemWise(UserObj: widget.UserObj);
      case 2:
        return Text("2");
      default:
        return Container(
          child: Text("A"),
        ); // Default widget if no match is found
    }
  }

  void getData() async {
    await syncData(widget.UserObj, "ORDER");
    setState(() {
      loading = false;
    });
  }

  Future syncData(UserObj, collectionName) async {
    var orderLocalSyncTime = "0";
    orderLocalSyncTime = Myf.getValFromSavedPref(UserObj, "${collectionName}orderLocalSyncTime") == ""
        ? "0"
        : Myf.getValFromSavedPref(UserObj, "${collectionName}orderLocalSyncTime");
    var databaseId = Myf.databaseId(UserObj);
    logger.i(databaseId);
    //---start hive
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("ORDER")
        .where("r_time", isGreaterThan: orderLocalSyncTime)
        .snapshots()
        .listen((event) async {
      var snp = await event.docs;
      if (snp.length > 0) {
        Myf.showBlurLoading(context);
        logger.d(orderLocalSyncTime);
        var box = await Hive.openBox("${databaseId}$collectionName");
        await Future.wait(snp.map((e) async {
          final id = e.id;
          dynamic d = e.data();
          await box.put(id, d);
        }).toList());
        await box.close();
        orderLocalSyncTime = await DateTime.now().millisecondsSinceEpoch.toString();
        await Myf.saveValToSavedPref(UserObj, "${collectionName}orderLocalSyncTime", orderLocalSyncTime);
        await mainHiveStreamBox!.put("key", "value");
        Navigator.pop(context);
      }
    });
  }
}
