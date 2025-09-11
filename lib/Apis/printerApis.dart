import 'dart:typed_data';

import 'package:empire_ios/Models/BillDispatchModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List?> stickerPrint(BillDispatchModel? billDispatchModel) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(2.5 * PdfPageFormat.inch, 1 * PdfPageFormat.inch),
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text("${billDispatchModel!.bill ?? ""}", style: pw.TextStyle(fontSize: 15)),
              pw.Text("OK", style: pw.TextStyle(fontSize: 15)),
              pw.Text("${Myf.dateFormateYYYYMMDD(billDispatchModel.cTime, formate: "dd-MM-yyyy hh:mm a") ?? ""}", style: pw.TextStyle(fontSize: 15)),
            ],
          ),
        );
      },
    ),
  );

  final bytes = await pdf.save();
  return bytes;
}
