// ignore_for_file: must_be_immutable

import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/OfficeRequestTabs.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeSearchList/OfficeSearchList.dart';
import 'package:empire_ios/Models/ResponseSuggetionsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/addNewUniqueClientRequest/addNewUniqueClientRequest.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqinstallRequest/uniqinstallRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var followUpTypes = [];
List<ResponseSuggetionsModel> responseSuggetions = [];

class OfficeDeshBoard extends StatefulWidget {
  var UserObj;

  OfficeDeshBoard({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<OfficeDeshBoard> createState() => _OfficeDeshBoardState();
}

class _OfficeDeshBoardState extends State<OfficeDeshBoard> {
  var currentIndex = 0;
  changeIndex(i) {
    setState(() {
      currentIndex = i;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // syncData(widget.UserObj, "UserResponseReq");
    // /softwares/EMPIRE/followUpTypes
    fireBCollection.collection("softwares").doc("EMPIRE").collection("followUpTypes").orderBy("ID").snapshots().listen((event) {
      followUpTypes = event.docs.map((e) => e.id).toList();
      followUpTypes.insert(0, "");
    });
    fireBCollection.collection("softwares").doc("EMPIRE").collection("responseSuggetions").snapshots().listen((event) {
      responseSuggetions = [];
      event.docs.map((e) {
        dynamic d = e.data();
        ResponseSuggetionsModel r = ResponseSuggetionsModel.fromMap(d);
        responseSuggetions.add(r);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Office Panel(${widget.UserObj["login_user"]})"),
        actions: [
          IconButton(onPressed: () => Myf.Navi(context, UniqinstallRequest(UserObj: widget.UserObj)), icon: Icon(Icons.new_label)),
          ElevatedButton(
              onPressed: () => Myf.Navi(context, AddNewUniqueClientRequest(UserObj: widget.UserObj, userDataObj: {})), child: Text("New Req")),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Follow Up Types", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: followUpTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(followUpTypes[index]),
                    onTap: () {
                      // Handle tap
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Container(width: MediaQuery.of(context).size.width * (kIsWeb ? .3 : .8), child: OfficeSearchList(UserObj: widget.UserObj)),
      body: OfficeRequestTabs(UserObj: widget.UserObj),
    );
  }

  // void syncData(UserObj, collectionName) async {
  //   var orderLocalSyncTime = Myf.getValFromSavedPref(UserObj, "${collectionName}orderLocalSyncTime") == ""
  //       ? "0"
  //       : Myf.getValFromSavedPref(UserObj, "${collectionName}orderLocalSyncTime");
  //   await fireBCollection.collection("$collectionName").where("m_time", isGreaterThan: orderLocalSyncTime).snapshots().listen((event) async {
  //     var snp = event.docs;
  //     logger.i("${snp.length}====synced==$collectionName");
  //     if (snp.length > 0) {
  //       Myf.showBlurLoading(context);
  //       var box = await Hive.openBox("$collectionName");
  //       await Future.wait(snp.map((e) async {
  //         final id = e.id;
  //         dynamic d = e.data();
  //         await box.put(id, d);
  //       }).toList());
  //       await box.close();
  //       orderLocalSyncTime = await DateTime.now().millisecondsSinceEpoch.toString();
  //       Myf.saveValToSavedPref(UserObj, "${collectionName}orderLocalSyncTime", orderLocalSyncTime);
  //       mainHiveStreamBox!.put("key", "value");
  //       Navigator.pop(context);
  //     }
  //   });
  // }
}
