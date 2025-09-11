// import 'dart:convert';

// import 'package:camera/camera.dart';
// import 'package:empire_ios/main.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';

// class Mobile extends StatefulWidget {
//   final CameraDescription camera;

//   Mobile({Key? key, required this.camera}) : super(key: key);

//   @override
//   MobileState createState() => MobileState();
// }

// class MobileState extends State<Mobile> {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   FlutterBarcodeSdk? _barcodeReader;
//   bool _isScanAvailable = true;
//   bool _isScanRunning = false;
//   String _barcodeResults = '';
//   String _buttonText = 'Start Video Scan';

//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );

//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller!.initialize().then((_) {
//       try {
//         videoScan();
//         // pictureScan();
//       } catch (e) {
//         // If an error occurs, log the error to the console.
//         //print(e);
//       }
//       setState(() {});
//     });
//     // Initialize Dynamsoft Barcode Reader
//     initBarcodeSDK();
//   }

//   Future<void> initBarcodeSDK() async {
//     _barcodeReader = FlutterBarcodeSdk();
//     // Get 30-day FREEE trial license from https://www.dynamsoft.com/customer/license/trialLicense?product=dbr
//     await _barcodeReader!.setLicense(
//         'DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
//     await _barcodeReader!.init();
//     await _barcodeReader!.setBarcodeFormats(BarcodeFormat.ALL);
//     // Get all current parameters.
//     // Refer to: https://www.dynamsoft.com/barcode-reader/parameters/reference/image-parameter/?ver=latest
//     String params = await _barcodeReader!.getParameters();
//     // Convert parameters to a JSON object.
//     dynamic obj = json.decode(params);
//     // Modify parameters.
//     obj['ImageParameter']['DeblurLevel'] = 5;
//     // Update the parameters.
//     int ret = await _barcodeReader!.setParameters(json.encode(obj));
//     //print('Parameter update: $ret');
//   }

//   void startVideo() async {
//     setState(() {
//       _buttonText = 'Stop Video Scan';
//     });
//     _isScanRunning = true;
//     await _controller!.startImageStream((CameraImage availableImage) async {
//       assert(defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
//       int format = ImagePixelFormat.IPF_NV21.index;

//       switch (availableImage.format.group) {
//         case ImageFormatGroup.yuv420:
//           format = ImagePixelFormat.IPF_NV21.index;
//           break;
//         case ImageFormatGroup.bgra8888:
//           format = ImagePixelFormat.IPF_ARGB_8888.index;
//           break;
//         default:
//           format = ImagePixelFormat.IPF_RGB_888.index;
//       }

//       if (!_isScanAvailable) {
//         return;
//       }

//       _isScanAvailable = false;

//       _barcodeReader!
//           .decodeImageBuffer(
//               availableImage.planes[0].bytes, availableImage.width, availableImage.height, availableImage.planes[0].bytesPerRow, format)
//           .then((results) {
//         if (_isScanRunning) {
//           _barcodeResults = getBarcodeResults(results);
//           if (results.length > 0 && results.first.text.isNotEmpty) {
//             Navigator.pop(context, results.first.text);
//           }
//         }

//         _isScanAvailable = true;
//       }).catchError((error) {
//         _isScanAvailable = false;
//       });
//     });
//   }

//   void stopVideo() async {
//     setState(() {
//       _buttonText = 'Start Video Scan';
//       _barcodeResults = '';
//     });
//     _isScanRunning = false;
//     await _controller!.stopImageStream();
//   }

//   void videoScan() async {
//     if (!_isScanRunning) {
//       startVideo();
//     } else {
//       stopVideo();
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller?.dispose();
//     super.dispose();
//   }

//   Widget getCameraWidget() {
//     if (!_controller!.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     } else {
//       // https://stackoverflow.com/questions/49946153/flutter-camera-appears-stretched
//       final size = MediaQuery.of(context).size;
//       var scale = size.aspectRatio * _controller!.value.aspectRatio;

//       if (scale < 1) scale = 1 / scale;

//       return Transform.scale(
//         scale: .75,
//         child: Center(
//           child: CameraPreview(_controller!),
//         ),
//       );
//       // return CameraPreview(_controller);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       getCameraWidget(),
//       Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Container(
//             height: 100,
//             child: SingleChildScrollView(
//               child: Text(
//                 _barcodeResults,
//                 style: TextStyle(fontSize: 14, color: Colors.black),
//               ),
//             ),
//           ),
//         ],
//       )
//     ]);
//   }

//   String getBarcodeResults(List<BarcodeResult> results) {
//     StringBuffer sb = new StringBuffer();
//     for (BarcodeResult result in results) {
//       sb.write(result.format);
//       sb.write("\n");
//       sb.write(result.text);
//       sb.write("\n");
//       sb.write((result.barcodeBytes).toString());
//       sb.write("\n\n");
//       // Navigator.pop(context, result.text);
//     }
//     if (results.length == 0) sb.write("No Barcode Detected");
//     return sb.toString();
//   }
// }
