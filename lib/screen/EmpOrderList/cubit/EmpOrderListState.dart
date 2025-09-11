import 'dart:convert';
import 'dart:io';

import 'package:download/download.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

abstract class EmpOrderListState {}

class EmpOrderListStateIni extends EmpOrderListState {}

class EmpOrderListStateLoadOrder extends EmpOrderListState {
  Widget widget;
  EmpOrderListStateLoadOrder(this.widget);
}

class EmpOrderListStateDownload extends EmpOrderListState {
  static void downloadCSVWeb(String csvData, String fileName, context, {title = 'Sale order'}) async {
    final stream = Stream.fromIterable('$csvData'.codeUnits);
    download(stream, '$title ${Myf.dateFormate(DateTime.now().toString())}.csv');
    return;
  }

// Function for mobile-based file download
  static void downloadCSVMobile(String csvData, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(csvData);
    Share.shareXFiles([XFile(file.path)]);
    // OpenFilex.open((file.path));
    //print('CSV file saved to: ${file.path}');
  }
}
