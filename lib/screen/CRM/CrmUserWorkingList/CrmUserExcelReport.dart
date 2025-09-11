import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart';
import 'package:share_plus/share_plus.dart'; // Import the conditional import file

class CrmUserExcelReport {
  static jsonToExcel(List<Map<String, dynamic>> json) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    CellStyle cellStyle = CellStyle(backgroundColorHex: ExcelColor.none, fontFamily: getFontFamily(FontFamily.Calibri));

    cellStyle.underline = Underline.Single; // or Underline.Double

    if (json.isNotEmpty) {
      // Add headers
      json.first.keys.toList().asMap().forEach((index, key) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 0));
        cell.value = TextCellValue(key);
        cell.cellStyle = cellStyle;
      });

      // Add data
      for (var i = 0; i < json.length; i++) {
        var data = json[i];
        data.values.toList().asMap().forEach((index, value) {
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: index, rowIndex: i + 1));
          cell.value = TextCellValue(value.toString());
          cell.cellStyle = cellStyle;
        });
      }
    }

    var excelBytes = await excel.encode();
    if (kIsWeb) {
      viewPdf(Uint8List.fromList(excelBytes!), fileName: 'CrmUserWorkingList.xlsx');
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final String fileName = '$path/CrmUserWorkingList.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(excelBytes!);
      Share.shareXFiles([XFile(file.path)]);
    }
  }
}
