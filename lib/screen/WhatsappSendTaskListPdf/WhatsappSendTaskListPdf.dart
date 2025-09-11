// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/Apis/Enotify.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart'; // For MediaType

class WhatsappSendTaskListPdf extends StatefulWidget {
  var UserObj;

  List<WhatsappSendToModel> whatsappSendToModelList;
  var shareBy;
  WhatsappSendTaskListPdf({Key? key, required this.UserObj, required this.whatsappSendToModelList, this.shareBy}) : super(key: key);

  @override
  State<WhatsappSendTaskListPdf> createState() => _WhatsappSendTaskListPdfState();
}

class _WhatsappSendTaskListPdfState extends State<WhatsappSendTaskListPdf> {
  int completedTasks = 0;

  void checkAllTasksCompleted() {
    if (completedTasks == widget.whatsappSendToModelList.length) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var sr = 0;
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text("TaskList")),
      body: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: widthResponsive(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...widget.whatsappSendToModelList.map((whatsappSendToModel) {
                  sr++;
                  return WhatsappSendTaskListPdfCard(
                    sr: sr,
                    whatsappSendToModel: whatsappSendToModel,
                    UserObj: widget.UserObj,
                    shareBy: widget.shareBy,
                    onTaskCompleted: () {
                      if (mounted) {
                        setState(() {
                          completedTasks++;
                          checkAllTasksCompleted();
                        });
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WhatsappSendTaskListPdfCard extends StatefulWidget {
  var shareBy;
  final VoidCallback onTaskCompleted;
  WhatsappSendTaskListPdfCard(
      {Key? key, required this.sr, required this.whatsappSendToModel, required this.UserObj, this.shareBy, required this.onTaskCompleted})
      : super(key: key);

  final int sr;
  final WhatsappSendToModel whatsappSendToModel;
  final dynamic UserObj;

  @override
  State<WhatsappSendTaskListPdfCard> createState() => _WhatsappSendTaskListPdfCardState();
}

class _WhatsappSendTaskListPdfCardState extends State<WhatsappSendTaskListPdfCard> {
  var progressChange = StreamController<double>.broadcast();
  WhatsappSendToModel whatsappSendToModel = WhatsappSendToModel();
  var issent = "loading";
  @override
  void initState() {
    super.initState();
    whatsappSendToModel = widget.whatsappSendToModel;
    uploadSend();
  }

  void uploadSend() async {
    var fileBytes = null;
    var fileName;
    var fileExtension = null;
    if (whatsappSendToModel.fileBytes != null) {
      fileBytes = whatsappSendToModel.fileBytes;
      fileName = whatsappSendToModel.fileName ?? "${whatsappSendToModel.pname}.pdf";
      fileExtension = whatsappSendToModel.fileExtension ?? "pdf";
    } else {
      var file = File(whatsappSendToModel.filePath!);
      fileBytes = await file.readAsBytes();
      fileName = path.basename(whatsappSendToModel.filePath!);
      fileExtension = path.extension(whatsappSendToModel.filePath!);
    }
    if (empOrderSettingModel.one1Za!.authToken != null) {
      (whatsappSendToModel.contactList ?? []).forEach((element) {
        element.status = "loading";
        var phone = element.phone!.replaceAll(RegExp(r'[^0-9]'), '');
        if (phone.startsWith('0')) {
          phone = phone.substring(1);
        } else if (phone.startsWith('91')) {
          phone = phone.substring(2);
        } else if (phone.startsWith('+91')) {
          phone = phone.substring(3);
        }
        sendTemplate11Za(fileBytes, fileExtension: fileExtension, fileName: fileName, mo: phone);
      });
    } else {
      uploadingStartEnotify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: progressChange.stream,
        builder: (context, snapshot) {
          var progress = snapshot.data ?? 0.0;
          return ListTile(
            onTap: () {
              uploadSend();
            },
            leading: CircleAvatar(child: Text("${widget.sr}")),
            title: Text("${whatsappSendToModel.pname}}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: progress),
                Text("Upload ${progress.toInt()}%"),
                ...whatsappSendToModel.contactList!.map((e) {
                  return Row(
                    children: [
                      Text("Phone: ${e.phone}"),
                      if (e.status == "true") Icon(Icons.done),
                    ],
                  );
                }).toList(),
              ],
            ),
            trailing: issent.contains("loading")
                ? Icon(Icons.watch_later)
                : issent.contains("true")
                    ? Icon(Icons.done_all)
                    : Icon(Icons.error),
          );
        });
  }

  void uploadingStartEnotify() async {
    var fileBytes = null;
    var fileName;
    var fileExtension = null;
    if (whatsappSendToModel.fileBytes != null) {
      fileBytes = whatsappSendToModel.fileBytes;
      fileName = whatsappSendToModel.fileName ?? "${whatsappSendToModel.pname}.pdf";
      fileExtension = whatsappSendToModel.fileExtension ?? "pdf";
    } else {
      var file = File(whatsappSendToModel.filePath!);
      fileBytes = await file.readAsBytes();
      fileName = path.basename(whatsappSendToModel.filePath!);
      fileExtension = path.extension(whatsappSendToModel.filePath!);
    }
    var url = await uploadFileToEnotifyFromFile(fileBytes, fileName, fileExtension);
    var res;
    whatsappSendToModel.contactList!.forEach((whatsappSendToContactModel) async {
      whatsappSendToContactModel.status = "loading";
      res = await EnotifyApis.sendFileByLink(fileLink: url, toPhone: '91${whatsappSendToContactModel.phone}', textMsg: fileName);
      if (res["status"] == "success") {
        Myf.saveLastPdfSentDate(context, MasterModel(partyname: whatsappSendToModel.pname, value: whatsappSendToModel.pcode));
        whatsappSendToContactModel.status = "true";
        issent = "true";
      } else {
        whatsappSendToContactModel.status = "false";
        issent = "false";
      }
      progressChange.sink.add(100);
      widget.onTaskCompleted();
    });
  }

  // Future<String?> uploadFileAws(File file) async {
  //   final awsFile = await AWSFile.fromPath(file.path);
  //   var imgKeypath = "softwaresExeUpdates/F/${path.basename(file.path)}";
  //   print("Uploading file to path: $imgKeypath");

  //   try {
  //     var result = await Amplify.Storage.uploadFile(
  //       localFile: awsFile,
  //       path: StoragePath.fromString(imgKeypath),
  //       options: StorageUploadFileOptions(
  //           // accessLevel: StorageAccessLevel.guest,
  //           ),
  //       onProgress: (progress) {
  //         double percentage = (progress.transferredBytes.toDouble() / progress.totalBytes.toDouble()) * 100;
  //       },
  //     );
  //     if (result.request.path.toString() == imgKeypath) {
  //       print('File uploaded successfully: ${result.request.path.toString()}');
  //     } else {
  //       print('File upload failed.');
  //       return null;
  //     }

  //     await Future.delayed(const Duration(seconds: 2));

  //     var resultUrl = await Amplify.Storage.getUrl(path: StoragePath.fromString(imgKeypath));
  //     var r = await resultUrl.result;
  //     var url = r.url.toString();
  //     var urlSplit = url.split("?");
  //     url = urlSplit[0];

  //     return url;
  //   } on StorageException catch (e) {
  //     print('Error uploading file: $e');
  //     return null;
  //   }
  // }

  Future<String?> uploadFileToEnotifyFromFile(Uint8List fileBytes, fileName, fileExtension) async {
    String url = 'https://enotify.app/api/media/upload/${loginUserModel.enotifyInstance}/png';

    try {
      Dio dio = Dio();

      String mimeType;
      switch (fileExtension) {
        case 'pdf':
          mimeType = 'application/pdf';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        default:
          mimeType = 'application/pdf';
      }

      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes.toList(),
        filename: fileName,
        contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
      );

      FormData formData = FormData.fromMap({
        'file': multipartFile,
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double percentage = (received / total * 100);
            print('Upload progress: ${percentage.toStringAsFixed(2)}%');
            progressChange.add(percentage);
          }
        },
      );

      print('Upload successful: ${response.data}');
      var mediaId = response.data["mediaId"];
      return mediaId;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future sendTemplate11Za(Uint8List fileBytes, {mo = "", required fileExtension, required fileName}) async {
    var dio = Dio();
    String mimeType;
    switch (fileExtension) {
      case 'pdf':
        mimeType = 'application/pdf';
        break;
      case 'png':
        mimeType = 'image/png';
        break;
      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;
      default:
        mimeType = 'application/pdf';
    }
    try {
      var formData = FormData.fromMap({
        'authToken': '${empOrderSettingModel.one1Za!.authToken}',
        'sendto': '91$mo',
        'originWebsite': '${empOrderSettingModel.one1Za!.originWebsite}',
        'templateName':
            '${whatsappSendToModel.type == "order" ? (empOrderSettingModel.one1Za!.orderTempName ?? "") : empOrderSettingModel.one1Za!.defTempName}',
        'data[0]': "${whatsappSendToModel.pname}",
        'data[1]': "${whatsappSendToModel.city ?? ""}",
        'myfile': MultipartFile.fromBytes(
          fileBytes.toList(),
          filename: fileName,
          contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
        ),
        'language': 'en',
      });

      var response = await dio.post(
        '${empOrderSettingModel.one1Za!.apiUrl}',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (int sent, int total) {
          if (total != -1) {
            double percentage = (sent / total * 100);
            print('Upload progress: ${percentage.toStringAsFixed(2)}%');
            progressChange.add(percentage);
          }
        },
      );

      if (response.statusCode == 200) {
        issent = "true";
        progressChange.add(100);
        Myf.saveLastPdfSentDate(context, MasterModel(partyname: whatsappSendToModel.pname, value: whatsappSendToModel.pcode));
        print('Request successful');
      } else {
        issent = "false";
        print('Request failed with status: ${response.statusCode}');
      }
      widget.onTaskCompleted();
    } catch (e) {
      issent = "false";
      print('Request failed with error: $e');
      widget.onTaskCompleted();
    }
  }
}
