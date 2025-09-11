// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/ProductManagement/ProductList/ProductList.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class ProductManagement extends StatefulWidget {
//   const ProductManagement({Key? key}) : super(key: key);

//   @override
//   State<ProductManagement> createState() => _ProductManagementState();
// }

// class _ProductManagementState extends State<ProductManagement> {
//   int currentIndex = 0;

//   void changeScreen(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       ProductList(UserObj: {}),
//       Text("data")
//       // HistoryImage(),
//     ];
//     return Scaffold(
//       body: SafeArea(
//         child: IndexedStack(
//           children: screens,
//           index: currentIndex,
//         ),
//       ),
//       // drawer: const HomeScreenDrawer(),
//       bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: jsmColor,
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.white70,
//           currentIndex: (currentIndex),
//           onTap: (index) => setState(() {
//                 currentIndex = index;
//                 changeScreen(index);
//               }),
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "PRODUCT", backgroundColor: jsmColor),
//             BottomNavigationBarItem(icon: Icon(Icons.tips_and_updates), label: "ORDER", backgroundColor: jsmColor),
//             // BottomNavigationBarItem(icon: Icon(Icons.history), label: "HISTORY", backgroundColor: baseColor),
//           ]),
//     );
//   }
// }
