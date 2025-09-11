import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:hive/hive.dart';

class CrmSync {
  static Future<void> syncFolloupList() async {
    // var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    // var localSyncTimeResource = (await hiveMainBox.get("${databaseId}CRM_FOLLOW_UP_LIST_TIME") ?? "0").toString();
    // var dt = await DateTime.now();
    // syncEmpire_OrderSnapShot = await fireBCollection
    //     .collection("supuser")
    //     .doc(GLB_CURRENT_USER["CLIENTNO"])
    //     .collection("CRM")
    //     .doc("DATABASE")
    //     .collection("followUpList")
    //     .where("mTime", isGreaterThan: localSyncTimeResource)
    //     .get()
    //     .then((event) async {
    //   var snp = event.docs;
    //   if (snp.length > 0) {
    //     if (localSyncTimeResource == "0") {
    //       LazyBox Resource = await Hive.openLazyBox("${databaseId}CRM_FOLLOW_UP_LIST");
    //       await Resource.deleteFromDisk();
    //       await hiveMainBox.put("${databaseId}CRM_FOLLOW_UP_LIST_TIME", dt.toString());
    //     }
    //     LazyBox Resource = await Hive.openLazyBox("${databaseId}CRM_FOLLOW_UP_LIST");
    //     await Future.wait(snp.map((e) async {
    //       var id = e.id;
    //       dynamic d = await e.data();
    //       await Resource.put(id, d);
    //     }).toList());
    //     await Resource.close();
    //     await hiveMainBox.put("${databaseId}CRM_FOLLOW_UP_LIST_TIME", dt.toString());
    //   }
    // });
  }
}
