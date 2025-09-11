import 'dart:convert';

import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SyncLocalFunction {
  static Future<void> onlyOrderFetch() async {
    var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    var localSyncTimeEMP_ORDER = (await hiveMainBox.get("${databaseId}EMP_ORDER") ?? "0").toString();
    var dt = await DateTime.now();
    syncEmpire_OrderSnapShot = await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .where("mTime", isGreaterThan: localSyncTimeEMP_ORDER)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        if (localSyncTimeEMP_ORDER == "0") {
          Box EMP_ORDER = await openBoxCheckByYearWise("EMP_ORDER");
          await EMP_ORDER.clear();
          await hiveMainBox.put("${databaseId}EMP_ORDER", dt.toString());
        }
        Box EMP_ORDER = await openBoxCheckByYearWise("EMP_ORDER");
        await Future.wait(snp.map((e) async {
          var id = e.id;
          dynamic d = await e.data();
          await EMP_ORDER.put(id, d);
        }).toList());
        if (EMP_ORDER.isOpen) {
          await EMP_ORDER.compact();
          await EMP_ORDER.close();
        }
        await hiveMainBox.put("${databaseId}EMP_ORDER", dt.toString());
      }
    });

    var localSyncTimeEMP_ORDER_DELETE = (await hiveMainBox.get("${databaseId}EMP_ORDER_DELETED") ?? "0").toString();
    dt = await DateTime.now();
    syncEmpire_Order_DeleteSnapShot = await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER_DELETED")
        .where("dTime", isGreaterThan: localSyncTimeEMP_ORDER_DELETE)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        Box EMP_ORDER = await openBoxCheckByYearWise("EMP_ORDER");
        await Future.wait(snp.map((e) async {
          var id = e.id;
          dynamic d = await e.data();
          await EMP_ORDER.delete(d["ide"]);
        }).toList());

        await EMP_ORDER.compact();
        await EMP_ORDER.close();
        await hiveMainBox.put("${databaseId}EMP_ORDER_DELETED", dt.toString());
      }
    });
  }

  static Future<void> onlyEMP_MSTFetch() async {
    try {
      var databaseId = Myf.databaseId(GLB_CURRENT_USER);
      var localSyncTimeEMP_MST = await hiveMainBox.get("${databaseId}EMP_MST") ?? 0;
      var dt = await DateTime.now().millisecondsSinceEpoch;

      await fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMP_MST")
          .where("mtime", isGreaterThan: localSyncTimeEMP_MST)
          .get()
          .then((event) async {
        var snp = event.docs;
        if (snp.length > 0) {
          if (localSyncTimeEMP_MST == 0) {
            LazyBox EMP_MST = await openLazyBoxCheck("EMP_MST");
            await EMP_MST.deleteFromDisk();
            await hiveMainBox.put("${databaseId}EMP_MST", dt);
          }
          LazyBox EMP_MST = await openLazyBoxCheck("EMP_MST");
          await Future.wait(snp.map((e) async {
            var id = e.id;
            dynamic d = await e.data();
            List<int> decodedBytes = base64Decode(d["data"]);
            d = null;
            String dJsonString = await utf8.decode(decodedBytes);
            decodedBytes.clear();
            dynamic j = await jsonDecode(dJsonString);
            dJsonString = "";
            await EMP_MST.put(id, j);
          }).toList());
          await EMP_MST.compact();
          await EMP_MST.close();
          snp.clear();
          await hiveMainBox.put("${databaseId}EMP_MST", dt);
        }
      });
    } catch (e) {}
  }

  static syncGallery() async {
    var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);

    Box galleryBox = await openBoxCheck("gallery");
    var localSyncTimegallery = await hiveMainBox.get("${databaseId}gallery") ?? "0";
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("gallery")
        .where("mTime", isGreaterThanOrEqualTo: localSyncTimegallery)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (localSyncTimegallery == "0") {
        await galleryBox.clear();
      }
      if (snp.length > 0) {
        await Future.wait(snp.map((e) async {
          var id = e.id;
          await galleryBox.put(id, e.data());
        }).toList());
        // events.close();
      }
    });
    // need GalleryDeleted
    var localSyncTimegalleryDeleted = await hiveMainBox.get("${databaseId}galleryDeleted") ?? "0";
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("galleryDeleted")
        .where("mTime", isGreaterThanOrEqualTo: localSyncTimegalleryDeleted)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        await Future.wait(snp.map((e) async {
          var id = e.id;
          await galleryBox.delete(id);
          // events.close();
        }).toList());
      }
    });
    // if (galleryBox.isOpen) {
    //   await galleryBox.compact();
    //   await galleryBox.close();
    // }
  }

  static void refreshLocalHive(collectionName) async {
    // somthingHaschange.sink.add("true");
    await mainHiveStreamBox!.put("key", "value");
  }

  static Future getDatFromHive({collectionName, UserObj}) async {
    var databaseId = Myf.databaseId(UserObj);
    var Data = [];
    await Hive.openBox("${databaseId}$collectionName").then((value) async {
      Data = [];
      var data = value.values;
      await Future.wait(data.map((e) async {
        Data.add(e);
      }).toList());
      await value.compact();
      await value.close();
    });
    return Data;
  }

  static Future<Box> openBoxCheckByNameID(boxName) async {
    var boxKey = "$boxName";

    if (await Hive.isBoxOpen(boxKey)) {
      // If the box is open, return the already open box
      try {
        return Hive.box(boxKey);
      } catch (e) {
        return await Hive.openBox(boxKey);
      }
    } else {
      // If the box is not open, open it and return the box
      var box = await Hive.openBox(boxKey);
      return box;
    }
  }

  static Future<Box> openBoxCheck(boxName) async {
    var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER) ?? "";
    var boxKey = "$databaseId$boxName";

    if (await Hive.isBoxOpen(boxKey)) {
      // If the box is open, return the already open box
      try {
        return Hive.box(boxKey);
      } catch (e) {
        return await Hive.openBox(boxKey);
      }
    } else {
      // If the box is not open, open it and return the box
      var box = await Hive.openBox(boxKey);
      return box;
    }
  }

  //
  static closeOpenBox(boxName) async {
    var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    var boxKey = "$databaseId$boxName";
    if (await Hive.isBoxOpen(boxKey)) {
      await Hive.box(boxKey).close();
    }
  }

  static Future<Box> openBoxCheckByYearWise(boxName) async {
    var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    var boxKey = "$databaseId$boxName";

    if (await Hive.isBoxOpen(boxKey)) {
      // If the box is open, return the already open box
      try {
        return Hive.box(boxKey);
      } catch (e) {
        return await Hive.openBox(boxKey);
      }
    } else {
      // If the box is not open, open it and return the box
      try {
        return await Hive.openBox(boxKey);
      } catch (e) {
        return await Hive.box(boxKey);
      }
    }
  }

  static Future<LazyBox> openLazyBoxCheckByYearWise(boxName) async {
    var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    var boxKey = "$databaseId$boxName";

    if (await Hive.isBoxOpen(boxKey)) {
      // If the box is open, return the already open box
      try {
        return Hive.lazyBox(boxKey);
      } catch (e) {
        return await Hive.openLazyBox(boxKey);
      }
    } else {
      // If the box is not open, open it and return the box
      try {
        return await Hive.openLazyBox(boxKey);
      } catch (e) {
        return await Hive.lazyBox(boxKey);
      }
    }
  }

  static openLazyBoxCheck(boxName) async {
    LazyBox box;
    var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);
    var boxKey = "$databaseId$boxName";
    if (await Hive.isBoxOpen("$databaseId$boxName")) {
      try {
        box = Hive.lazyBox("$databaseId$boxName");
      } catch (e) {
        box = await Hive.openLazyBox("$databaseId$boxName");
      }
    } else {
      box = await Hive.openLazyBox("$databaseId$boxName");
    }
    return box;
  }
}
