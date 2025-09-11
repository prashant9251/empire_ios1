import 'dart:io';

import 'package:download/download.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';

abstract class AgEmpOrderListState {}

class AgEmpOrderListStateIni extends AgEmpOrderListState {}

class AgEmpOrderListStateLoadOrder extends AgEmpOrderListState {
  Widget widget;
  AgEmpOrderListStateLoadOrder(this.widget);
}

class AgEmpOrderListStateDownload extends AgEmpOrderListState {
  static void downloadCSVWeb(String csvData, String fileName, context) async {
    final stream = Stream.fromIterable('$csvData'.codeUnits);
    download(stream, 'Sale Order ${Myf.dateFormate(DateTime.now().toString())}.csv');
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
