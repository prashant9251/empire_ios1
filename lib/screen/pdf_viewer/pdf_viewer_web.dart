import 'dart:typed_data';
import 'dart:html' as html;

void viewPdf(Uint8List pdfBytes, {required fileName, cmd}) {
  if (cmd == "print") {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    return;
  }
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create an anchor element to download the PDF
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  // Clean up the Object URL after the download is initiated
  html.Url.revokeObjectUrl(url);
}
