import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class ShareImageOptions extends StatefulWidget {
  List<GalleryModel> selectedFiles;
  String currentFolderName;
  ShareImageOptions({key, required this.selectedFiles, required this.currentFolderName});

  @override
  State<ShareImageOptions> createState() => _ShareImageOptionsState();
}

class _ShareImageOptionsState extends State<ShareImageOptions> {
  var ctrlName = TextEditingController(text: "");

  var ctrlRate = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlName.text = widget.currentFolderName.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Share options"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ctrlName,
                  decoration: InputDecoration(
                      labelText: "Enter Name",
                      border: OutlineInputBorder(),
                      suffix: InkWell(
                          onTap: () {
                            ctrlName.clear();
                          },
                          child: Icon(Icons.clear))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: ctrlRate,
                  decoration: InputDecoration(
                    labelText: "Enter Rate",
                  ),
                ),
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jsmColor,
                  ),
                  onPressed: () async {
                    if (ctrlName.text.isEmpty && ctrlRate.text.isEmpty) {
                      await shareDirect();
                    } else {
                      // editImageWithText(context, ctrlName.text.toUpperCase().trim(), "${ctrlRate.text.isEmpty ? "" : "${ctrlRate.text}/-"}");
                      // edit image with name and rate then share
                    }
                  },
                  label: Text(
                    "Share",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.share, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shareDirect() async {
    List<XFile> files = [];
    await Future.wait(widget.selectedFiles.map((GalleryModel url) async {
      // get file path from cache
      var filePath = await baseCacheManager.getFileFromCache(url.url!).then((value) => (value?.file.path));
      files.add(XFile(filePath!));
      return XFile(url.url!);
    }).toList());
    // OpenFilex.open(files[0].path);
    Share.shareXFiles(files);
  }

  // void editImageWithText(context, String name, String rate) async {
  //   // edit image with text
  //   Myf.showLoading(context, "Please wait...");
  //   List<XFile> files = [];
  //   await Future.wait(widget.selectedFiles.map((GalleryModel url) async {
  //     // get file path from cache
  //     Map<String, dynamic> d = {"name": name, "rate": rate};
  //     var filePath = await baseCacheManager.getFileFromCache(url.url!).then((value) => (value?.file.path));
  //     d["cacheFilePath"] = filePath;
  //     var editImgFile = await DesignImg.reDesignImgSave(context, d);
  //     files.add(XFile(editImgFile.path));
  //     return XFile(editImgFile.path);
  //   }).toList());
  //   // OpenFilex.open(files[0].path);
  //   Share.shareXFiles(files);
  //   Navigator.pop(context);
  // }
}
