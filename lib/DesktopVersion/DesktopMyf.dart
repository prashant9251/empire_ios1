
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:hive/hive.dart';

class DesktopMyf {
  static startSync({DUserObj}) async {
    DUserObj["customerDBname"] = DUserObj["customerDBname"];
    var databaseId = Myf.databaseId(DUserObj);
    var desktopLocalSyncTimeInMilli =
        Myf.getIntFromSavedPref(DUserObj, "desktopLocalSyncTimeInMilli") == "" ? 0 : Myf.getIntFromSavedPref(DUserObj, "desktopLocalSyncTimeInMilli");
    var desktopLocalSyncDeleteTimeInMilli = Myf.getIntFromSavedPref(DUserObj, "desktopLocalSyncDeleteTimeInMilli") == ""
        ? 0
        : Myf.getIntFromSavedPref(DUserObj, "desktopLocalSyncDeleteTimeInMilli");
    await Hive.openBox('${databaseId}ORDER');
    desktopLocalSyncTimeInMilli = 0;
    await fireBCollection
        .collection("supuser")
        .doc(DUserObj["CLIENTNO"])
        .collection("ORDER")
        .where("c_time_milli", isGreaterThan: desktopLocalSyncTimeInMilli)
        .snapshots()
        .listen((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        final box = Hive.box('${databaseId}ORDER');
        await Future.wait(snp.map((e) async {
          final id = e.id;
          dynamic d = e.data();
          box.put(id, d);
        }).toList());
      }
      DesktopOrderChangeStream.sink.add(true);
      Myf.saveIntToSavedPref(DUserObj, "desktopLocalSyncTimeInMilli", DateTime.now().millisecondsSinceEpoch);
    });
    //--------created data Sync done
    await fireBCollection
        .collection("supuser")
        .doc(DUserObj["CLIENTNO"])
        .collection("ORDER")
        .where("u_time_milli", isGreaterThan: desktopLocalSyncTimeInMilli)
        .snapshots()
        .listen((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        final box = await Hive.box('${databaseId}ORDER');
        await Future.wait(snp.map((e) async {
          final id = e.id;
          dynamic d = e.data();
          box.put(id, d);
        }).toList());
      }
      DesktopOrderChangeStream.sink.add(true);
      Myf.saveIntToSavedPref(DUserObj, "desktopLocalSyncTimeInMilli", DateTime.now().millisecondsSinceEpoch);
    });

    //--------created data Sync done
    await fireBCollection
        .collection("supuser")
        .doc(DUserObj["CLIENTNO"])
        .collection("ORDER_DELETED")
        .where("d_time_milli", isGreaterThan: desktopLocalSyncDeleteTimeInMilli)
        .snapshots()
        .listen((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        final box = Hive.box('${databaseId}ORDER');
        await Future.wait(snp.map((e) async {
          final id = e.id;
          box.delete(id);
        }).toList());
      }
      DesktopOrderChangeStream.sink.add(true);
      Myf.saveIntToSavedPref(DUserObj, "desktopLocalSyncDeleteTimeInMilli", DateTime.now().millisecondsSinceEpoch);
    });
  }
}
