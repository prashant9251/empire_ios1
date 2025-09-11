import 'dart:io';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:html/dom.dart' as dom;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pp;
import 'package:printing/printing.dart';
import 'package:html/parser.dart';

class WebViewCreatePdfClass {
  static Future<File?> createPdf(PdfCreationParams params) async {
    // await WidgetsFlutterBinding.ensureInitialized();

    var htmlContent = params.htmlContent;
    final name = params.name;
    final showLoader = params.showLoader;
    final filepath = params.applicationDocDirectory;
    var path = "$filepath/";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yy h:mm a', 'en_US').format(now);
    File file = File("$path$name(PDF GENERATED ON $formattedDate).pdf");

    // Load CSS styles
    htmlContent = await loadCssStyles(htmlContent);

    // Remove script tags
    htmlContent = await removeScriptTags(htmlContent);

    if (Platform.isAndroid) {
      PdfPageFormat pdfFormat = PdfPageFormat(
        210.0 * PdfPageFormat.mm,
        297.0 * PdfPageFormat.mm,
      );

      var pdf = await Printing.convertHtml(
        format: pdfFormat.portrait,
        html: htmlContent,
      );

      file = await file.writeAsBytes(pdf.buffer.asUint8List());
    } else if (Myf.isIos()) {
      await Myf.deleteFile(file);

      var pdf = await Printing.convertHtml(
        format: PdfPageFormat.a3,
        html: htmlContent,
      );

      await file.writeAsBytes(await pdf.buffer.asUint8List());
    }
    return file;
  }

  static Future<String> loadCssStyles(String html) async {
    final document = parse(html);
    for (dom.Element child in document.head?.children ?? []) {
      if (child.localName == "link" && child.attributes["rel"] == "stylesheet") {
        var cssContent = "";
        try {
          cssContent = await rootBundle.loadString("assets$assethtmlFolder$assethtmlSubFolder/${child.attributes["href"]}");
        } catch (e) {
          // Handle error loading CSS content (log, show error message, etc.)
        }
        html = html.replaceAll(child.outerHtml, "<style>\n$cssContent\n</style>");
      }
    }
    return html;
  }

  static Future<String> removeScriptTags(String html) async {
    final document = await parse(html);
    document.querySelectorAll('script').forEach((element) => element.remove());
    return await document.outerHtml;
  }
}

class PdfCreationParams {
  final String htmlContent;
  final String name;
  final String applicationDocDirectory;
  final bool showLoader;

  PdfCreationParams({
    required this.htmlContent,
    required this.name,
    required this.applicationDocDirectory,
    required this.showLoader,
  });
}
