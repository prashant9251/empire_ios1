// import 'package:empire_ios/main.dart';
// import 'package:flutter/material.dart';
// import 'package:mlkit_scanner/mlkit_scanner.dart';

// class Test extends StatefulWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   List<String> barList = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 200.0, // CameraPreview needs height constraints, if you use widget
//             // in Column use SizedBox or Container with height.
//             child: BarcodeScanner(
//               onScannerInitialized: _onScannerInitialized,
//               onCameraInitializeError: (error) {
//                 logger.d(error);
//               },
//               onScan: (barcode) {
//                 //print("=====scaneResult==${barcode.displayValue}");
//                 barList.add(barcode.displayValue.toString());
//                 setState(() {});
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               reverse: true,
//               children: [
//                 ...barList.map((e) {
//                   return ListTile(
//                     title: Text(e),
//                   );
//                 }).toList()
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _onScannerInitialized(BarcodeScannerController controller) async {
//     // await controller.startScan(100); // Detection starts only after this call.
//     // 100 - delay in milliseconds between detection for decreasing
//     // CPU consumption. Detection happens every 100 milliseconds
//     // skipping frames during delay. Use 0 to turn off delay.

//     await controller.startScan(200); // You can stop detection.

//     // await controller.setDelay(200); // Or set delay while detection is going.

//     // await controller.toggleFlash(); // Toggle device flash. Can throw an Exception if device
//     // doesn't have flash.

//     // await controller.pauseCamera(); // Pause camera preview, detection also stops.

//     // await controller.resumeCamera(); // Resume camera preview, detection resumes too if
//     // controller.startScan calls before.

//     await controller.setZoom(0); // Set camera zoom. Values must be in range 0...1
//   }
// }
