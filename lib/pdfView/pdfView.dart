import 'dart:io';
import 'dart:typed_data';

import 'package:empire_ios/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart';

class PdfView extends StatefulWidget {
  XFile? pdfFile;
  Uint8List? bytes;
  bool? directPrint;
  PdfView({Key? key, this.pdfFile, this.bytes, this.directPrint = false}) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getData() async {
    if (widget.directPrint == true) {
      if (widget.bytes != null) {
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => widget.bytes!);
        if (getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.desktop) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("PDF Viewer"),
        actions: [
          IconButton(
            onPressed: () async {
              if (kIsWeb) {
                viewPdf(widget.bytes!, fileName: 'PDF ${DateTime.now().toString()}.pdf');
              } else {
                var dir = await getTemporaryDirectory();
                File f = File('${dir.path}/example.pdf');
                f.writeAsBytesSync(widget.bytes!);
                widget.pdfFile = XFile(f.path);
                if (widget.pdfFile != null) {
                  // save bytes and share xfile
                  Share.shareXFiles([widget.pdfFile!]);
                }
              }
            },
            icon: Icon(Icons.share),
          ),
          IconButton(
              onPressed: () async {
                // print pdf in web
                // Printing.pickPrinter(context: context);
                if (widget.bytes != null) {
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => widget.bytes!,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No PDF bytes available")),
                  );
                }
              },
              icon: Icon(Icons.print)),
        ],
      ),
      body: Center(child: Text("No PDF View available")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.pdfFile != null) {
            Share.shareXFiles([widget.pdfFile!]);
          }
        },
        child: Icon(Icons.share),
      ),
    );
  }
}
