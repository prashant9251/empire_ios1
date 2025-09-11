import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/EMPIRE/urlDataAg.dart';
import 'package:empire_ios/screen/SyncDataIsolate/SyncDataIsolateClass.dart';
import 'package:empire_ios/screen/SyncDataIsolate/cubit/SyncDataIsolateState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;
import 'package:encrypt/encrypt.dart' as enc;

class SyncDataIsolateCubit extends Cubit<SyncDataIsolateState> {
  BuildContext context;
  List<Map<String, dynamic>> FileList = [];

  var databaseId = "";

  String? FILE_NAME = "";

  String? StorageType = "";

  String? firebaseUrl = "";

  String boolZipPassword = "";

  String? CLDB = "";
  var ctrlZipPassword = TextEditingController();

  String CLNT = "";

  String year = "";

  bool boolShowDetails = false;

  String responseStatusCode = "";

  File? zipFile = null;

  String url = "";

  var progress = 0.0;

  var savingProgress = 0.0;
  final receivePort = ReceivePort();

  SyncDataIsolateCubit(this.context) : super(SyncDataIsolateStateIni()) {
    loginUserModel = LoginUserModel.fromJson(GLB_CURRENT_USER);
    getData();
  }

  void getData({boolShowDetails}) async {
    emit(SyncDataIsolateStateDownloadProgressUpdate(1.0, 0, "", {}));
    receivePort.listen((dynamic message) async {
      if (message is File) {
        zipFile = message;
        if (zipFile == null) {
          // SyncStatus.sink.add("No file found");
          var nurl = url.substring(0, 10);
          // SyncStatus.sink.add("pls check internet conn. or try again letter $nurl $responseStatusCode");

          backgroundSyncInProcess = false;
        }
        await unArchiveAndSave();
        backgroundSyncInProcess = false;
        // receivePort.close();
      } else if (message is Map) {
        //print(message);
        if (message["downloadprogress"] != null) {
          progress = message["downloadprogress"];
          var stringProgress = "${(progress * 100).toInt()} %";
          emit(SyncDataIsolateStateDownloadProgressUpdate(progress, 0, "Downloading... ${("${stringProgress}")}", message));
        } else if (message["savingProgress"] != null) {
          savingProgress = message["savingProgress"];
          var stringsavingProgress = "${(savingProgress).toInt()} %";
          emit(SyncDataIsolateStateDownloadProgressUpdate(progress, savingProgress, "Saving... ${("${stringsavingProgress}")}", message));
          // await Future.delayed(Duration(milliseconds: 200));
          // emit(SyncDataIsolateStateDownloadProgressMap(message));
        }
      }
    });

    // SyncStatus.sink.add("please wait");
    backgroundSyncInProcess = true;
    kIsWeb ? null : await loadHeadLessWeb();
    FileList = [];

    // SyncStatus.sink.add("Checking");
    databaseId = await Myf.databaseId(GLB_CURRENT_USER);
    var autoSync = true;
    if (firebaseCurrntUserObj["autoSync"] != null && firebaseCurrntUserObj["autoSync"] != "") {
      autoSync = "${firebaseCurrntUserObj["autoSync"]}".contains("true") ? true : false;
      if (autoSync == false) {
        backgroundSyncInProcess = false;

        // SyncStatus.sink.add("Auto Sync Off");
        return;
      }
    }

    // var latestDataUpdateOn = widget.CURRENT_USER["latestDataUpdateOn"];
    FILE_NAME = loginUserModel.fILENAME;
    StorageType = loginUserModel.storageType;
    var extraPathSelected = loginUserModel.extraPathSelected;
    var privateNetWorkSync = loginUserModel.privateNetWorkSync;
    backgroundSyncInProcessForCompanyYear = "${loginUserModel.sHOPNAME} -${loginUserModel.yearVal}";
    dynamic extraPathLIST_MAIN = {};
    try {
      extraPathLIST_MAIN = jsonDecode(loginUserModel.extraPathLISTMAIN!);
    } catch (e) {}
    dynamic extraPathLIST_USER = {};
    try {
      extraPathLIST_USER = (extraPathLIST_MAIN[extraPathSelected]);
    } catch (e) {}
    var onlineTimeInMili = "0";
    firebaseUrl = loginUserModel.firebaseUrl;
    try {
      if (firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"] != null && firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"] != "") {
        onlineTimeInMili = "${firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"]}";
        onlineTimeInMili = onlineTimeInMili == "null" || onlineTimeInMili == "" ? "0" : onlineTimeInMili;
        if (firebaseCurrntSupUserObj["${FILE_NAME}_URL"] != null && firebaseCurrntSupUserObj["${FILE_NAME}_URL"] != "") {
          firebaseUrl = "${firebaseCurrntSupUserObj["${FILE_NAME}_URL"]}";
        }
      } else {
        if (extraPathLIST_USER["timeInMili"] != null && extraPathLIST_USER["timeInMili"] != "") {
          onlineTimeInMili = extraPathLIST_USER["timeInMili"];
          onlineTimeInMili = onlineTimeInMili == "" ? "0" : onlineTimeInMili;
        }
      }
    } catch (e) {}
    boolZipPassword = loginUserModel.zipPassword ?? "";
    CLDB = loginUserModel.encdb;
    if (CLDB == null) {
      backgroundSyncInProcess = false;
      return;
    }
    // var lastUpdatetimeLocal = Myf.getValFromSavedPref(GLB_CURRENT_USER, "lastUpdatetime");
    var localTimeInMili = Myf.getValFromSavedPref(GLB_CURRENT_USER, "localTimeInMili");
    localTimeInMili = localTimeInMili == null || localTimeInMili == "" ? "0" : localTimeInMili;
    ctrlZipPassword.text = Myf.getValFromSavedPref(GLB_CURRENT_USER, "zipPassword");
    // lastUpdateDateControl.sink.add(lastUpdatetimeLocal);
    CLNT = stringToBase64.decode(CLDB.toString());
    var ServerLocation = loginUserModel.android;
    year = loginUserModel.yearVal.toString().replaceAll("-", "");
    url =
        "https://$ServerLocation/CLIENT/zipacs.php?year=${year}&FILE_NAME=${FILE_NAME}&CLNT=$CLNT&CLDB=$CLDB&flname=$CD&extraPath=$extraPathSelected";
    if (firebaseUrl != null && firebaseUrl != "" && firebaseUrl != "null") {
      url = firebaseUrl!;
    }
    var miliLastUpdateTimeOnline = int.parse("$onlineTimeInMili");
    var mililastUpdatetimeLocal = int.parse("$localTimeInMili");

    // //print("$miliLastUpdateTime====$mililastUpdatetimeLocal===databaseId=$databaseId");

    if (miliLastUpdateTimeOnline <= mililastUpdatetimeLocal) {
      SyncStatus.sink.add("");
      // final appStorage = await getApplicationDocumentsDirectory();
      // File file = await File("${appStorage.path}/$CLNT${FILE_NAME}$databaseId.zip");
      // if (File(file.path).existsSync()) {
      //   await unArchiveAndSave(file, CLDB, year, widget.setLastUpdateDate);
      // var api = widget.CURRENT_USER["api"];
      // var Ltoken = widget.CURRENT_USER["Ltoken"];
      // SyncStatus.sink.add("");
      // url =
      //     "https://$privateNetworkIp/$LFolder/js/$api$CLDB$Ltoken/$FILE_NAME/zipacs.php?year=${year}&FILE_NAME=${FILE_NAME}&CLNT=$CLNT&CLDB=$CLDB&flname=";
      if (boolShowDetails == true) {
      } else {
        backgroundSyncInProcess = false;

        return;
      }
    }
    // if (!widget.HiveBox!.isOpen) {
    //   widget.HiveBox = await Myf.openHiveBox(databaseId);
    // }
    if (privateNetWorkSync.toString().contains("true")) {
      var ENC = "";
      if (boolZipPassword.isNotEmpty) {
        ENC = "_ENC";
      }
      var privateNetworkIp = Myf.getPrivateNetWorkIp(GLB_CURRENT_USER);
      // privateNetworkIp =
      var LFolder = loginUserModel.lFolder;
      var extraPath = loginUserModel.extraPathSelected != null && loginUserModel.extraPathSelected.toString().isNotEmpty
          ? loginUserModel.extraPathSelected
          : LFolder;
      //print("===================================/$extraPath/${loginUserModel.extraPathSelected}===");

      url = "http://$privateNetworkIp/$extraPath/zipacs.php?FILE_NAME=$FILE_NAME&CLNT=$CLNT&CLDB=$CLDB&Musertoken=$CLDB&ENC=$ENC";
    }
    // SyncStatus.sink.add("");
    try {} catch (e) {
      // SyncStatus.sink.add("");
    }
    // SyncStatus.sink.add("");
    if (kIsWeb) {
      return;
    }
    // download();
  }

  // void download() async {
  //   emit(SyncDataIsolateStateDownloadProgressUpdate(1.0, 0, "Starting download", {}));
  //   final appStorage = await getApplicationDocumentsDirectory();

  //   DownloadData downloadData = DownloadData(GLB_CURRENT_USER, appStorage.path, receivePort.sendPort, "", false);

  //   switch (StorageType!.toUpperCase()) {
  //     case "AWS":
  //       compute(downloadFileFromS3, downloadData);
  //       break;
  //     default:
  //       compute(downloadFileFromS3, downloadData);
  //   }
  // }

  unArchiveAndSave() async {
    var keyfileName = "";
    if (!zipFile!.existsSync()) {
      SyncStatus.sink.add("File Not Found");
      return;
    }
    if (boolZipPassword.isEmpty) {
    } else {
      File? outputFile = null;
      final appStorage = await getApplicationDocumentsDirectory();
      outputFile = await File("${appStorage.path}/${databaseId}_DNC.zip");
      zipFile = await decryptFile(inputFile: zipFile!.path, outputFile: outputFile.path);
      try {} catch (e) {
        Myf.snakeBar(context, "$e");
        // showInputBoxForPasswordZip();
        SyncStatus.sink.add("$e");
        backgroundSyncInProcess = false;
        return;
      }
    }
    if (!headlessWebView!.isRunning()) {
      await headlessWebView?.run();
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    // processListSyncdone.sink.close();
    var _dir = (await getApplicationDocumentsDirectory()).path;
    var bytes = await zipFile!.readAsBytesSync();
    var s = await zipFile!.lengthSync();
    DownloadData downloadData = DownloadData(GLB_CURRENT_USER, zipFile!.path, receivePort.sendPort, "", false);
    compute(isolateLocalSave, downloadData);
    if (!IosPlateForm) {
      if (await headlessWebView!.isRunning()) {
        String base64String = await base64.encode(bytes);
        await headlessWebView?.webViewController!
            .evaluateJavascript(source: "fileSave('${databaseId}','base64','${base64String}');")
            .then((value) {});
        await Future.delayed(const Duration(milliseconds: 1000));
        return;
      }
    }
  }

  Future<File> decryptFile({required String inputFile, required String outputFile}) async {
    // Load the key and IV from files
    var mainKey = "${CLNT}${loginUserModel.api}${loginUserModel.ltoken}${loginUserModel.encdb}${CLNT}";
    var keyString = "key_$mainKey";
    var ivString = "iv_$mainKey";

    Uint8List keyData = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
    Uint8List ivData = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));

    final key = enc.Key(keyData);
    final iv = enc.IV(ivData);

    // Read the encrypted file into memory
    final encryptedData = await File(inputFile).readAsBytesSync();
    // Decrypt the data using the key and IV
    final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
    final decryptedData = await encrypter.decryptBytes(enc.Encrypted(encryptedData), iv: iv);
    // Write the decrypted data to the output file
    File(outputFile).writeAsBytesSync(decryptedData);
    return await File(outputFile);
  }

  Future loadHeadLessWeb() async {
    var runingServer = await localhostServer.isRunning();
    if (!runingServer) {
      await localhostServer.start();
      runingServer = await localhostServer.isRunning();
    }
    var url = urldata.headLessSync;
    var software_name = loginUserModel.softwareName.toString();
    if (software_name.contains("AGENCY")) {
      url = urldataAG.headLessSync;
    }
    headlessWebView = await new HeadlessInAppWebView(
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        // allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: IosPlateForm ? true : false,
      )),
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onWebViewCreated: (controller) async {
        controller.addJavaScriptHandler(
            handlerName: 'SaveToLocal',
            callback: (args) async {
              return await Myf.SaveToLocal(args);
            });
        controller.addJavaScriptHandler(
            handlerName: 'GetFromLocal',
            callback: (args) async {
              return await Myf.GetFromLocal(args);
            });
        //---------save date
        controller.addJavaScriptHandler(
            handlerName: 'setToTime',
            callback: (args) async {
              var timeJson = (args[1]);
              ////print(timeJson);
              var timeForUpdate = "";
              var timeForUpdateInMili = "";
              if (timeJson.length > 0) {
                try {
                  timeForUpdate = await timeJson[0]["TIME"];
                  timeForUpdateInMili = await timeJson[0]["timeInMili"];

                  // SyncStatus.sink.add("");
                  await Myf.saveValToSavedPref(GLB_CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
                  await Myf.saveValToSavedPref(GLB_CURRENT_USER, "lastUpdatetime", timeForUpdate);
                  lastUpdateDateControl.sink.add(timeForUpdate);

                  backgroundSyncInProcess = false;
                } catch (e) {
                  // SyncStatus.sink.add(e.toString());
                }
              }
            });
        //---------ShowProgress
        controller.addJavaScriptHandler(
            handlerName: 'showOnSyncData',
            callback: (args) async {
              double progress = double.parse("${args[2]}");
              FileList.add({"key": args[0], "size": args[1], "save": true});
              // SyncStatus.sink.add("${loginUserModel.yearVal} Saving ${progress}%");
              var timeJson = (args[3]);
              ////print(timeJson);
              var timeForUpdate = "";
              var timeForUpdateInMili = "";
              if (progress >= 100) {
                if (timeJson.length > 0) {
                  try {
                    timeForUpdate = await timeJson[0]["TIME"];
                    timeForUpdateInMili = await timeJson[0]["timeInMili"];
                    await Myf.saveValToSavedPref(GLB_CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
                    await Myf.saveValToSavedPref(GLB_CURRENT_USER, "lastUpdatetime", timeForUpdate);
                    lastUpdateDateControl.sink.add(timeForUpdate);
                    backgroundSyncInProcess = false;
                  } catch (e) {
                    // SyncStatus.sink.add(e.toString());
                  }
                }
              }
            });
      },
      onConsoleMessage: (controller, consoleMessage) {
        //print(consoleMessage);
      },
      onLoadStart: (controller, url) async {},
      onLoadStop: (controller, url) async {},
    );
    if (!headlessWebView!.isRunning()) {
      await headlessWebView?.run();
    }
  }
}
