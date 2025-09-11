import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class GalleryUpload extends StatefulWidget {
  List<GalleryModel> galleryList;
  String path;
  CollectionReference<Map<String, dynamic>> oprativeCollection;
  QualModel qualModel;
  GalleryUpload({Key? key, required this.galleryList, required this.path, required this.oprativeCollection, required this.qualModel})
      : super(key: key);

  @override
  State<GalleryUpload> createState() => _GalleryUploadState();
}

class _GalleryUploadState extends State<GalleryUpload> {
  final StreamController<bool> galleryListStream = StreamController<bool>.broadcast();
  List<GalleryModel> galleryList = [];
  var uploading = false;
  late DropzoneViewController controller;
  @override
  void initState() {
    super.initState();
    if (widget.galleryList.length > 0) {
      galleryList = widget.galleryList;
      uploadFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: const Text("Upload Media"),
      ),
      body: Center(
        child: Container(
          width: widthResponsive(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (kIsWeb) _buildDropzone(),
              StreamBuilder<bool>(
                  stream: galleryListStream.stream,
                  builder: (context, snapshot) {
                    return Expanded(child: _buildGalleryList());
                  }),
              StreamBuilder<bool>(
                  stream: galleryListStream.stream,
                  builder: (context, snapshot) {
                    return uploading
                        ? CircularProgressIndicator()
                        : Container(
                            width: widthResponsive(context),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: jsmColor,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  elevation: 10,
                                  padding: const EdgeInsets.all(10),
                                ),
                                onPressed: () async {
                                  await uploadFiles();
                                },
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                )),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropzone() {
    return Container(
      height: 200,
      width: widthResponsive(context),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DropzoneView(
            // mime: ['image/*', 'pdf/*'],
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (DropzoneViewController ctrl) => controller = ctrl,
            onError: (String? ev) => print('Error: $ev'),
            onDropFile: (file) {
              print("=======fileName--${file.name}");
              acceptFile(file);
            },
            onDropFiles: (files) {
              if (files != null) return;
              for (var file in files!) {
                acceptFile(file);
              }
            },
          ),
          const Center(child: Text('Drop files here or click to select files')),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () async {
                var f = await controller.pickFiles(multiple: true);
                if (f.isEmpty) return;
                for (var file in f) {
                  acceptFile(file);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryList() {
    return galleryList.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: galleryList.length,
            itemBuilder: (context, index) {
              return _buildGalleryListItem(index);
            },
          );
  }

  Widget _buildGalleryListItem(int index) {
    return ListTile(
      leading: CachedNetworkImage(
        httpHeaders: {
          "Authorization": basicAuthForLocal,
        },
        height: 50,
        width: 50,
        imageUrl: galleryList[index].url!,
        placeholder: (context, url) => ShimmerSkelton(height: 50, width: 50),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      title: Text(galleryList[index].name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(galleryList[index].type!),
          Text("Size: ${galleryList[index].size.toString()}"),
          Text("Path: ${galleryList[index].keypath.toString()}"),
          LinearProgressIndicator(
            value: galleryList[index].progress,
            // backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
            color: Colors.red,
            semanticsLabel: 'Linear progress indicator',
            valueColor: AlwaysStoppedAnimation<Color>(jsmColor),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            galleryList.removeAt(index);
          });
        },
      ),
    );
  }

  Future<void> acceptFile(DropzoneFileInterface file) async {
    final fileType = await file.type;
    final fileSize = await file.size;
    final fileUrl = await controller.createFileUrl(file);
    print(fileSize);
    if (fileType != null && fileSize != null && fileUrl != null) {
      var galleryModel = GalleryModel(
        value: widget.path,
        id: DateTime.now().toString(),
        name: file.name,
        keypath: file.webkitRelativePath,
        type: fileType,
        mTime: DateTime.now().millisecondsSinceEpoch.toString(),
        size: fileSize,
        bytes: await controller.getFileData(file),
        url: fileUrl,
      );
      galleryList.add(galleryModel);
      galleryListStream.sink.add(true);
    } else {
      print('Error: Invalid file properties');
    }
  }

  uploadFiles() async {
    if (uploading) return;
    uploading = true;
    galleryListStream.sink.add(true);
    for (var galleryModelFile in galleryList) {
      final Reference ref = FirebaseStorage.instance.ref("/${widget.path}/${galleryModelFile.name}");
      final UploadTask uploadTask = ref.putData(galleryModelFile.bytes!);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          galleryModelFile.progress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();
        var extension = ref.name.split(".").last;
        GalleryModel newGalleryModel = GalleryModel(
            value: widget.qualModel.value,
            size: galleryModelFile.size,
            name: galleryModelFile.name!,
            url: url.toString(),
            type: extension,
            bytes: null,
            keypath: "${widget.path}/${galleryModelFile.name!}",
            mTime: DateTime.now().millisecondsSinceEpoch.toString(),
            id: DateTime.now().toString());
        await widget.oprativeCollection.doc(newGalleryModel.id).set(newGalleryModel.toJson());
        galleryListStream.sink.add(true);
      });
    }

    uploading = false;
    galleryListStream.sink.add(true);
    Navigator.pop(context);
  }
}
