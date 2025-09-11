import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AssetsUpdate extends StatefulWidget {
  const AssetsUpdate({Key? key}) : super(key: key);

  @override
  State<AssetsUpdate> createState() => _AssetsUpdateState();
}

class _AssetsUpdateState extends State<AssetsUpdate> {
  var downloadSoftwaresLink = "";
  StreamController<double> progressbarDownload = StreamController<double>.broadcast();
  bool updateDone = false;
  String? LocalSyncTimeSoftwaresUpdate = "0";

  @override
  void initState() {
    super.initState();
    LocalSyncTimeSoftwaresUpdate = prefs!.getString("LocalSyncTimeSoftwaresUpdate") == null || prefs!.getString("LocalSyncTimeSoftwaresUpdate") == ""
        ? "0"
        : prefs!.getString("LocalSyncTimeSoftwaresUpdate");

    fireBCollection
        .collection("softwares")
        .doc(firebaseSoftwaresName)
        .collection("assets")
        .where("m_time", isGreaterThan: LocalSyncTimeSoftwaresUpdate)
        .orderBy("m_time", descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      var snp = event.docs;
      if (snp.length > 0) {
        dynamic d = snp.first.data();
        downloadSoftwaresLink = d["link"];
        LocalSyncTimeSoftwaresUpdate = d["m_time"];
        downLoadZip(downloadSoftwaresLink, "myAppAssets.zip");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<double>(
        stream: progressbarDownload.stream,
        builder: (context, snapshot) {
          var progress = snapshot.data;
          if (progress != null && progress != "") {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse("${LocalSyncTimeSoftwaresUpdate}"));
            String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);

            return Column(
              children: [
                LinearProgressIndicator(value: progress),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("software upgrade  ${formattedDate}"),
                    updateDone ? Icon(Icons.done, color: Colors.green) : SizedBox.shrink(),
                  ],
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<File?> downLoadZip(String url, String name) async {
    DateTime now = DateTime.now();
    url = url + "&time=$now";
    progressbarDownload.sink.add(0);
    File? file = null;
    final appStorage = await getApplicationDocumentsDirectory();
    file = await File("${appStorage.path}/$name");
    try {
      var response = await Dio().get(
        url,
        onReceiveProgress: (count, total) {
          var progressbar = ((count / total) * 1);
          progressbarDownload.sink.add(progressbar);
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      if (response.statusCode == 200) {
        final raf = await file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      } else {}
    } catch (e) {
      file = null;
    }

    if (file != null) {
      extractZipTomyUniqueApp(file);
    }
    return null;
  }

  Future<void> extractZipTomyUniqueApp(File file) async {
    try {
      var bytes = await Myf.decryptBytes(file.readAsBytesSync(), "${firebaseSoftwaresName}Unique123456789@uniquesoftwares.com",
          "${firebaseSoftwaresName}Unique123456789@uniquesoftwares.com");

      var archive = await ZipDecoder().decodeBytes(bytes);
      final appDir = await getApplicationDocumentsDirectory();
      final myUniqueAppName = 'myUniqueApp';
      final myUniqueAppPath = '${appDir.path}/$myUniqueAppName';
      myUniqueApp = Directory(myUniqueAppPath);
      myUniqueApp.createSync(recursive: true);
      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>;
          final fileBuffer = Uint8List.fromList(data);
          final filePath = '$myUniqueAppPath/${file.name}';
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBuffer);
        }
      }
      prefs!.setString("LocalSyncTimeSoftwaresUpdate", LocalSyncTimeSoftwaresUpdate.toString());
      updateDone = true;
      progressbarDownload.sink.add(100);

      //print('Zip file extracted to: ${myUniqueApp.path}');
    } catch (e) {
      //print('Error extracting zip file: $e');
    }
  }
}
