import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/EMPIRE/urlDataAg.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'dart:math' as math;

import 'package:encrypt/encrypt.dart' as enc;

import 'screen/EMPIRE/Myf.dart';
import 'screen/SyncDataIsolate/SyncDataIsolateClass.dart';

var zipPasswordApply = "";

class SyncdataFetch extends StatefulWidget {
  SyncdataFetch({Key? key, required this.CURRENT_USER, this.boolShowDetails}) : super(key: key);
  dynamic CURRENT_USER;
  var boolShowDetails;
  @override
  State<SyncdataFetch> createState() => _SyncdataFetchState();
}

class _SyncdataFetchState extends State<SyncdataFetch> {
  String responseStatusCode = "";
  var boolZipPassword = "";
  var StorageType = "";
  var databaseId;
  var ctrlZipPassword = TextEditingController();
  HeadlessInAppWebView? headlessWebView;
  final StreamController<double> progressIsolateSyncStream = StreamController<double>.broadcast();
  final StreamController<double> progressbarDownload = StreamController<double>.broadcast();
  final StreamController<double> progressFileStatus = StreamController<double>.broadcast();
  List<Map<String, dynamic>> FileList = [];
  double progressProcess = 0;
  bool dataSynced = false;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  File? zipFile;
  var CLDB = "";
  String year = "";

  String CLNT = "";

  var FILE_NAME = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // red as border color
            ),
            borderRadius: BorderRadius.circular(10), // radius of 10
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<double>(
                      stream: progressbarDownload.stream,
                      builder: (context, snapshot) {
                        double snp = 0.0;
                        try {
                          snp = snapshot.data ?? 0.0;
                        } catch (e) {
                          snp = 0.0;
                        }
                        if (snp > 0) {
                          var progress = snapshot.data ?? 0.0;
                          return LinearProgressIndicator(value: progress, color: HexColor(ColorHex));
                        } else {
                          return SizedBox.fromSize();
                        }
                      }),
                  widget.boolShowDetails == true
                      ? StreamBuilder<List<Map<String, dynamic>>>(
                          stream: processListSyncdone.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Map<String, dynamic>>? L = snapshot.data;
                              if (L!.length > 0) {
                                var sr = 0;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ListView.builder(
                                        // physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: L.length,
                                        itemBuilder: (context, index) {
                                          int size = L[index]["size"];
                                          bool save = L[index]["save"];
                                          sr += 1;
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text("$sr ${L[index]["key"]}")),
                                              save ? SizedBox.shrink() : Icon(Icons.close, color: Colors.red),
                                              size > 0 ? Icon(Icons.done) : Icon(Icons.close, color: Colors.red),
                                            ],
                                          );
                                        }),
                                    Text(
                                      "${boolZipPassword.isNotEmpty ? " Secure by encryption" : ""} Total: ${L.length}",
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                );
                              } else {
                                return SizedBox.fromSize();
                              }
                            } else {
                              return SizedBox.fromSize();
                            }
                          })
                      : SizedBox.shrink(),
                  SizedBox(height: 5),
                  StreamBuilder(
                      stream: progressFileStatus.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var progress = double.parse(snapshot.data.toString());
                          return LinearProgressIndicator(value: progress, color: HexColor(ColorHex));
                        } else {
                          return SizedBox.fromSize();
                        }
                      }),
                  SizedBox(height: 4),
                  StreamBuilder(
                      stream: progressIsolateSyncStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var progress = double.parse(snapshot.data.toString());
                          return LinearProgressIndicator(value: progress, color: HexColor(ColorHex));
                        } else {
                          return SizedBox.fromSize();
                        }
                      }),
                  widget.boolShowDetails == true
                      ? StreamBuilder<String>(
                          stream: lastUpdateDateControl.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var lastUpdatetime = Myf.getValFromSavedPref(widget.CURRENT_USER, "lastUpdatetime");

                              return Column(
                                children: [
                                  Text("Last Sync${lastUpdatetime.toString()}"),
                                  ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back), label: Text("OK"))
                                ],
                              );
                            } else {
                              return SizedBox.fromSize();
                            }
                          },
                        )
                      : SizedBox.shrink(),
                  StreamBuilder<String>(
                    stream: SyncStatus.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.contains("syncing")) {
                          return SizedBox.fromSize();
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            style: TextStyle(color: Colors.red),
                          );
                        }
                      } else {
                        return SizedBox.fromSize();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  Future<void> getData() async {
    if (backgroundSyncInProcess) return;
    backgroundSyncInProcess = true;

    Future.delayed(Duration(minutes: 4), () {
      backgroundSyncInProcess = false;
    });
    SyncStatus.sink.add("please wait");
    FileList = [];
    SyncStatus.sink.add("Checking");
    databaseId = await Myf.databaseId(widget.CURRENT_USER);
    autoSync = Myf.autoSyncIs();
    if (autoSync == false) {
      backgroundSyncInProcess = false;
      SyncStatus.sink.add("Auto Sync Off");
      return;
    }
    // var latestDataUpdateOn = widget.CURRENT_USER["latestDataUpdateOn"];
    FILE_NAME = widget.CURRENT_USER["FILE_NAME"];
    StorageType = firebaseCurrntSupUserObj["StorageType"] ?? widget.CURRENT_USER["StorageType"];

    var extraPathSelected = widget.CURRENT_USER["extraPathSelected"];
    var privateNetWorkSync = widget.CURRENT_USER["privateNetWorkSync"];
    backgroundSyncInProcessForCompanyYear = "${widget.CURRENT_USER["SHOPNAME"]} -${widget.CURRENT_USER["yearVal"]}";
    dynamic extraPathLIST_MAIN = {};
    try {
      extraPathLIST_MAIN = jsonDecode(widget.CURRENT_USER["extraPathLIST_MAIN"] == "" ? "{}" : widget.CURRENT_USER["extraPathLIST_MAIN"]);
    } catch (e) {
      // backgroundSyncInProcess = false;
    }
    dynamic extraPathLIST_USER = {};
    try {
      extraPathLIST_USER = (extraPathLIST_MAIN[extraPathSelected]);
    } catch (e) {
      // backgroundSyncInProcess = false;
    }
    var onlineTimeInMili = "0";
    String? firebaseUrl = widget.CURRENT_USER["firebaseUrl"];
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
    } catch (e) {
      backgroundSyncInProcess = false;
    }
    zipPasswordApply = firebaseCurrntSupUserObj["zipPasswordApply"] ?? "0";

    boolZipPassword = widget.CURRENT_USER["zipPassword"] ?? "";
    CLDB = widget.CURRENT_USER["encdb"];
    // var lastUpdatetimeLocal = Myf.getValFromSavedPref(widget.CURRENT_USER, "lastUpdatetime");
    var localTimeInMili = Myf.getValFromSavedPref(widget.CURRENT_USER, "localTimeInMili");
    print("====localTimeInMili==${localTimeInMili}");
    print("====onlineTimeInMili==${onlineTimeInMili}");
    localTimeInMili = localTimeInMili == null || localTimeInMili == "" ? "0" : localTimeInMili;
    ctrlZipPassword.text = Myf.getValFromSavedPref(widget.CURRENT_USER, "zipPassword");
    // lastUpdateDateControl.sink.add(lastUpdatetimeLocal);
    CLNT = stringToBase64.decode(CLDB);
    var ServerLocation = firebaseCurrntSupUserObj["ServerLocation"] ?? widget.CURRENT_USER["android"];
    year = widget.CURRENT_USER["yearVal"].toString().replaceAll("-", "");
    var url =
        "https://$ServerLocation/CLIENT/zipacs.php?year=${year}&FILE_NAME=${FILE_NAME}&CLNT=$CLNT&CLDB=$CLDB&flname=$CD&extraPath=$extraPathSelected";
    if (firebaseUrl != null && firebaseUrl != "" && firebaseUrl != "null") {
      //log("====firebaseUrl==${firebaseUrl}");
      url = firebaseUrl;
    }
    var miliLastUpdateTimeOnline = int.parse("$onlineTimeInMili");
    var mililastUpdatetimeLocal = int.parse("$localTimeInMili");

    // //print("$miliLastUpdateTime====$mililastUpdatetimeLocal===databaseId=$databaseId");

    if (miliLastUpdateTimeOnline <= mililastUpdatetimeLocal) {
      // SyncStatus.sink.add("");
      // final appStorage = await getApplicationDocumentsDirectory();
      // File file = await File("${appStorage.path}/$CLNT${FILE_NAME}$databaseId.zip");
      // if (File(file.path).existsSync()) {
      //   await unArchiveAndSave(file, CLDB, year, widget.setLastUpdateDate);
      // var api = widget.CURRENT_USER["api"];
      // var Ltoken = widget.CURRENT_USER["Ltoken"];
      SyncStatus.sink.add("");
      // url =
      //     "https://$privateNetworkIp/$LFolder/js/$api$CLDB$Ltoken/$FILE_NAME/zipacs.php?year=${year}&FILE_NAME=${FILE_NAME}&CLNT=$CLNT&CLDB=$CLDB&flname=";
      if (widget.boolShowDetails == true) {
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
      var privateNetworkIp = Myf.getPrivateNetWorkIp(widget.CURRENT_USER);
      // privateNetworkIp =
      var LFolder = "";
      if (firebaseCurrntUserObj['LFolder'] != null) {
        LFolder = "${firebaseCurrntUserObj['LFolder']}";
      } else {
        LFolder = "${widget.CURRENT_USER["LFolder"]}";
      }
      loginUserModel.lFolder = LFolder;
      var extraPath = widget.CURRENT_USER["extraPathSelected"] != null && widget.CURRENT_USER["extraPathSelected"].toString().isNotEmpty
          ? widget.CURRENT_USER["extraPathSelected"]
          : LFolder;
      //print("===================================/$extraPath/${widget.CURRENT_USER["extraPathSelected"]}===");

      url = "http://$privateNetworkIp/$extraPath/zipacs.php?FILE_NAME=$FILE_NAME&CLNT=$CLNT&CLDB=$CLDB&Musertoken=$CLDB&ENC=$ENC";
    }
    SyncStatus.sink.add("");
    // if (kIsWeb) {
    //   backgroundSyncInProcess = false;
    //   // downloadBackupProcessForWeb(url);
    //   return;
    // }
    final receivePort = ReceivePort();
    var downloadCompute;
    kIsWeb ? null : await loadHeadLessWeb();
    if (privateNetWorkSync.toString().contains("true")) {
      final appStorage = await getApplicationDocumentsDirectory();
      var f = await File("${appStorage.path}/$CLNT${FILE_NAME}$databaseId.zip");
      zipFile = await downLoadZipFile(url, "$CLNT${FILE_NAME}$databaseId.zip");
    } else if (kIsWeb) {
      await downloadSyncForWeb();
      return;
    } else if (StorageType == "" || StorageType == null) {
      zipFile = await downLoadZipFile(url, "$CLNT${FILE_NAME}$databaseId.zip");
    } else if (StorageType.toString().toUpperCase() == "AWS1") {
      zipFile = await downloadFileAmplify();
    } else {
      zipFile = await downloadFileFromS3File();
    }
    if (zipFile == null) {
      backgroundSyncInProcess = false;
      SyncStatus.sink.add("No file found");
      SyncStatus.sink.add("pls check internet conn. or try again letter $responseStatusCode");

      return;
    }
    await unArchiveAndSave(zipFile!, CLDB, year);
    backgroundSyncInProcess = false;
  }

  Future<File?> downloadFileAmplify() async {
    try {
      var s3Key = "public/CLNT/$CLNT/$CLNT$FILE_NAME.zip";

      var appStorage = await getApplicationDocumentsDirectory();
      File file = await File("${appStorage.path}/${CLNT}$FILE_NAME.zip");
      try {
        await Amplify.Storage.downloadFile(
          path: StoragePath.fromString(s3Key),
          localFile: AWSFile.fromPath(file.path),
          onProgress: (p0) {
            // _logger.debug('Progress: ${(p0.transferredBytes / p0.totalBytes) * 100}%')
            double progress = p0.transferredBytes / p0.totalBytes;
            int progressBar = (p0.transferredBytes / p0.totalBytes * 100).toInt();
            progressbarDownload.sink.add(progress);
            SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${(progressBar)}%");
          },
        ).result;
      } on StorageException catch (e) {
        // _logger.error('Download error - ${e.message}');
      }
      return file;
    } catch (e) {
      backgroundSyncInProcess = false;
      responseStatusCode = "4-${e}";
      // SyncStatus.sink.add("4-${e}");
      Myf.noteError(e);
      return null;
    }
  }

  Future<File?> downloadFileFromS3File() async {
    try {
      // Validate environment variables
      var s3Key = "CLNT/$CLNT/$CLNT$FILE_NAME.zip";
      var receivedBytes = 0;
      var contentLength = -1;

      // Initialize progress
      progressbarDownload.sink.add(0);
      SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${(0)}%");

      final appStorage = await getApplicationDocumentsDirectory();
      final file = File("${appStorage.path}/${CLNT}$FILE_NAME.zip");

      try {
        // Download file using Amplify Storage
        await Amplify.Storage.downloadFile(
          path: StoragePath.fromString(s3Key),
          localFile: AWSFile.fromPath(file.path),
          onProgress: (progress) {
            receivedBytes = progress.transferredBytes;
            contentLength = progress.totalBytes;
            double progressValue = progress.transferredBytes / progress.totalBytes;
            int progressPercent = (progressValue * 100).toInt();

            progressbarDownload.sink.add(progressValue);
            SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${progressPercent}%");
          },
        ).result;

        return file;
      } on StorageException catch (e) {
        backgroundSyncInProcess = false;
        responseStatusCode = "3-${e.message}";
        Myf.noteError("3-${e.message}");
        return null;
      }
    } catch (e) {
      backgroundSyncInProcess = false;
      responseStatusCode = "4-${e}";
      - // SyncStatus.sink.add("4-${e}");
          Myf.noteError(e);
      return null;
    }
  }

  Future<File?> downLoadZipFile(String url, String name) async {
    DateTime now = DateTime.now();
    url = url + "&time=$now";
    var progressbar = 0.0;
    SyncStatus.sink.add("downloadprogress ${progressbar}");
    File? file = null;
    final appStorage = await getApplicationDocumentsDirectory();
    file = await File("${appStorage.path}/$name");
    try {
      var response = await Dio().get(
        url,
        onReceiveProgress: (count, total) {
          var progressbar = ((count / total) * 1);
          var progressbarString = ((count / total) * 100);
          progressbarDownload.sink.add(progressbar);
          SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${(progressbarString.toStringAsFixed(0))}%");
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
        backgroundSyncInProcess = false;
        responseStatusCode = "1-aws-${response.statusCode}";
        // SyncStatus.sink.add("1-${response.statusCode}");
      }
      // return file;
    } catch (e) {
      file = null;
      backgroundSyncInProcess = false;
      Myf.noteError(e);
      responseStatusCode = "2-${e}";
      // SyncStatus.sink.add("2-${e}");
    }
    return file;
  }

  Future<List<int>?> downloadSyncForWeb() async {
    var progressbar = 0.0;
    SyncStatus.sink.add("downloadprogress ${progressbar}");
    Uint8List? bytes;
    var s3Key = "public/CLNT/$CLNT/$CLNT$FILE_NAME.zip"; //
    try {
      try {
        // Download data from S3
        final result = await Amplify.Storage.downloadData(
          path: StoragePath.fromString(s3Key),
          onProgress: (progressEvent) {
            double progress = progressEvent.transferredBytes / progressEvent.totalBytes;
            int progressBar = (progressEvent.transferredBytes / progressEvent.totalBytes * 100).toInt();
            progressbarDownload.sink.add(progress);
            SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${progressBar}%");
          },
        ).result;
        bytes = Uint8List.fromList(result.bytes);
      } on StorageException catch (e) {}
      // return file;
    } catch (e) {
      bytes = null;
      backgroundSyncInProcess = false;
      Myf.noteError(e);
      responseStatusCode = "2-${e}";
      // SyncStatus.sink.add("2-${e}");
    }

    var b = null;
    if (boolZipPassword.isEmpty) {
      b = bytes!.toList();
    } else {
      try {
        b = await decryptData(bytes!);
        bytes = null;
        backgroundSyncInProcess = false;
      } catch (e) {
        backgroundSyncInProcess = false;
        // Myf.snakeBar(context, "unz-$e");
        // SyncStatus.sink.add("unz-$e");
      }
    }

    Uint8List? uint8 = await Uint8List.fromList(b);
    var fileProcessDone = 0;
    var timeForUpdate = "";
    var timeForUpdateInMili = "0";
    var keyfileName = "";
    try {
      Archive archive = await ZipDecoder().decodeBytes(uint8);
      uint8 = null;
      var totalFiles = await archive.length;
      for (var file in archive) {
        try {
          if (file.isFile) {
            var content = file.content;
            var jsondata = await utf8.decode(content);
            keyfileName = await file.name;
            keyfileName = await keyfileName.replaceAll(".json", "").trim();
            var jsondatasize = await jsondata.length;
            if (jsondatasize > 0 && file.name.toString().contains(".json")) {
              var saveStatus = false;
              var key = await "${databaseId}${file.name}".replaceAll(".json", "");
              List args = [];
              if ("${key}".contains("TIME")) {
                List timeJson = jsonDecode(jsondata);
                if (timeJson.length > 0) {
                  timeForUpdate = await timeJson[0]["TIME"];
                  try {
                    timeForUpdateInMili = await timeJson[0]["timeInMili"];
                  } catch (e) {
                    SyncStatus.sink.add(e.toString());
                  }
                  dataSynced = true;
                }
              }
              if (file.name.contains(".json")) {
                LazyBox CuHiveBox = await await Hive.openLazyBox(key);
                if (CuHiveBox.isOpen) {
                  final jsonArray = await jsonIsolate.decode(jsondata) as List<dynamic>;
                  await CuHiveBox.put(key, jsonArray);
                  await saveByKeyInBox(key, jsonArray, CuHiveBox, UserObj: widget.CURRENT_USER);
                  try {
                    await CuHiveBox.compact();
                  } catch (e) {}
                  try {
                    await CuHiveBox.close();
                  } catch (e) {}
                  jsonArray.clear();
                }
                // await Future.delayed(const Duration(milliseconds: 1000));
              }
              fileProcessDone += 1;
              var progressProcess = await fileProcessDone / totalFiles * 100;
              var progressProcessString = await fileProcessDone / totalFiles * 100;
              progressFileStatus.sink.add(progressProcess);
              // List json = await jsonDecode(jsondata);
              FileList.add({"key": keyfileName, "size": content.length, "save": saveStatus});
              processListSyncdone.sink.add(FileList);
              SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Saving ${(progressProcessString.toStringAsFixed(0))}%");
            }
          }
        } catch (e) {
          logger.d("${e.toString()}-${file.name}");
        }
      }

      await Myf.saveValToSavedPref(widget.CURRENT_USER, "lastUpdatetime", timeForUpdate);
      SyncStatus.sink.add("");
      await Myf.saveValToSavedPref(widget.CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
      backgroundSyncInProcess = false;

      lastUpdateDateControl.sink.add(timeForUpdate);
    } on Exception catch (e) {
      FileList.add({"key": "$keyfileName$e", "size": 0, "save": false});
      processListSyncdone.sink.add(FileList);
      //log(e.toString());
      backgroundSyncInProcess = false;
    }
    return b;
  }

  Future<List<int>?> decryptData(Uint8List? encryptedData) async {
    try {
      var mainKey =
          "${widget.CURRENT_USER["CLIENTNO"]}${widget.CURRENT_USER["api"]}${widget.CURRENT_USER["Ltoken"]}${widget.CURRENT_USER["encdb"]}${widget.CURRENT_USER["CLIENTNO"]}";

      var keyString = "key_$mainKey";
      var ivString = "iv_$mainKey";
      Uint8List keyData = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
      Uint8List ivData = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));

      final key = enc.Key(keyData);
      final iv = enc.IV(ivData);

      final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
      List<int>? decryptedData = await encrypter.decryptBytes(enc.Encrypted(encryptedData!), iv: iv);
      encryptedData = null;
      // Write the decrypted data to the output file

      return decryptedData;
    } catch (e) {
      backgroundSyncInProcess = false;
      return null;
    }
  }

  // Function to update the progress
  void updateProgress(var progress) {
    progressbarDownload.sink.add(progress);
    SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Downloading ${(progress * 100).toInt()}%");
  }

  void updateError(var error) {
    try {
      SyncStatus.sink.add("${error.toString().substring(0, 50)}");
    } catch (e) {
      SyncStatus.sink.add("${error.toString()}");
    }
    Myf.noteError(error);
  }

  Future<File?> decryptFile({required String inputFile, required String outputFile}) async {
    try {
      var mainKey =
          "${widget.CURRENT_USER["CLIENTNO"]}${widget.CURRENT_USER["api"]}${widget.CURRENT_USER["Ltoken"]}${widget.CURRENT_USER["encdb"]}${widget.CURRENT_USER["CLIENTNO"]}";

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
    } catch (e) {
      backgroundSyncInProcess = false;
      // Myf.snakeBar(context, "$e");
      // showInputBoxForPasswordZip();
      // SyncStatus.sink.add("$e");
      return null;
    }
  }

  unArchiveAndSave(File? zipFile, CLDB, year) async {
    var keyfileName = "";
    if (zipFile == null) {
      backgroundSyncInProcess = false;
      return;
    }
    if (!zipFile.existsSync()) {
      backgroundSyncInProcess = false;
      SyncStatus.sink.add("File Not Found");
      return;
    }
    if (boolZipPassword.isEmpty) {
    } else {
      File? outputFile = null;
      final appStorage = await getApplicationDocumentsDirectory();
      outputFile = await File("${appStorage.path}/${databaseId}_DNC.zip");
      try {
        zipFile = await decryptFile(inputFile: zipFile.path, outputFile: outputFile.path);
        // zip passowrd check
        if (zipPasswordApply == "1") {
          zipFile = await saveUnZipFileWithoutPassword(zipFile);
        }
        if (zipFile == null) {
          backgroundSyncInProcess = false;
          return;
        }
      } catch (e) {
        backgroundSyncInProcess = false;
        // Myf.snakeBar(context, "unz-$e");
        // SyncStatus.sink.add("unz-$e");
        return;
      }
    }
    final receivePort = ReceivePort();

    DownloadData downloadData = DownloadData(widget.CURRENT_USER, zipFile.path, receivePort.sendPort, "", false);
    try {
      // await headlessWebView?.dispose();
      if (!headlessWebView!.isRunning()) {
        await headlessWebView?.run();
      }
      await Future.delayed(const Duration(milliseconds: 1000));
      // processListSyncdone.sink.close();
      var _dir = (await getApplicationDocumentsDirectory()).path;
      var bytes = await zipFile.readAsBytesSync();
      // var s = await zipFile.lengthSync();
      if (!IosPlateForm) {
        receivePort.listen((message) {
          if (message is double) {
            print("Progress1: ${message.toStringAsFixed(2)}%");
            progressIsolateSyncStream.sink.add(message / 100);
          }
        });

        Isolate.spawn(isolateLocalSave, downloadData);
        if (await headlessWebView!.isRunning()) {
          String base64String = await base64.encode(bytes);
          await headlessWebView?.webViewController!
              .evaluateJavascript(source: "fileSave('${databaseId}','base64','${base64String}');")
              .then((value) {});
          await Future.delayed(const Duration(milliseconds: 1000));
          return;
        }
      }
      Archive archive = await ZipDecoder().decodeBytes(bytes);

      var fileProcessDone = 0;
      var totalFiles = await archive.length;
      var timeForUpdate = "";
      var timeForUpdateInMili = "0";
      for (var file in archive) {
        var filePath = await '$_dir/${file.name}';
        if (file.isFile) {
          // //print(outFile.path);
          var content = file.content;
          var jsondata = await utf8.decode(content);
          keyfileName = await file.name;
          keyfileName = await keyfileName.replaceAll(".json", "").trim();
          var jsondatasize = await jsondata.length;
          if (jsondatasize > 0 && file.name.toString().contains(".json")) {
            var saveStatus = false;
            var key = await "${databaseId}${file.name}".replaceAll(".json", "");
            List args = [];
            if ("${key}".contains("TIME")) {
              List timeJson = jsonDecode(jsondata);
              if (timeJson.length > 0) {
                timeForUpdate = await timeJson[0]["TIME"];
                try {
                  timeForUpdateInMili = await timeJson[0]["timeInMili"];
                } catch (e) {
                  SyncStatus.sink.add(e.toString());
                }
                dataSynced = true;
              }
            }
            if (file.name.contains(".json")) {
              args.add(key);
              args.add(jsondata);
              saveStatus = await Myf.SaveToLocal(args);

              // await Future.delayed(const Duration(milliseconds: 1000));
            }
            fileProcessDone += 1;
            var progressProcess = await fileProcessDone / totalFiles * 100;
            var progressProcessString = await fileProcessDone / totalFiles * 100;
            progressFileStatus.sink.add(progressProcess);
            // List json = await jsonDecode(jsondata);
            FileList.add({"key": keyfileName, "size": content.length, "save": saveStatus});
            processListSyncdone.sink.add(FileList);
            SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Saving ${(progressProcessString.toStringAsFixed(0))}%");
          }
        }
      }

      await Myf.saveValToSavedPref(widget.CURRENT_USER, "lastUpdatetime", timeForUpdate);
      SyncStatus.sink.add("");
      await Myf.saveValToSavedPref(widget.CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
      backgroundSyncInProcess = false;

      lastUpdateDateControl.sink.add(timeForUpdate);
    } catch (e) {
      FileList.add({"key": "$keyfileName$e", "size": 0, "save": false});
      processListSyncdone.sink.add(FileList);
      //log(e.toString());
      backgroundSyncInProcess = false;

      // Myf.snakeBar(context, e.toString());
    }
  }

  Future loadHeadLessWeb() async {
    var runingServer = await localhostServer.isRunning();
    if (!runingServer) {
      try {
        await localhostServer.start();
      } catch (e) {}
      runingServer = await localhostServer.isRunning();
    }
    var url = urldata.headLessSync;
    var software_name = widget.CURRENT_USER["software_name"].toString();
    if (software_name.contains("AGENCY")) {
      url = urldataAG.headLessSync;
    }
    headlessWebView = await new HeadlessInAppWebView(
      initialSettings: InAppWebViewSettings(
        allowFileAccess: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        allowContentAccess: true,
        javaScriptEnabled: true,
      ),
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

                  SyncStatus.sink.add("");
                  await Myf.saveValToSavedPref(widget.CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
                  await Myf.saveValToSavedPref(widget.CURRENT_USER, "lastUpdatetime", timeForUpdate);
                  lastUpdateDateControl.sink.add(timeForUpdate);

                  backgroundSyncInProcess = false;
                } catch (e) {
                  SyncStatus.sink.add(e.toString());
                }
                dataSynced = true;
              }
            });
        //---------ShowProgress
        controller.addJavaScriptHandler(
            handlerName: 'showOnSyncData',
            callback: (args) async {
              double progress = double.parse("${args[2]}");
              FileList.add({"key": args[0], "size": args[1], "save": true});
              processListSyncdone.sink.add(FileList);
              progressFileStatus.sink.add(progress);
              SyncStatus.sink.add("${widget.CURRENT_USER["yearVal"]} Saving ${progress}%");
              var timeJson = (args[3]);
              ////print(timeJson);
              var timeForUpdate = "";
              var timeForUpdateInMili = "";
              if (progress >= 100) {
                if (timeJson.length > 0) {
                  try {
                    timeForUpdate = await timeJson[0]["TIME"];
                    timeForUpdateInMili = await timeJson[0]["timeInMili"];

                    SyncStatus.sink.add("");
                    await Myf.saveValToSavedPref(widget.CURRENT_USER, "localTimeInMili", timeForUpdateInMili);
                    await Myf.saveValToSavedPref(widget.CURRENT_USER, "lastUpdatetime", timeForUpdate);
                    lastUpdateDateControl.sink.add(timeForUpdate);
                    backgroundSyncInProcess = false;
                  } catch (e) {
                    SyncStatus.sink.add(e.toString());
                  }
                  dataSynced = true;
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

  showInputBoxForPasswordZip() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Encryption password"),
            actionsAlignment: MainAxisAlignment.end,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                    child: TextFormField(
                  // obscureText: true,
                  controller: ctrlZipPassword,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          Myf.showBlurLoading(context);

                          // decodeBuffer(zipFile!, verify: true, password: (ctrlZipPassword.text));
                          await unArchiveAndSave(zipFile!, CLDB, year);
                          await Myf.saveValToSavedPref(widget.CURRENT_USER, "zipPassword", (ctrlZipPassword.text));
                          // setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Save")),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Close")),
                  ],
                )
              ],
            ),
          );
        });
  }

  Archive decodeBuffer(File inputFile, {bool verify = false, String? password}) {
    Uint8List wzzip = inputFile.readAsBytesSync();
    InputStream ifs = InputStream(wzzip);
    var directory = ZipDirectory.read(ifs, password: password);
    final archive = Archive();

    for (final zfh in directory.fileHeaders) {
      final zf = zfh.file!;

      // The attributes are stored in base 8
      final mode = zfh.externalFileAttributes!;
      final compress = zf.compressionMethod != ZipFile.zipCompressionStore;

      if (verify) {
        final computedCrc = getCrc32(zf.content);
        if (computedCrc != zf.crc32) {
          throw ArchiveException('Invalid CRC for file in archive.');
        }
      }

      dynamic content = zf.rawContent;
      var file = ArchiveFile(zf.filename, zf.uncompressedSize!, content, zf.compressionMethod);

      file.mode = mode >> 16;

      // see https://github.com/brendan-duncan/archive/issues/21
      // UNIX systems has a creator version of 3 decimal at 1 byte offset
      if (zfh.versionMadeBy >> 8 == 3) {
        //final bool isDirectory = file.mode & 0x7000 == 0x4000;
        final isFile = file.mode & 0x3F000 == 0x8000;
        file.isFile = isFile;
      } else {
        file.isFile = !file.name.endsWith('/');
      }

      file.crc32 = zf.crc32;
      file.compress = compress;
      file.lastModTime = zf.lastModFileDate << 16 | zf.lastModFileTime;

      archive.addFile(file);
    }

    return archive;
  }

  //  Future<File> decryptFile({required String inputFile, required String outputFile}) async {
  //   // Load the key and IV from files
  //   var mainKey =
  //       " ${widget.CURRENT_USER["CLIENTNO"]}${widget.CURRENT_USER["api"]}${widget.CURRENT_USER["Ltoken"]}${widget.CURRENT_USER["encdb"]}${widget.CURRENT_USER["CLIENTNO"]}";
  //   var keyString = "key_$mainKey";
  //   var ivString = "iv_$mainKey";

  //   Uint8List keyL = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
  //   Uint8List ivL = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));
  //   Uint8List keyData = await base64.decode("a2V5XzExMVZVNUpVVlZGVQ==");
  //   Uint8List ivData = await base64.decode("aXZfMTExVlU1SlVWVkZVMA==");
  //   final key = enc.Key(keyData);
  //   final iv = enc.IV(ivData);

  //   // Read the encrypted file into memory
  //   final encryptedData = await File(inputFile).readAsBytesSync();
  //   // Decrypt the data using the key and IV
  //   final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
  //   final decryptedData = await encrypter.decryptBytes(enc.Encrypted(encryptedData), iv: iv);
  //   // Write the decrypted data to the output file
  //   File(outputFile).writeAsBytesSync(decryptedData);
  //   return await File(outputFile);
  // }

  saveUnZipFileWithoutPassword(File? zipFile) async {
    try {
      // Step 1: Read the ZIP file as bytes
      final bytes = zipFile!.readAsBytesSync();
      // Step 2: Decode the archive with the provided password
      var bearer = firebaseCurrntSupUserObj["bearer"] ?? "";
      var FILE_NAME = firebaseCurrntSupUserObj["FILE_NAME"] ?? "";
      var CLNT = firebaseCurrntSupUserObj["CLNT"] ?? "";
      var passbearer = "${bearer}${FILE_NAME}${CLNT}";
      var pass = Myf.encryptAesString(passbearer);
      final archive = ZipDecoder().decodeBytes(bytes, password: pass);

      // Step 3: Create a directory to save the extracted files
      final outputDir = await getApplicationDocumentsDirectory();
      final extractedDir = Directory('${outputDir.path}/extracted');
      // Step 4: Delete the 'extracted' directory if it exists
      if (await extractedDir.exists()) {
        await extractedDir.delete(recursive: true);
      }
      await extractedDir.create(recursive: true);

      // Step 4: Extract the files without password
      for (final file in archive) {
        if (file.isFile) {
          final fileData = file.content as List<int>;
          final extractedFile = File('${extractedDir.path}/${file.name}');
          await extractedFile.create(recursive: true);
          await extractedFile.writeAsBytes(fileData);
        }
      }

      // Step 5: Create a new ZIP file without a password
      final newZipEncoder = ZipEncoder();
      final newZipFile = File('${outputDir.path}/unprotected_archive.zip');
      final newZipBytes = newZipEncoder.encode(archive);
      await newZipFile.writeAsBytes(newZipBytes!);

      // Step 6: Return the path of the new ZIP file
      return newZipFile;
    } catch (e) {
      //print('Failed to process ZIP file: $e');
      return null;
    }
  }
}
