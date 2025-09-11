import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/Models/ImageModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GalleryPage/ShareImageOptions.dart';
import 'package:empire_ios/screen/GalleryUpload/GalleryUpload.dart';
import 'package:empire_ios/screen/ImageViewer/ImageViewer.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class EmpOrderFormProductDesign extends StatefulWidget {
  QualModel qualModel;
  EmpOrderFormProductDesign({Key? key, required this.qualModel}) : super(key: key);

  @override
  State<EmpOrderFormProductDesign> createState() => _EmpOrderFormProductDesignState();
}

class _EmpOrderFormProductDesignState extends State<EmpOrderFormProductDesign> {
  List<GalleryModel> uploadgalleryList = [];
  var oprativeCollection = fireBCollection.collection("supuser").doc(loginUserModel.cLIENTNO).collection("gallery");
  List<GalleryModel> selectedFiles = [];
  List<GalleryModel> designList = [];
  var loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    await oprativeCollection.where("value", isEqualTo: widget.qualModel.value).get().then((value) {
      if (value.docs.length == 0) {
        return;
      }
      designList.clear();
      value.docs.forEach((element) {
        dynamic data = element.data();
        GalleryModel galleryModel = GalleryModel.fromJson(Myf.convertMapKeysToString(data));
        designList.add(galleryModel);
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var path = "${loginUserModel.cLIENTNO}/gallery/${widget.qualModel.value}";

    return WillPopScope(
      onWillPop: () {
        if (selectedFiles.isNotEmpty) {
          setState(() {
            selectedFiles = [];
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text(widget.qualModel.label ?? ""),
          actions: [
            if (selectedFiles.isNotEmpty) ...[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  Share.shareXFiles(await Future.wait(selectedFiles.map((e) async {
                    var f = await baseCacheManager.getSingleFile(e.url!);
                    return XFile(f.path);
                  }).toList()));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () async {
                  // ask for yes no dialog
                  var yesNo = await Myf.yesNoShowDialod(context, title: "Delete", msg: "Are you sure you want to delete?");
                  if (yesNo == false) return;
                  Myf.showLoading(context, "Deleting...");
                  await Future.wait(selectedFiles.map((GalleryModel galleryModel) async {
                    try {
                      await FirebaseStorage.instance
                          .ref(galleryModel.keypath)
                          .delete()
                          .then((value) async {
                            await oprativeCollection.doc(galleryModel.id).delete();
                            await galleryDeletedSave(galleryModel);
                          })
                          .then((value) {})
                          .onError((error, stackTrace) async {
                            await oprativeCollection.doc(galleryModel.id).delete();
                            await galleryDeletedSave(galleryModel);
                          });
                    } catch (e) {
                      // galleryDeletedSave(galleryModel);
                      logger.e(e);
                    }
                  }).toList());
                  selectedFiles.clear();
                  await SyncLocalFunction.syncGallery();
                  await getData();
                  Navigator.pop(context);
                },
              )
            ],
          ],
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: designList.length == 0
                    ? Text("No Data")
                    : Container(
                        width: widthResponsive(context),
                        child: ListView.builder(
                            itemCount: designList.length,
                            itemBuilder: (context, index) {
                              GalleryModel galleryModel = designList[index];
                              var isSelected = selectedFiles.where((e) => e.id == galleryModel.id).isNotEmpty;
                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onLongPress: () {
                                  setState(() {
                                    selectPhoto(galleryModel);
                                  });
                                },
                                onTap: () {
                                  if (selectedFiles.isNotEmpty) {
                                    setState(() {
                                      selectPhoto(galleryModel);
                                    });
                                  } else {
                                    List<String> viewAblefileUrls = designList.map((ele) {
                                      return ele.url!;
                                    }).toList();
                                    Myf.Navi(context, ImageViewer(viewAblefileUrls, iniIndex: viewAblefileUrls.indexOf(galleryModel.url!)));
                                  }
                                },
                                child: Card(
                                  elevation: isSelected ? 8 : 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: isSelected ? BorderSide(color: Colors.blue, width: 2) : BorderSide(color: Colors.grey.shade200, width: 1),
                                  ),
                                  color: isSelected ? Colors.blue[50] : Colors.white,
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(12),
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Myf.showImg(
                                            ImageModel(url: galleryModel.url, type: "url"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                galleryModel.name ?? "",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected ? Colors.blue[900] : Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(Icons.insert_drive_file, size: 18, color: Colors.grey[600]),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    galleryModel.type ?? "",
                                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                  ),
                                                  Spacer(),
                                                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    Myf.datetimeFormateFromMilli(galleryModel.mTime, format: "dd/MM/yyyy HH:mm"),
                                                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Icon(Icons.check_circle, color: Colors.blue, size: 28),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (kIsWeb) {
              await Myf.Navi(
                  context,
                  GalleryUpload(
                    galleryList: [],
                    path: path,
                    oprativeCollection: oprativeCollection,
                    qualModel: widget.qualModel,
                  ));
              await SyncLocalFunction.syncGallery();
              await getData();
              return;
            }
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Upload File'),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();

                            final List<XFile>? image = await _picker.pickMultiImage();
                            if (image != null) {
                              await Future.wait(image.map((XFile file) async {
                                var extension = file.name.split(".").last;
                                var file2 = File(file.path);
                                GalleryModel galleryModel = GalleryModel(
                                    size: file2.lengthSync(),
                                    name: file.path.split("/").last,
                                    url: "",
                                    type: extension,
                                    bytes: await file2.readAsBytes(),
                                    keypath: "$path/${file.name}",
                                    mTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                    id: DateTime.now().toString());
                                uploadgalleryList.add(galleryModel);
                              }));
                              await Myf.Navi(
                                  context,
                                  GalleryUpload(
                                    galleryList: uploadgalleryList,
                                    path: path,
                                    oprativeCollection: oprativeCollection,
                                    qualModel: widget.qualModel,
                                  ));
                              uploadgalleryList.clear();

                              await SyncLocalFunction.syncGallery();
                              await getData();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Gallery',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                            // ask for file Rename

                            if (image != null) {
                              final File file = File(image.path);
                              var fName = await Myf.showEntryDialog(context, "${file.path.split("/").last.split(".").first}", "Name");
                              if (fName == null && fName != "") return;
                              var extension = image.name.split(".").last;
                              var fullFileName = "${fName}.${extension}";
                              GalleryModel galleryModel = GalleryModel(
                                  size: file.lengthSync(),
                                  name: "$fullFileName",
                                  url: "",
                                  type: extension,
                                  bytes: await file.readAsBytes(),
                                  keypath: "${path}/${fullFileName}",
                                  mTime: DateTime.now().millisecondsSinceEpoch.toString(),
                                  id: DateTime.now().toString());
                              uploadgalleryList.add(galleryModel);
                              await Myf.Navi(
                                  context,
                                  GalleryUpload(
                                    galleryList: uploadgalleryList,
                                    path: path,
                                    oprativeCollection: oprativeCollection,
                                    qualModel: widget.qualModel,
                                  ));
                              uploadgalleryList.clear();
                              await SyncLocalFunction.syncGallery();
                              await getData();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Camera',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Icon(Icons.upload),
        ),
      ),
    );
  }

  Future galleryDeletedSave(GalleryModel galleryModel) async {
    fireBCollection.collection("supuser").doc(loginUserModel.cLIENTNO).collection("galleryDeleted").doc(galleryModel.id).set({
      "id": galleryModel.id,
      "mTime": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  void selectPhoto(GalleryModel element) async {
    var isFind = false;
    await Future.wait(selectedFiles.map((e) async {
      if (e.id == element.id) {
        isFind = true;
      }
    }).toList());
    if (isFind) {
      selectedFiles.removeWhere((e) => e.id == element.id);
    } else {
      selectedFiles.add(element);
    }
  }
}
