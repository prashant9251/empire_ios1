import 'dart:io';
import 'dart:typed_data';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class StickerPrintingClass {
  static const int TSC_PRINTER_PORT = 9100; // Default TSC printer port

  /// Print PDF to TSC printer via LAN
  Future<bool> printPdfToTSC({
    required String printerIP,
    required Uint8List pdfBytes,
    int dpi = 203, // TSC printer DPI (203 or 300)
    double labelWidth = 4.0, // inches
    double labelHeight = 6.0, // inches
  }) async {
    try {
      // Convert PDF to image
      final images = await _convertPdfToImages(pdfBytes, dpi);

      for (int i = 0; i < images.length; i++) {
        // Convert image to TSC commands
        final tscCommands = await _generateTSCCommands(images[i], labelWidth, labelHeight, dpi);

        // Send to printer
        final success = await _sendToPrinter(printerIP, tscCommands);
        if (!success) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error printing to TSC: $e');
      return false;
    }
  }

  /// Convert PDF bytes to list of images
  Future<List<img.Image>> _convertPdfToImages(Uint8List pdfBytes, int dpi) async {
    final images = <img.Image>[];

    try {
      // Use printing package to render PDF pages as images
      await for (final page in Printing.raster(pdfBytes, dpi: dpi.toDouble())) {
        final imageBytes = await page.toPng();
        final image = img.decodePng(imageBytes);
        if (image != null) {
          images.add(image);
        }
      }
    } catch (e) {
      print('Error converting PDF to images: $e');
    }

    return images;
  }

  /// Generate TSC printer commands from image
  Future<List<int>> _generateTSCCommands(img.Image image, double labelWidth, double labelHeight, int dpi) async {
    final commands = <String>[];

    // TSC Setup Commands
    commands.add('SIZE $labelWidth,$labelHeight'); // Set label size
    commands.add('GAP 0.1,0'); // Set gap between labels
    commands.add('DIRECTION 1,0'); // Set print direction
    commands.add('REFERENCE 0,0'); // Set reference point
    commands.add('OFFSET 0'); // Set offset
    commands.add('SET PEEL OFF'); // Set peel off
    commands.add('SET CUTTER OFF'); // Set cutter off
    commands.add('SET PARTIAL_CUTTER OFF'); // Set partial cutter off
    commands.add('SPEED 4'); // Set print speed
    commands.add('DENSITY 8'); // Set print density
    commands.add('CLS'); // Clear image buffer

    // Convert image to monochrome bitmap
    final bitmapData = _convertImageToBitmap(image);
    final width = image.width;
    final height = image.height;

    // BITMAP command for printing image
    commands.add('BITMAP 0,0,$width,$height,1,$bitmapData');

    commands.add('PRINT 1,1'); // Print 1 copy

    // Convert commands to bytes
    final commandBytes = <int>[];
    for (final command in commands) {
      commandBytes.addAll(command.codeUnits);
      commandBytes.add(0x0D); // CR
      commandBytes.add(0x0A); // LF
    }

    return commandBytes;
  }

  /// Convert image to bitmap data for TSC printer
  String _convertImageToBitmap(img.Image image) {
    // Convert to grayscale first
    final grayscale = img.grayscale(image);

    // Convert to monochrome (1-bit)
    final width = grayscale.width;
    final height = grayscale.height;
    final bytesPerRow = (width + 7) ~/ 8;

    final bitmapBytes = <int>[];

    for (int y = 0; y < height; y++) {
      for (int byteIndex = 0; byteIndex < bytesPerRow; byteIndex++) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          final x = byteIndex * 8 + bit;
          if (x < width) {
            final pixel = grayscale.getPixel(x, y);
            final luminance = img.getLuminance(pixel);
            // Threshold for black/white conversion
            if (luminance < 128) {
              byte |= (1 << (7 - bit));
            }
          }
        }
        bitmapBytes.add(byte);
      }
    }

    // Convert to hex string
    return bitmapBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  /// Send commands to TSC printer via TCP
  Future<bool> _sendToPrinter(String printerIP, List<int> commands) async {
    Socket? socket;
    try {
      // Connect to printer
      socket = await Socket.connect(printerIP, TSC_PRINTER_PORT, timeout: Duration(seconds: 10));

      // Send commands
      socket.add(commands);
      await socket.flush();

      // Wait a bit for processing
      await Future.delayed(Duration(milliseconds: 500));

      return true;
    } catch (e) {
      print('Error sending to printer: $e');
      return false;
    } finally {
      socket?.close();
    }
  }

  /// Check if TSC printer is online
  Future<bool> isPrinterOnline(String printerIP) async {
    try {
      final socket = await Socket.connect(printerIP, TSC_PRINTER_PORT, timeout: Duration(seconds: 5));
      socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get printer status
  Future<String> getPrinterStatus(String printerIP) async {
    Socket? socket;
    try {
      socket = await Socket.connect(printerIP, TSC_PRINTER_PORT, timeout: Duration(seconds: 5));

      // Send status command
      socket.add('~HS\r\n'.codeUnits);
      await socket.flush();

      // Read response
      final response = await socket.first;
      return String.fromCharCodes(response);
    } catch (e) {
      return 'Error: $e';
    } finally {
      socket?.close();
    }
  }
}

// Usage Example Widget
class TSCPrintScreen extends StatefulWidget {
  @override
  _TSCPrintScreenState createState() => _TSCPrintScreenState();
}

class _TSCPrintScreenState extends State<TSCPrintScreen> {
  final StickerPrintingClass _printerService = StickerPrintingClass();
  final TextEditingController _ipController = TextEditingController(text: '192.168.1.100');
  bool _isPrinting = false;
  String _status = 'Ready';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TSC Printer'), backgroundColor: jsmColor),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Printer IP Address',
                hintText: '192.168.1.100',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkPrinterStatus,
                    child: Text('Check Status'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isPrinting ? null : _printSamplePDF,
                    child: _isPrinting ? CircularProgressIndicator(strokeWidth: 2) : Text('Print PDF'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Status: $_status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPrinterStatus() async {
    setState(() => _status = 'Checking...');

    final isOnline = await _printerService.isPrinterOnline(_ipController.text);
    if (isOnline) {
      final status = await _printerService.getPrinterStatus(_ipController.text);
      setState(() => _status = 'Online - $status');
    } else {
      setState(() => _status = 'Offline or unreachable');
    }
  }

  Future<void> _printSamplePDF() async {
    setState(() {
      _isPrinting = true;
      _status = 'Printing...';
    });

    try {
      // Create a sample PDF or load your PDF bytes here
      final pdfBytes = await _createSamplePDF();

      final success = await _printerService.printPdfToTSC(
        printerIP: _ipController.text,
        pdfBytes: pdfBytes,
        labelWidth: 4.0,
        labelHeight: 6.0,
      );

      setState(() => _status = success ? 'Print completed' : 'Print failed');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<Uint8List> _createSamplePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Sample Label', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Printed via Flutter'),
                pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
