// // ignore_for_file: must_be_immutable

// import 'package:bubble/bubble.dart';
// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/remark/addNewRemark.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/inputwidgetlist.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutterfire_ui/firestore.dart';

// import '../NotificationService/NotificationService.dart';

// class Remark extends StatelessWidget {
//   var UserObj;
//   var preFilledPbj;

//   Remark({Key? key, required this.UserObj, this.preFilledPbj}) : super(key: key);

//   var ctrlMsg = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(backgroundColor: jsmColor, title: Text("My Reminder")),
//       body: Column(
//         children: [
//           Expanded(
//             child: FirestoreQueryBuilder(
//               pageSize: 10,
//               query: fireBCollection
//                   .collection("supuser")
//                   .doc(UserObj["CLIENTNO"])
//                   .collection("RMK")
//                   .where("user", isEqualTo: UserObj["login_user"])
//                   .orderBy("date", descending: true),
//               builder: (context, snapshot, child) {
//                 if (snapshot.isFetching) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error in Req search order"));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text("No data"));
//                 } else {
//                   var snp = snapshot.docs;

//                   if (snp.length > 0) {
//                     return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snp.length,
//                         itemBuilder: (context, index) {
//                           var hasEndReached = snapshot.hasMore && index + 1 == snapshot.docs.length && !snapshot.isFetchingMore;
//                           if (hasEndReached) {
//                             snapshot.fetchMore();
//                           }
//                           dynamic d = snp[index].data();
//                           d["rmdate"] != null && d["rmdate"] != ""
//                               ? NotificationService()
//                                   .showNotificationOnTime(d["ID"].hashCode, "${d["title"]}", "${d["notes"]}", time: DateTime.parse(d["rmdate"]))
//                               : null;
//                           return GestureDetector(
//                             onTap: () => Myf.Navi(context, addNewRemark(UserObj: UserObj, exitsingNotes: d)),
//                             child: ContainerWidget(d, context).animate().slide(),
//                           );
//                         });
//                   } else {
//                     return Center(child: Text("No data found"));
//                   }
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//           heroTag: "addnewremark",
//           onPressed: () => Myf.Navi(context, addNewRemark(UserObj: UserObj, preFilledPbj: preFilledPbj)),
//           label: Text("Add New Reminders")),
//     );
//   }

//   Padding ContainerWidget(d, context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey, // Border color
//                   width: 2.0, // Border width
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         "${d["title"]}",
//                         style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor, fontSize: 18),
//                       ),
//                     ),
//                     Flexible(child: Text("${Myf.dateFormate(d["date"])}")),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Flexible(
//                       child: Text(
//                         "${d["notes"]}",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                     Flexible(child: Text(""))
//                   ],
//                 )
//               ],
//             ),
//           ),
//           Positioned(
//               right: 0,
//               child: IconButton(
//                   onPressed: () {
//                     showDialog<void>(
//                       context: context,
//                       barrierDismissible: false, // user must tap button!
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text("Alert"),
//                           content: SingleChildScrollView(
//                             child: ListBody(
//                               children: <Widget>[
//                                 Text(" Are you sure you want to delete?"),
//                               ],
//                             ),
//                           ),
//                           actions: <Widget>[
//                             ElevatedButton(
//                               child: const Text('Yes'),
//                               onPressed: () {
//                                 fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("RMK").doc(d["ID"]).delete();
//                               },
//                             ),
//                             ElevatedButton(
//                               child: const Text('Cancel'),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   icon: Icon(Icons.delete)))
//         ],
//       ),
//     );
//   }
// }
