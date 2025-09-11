// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:cunning_document_scanner/cunning_document_scanner.dart';

// class DocScanner extends StatefulWidget {
//   var UserObj;

//   DocScanner({Key? key, this.UserObj}) : super(key: key);

//   @override
//   State<DocScanner> createState() => _DocScannerState();
// }

// class _DocScannerState extends State<DocScanner> {
//   List<String> _pictures = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//           children: [
//             ElevatedButton(onPressed: onPressed, child: const Text("Add Pictures")),
//             for (var picture in _pictures) Image.file(File(picture))
//           ],
//         )),
//       ),
//     );
//   }

//   void onPressed() async {
//     List<String> pictures;
//     try {
//       pictures = await CunningDocumentScanner.getPictures() ?? [];
//       if (!mounted) return;
//       setState(() {
//         _pictures = pictures;
//       });
//     } catch (exception) {
//       // Handle exception here
//     }
//   }
// }
