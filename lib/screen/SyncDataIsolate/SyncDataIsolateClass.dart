import 'dart:convert';
import 'dart:io';

import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/EMPIRE/urlDataAg.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

HeadlessInAppWebView? headlessWebView;

class DownloadData {
  final String appStorage;
  final SendPort sendPort;
  dynamic UserObj;
  var url;
  var fastSync;
  DownloadData(this.UserObj, this.appStorage, this.sendPort, this.url, this.fastSync);
}

class GetDataModel {
  final SendPort sendPort;
  dynamic UserObj;
  String key;
  String hivePath;
  String keyName;
  GetDataModel(this.UserObj, this.sendPort, this.key, this.hivePath, this.keyName);
}

Future<bool> SaveToLocalByKeyValIsolate(dynamic data) async {
  try {
    var appStoragePath = data["appStoragePath"];
    dynamic UserObj = data["UserObj"];
    String key = data["key"];
    final jsonArray = await jsonDecode(data["value"]) as List<dynamic>;
    Hive.init(appStoragePath);
    var CuHiveBox = await Hive.openLazyBox(key);
    // await CuHiveBox.compact();
    if (CuHiveBox.isOpen) {
      await CuHiveBox.deleteFromDisk();
      CuHiveBox = await Hive.openLazyBox(key);
      if (CuHiveBox.isOpen) {
        await CuHiveBox.put(key, jsonArray);
        await saveByKeyInBox(key, jsonArray, CuHiveBox, UserObj: UserObj);
        await CuHiveBox.compact();
        await CuHiveBox.close();
      }
    }
    return true;
  } catch (e) {
    logger.d(e);
    return false;
  }
}

// Future<bool> SaveToLocalByKeyValIsolateMst(dynamic data) async {
//   try {
//     var appStoragePath = data["appStoragePath"];
//     String key = data["key"];
//     final jsonArray = await jsonDecode(data["value"]) as List<dynamic>;
//     Hive.init(appStoragePath);
//     var CuHiveBox = await Hive.openLazyBox(key);
//     // await CuHiveBox.compact();
//     await CuHiveBox.deleteFromDisk();
//     CuHiveBox = await Hive.openLazyBox<MasterModel>(key);
//     await Future.wait(jsonArray.map((e) async {
//       MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(e));
//       CuHiveBox.put(masterModel.value, masterModel);
//     }).toList());
//     await CuHiveBox.close();
//     return true;
//   } catch (e) {
//     logger.d(e);
//     return false;
//   }
// }

isolateLocalSave(DownloadData data) async {
  var keyfileName = "";
  final UserObj = data.UserObj;
  var zipFilePath = data.appStorage;
  var sendPort = data.sendPort;

  LoginUserModel _loginUserModel = LoginUserModel.fromJson(UserObj);
  var CLNT = _loginUserModel.cLIENTNO;
  var FILE_NAME = _loginUserModel.fILENAME;

  if (!File(zipFilePath).existsSync()) {
    return;
  }

  File zipFile = File(zipFilePath);
  var bytes = zipFile.readAsBytesSync();

  var databaseId = Myf.databaseId(UserObj);

  Hive.init(zipFile.parent.path);
  Archive archive = ZipDecoder().decodeBytes(bytes);

  // count only JSON files
  final jsonFiles = archive.where((f) => f.isFile && f.name.endsWith(".json")).toList();
  int total = jsonFiles.length;
  int processed = 0;

  for (var file in jsonFiles) {
    var filePath = '${zipFile.parent.path}/${file.name}';
    var content = file.content;
    var jsondata = utf8.decode(content);
    keyfileName = file.name.replaceAll(".json", "").trim();

    if (jsondata.isNotEmpty) {
      var key = "${databaseId}${file.name}".replaceAll(".json", "");
      try {
        final jsonArray = jsonDecode(jsondata) as List<dynamic>;
        var CuHiveBox = await Hive.openLazyBox(key);
        if (CuHiveBox.isOpen) {
          await CuHiveBox.deleteFromDisk();
          CuHiveBox = await Hive.openLazyBox(key);
          if (CuHiveBox.isOpen) {
            await CuHiveBox.put(key, jsonArray);
            await saveByKeyInBox(key, jsonArray, CuHiveBox, UserObj: UserObj);
            jsonArray.clear();
            await CuHiveBox.compact();
            await CuHiveBox.close();
          }
        }
      } catch (e) {
        // handle JSON error if needed
      }
    }

    // ✅ Update progress after each file
    processed++;
    double percent = (processed / total) * 100;
    sendPort.send(percent);
  }
}

Future<void> saveByKeyInBox(String key, List<dynamic> jsonArray, LazyBox<dynamic> CuHiveBox, {required dynamic UserObj}) async {
  LoginUserModel _loginUserModel = LoginUserModel.fromJson(UserObj);
  if (key.toString().contains("MST") && !key.toString().contains("COMPMST")) {
    for (var element in jsonArray) {
      await CuHiveBox.put(element["value"], element);
    }
  } else if (key.toString().contains("BLS")) {
    for (var element in jsonArray) {
      List billDetails = element["billDetails"] ?? [];
      for (var bill in billDetails) {
        try {
          var date = _loginUserModel.softwareName.contains("TRADING") ? (bill['DATE'] ?? '') : bill["DTE"];
          var b = bill['BAMT'];
          var billAmt = double.tryParse(b) ?? 0.0;
          DateTime recordDate;
          try {
            recordDate = DateFormat('yyyy-MM-dd').parse(date);
          } catch (e) {
            continue;
          }
          DateTime today = DateTime.now();
          if (recordDate.isAfter(today.subtract(Duration(days: 30))) &&
              recordDate.isBefore(today.add(Duration(days: 1))) &&
              bill["DT"].toString().toUpperCase().contains("OS")) {
            await CuHiveBox.put("${bill["IDE"]}", bill);
          }
        } catch (e) {}
      }
    }
  }
}

Future<File?> downLoadZip(DownloadData data) async {
  final UserObj = data.UserObj; // Replace with the actual user object
  var filePath = data.appStorage;
  var sendPort = data.sendPort;
  LoginUserModel _loginUserModel = LoginUserModel.fromJson(UserObj);
  var CLNT = _loginUserModel.cLIENTNO;
  var FILE_NAME = _loginUserModel.fILENAME;
  var url = data.url;
  DateTime now = DateTime.now();
  url = url + "&time=$now";
  var progressbar = 0.0;
  sendPort.send({"downloadprogress": progressbar});
  File? file = null;
  file = await File(filePath);
  try {
    var response = await Dio().get(
      url,
      onReceiveProgress: (count, total) {
        progressbar = ((count / total) * 1);
        sendPort.send({"downloadprogress": progressbar});
      },
      options: Options(
        // followRedirects: false,
        responseType: ResponseType.bytes,
        // validateStatus: (status) {
        //   return status! < 500;
        // },
      ),
    );
    if (response.statusCode == 200) {
      final raf = await file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } else {
      var responseStatusCode = "";
      sendPort.send({"error": "1-${response.statusCode}"});
    }
    // return file;
  } catch (e) {
    file = null;
    sendPort.send({"error": "2-${e}"});
  }
  sendPort.send(file);

  return file;
}

iniIsolateHive(List<dynamic> args) async {
  SendPort sendPort = args[0];
  String appStoragePath = args[1];
  Hive.init(appStoragePath);
  sendPort.send("message");
}

void hiveIsolateMain(List<dynamic> args) async {
  SendPort sendPort = args[0];
  var appDocumentDirectory = args[1];
  Hive.init(appDocumentDirectory);

  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is Map) {
      final key = message['key'];

      final box = await Hive.openBox(key);
      dynamic data = box.get(key, defaultValue: []);
      sendPort.send(data);
    }
  });
}
