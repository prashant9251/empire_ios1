import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

htmlToPdf(String? htmlContent, fileName) async {
  var dirPath = await getApplicationDocumentsDirectory();
  final file = await HtmlToPdf.convertFromHtmlContent(
    htmlContent: htmlContent!,
    printPdfConfiguration: PrintPdfConfiguration(
      targetDirectory: dirPath.path,
      targetName: "$fileName.pdf",
      printSize: PrintSize.A3,
      printOrientation: PrintOrientation.Portrait,
    ),
  );
  // OpenFilex.open(file.path);
  return file;
}
