// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:empire_ios/Models/GalleryModel.dart';
// import 'package:empire_ios/functions/syncLocalFunction.dart';
// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/GalleryPage/ShareImageOptions.dart';
// import 'package:empire_ios/screen/GalleryUpload/GalleryUpload.dart';
// import 'package:empire_ios/screen/ImageViewer/ImageViewer.dart';
// import 'package:empire_ios/widget/Skelton.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// class GalleryPage extends StatefulWidget {
//   final String path;
//   GalleryPage({key, required this.path});

//   @override
//   State<GalleryPage> createState() => _GalleryPageState();
// }

// class _GalleryPageState extends State<GalleryPage> {
//   late Box galleryHiveBox;
//   List<GalleryModel> selectedFiles = [];
//   var loadingFiles = true;
//   var currentFolderName = "";
//   var loading = true;
//   var oprativePath = "${loginUserModel.cLIENTNO}";
//   List<GalleryModel> uploadgalleryList = [];
//   CollectionReference<Map<String, dynamic>> oprativeCollection = fireBCollection
//       .collection("supuser")
//       .doc("${loginUserModel.cLIENTNO}")
//       .collection("gallery")
//       .doc("${loginUserModel.cLIENTNO}")
//       .collection("dir");
//   @override
//   void initState() {
//     super.initState();
//     oprativePath = widget.path.replaceAll("/", "~");
//     oprativeCollection =
//         fireBCollection.collection("supuser").doc("${loginUserModel.cLIENTNO}").collection("gallery").doc(oprativePath).collection("dir");
//     SyncLocalFunction.openBoxCheckByNameID('$oprativePath').then((value) async {
//       galleryHiveBox = value;
//       setState(() {
//         loading = false;
//       });
//       fetchFiles();
//       currentFolderName = widget.path.split("/").last;
//     });
//   }

//   Future<void> fetchFiles() async {
//     var galleryLastSyncTimeinMiliSec = hiveMainBox.get("galleryLastSyncTimeinMiliSec") ?? "0";
//     oprativeCollection.where("mTime", isGreaterThanOrEqualTo: galleryLastSyncTimeinMiliSec).get().then((value) {
//       value.docs.forEach((element) {
//         GalleryModel galleryModel = GalleryModel.fromJson(element.data());
//         galleryHiveBox.put(element.id, galleryModel.toJson());
//       });
//       fireBCollection
//           .collection("supuser")
//           .doc("${loginUserModel.cLIENTNO}")
//           .collection("galleryDeleted")
//           .where("mTime", isGreaterThanOrEqualTo: galleryLastSyncTimeinMiliSec)
//           .get()
//           .then((value) {
//         value.docs.forEach((element) {
//           GalleryModel galleryModel = GalleryModel.fromJson(element.data());
//           galleryHiveBox.delete(galleryModel.id);
//         });
//         hiveMainBox.put("galleryLastSyncTimeinMiliSec", DateTime.now().millisecondsSinceEpoch.toString());
//         if (mounted) {
//           setState(() {});
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveBuilder(builder: (context, sizingInformation) {
//       var gridViewCrossCount = 2;
//       double? mainAxisExtent = 120;
//       if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
//         gridViewCrossCount = 6;
//         mainAxisExtent = null;
//       } else if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
//         gridViewCrossCount = 4;
//         mainAxisExtent = 120;
//       }
//       return WillPopScope(
//         onWillPop: () {
//           if (selectedFiles.isNotEmpty) {
//             setState(() {
//               selectedFiles = [];
//             });
//             return Future.value(false);
//           }
//           return Future.value(true);
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: jsmColor,
//             title: const Text('Gallery'),
//             actions: [
//               IconButton(onPressed: () => fetchFiles(), icon: Icon(Icons.refresh)),
//               if (selectedFiles.isNotEmpty) ...[
//                 IconButton(
//                   icon: Icon(Icons.share),
//                   onPressed: () async {
//                     showModalBottomSheet(
//                       scrollControlDisabledMaxHeightRatio: .8,
//                       context: context,
//                       builder: (context) {
//                         return ShareImageOptions(
//                           selectedFiles: selectedFiles,
//                           currentFolderName: currentFolderName,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.delete,
//                   ),
//                   onPressed: () async {
//                     // ask for yes no dialog
//                     var yesNo = await Myf.yesNoShowDialod(context, title: "Delete", msg: "Are you sure you want to delete?");
//                     if (yesNo == false) return;
//                     Myf.showLoading(context, "Deleting...");
//                     await Future.wait(selectedFiles.map((GalleryModel galleryModel) async {
//                       // get file path from cache
//                       try {
//                         await FirebaseStorage.instance
//                             .ref(galleryModel.keypath)
//                             .delete()
//                             .then((value) async {
//                               await oprativeCollection.doc(galleryModel.id).delete();
//                               await galleryDeletedSave(galleryModel);
//                               oprativeCollection.doc(galleryModel.keypath).delete().then((value) {}).onError((error, stackTrace) {});
//                             })
//                             .then((value) {})
//                             .onError((error, stackTrace) async {
//                               if (error.toString().contains("object-not-found")) {
//                                 await oprativeCollection.doc(galleryModel.id).delete();
//                                 await galleryDeletedSave(galleryModel);
//                                 oprativeCollection.doc(galleryModel.keypath).delete().then((value) {}).onError((error, stackTrace) {});
//                               }
//                             });
//                       } catch (e) {
//                         // galleryDeletedSave(galleryModel);
//                         logger.e(e);
//                       }
//                     }).toList());
//                     selectedFiles.clear();
//                     Navigator.pop(context);
//                     fetchFiles();
//                   },
//                 )
//               ],
//               PopupMenuButton(itemBuilder: (BuildContext context) {
//                 return [
//                   PopupMenuItem(
//                     child: ListTile(
//                       title: const Text('New Folder'),
//                       onTap: () {
//                         Navigator.of(context).pop();
//                         newFolderCreateDialog(context);
//                       },
//                     ),
//                   ),
//                   PopupMenuItem(
//                     child: ListTile(
//                       title: const Text('Reset'),
//                       onTap: () {
//                         Navigator.of(context).pop();
//                         galleryHiveBox.clear();
//                         hiveMainBox.put("galleryLastSyncTimeinMiliSec", "0");
//                         fetchFiles();
//                       },
//                     ),
//                   )
//                 ];
//               })
//             ],
//           ),
//           body: loading
//               ? Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       if (galleryHiveBox != null)
//                         ValueListenableBuilder(
//                             valueListenable: galleryHiveBox.listenable(),
//                             builder: (context, Box box, child) {
//                               var folders = box.keys.where((key) {
//                                 var json = box.get(key);
//                                 var element = GalleryModel.fromJson(Myf.convertMapKeysToString(json));
//                                 return element.type == "folder";
//                               }).toList();

//                               var files = box.keys.where((key) {
//                                 var json = box.get(key);
//                                 var element = GalleryModel.fromJson(Myf.convertMapKeysToString(json));
//                                 return element.type != "folder";
//                               }).toList();

//                               return Expanded(
//                                 child: box.keys.length == 0
//                                     ? Center(
//                                         child: Text(
//                                           "No File Found",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       )
//                                     : GridView.builder(
//                                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: gridViewCrossCount,
//                                           mainAxisExtent: mainAxisExtent,
//                                           crossAxisSpacing: 10,
//                                           mainAxisSpacing: 10,
//                                           childAspectRatio: 1,
//                                         ),
//                                         itemCount: folders.length + files.length,
//                                         itemBuilder: (context, index) {
//                                           var key;
//                                           if (index < folders.length) {
//                                             key = folders[index];
//                                           } else {
//                                             key = files[index - folders.length];
//                                           }
//                                           var json = box.get(key);
//                                           var element = GalleryModel.fromJson(Myf.convertMapKeysToString(json));
//                                           if (element.type == "folder") {
//                                             return folder(context, element);
//                                           } else {
//                                             return InkWell(
//                                               onLongPress: () {
//                                                 setState(() {
//                                                   selectPhoto(element);
//                                                 });
//                                               },
//                                               onTap: () {
//                                                 if (selectedFiles.isNotEmpty) {
//                                                   setState(() {
//                                                     selectPhoto(element);
//                                                   });
//                                                 } else {
//                                                   List<String> viewAblefileUrls = files.map((key) {
//                                                     var json = box.get(key);
//                                                     var element = GalleryModel.fromJson(Myf.convertMapKeysToString(json));
//                                                     return element.url!;
//                                                   }).toList();
//                                                   Myf.Navi(context, ImageViewer(viewAblefileUrls, iniIndex: viewAblefileUrls.indexOf(element.url!)));
//                                                 }
//                                               },
//                                               child: LayoutBuilder(builder: (context, constraints) {
//                                                 var isSelected = selectedFiles.where((e) => e.id == element.id).isNotEmpty;
//                                                 double parentWidth = constraints.maxWidth;
//                                                 double parentheight = constraints.maxHeight;
//                                                 return Card(
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(15.0),
//                                                   ),
//                                                   elevation: 5,
//                                                   color: Colors.white,
//                                                   child: Container(
//                                                     height: parentheight,
//                                                     width: parentWidth,
//                                                     padding: isSelected ? EdgeInsets.all(8) : null,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius: BorderRadius.circular(0.0),
//                                                       border: Border.all(
//                                                         width: isSelected ? 10 : 1,
//                                                         color: isSelected ? Colors.black : Colors.grey,
//                                                       ),
//                                                       boxShadow: [
//                                                         BoxShadow(
//                                                           color: Colors.grey.withOpacity(0.5),
//                                                           spreadRadius: 2,
//                                                           blurRadius: 5,
//                                                           offset: Offset(0, 3),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: Stack(
//                                                       alignment: Alignment.bottomCenter,
//                                                       fit: StackFit.expand,
//                                                       children: [
//                                                         CachedNetworkImage(
//                                                             imageUrl: element.url!,
//                                                             fit: BoxFit.cover,
//                                                             height: parentheight,
//                                                             width: parentWidth,
//                                                             placeholder: (context, url) => ShimmerSkelton(height: 140, width: 180),
//                                                             errorWidget: (context, url, error) => Icon(Icons.error)),
//                                                         Positioned(
//                                                             bottom: 0,
//                                                             right: 0,
//                                                             left: 0,
//                                                             child: Container(
//                                                               width: parentWidth,
//                                                               color: Colors.black.withOpacity(0.5),
//                                                               child: Text(
//                                                                 "${element.name}",
//                                                                 textAlign: TextAlign.center,
//                                                                 style: TextStyle(color: Colors.white),
//                                                               ),
//                                                             ))
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               }),
//                                             );
//                                           }
//                                         },
//                                       ),
//                               );
//                             }),
//                     ],
//                   ),
//                 ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () async {
//               if (kIsWeb) {
//                 await Myf.Navi(
//                     context,
//                     GalleryUpload(
//                       galleryList: [],
//                       path: widget.path,
//                       oprativeCollection: oprativeCollection,
//                     ));
//                 fetchFiles();
//                 return;
//               }
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Upload File'),
//                       content: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                             ),
//                             onPressed: () async {
//                               final ImagePicker _picker = ImagePicker();

//                               final List<XFile>? image = await _picker.pickMultiImage();
//                               if (image != null) {
//                                 await Future.wait(image.map((XFile file) async {
//                                   var extension = file.name.split(".").last;
//                                   var file2 = File(file.path);
//                                   GalleryModel galleryModel = GalleryModel(
//                                       size: file2.lengthSync(),
//                                       name: file.path.split("/").last,
//                                       url: "",
//                                       type: extension,
//                                       bytes: file2.readAsBytesSync(),
//                                       keypath: "${widget.path}/${file.name}",
//                                       mTime: DateTime.now().millisecondsSinceEpoch.toString(),
//                                       id: DateTime.now().toString());
//                                   uploadgalleryList.add(galleryModel);
//                                 }));
//                                 await Myf.Navi(context,
//                                     GalleryUpload(galleryList: uploadgalleryList, path: widget.path, oprativeCollection: oprativeCollection));
//                                 uploadgalleryList.clear();
//                                 await fetchFiles();
//                                 Navigator.of(context).pop();
//                               }
//                             },
//                             child: const Text(
//                               'Gallery',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                             ),
//                             onPressed: () async {
//                               final ImagePicker _picker = ImagePicker();
//                               final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//                               if (image != null) {
//                                 final File file = File(image.path);
//                                 GalleryModel galleryModel = GalleryModel(
//                                     size: file.lengthSync(),
//                                     name: file.path.split("/").last,
//                                     url: "",
//                                     type: image.name.split(".").last,
//                                     bytes: file.readAsBytesSync(),
//                                     keypath: "${widget.path}/${image.name}",
//                                     mTime: DateTime.now().millisecondsSinceEpoch.toString(),
//                                     id: DateTime.now().toString());
//                                 uploadgalleryList.add(galleryModel);
//                                 await Myf.Navi(context,
//                                     GalleryUpload(galleryList: uploadgalleryList, path: widget.path, oprativeCollection: oprativeCollection));
//                                 uploadgalleryList.clear();
//                                 await fetchFiles();
//                                 Navigator.of(context).pop();
//                               }
//                             },
//                             child: const Text(
//                               'Camera',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             },
//             child: const Icon(Icons.upload),
//           ),
//         ),
//       );
//     });
//   }

//   void selectPhoto(GalleryModel element) async {
//     var isFind = false;
//     await Future.wait(selectedFiles.map((e) async {
//       if (e.id == element.id) {
//         isFind = true;
//       }
//     }).toList());
//     if (isFind) {
//       selectedFiles.removeWhere((e) => e.id == element.id);
//     } else {
//       selectedFiles.add(element);
//     }
//   }

//   GestureDetector folder(BuildContext context, GalleryModel element) {
//     return GestureDetector(
//       onLongPress: () {
//         // delete folder
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Delete Folder'),
//                 content: const Text('Are you sure you want to delete?'),
//                 actions: [
//                   TextButton(
//                     style: TextButton.styleFrom(backgroundColor: Colors.green),
//                     child: const Text(
//                       'No',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop(false);
//                     },
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(backgroundColor: Colors.red),
//                     child: const Text(
//                       'Yes',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       Myf.showLoading(context, "Deleting...");
//                       await FirebaseStorage.instance.ref(element.keypath).listAll().then((result) {
//                         for (var fileRef in result.items) {
//                           fileRef.delete().then((value) {
//                             oprativeCollection.doc(element.id).delete();
//                             galleryDeletedSave(element);
//                             fetchFiles();
//                           });
//                         }
//                         Navigator.of(context).pop(true);
//                       });
//                       Navigator.of(context).pop(true);
//                     },
//                   ),
//                 ],
//               );
//             });
//       },
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => GalleryPage(
//                   path: "${widget.path}/${element.name}",
//                 )));
//       },
//       child: Container(
//         width: 120,
//         height: 120,
//         decoration: BoxDecoration(border: Border.all(color: jsmColor, width: 1)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.folder, size: 70, color: jsmColor),
//             Text(
//               element.name!,
//               style: TextStyle(fontSize: 15),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void newFolderCreateDialog(BuildContext context) {
//     var ctrl = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Create New Folder'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: ctrl,
//                 decoration: const InputDecoration(hintText: 'Folder Name'),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: jsmColor,
//                 ),
//                 onPressed: () {
//                   if (ctrl.text.isEmpty) {
//                     return;
//                   }
//                   var text = ctrl.text.toUpperCase().trim();
//                   FirebaseStorage.instance.ref("/${widget.path}/${text}/${text}").putData(Uint8List.fromList([])).whenComplete(() {
//                     var docId = "/${widget.path}/${text}".replaceAll("/", "~");
//                     GalleryModel galleryModel = GalleryModel(
//                         name: text,
//                         url: "",
//                         type: "folder",
//                         keypath: "${widget.path}/${text}/",
//                         id: docId,
//                         mTime: DateTime.now().millisecondsSinceEpoch.toString());

//                     oprativeCollection.doc(galleryModel.id).set(galleryModel.toJson());
//                     fetchFiles();
//                     Navigator.of(context).pop();
//                   });
//                 },
//                 child: const Text(
//                   'Create',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future galleryDeletedSave(GalleryModel galleryModel) async {
//     fireBCollection.collection("supuser").doc("${loginUserModel.cLIENTNO}").collection("galleryDeleted").doc(galleryModel.id).set({
//       "id": galleryModel.id,
//       "mTime": DateTime.now().millisecondsSinceEpoch.toString(),
//     });
//   }
// }
