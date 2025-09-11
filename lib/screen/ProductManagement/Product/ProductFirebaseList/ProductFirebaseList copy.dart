// // ignore_for_file: must_be_immutable

// import 'dart:convert';

// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/AddNewproduct.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ViewSingleProduct/ViewSingleProduct.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/ProductFilter/ProductFilter.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/shareOption.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:flutterfire_ui/firestore.dart';
// import 'package:hive/hive.dart';

// import '../../ProductManagementDrawer.dart';
// import '../AddNewproduct/ProductCardTile/ProductCardTileFirebase.dart';

// class ProductFirebaseList extends StatefulWidget {
//   var UserObj;

//   ProductFirebaseList({Key? key, required this.UserObj}) : super(key: key);

//   @override
//   State<ProductFirebaseList> createState() => _ProductFirebaseListState();
// }

// class _ProductFirebaseListState extends State<ProductFirebaseList> {
//   List<dynamic> QUL_LIST = [];
//   List<dynamic> QUL_LIST_MAIN = [];

//   var loading = true;

//   var searchCtrl = TextEditingController();

//   var searchMainCtrl = TextEditingController();
//   var searchFabrics = TextEditingController();

//   var ctrlSearch = TextEditingController();
//   List<Map<String, dynamic>> LID_LIST = [];

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     LID_LIST.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         var databaseId = await Myf.databaseIdCurrent(widget.UserObj);
//         var box = await Hive.openBox("${databaseId}PRODUCT");
//         box.close();
//         QualLocalObjById = {};
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey[300],
//         appBar: AppBar(
//           backgroundColor: jsmColor,
//           title: Text("Product"),
//           actions: [
//             StreamBuilder(
//               stream: shareButtonBool.stream,
//               builder: (context, snapshot) {
//                 var boolShowShare = snapshot.data.toString().contains("true");
//                 return boolShowShare
//                     ? badges.Badge(
//                         position: badges.BadgePosition.topEnd(top: -1, end: -1),
//                         showBadge: true,
//                         ignorePointer: false,
//                         onTap: () {},
//                         badgeContent: Text("${tempSelectImglist.length}"),
//                         badgeAnimation: badges.BadgeAnimation.scale(
//                           animationDuration: Duration(seconds: 1),
//                           colorChangeAnimationDuration: Duration(seconds: 1),
//                           loopAnimation: false,
//                           curve: Curves.fastOutSlowIn,
//                           colorChangeAnimationCurve: Curves.easeInCubic,
//                         ),
//                         child: ElevatedButton.icon(
//                             label: Text("Share"),
//                             onPressed: () async {
//                               ShareOption.showModelShare(context, productList: tempSelectImglist);
//                               // await ProductListClass.shareAllSelectedFile(context, productList: tempSelectImglist);
//                             },
//                             icon: Icon(Icons.share)),
//                       )
//                     //
//                     : SizedBox.shrink();
//               },
//             ),
//             IconButton(
//                 onPressed: () {
//                   // Myf.showMyDialog(context, "Alert", "Coming soon");
//                   // Myf.Navi(context, WebView(mainUrl: urldata().imageManagementUrl, CURRENT_USER: widget.UserObj));
//                   Myf.Navi(context, ProductFilter(UserObj: widget.UserObj, LID_LIST: LID_LIST));
//                 },
//                 icon: Icon(Icons.filter_alt))
//           ],
//         ),
//         body: WillPopScope(
//           onWillPop: () async {
//             if (tempSelectImglist.length > 0) {
//               tempSelectImglist = [];
//               shareImgObjList.sink.add(tempSelectImglist);
//               shareButtonBool.sink.add(false);
//               return false;
//             }
//             return true;
//           },
//           child: SafeArea(
//             child: ListView(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(29.5)),
//                   child: TextFormField(
//                     onChanged: (value) => setState(() {}),
//                     controller: ctrlSearch,
//                     decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
//                   ),
//                 ),
//                 StreamBuilder<List<dynamic>>(
//                     stream: filterProductTag_LIDList.stream,
//                     builder: (context, snapshot) {
//                       var l = snapshot.data;
//                       var list = fireBCollection
//                           .collection("supuser")
//                           .doc(widget.UserObj["CLIENTNO"])
//                           .collection("PRODUCT")
//                           .where('name', isGreaterThanOrEqualTo: ctrlSearch.text.toUpperCase())
//                           .where('name', isLessThan: ctrlSearch.text.toUpperCase() + 'z');
//                       if (l != null && l.length > 0) {
//                         //print("===============;llllllllll====$l");
//                         list = fireBCollection
//                             .collection("supuser")
//                             .doc(widget.UserObj["CLIENTNO"])
//                             .collection("PRODUCT")
//                             .where("LID", whereIn: l)
//                             .where('name', isGreaterThanOrEqualTo: ctrlSearch.text.toUpperCase())
//                             .where('name', isLessThan: ctrlSearch.text.toUpperCase() + 'z');
//                       }
//                       return FirestoreQueryBuilder(
//                         pageSize: 10,
//                         query: list,
//                         builder: (context, snapshot, child) {
//                           if (snapshot.isFetching) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(child: Text("Error in Category"));
//                           } else if (!snapshot.hasData) {
//                             return Center(child: Text("No data"));
//                           } else {
//                             var snp = snapshot.docs;

//                             if (snp.length > 0) {
//                               return GridView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.all(5),
//                                 itemCount: snp.length,
//                                 itemBuilder: (context, index) {
//                                   var hasEndReached = snapshot.hasMore && index + 1 == snapshot.docs.length && !snapshot.isFetchingMore;
//                                   if (hasEndReached) {
//                                     snapshot.fetchMore();
//                                   }
//                                   dynamic d = snp[index].data();
//                                   logger.d(d);
//                                   dynamic TagProductObj = QualLocalObjById[d["LID"].toString()];
//                                   Map<String, dynamic> QO = {...d};
//                                   //----mearging
//                                   if (TagProductObj != null) {
//                                     Map<String, dynamic> QOI = Map.from(TagProductObj);
//                                     QOI["PID"] = QOI["ID"];
//                                     QOI.remove("ID");
//                                     QO.addAll(QOI);
//                                   }
//                                   //----mearging
//                                   return InkWell(
//                                       onLongPress: () => ProductListClass.showHideShareButtonProcess(product: QO),
//                                       onTap: () {
//                                         if (tempSelectImglist.length > 0) {
//                                           ProductListClass.selectit(product: QO);
//                                         } else {
//                                           Myf.Navi(context, ViewSingleProduct(QUL_OBJ: QO, UserObj: widget.UserObj));
//                                         }
//                                       },
//                                       child: ProductCardTileFirebase(product: QO, UserObj: widget.UserObj));
//                                 },
//                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: kIsWeb ? 5 : 2,
//                                   mainAxisSpacing: 5,
//                                   crossAxisSpacing: 2,
//                                 ),
//                               );
//                             } else {
//                               return Center(child: Text("No data found"));
//                             }
//                           }
//                         },
//                       );
//                     }),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//             onPressed: () => Myf.Navi(context, AddNewproduct(QUL_OBJ: {}, UserObj: widget.UserObj)), label: Text("Add New Product")),
//       ),
//     );
//   }

//   void getData() async {
//     var databasId = await Myf.databaseIdCurrent(widget.UserObj);
//     var Qul = await Myf.GetFromLocal(["${databasId}QUL"], HiveBox: currentHiveBox);
//     QUL_LIST_MAIN = [];
//     if (Qul != null) {
//       try {
//         QUL_LIST_MAIN = await jsonDecode(Qul);
//       } catch (e) {}
//     }
//     QualLocalObjById = {};
//     await Future.wait(QUL_LIST_MAIN.map((e) async {
//       var id = e["value"].toString().toUpperCase().hashCode;
//       e["LID"] = id.toString();
//       QualLocalObjById.putIfAbsent(e["LID"], () => e);
//     }));
//     await getPRODUCT_TAGS_ID();
//     setState(() {
//       loading = false;
//     });
//   }

//   getPRODUCT_TAGS_ID() async {
//     fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("PRODUCT_TAGS_ID").get().then((event) async {
//       var snp = event.docs;
//       if (snp.length > 0) {
//         await Future.wait(snp.map((L) async {
//           dynamic d = L.data();
//           if (QualLocalObjById[d["LID"]] != null) {
//             Map<String, dynamic> pobj = QualLocalObjById[d["LID"]]!;
//             Map<String, dynamic> l = {...pobj};
//             LID_LIST.add(l);
//           }
//         }).toList());
//       } else {
//         await (fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("PRODUCT").get().then((value) async {
//           var psnp = value.docs;
//           await Future.wait(psnp.map((e) async {
//             dynamic d = e.data();
//             await fireBCollection
//                 .collection("supuser")
//                 .doc(widget.UserObj["CLIENTNO"])
//                 .collection("PRODUCT_TAGS_ID")
//                 .doc(d["LID"])
//                 .set({"LID": d["LID"]});
//           }).toList());
//         }));
//       }
//     });
//   }
// }
