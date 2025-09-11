// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:empire_ios/Models/ProductModel.dart';
// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/imgShowCacheClass.dart';
// import 'package:empire_ios/screen/ProductManagement/TagProductListView/TagProductListView.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:image_picker/image_picker.dart';

// class ImgShow extends StatefulWidget {
//   ImgShow({Key? key, required this.QUL_OBJ, required this.UserObj}) : super(key: key);
//   dynamic QUL_OBJ;
//   var UserObj;
//   @override
//   State<ImgShow> createState() => _ImgShowState();
// }

// class _ImgShowState extends State<ImgShow> {
//   dynamic QUL_OBJ;

//   @override
//   Widget build(BuildContext context) {
//     var ID = "${widget.QUL_OBJ["value"].hashCode}";
//     widget.QUL_OBJ["ID"] = ID;
//     QUL_OBJ = imgFirebaseObjById[widget.QUL_OBJ["ID"]];
//     return QUL_OBJ != null
//         ? Stack(children: [
//             imgCard(context, QUL_OBJ),
//             deleteButton(context),
//             SelectButton(),
//           ])
//         : StreamBuilder<QuerySnapshot>(
//             stream: fireBCollection
//                 .collection("supuser")
//                 .doc(widget.UserObj["CLIENTNO"])
//                 .collection("PRODUCT")
//                 .where("ID", isEqualTo: widget.QUL_OBJ["ID"])
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text("PRODUCT ERROR"));
//               } else if (!snapshot.hasData) {
//                 return Center(child: Text("PRODUCT LOGIN ISSUE"));
//               } else if (snapshot.hasData) {
//                 var snp = snapshot.data!.docs;
//                 if (snp.length > 0) {
//                   return Stack(alignment: Alignment.center, children: [
//                     ...snp.map((e) {
//                       dynamic d = e.data();
//                       QUL_OBJ = Map.from(widget.QUL_OBJ);
//                       Map<dynamic, dynamic> sd = Map.from(d);
//                       QUL_OBJ.addAll(sd);
//                       // //print(firebaseCurrntSupUserObj["CURRENT_YEAR_URL"]);
//                       imgCacheUrlById.remove(d["ID"]);
//                       imgCacheUrlById.putIfAbsent(d["ID"], () => d["url"]);
//                       imgFirebaseObjById.remove(d["ID"]);
//                       imgFirebaseObjById.putIfAbsent(d["ID"], () => QUL_OBJ);
//                       // savedUrlForHomeScreen = d["url"];

//                       return imgCard(context, QUL_OBJ);
//                     }).toList(),
//                     deleteButton(context),
//                     SelectButton()
//                   ]);
//                 } else {
//                   return InkWell(
//                     onTap: () async {
//                       await showPhotoOptionsGallery(context);
//                     },
//                     child: Icon(
//                       Icons.add_box_outlined,
//                       color: Colors.black26,
//                     ),
//                   );
//                 }
//               } else {
//                 return Center(child: Text("please wait Login process"));
//               }
//             });
//   }

//   InkWell imgCard(BuildContext context, Map<dynamic, dynamic> QUL_OBJ) {
//     return InkWell(
//       onTap: () {
//         // Myf.Navi(
//         //     context,
//         //     TagProductListView(
//         //       UserObj: widget.UserObj,
//         //       QUL_OBJ: QUL_OBJ,
//         //     ));
//       },
//       child: imgShowCacheClass.imgCachebyBurl(QUL_OBJ["url"]),
//     );
//   }

//   Positioned SelectButton() {
//     return Positioned(
//       top: 0,
//       right: 0,
//       child: StreamBuilder<List<ProductModel>>(
//           stream: shareImgObjList.stream,
//           builder: (context, snapshot) {
//             List<ProductModel> l = snapshot.data??[];
//             if (l.length > 0) {
//               bool select = false;
//               l.map((e) {
//                 if (e.qualModel!.value == widget.QUL_OBJ["value"]) {
//                   select = true;
//                 }
//               }).toList();
//               return select
//                   ? IconButton(iconSize: 100, onPressed: () async {}, icon: Icon(Icons.check_box_outlined, color: Colors.white))
//                   : SizedBox.shrink();
//             } else {
//               return SizedBox.shrink();
//             }
//           }),
//     );
//   }

//   Positioned deleteButton(BuildContext context) {
//     return Positioned(
//         top: 0,
//         left: 0,
//         child: CircleAvatar(
//           backgroundColor: Colors.white60,
//           child: IconButton(
//             onPressed: () => ProductListClass.deleteImg(context: context, QUL_OBJ: QUL_OBJ, UserObj: widget.UserObj),
//             icon: Icon(
//               Icons.delete,
//               color: Colors.red,
//             ),
//           ),
//         ));
//   }

//   showPhotoOptionsGallery(context) async {
//     await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Upload Category Picture"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   onTap: () async {
//                     XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//                     if (pickedFile != null) {
//                       if (pickedFile != null) {
//                         uploadMethod(pickedFile, context);
//                       }
//                     }
//                   },
//                   leading: const Icon(Icons.photo_album),
//                   title: const Text("Select from Gallery"),
//                 ),
//                 ListTile(
//                   onTap: () async {
//                     XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
//                     uploadMethod(pickedFile, context);
//                   },
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text("Take a photo"),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void uploadMethod(XFile? pickedFile, BuildContext context) {
//     if (pickedFile != null) {
//       ProductListClass.askForUpload(context: context, file: pickedFile, QualId: widget.QUL_OBJ["ID"], UserObj: widget.UserObj);
//     }
//   }
// }
