// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/adminPanel/userPermissionSettingsAdminEmpTrading.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class OptionsWidget extends StatefulWidget {
//   final String title;
//   final String trueFalse;
//   final String id;

//   OptionsWidget(
//     this.title,
//     this.trueFalse,
//     this.id,
//   );

//   @override
//   _OptionsWidgetState createState() => _OptionsWidgetState();
// }

// class _OptionsWidgetState extends State<OptionsWidget> {
//   late bool trueFalseValue;

//   @override
//   void initState() {
//     super.initState();
//     trueFalseValue = widget.trueFalse == "true";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return boolparticularIconPermission
//         ? Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(widget.title),
//               ),
//               CupertinoSwitch(
//                 value: trueFalseValue,
//                 onChanged: (value) {
//                   setState(() {
//                     trueFalseValue = value;
//                     settingsMap[widget.id] = trueFalseValue;
//                     updatePermission(widget.id, trueFalseValue);
//                   });
//                 },
//               ),
//             ],
//           )
//         : SizedBox.shrink();
//   }

//   void updatePermission(String id, var trueFalse) async {
//     Myf.showBlurLoading(context);
//     await fireBCollection
//         .collection("supuser")
//         .doc(currentUserObjForPermission["clnt"])
//         .collection("user")
//         .doc(currentUserObjForPermission["usernm"])
//         .update({"$id": trueFalse}).then((value) {});

//     Navigator.pop(context);
//   }
// }
