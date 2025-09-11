// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/AddNewproduct.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ProductCardTile/ProductCardTileFirebase.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ViewSingleProduct/ViewSingleProduct.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/reDesign.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductJsonList/shareOption.dart';
// import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/firestore.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:badges/badges.dart' as badges;

// class TagProductListView extends StatefulWidget {
//   dynamic UserObj;
//   dynamic QUL_OBJ;
//   TagProductListView({Key? key, required this.UserObj, required this.QUL_OBJ}) : super(key: key);

//   @override
//   State<TagProductListView> createState() => _TagProductListViewState();
// }

// class _TagProductListViewState extends State<TagProductListView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: jsmColor,
//         title: Text("Product View"),
//         actions: [
//           IconButton(onPressed: () => Myf.Navi(context, Redesign(QUL_OBJ: widget.QUL_OBJ)), icon: Icon(Icons.design_services)),
//           StreamBuilder(
//             stream: shareButtonBool.stream,
//             builder: (context, snapshot) {
//               var boolShowShare = snapshot.data.toString().contains("true");
//               return boolShowShare
//                   ? badges.Badge(
//                       position: badges.BadgePosition.topEnd(top: -1, end: -1),
//                       showBadge: true,
//                       ignorePointer: false,
//                       onTap: () {},
//                       badgeContent: Text("${tempSelectImglist.length}"),
//                       badgeAnimation: badges.BadgeAnimation.scale(
//                         animationDuration: Duration(seconds: 1),
//                         colorChangeAnimationDuration: Duration(seconds: 1),
//                         loopAnimation: false,
//                         curve: Curves.fastOutSlowIn,
//                         colorChangeAnimationCurve: Curves.easeInCubic,
//                       ),
//                       child: ElevatedButton.icon(
//                           label: Text("Share"),
//                           onPressed: () async {
//                             // ShareOption.showModelShare(context, productList: tempSelectImglist);
//                             ShareOption.showModelShare(context, productList: tempSelectImglist);
//                           },
//                           icon: Icon(Icons.share)),
//                     )
//                   //
//                   : SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: ProductCard(context, QUL_OBJ: widget.QUL_OBJ),
//             ),
//           ),
//           FirestoreQueryBuilder(
//             pageSize: 20,
//             query: fireBCollection
//                 .collection("supuser")
//                 .doc(widget.UserObj["CLIENTNO"])
//                 .collection("PRODUCT")
//                 .where("LID", isEqualTo: widget.QUL_OBJ["LID"]),
//             builder: (context, snapshot, child) {
//               if (snapshot.isFetching) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text("Error in Category"));
//               } else if (!snapshot.hasData) {
//                 return Center(child: Text("No data"));
//               } else {
//                 var snp = snapshot.docs;

//                 if (snp.length > 0) {
//                   return GridView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: snp.length,
//                     itemBuilder: (context, index) {
//                       var hasEndReached = snapshot.hasMore && index + 1 == snapshot.docs.length && !snapshot.isFetchingMore;
//                       if (hasEndReached) {
//                         snapshot.fetchMore();
//                       }
//                       dynamic d = snp[index].data();
//                       dynamic TagProductObj = QualLocalObjById[d["LID"].toString()];
//                       Map<String, dynamic> QO = d;
//                       //----mearging
//                       if (TagProductObj != null) {
//                         Map<String, dynamic> QOI = Map.from(TagProductObj);
//                         QOI["PID"] = QOI["ID"];
//                         QOI.remove("ID");
//                         QO.addAll(QOI);
//                       }
//                       //----mearging
//                       return InkWell(
//                           onLongPress: () => ProductListClass.showHideShareButtonProcess(product: QO),
//                           onTap: () {
//                             if (tempSelectImglist.length > 0) {
//                               ProductListClass.selectit(product: QO);
//                             } else {
//                               Myf.Navi(context, ViewSingleProduct(QUL_OBJ: QO, UserObj: widget.UserObj));
//                             }
//                           },
//                           child: ProductCardTileFirebase(productModel: d, UserObj: widget.UserObj));
//                     },
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 8,
//                       crossAxisSpacing: 8,
//                     ),
//                   );
//                 } else {
//                   return Center(child: Text("No data found"));
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//           onPressed: () => Myf.Navi(context, AddNewproduct(QUL_OBJ: widget.QUL_OBJ, UserObj: widget.UserObj)), label: Text("Add")),
//     );
//   }

//   Container ProductCard(BuildContext context, {required QUL_OBJ}) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       // padding: const EdgeInsets.all(8.0),
//       child: Card(
//         color: Colors.grey[300],
//         child: Container(
//           padding: EdgeInsets.all(5),
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           // height: 100,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               titlecard(title: "PRODUCT TAG", text: "${QUL_OBJ["label"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "MAIN SCREEN", text: "${QUL_OBJ["MS"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "FABRICS", text: "${QUL_OBJ["BQ"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "CATEGORY", text: "${QUL_OBJ["CT"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "RATE1", text: "${QUL_OBJ["S1"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "RATE2", text: "${QUL_OBJ["S2"]}"),
//               Divider(color: Colors.grey),
//               titlecard(title: "RATE3", text: "${QUL_OBJ["S3"]}"),
//               Divider(color: Colors.grey),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Row titlecard({required title, required text}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           "$title : ",
//           style: TextStyle(color: Colors.black87),
//         ),
//         Text(
//           "${text}",
//           style: TextStyle(color: jsmColor, fontSize: 18),
//         ),
//       ],
//     );
//   }
// }
