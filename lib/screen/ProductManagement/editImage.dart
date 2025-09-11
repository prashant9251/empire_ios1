// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';

import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/painting.dart' as pp;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart' as mt;

class buildPDFImageClass {
  static rename({required ProductModel QUL_OBJ}) async {
    var v_rateType = shareSettingObj["v_rateType"] ?? "S1";
    var boolviewDno = shareSettingObj["v_name"] ?? false;
    var boolviewPrice = shareSettingObj["v_rate"] ?? false;
    var boolviewMainScreenName = shareSettingObj["v_mainscreen"] ?? false;
    var boolviewFabricsName = shareSettingObj["v_fabrics"] ?? false;
    var f = File("${QUL_OBJ.cacheFilePath}");
    final appStorage = await getTemporaryDirectory();
    var path = "${appStorage.path}/";
    if (!Directory(path).existsSync()) {
      await Directory(path).create();
    }
    String datetime = DateTime.now().toString();
    var rate = "";
    switch (v_rateType) {
      case "S1":
        rate = "${QUL_OBJ.qualModel!.s1}";
        break;
      case "S2":
        rate = "${QUL_OBJ.qualModel!.s2}";
        break;
      case "S3":
        rate = "${QUL_OBJ.qualModel!.s3}";
        break;
      default:
    }
    var newName = "";
    newName += shareSettingObj["v_mainscreen"].toString().contains("true") ? "${QUL_OBJ.qualModel!.mainScreen} " : " ";
    newName += shareSettingObj["v_fabrics"].toString().contains("true") ? "${QUL_OBJ.qualModel!.baseQual} " : " ";
    newName += shareSettingObj["v_name"].toString().contains("true") ? "${QUL_OBJ.qualModel!.value} " : " ";
    newName += shareSettingObj["v_rate"].toString().contains("true") ? "RATE: ${rate}/- " : " ";
    newName += ".pdf";
    newName = newName.toString().replaceAll("/", "");
    final file = File("$path$newName");
    Uint8List bytes = f.readAsBytesSync();
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(bytes);
    await raf.close();
    return file;
  }

  static Future<File> copyWithNewName(newName, filePath) async {
    final appStorage = await getTemporaryDirectory();
    var path = "${appStorage.path}/";
    if (!Directory(path).existsSync()) {
      await Directory(path).create();
    }
    var mimeType = Myf.getMimeType(filePath);
    String datetime = DateTime.now().toString();
    var f = File(filePath);
    // newName += "  ${datetime}";
    newName += ".$mimeType";
    newName = newName.toString().replaceAll("/", "");
    final file = File("$path$newName");
    Uint8List bytes = f.readAsBytesSync();
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(bytes);
    await raf.close();
    return file;
  }

  static Future<Widget> buildPDFImage({required ProductModel QUL_OBJ}) async {
    final backImage = await flutterImageProvider(pp.FileImage(await File("${QUL_OBJ.cacheFilePath}")));
    final textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontBold: Font.helveticaBold(), color: PdfColors.white);
    const double containerHeight = 85;
    var v_rateType = shareSettingObj["v_rateType"] ?? "S1";
    var boolviewDno = shareSettingObj["v_name"] ?? false;
    var boolviewPrice = shareSettingObj["v_rate"] ?? false;
    var boolviewMainScreenName = shareSettingObj["v_mainscreen"] ?? false;
    var boolviewFabricsName = shareSettingObj["v_fabrics"] ?? false;
    var rate = "";
    switch (v_rateType) {
      case "S1":
        rate = "${QUL_OBJ.qualModel!.s1}";
        break;
      case "S2":
        rate = "${QUL_OBJ.qualModel!.s2}";
        break;
      case "S3":
        rate = "${QUL_OBJ.qualModel!.s3}";
        break;
      default:
    }
    return await Stack(
      alignment: Alignment.center,
      children: [
        await Image(backImage),
        await Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          // top: 0,
          child: Opacity(
            opacity: 0.3,
            child: Container(
              height: containerHeight,
              color: const PdfColor.fromInt(0xFF0E3311),
            ),
          ),
        ),
        (boolviewDno || boolviewPrice || boolviewMainScreenName || boolviewFabricsName)
            ? await Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                // top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: containerHeight,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: shareSettingObj["v_mainscreen"].toString().contains("true")
                              ? Text("${QUL_OBJ.qualModel!.mainScreen}", style: textStyle)
                              : SizedBox.shrink()),
                      Align(
                          alignment: Alignment.centerRight,
                          child: shareSettingObj["v_fabrics"].toString().contains("true")
                              ? Text("${QUL_OBJ.qualModel!.baseQual}", style: textStyle)
                              : SizedBox.shrink()),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: shareSettingObj["v_name"].toString().contains("true")
                              ? Text("Name: ${QUL_OBJ.qualModel!.value}", style: textStyle)
                              : SizedBox.shrink()),
                      Align(
                          alignment: Alignment.centerRight,
                          child:
                              shareSettingObj["v_rate"].toString().contains("true") ? Text("RATE: ${rate}/-", style: textStyle) : SizedBox.shrink()),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
