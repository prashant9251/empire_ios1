// // ignore_for_file: must_be_immutable

// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:dio/dio.dart';
// import 'package:empire_ios/Apis/Enotify.dart';
// import 'package:empire_ios/Models/WhatsappSendToModel.dart';
// import 'package:empire_ios/main.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;
// import 'package:http_parser/http_parser.dart'; // For MediaType

// class TaskListPdfCard extends StatefulWidget {
//   var shareBy;
//   TaskListPdfCard({Key? key, required this.sr, required this.whatsappSendToModel, required this.UserObj, this.shareBy}) : super(key: key);

//   final int sr;
//   final WhatsappSendToModel whatsappSendToModel;
//   final dynamic UserObj;

//   @override
//   State<TaskListPdfCard> createState() => _TaskListPdfCardState();
// }

// class _TaskListPdfCardState extends State<TaskListPdfCard> {
//   var progressChange = StreamController<double>.broadcast();
//   WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel();
//   var issent = "loading";
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     whatsappSendToModel = widget.whatsappSendToModel;
//     uploadSend();
//   }

//   void uploadSend() async {
//     var fileBytes = null;
//     var fileName;
//     var fileExtension = null;
//     if (whatsappSendToModel.fileBytes != null) {
//       fileBytes = whatsappSendToModel.fileBytes;
//       fileName = whatsappSendToModel.fileName ?? "${whatsappSendToModel.pname}.pdf";
//       fileExtension = whatsappSendToModel.fileExtension ?? "pdf";
//     } else {
//       var file = File(whatsappSendToModel.filePath!);
//       fileBytes = await file.readAsBytes();
//       fileName = path.basename(whatsappSendToModel.filePath!);
//       fileExtension = path.extension(whatsappSendToModel.filePath!);
//     }
//     if (empOrderSettingModel.one1Za != null) {
//       // sendTemplate11ZaRequest(whatsappSendToModel.fileBytes!);
//       whatsappSendToModel.contactList!.forEach((element) {
//         element.status = "loading";
//         sendTemplate11Za(whatsappSendToModel.fileBytes!, fileExtension: fileExtension, fileName: whatsappSendToModel.fileName, mo: element.phone);
//       });
//     } else {
//       uploadingStartEnotify();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<double>(
//         stream: progressChange.stream,
//         builder: (context, snapshot) {
//           var progress = snapshot.data ?? 0.0;
//           return ListTile(
//             onTap: () {
//               // OpenFilex.open(widget.d["loc"]);
//               uploadSend();
//             },
//             leading: CircleAvatar(child: Text("${widget.sr}")),
//             title: Text("${whatsappSendToModel.pname}}"),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 LinearProgressIndicator(value: progress),
//                 Text("Upload ${progress.toInt()}%"),
//                 ...whatsappSendToModel.contactList!.map((e) {
//                   return Row(
//                     children: [
//                       Text("Phone: ${e.phone}"),
//                       if (e.status == "true") Icon(Icons.done),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//             trailing: issent.contains("loading")
//                 ? Icon(Icons.watch_later)
//                 : issent.contains("true")
//                     ? Icon(Icons.done_all)
//                     : Icon(Icons.error),
//             // subtitle: ,
//           );
//         });
//   }

//   void uploadingStartEnotify() async {
//     var fileBytes = null;
//     var fileName;
//     var fileExtension = null;
//     if (whatsappSendToModel.fileBytes != null) {
//       fileBytes = whatsappSendToModel.fileBytes;
//       fileName = whatsappSendToModel.fileName ?? "${whatsappSendToModel.pname}.pdf";
//       fileExtension = whatsappSendToModel.fileExtension ?? "pdf";
//     } else {
//       var file = File(whatsappSendToModel.filePath!);
//       fileBytes = await file.readAsBytes();
//       fileName = path.basename(whatsappSendToModel.filePath!);
//       fileExtension = path.extension(whatsappSendToModel.filePath!);
//     }
//     var url = await uploadFileToEnotifyFromFile(fileBytes, fileName, fileExtension);
//     var res;
//     whatsappSendToModel.contactList!.forEach((whatsappSendToContactModel) async {
//       whatsappSendToContactModel.status = "loading";
//       res = await EnotifyApis.sendFileByLink(fileLink: url, toPhone: '91${whatsappSendToContactModel.phone}', textMsg: fileName);
//       if (res["status"] == "success") {
//         whatsappSendToContactModel.status = "true";
//         issent = "true";
//       } else {
//         whatsappSendToContactModel.status = "false";
//         issent = "false";
//       }
//       progressChange.sink.add(100);
//     });
//     // setState(() {});
//   }

//   Future<String?> uploadFileAws(File file) async {
//     // AWSFile creation from path
//     final awsFile = await AWSFile.fromPath(file.path);
//     var imgKeypath = "softwaresExeUpdates/F/${path.basename(file.path)}";
//     print("Uploading file to path: $imgKeypath");

//     try {
//       // Uploading the file with progress tracking
//       var result = await Amplify.Storage.uploadFile(
//         localFile: awsFile,
//         key: imgKeypath,
//         options: StorageUploadFileOptions(
//           accessLevel: StorageAccessLevel.guest, // Check if this access level fits your requirement
//         ),
//         onProgress: (progress) {
//           double percentage = (progress.transferredBytes.toDouble() / progress.totalBytes.toDouble()) * 100;
//           print('Upload progress: ${percentage.toStringAsFixed(2)}%');
//           progressChange.add(percentage);
//         },
//       );

//       // Check if the uploaded key matches the expected key
//       if (result.request.key == imgKeypath) {
//         print('File uploaded successfully: ${result.request.key}');
//       } else {
//         print('File upload failed.');
//         return null;
//       }

//       // Delay to allow time for file visibility
//       await Future.delayed(const Duration(seconds: 2));

//       // Retrieve the URL of the uploaded file
//       var resultUrl = await Amplify.Storage.getUrl(key: imgKeypath);
//       var r = await resultUrl.result;
//       var url = r.url.toString();
//       // from url i need to remove all query params
//       var urlSplit = url.split("?");
//       url = urlSplit[0];

//       return url;
//     } on StorageException catch (e) {
//       print('Error uploading file: $e');
//       return null;
//     }
//   }

//   Future<String?> uploadFileToEnotifyFromFile(Uint8List fileBytes, fileName, fileExtension) async {
//     String url = 'https://enotify.app/api/media/upload/${loginUserModel.enotifyInstance}/png';

//     try {
//       Dio dio = Dio();

//       // Convert the file to a List<int> (byte array)

//       // Get file extension to determine content type

//       String mimeType;
//       switch (fileExtension) {
//         case 'pdf':
//           mimeType = 'application/pdf';
//           break;
//         case 'png':
//           mimeType = 'image/png';
//           break;
//         case 'jpg':
//         case 'jpeg':
//           mimeType = 'image/jpeg';
//           break;
//         default:
//           mimeType = 'application/octet-stream';
//       }

//       // Create MultipartFile from the byte array
//       MultipartFile multipartFile = MultipartFile.fromBytes(
//         fileBytes.toList(),
//         filename: fileName,
//         contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
//       );

//       // Create FormData with the file
//       FormData formData = FormData.fromMap({
//         'file': multipartFile,
//       });

//       // Make the API request
//       Response response = await dio.post(
//         url,
//         data: formData,
//         options: Options(
//           headers: {
//             'Content-Type': 'multipart/form-data',
//           },
//         ),
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             double percentage = (received / total * 100);
//             print('Upload progress: ${percentage.toStringAsFixed(2)}%');
//             progressChange.add(percentage);
//           }
//         },
//       );

//       print('Upload successful: ${response.data}');
//       var mediaId = response.data["mediaId"];
//       return mediaId;
//     } catch (e) {
//       print('Error uploading file: $e');
//       return null;
//     }
//   }

//   Future sendTemplate11Za(Uint8List fileBytes, {mo = "8469190530", required fileExtension, required fileName}) async {
//     var dio = Dio();
//     String mimeType;
//     switch (fileExtension) {
//       case 'pdf':
//         mimeType = 'application/pdf';
//         break;
//       case 'png':
//         mimeType = 'image/png';
//         break;
//       case 'jpg':
//       case 'jpeg':
//         mimeType = 'image/jpeg';
//         break;
//       default:
//         mimeType = 'application/octet-stream';
//     }
//     try {
//       var formData = FormData.fromMap({
//         'authToken': '${empOrderSettingModel.one1Za!.authToken}', // Your 11za Auth Token
//         'sendto': '91$mo',
//         'originWebsite': '${empOrderSettingModel.one1Za!.originWebsite}',
//         'templateName': '${empOrderSettingModel.one1Za!.defTempName}',
//         'myfile': MultipartFile.fromBytes(
//           fileBytes.toList(),
//           filename: fileName,
//           contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
//         ),
//         'language': 'en',
//       });

//       var response = await dio.post(
//         '${empOrderSettingModel.one1Za!.apiUrl}',
//         data: formData,
//         options: Options(
//           headers: {
//             'Content-Type': 'multipart/form-data',
//           },
//         ),
//         onSendProgress: (int sent, int total) {
//           if (total != -1) {
//             double percentage = (sent / total * 100);
//             print('Upload progress: ${percentage.toStringAsFixed(2)}%');
//             progressChange.add(percentage);
//           }
//         },
//       );

//       if (response.statusCode == 200) {
//         issent = "true";
//         progressChange.add(100);
//         print('Request successful');
//       } else {
//         issent = "false";
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       issent = "false";
//       print('Request failed with error: $e');
//     }
//   }
// }



// // void sendTemplate11ZaRequest(Uint8List fileBytes) async {
// //     final dio = Dio();

// //     final authToken =
// //         'U2FsdGVkX1893ZUGoAvdYxb4+r3pmvXvneNSHXPZf6jOg/Xiz/9CCmaUq7tocGLNulCWUPBehmCa6Ei0IiytjsRm8Q09+ifI1Z38YnJwjue3ohKIHPMKyLWkWNk6PdVE6ciEtaIm4H7eOxci3TTRzO1mI+yM6tNWv+51SuwyeS8a20CS9j4OG8t6uj3uu/PQ';

// //     try {
// //       final formData = FormData.fromMap({
// //         'authToken': authToken,
// //         'sendto': '918469190530',
// //         'originWebsite': 'https://www.durgasarees.com/',
// //         'templateName': 'unique_report',
// //         'myfile': MultipartFile.fromBytes(
// //           fileBytes.toList(),
// //           filename: 'SALES_ASHOK_KUMAR_JAIN.pdf',
// //           contentType: MediaType('application', 'pdf'),
// //         ),
// //         'language': 'en',
// //       });

// //       final response = await dio.post(
// //         'https://app.11za.in/apis/template/sendTemplate11Za',
// //         data: formData,
// //         options: Options(
// //           headers: {
// //             'Content-Type': 'multipart/form-data',
// //           },
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         print('Request successful: ${response.data}');
// //       } else {
// //         print('Request failed with status: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error occurred: $e');
// //     }
// //   }
