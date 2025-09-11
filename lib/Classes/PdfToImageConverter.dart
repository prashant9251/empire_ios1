import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfToImageConverter {
  // Method 1: Convert PDF file to image
  static Future<Uint8List?> convertPdfToImage({required String pdfPath, int pageIndex = 0, double dpi = 300}) async {
    try {
      // Read PDF file
      final file = File(pdfPath);
      final pdfData = await file.readAsBytes();

      // Convert PDF page to image
      final images = Printing.raster(
        pdfData,
        pages: [pageIndex], // Specify which page to convert
        dpi: dpi, // Higher DPI = better quality
      );

      await for (final page in images) {
        return await page.toPng();
      }

      return null;
    } catch (e) {
      print('Error converting PDF to image: $e');
      return null;
    }
  }

  // Method 2: Convert PDF bytes to image
  static Future<Uint8List?> convertPdfBytesToImage({required Uint8List pdfBytes, int pageIndex = 0, double dpi = 300}) async {
    try {
      // Convert PDF page to image, preserving original page padding
      final images = Printing.raster(
        pdfBytes,
        pages: [pageIndex],
        dpi: dpi,
        // Do not set 'crop' or 'margin' so original padding is preserved
      );

      await for (final page in images) {
        return await page.toPng();
      }

      return null;
    } catch (e) {
      print('Error converting PDF bytes to image: $e');
      return null;
    }
  }

  // Method 3: Convert all PDF pages to images
  static Future<List<Uint8List>> convertAllPagesToImages({required String pdfPath, double dpi = 300}) async {
    try {
      final file = File(pdfPath);
      final pdfData = await file.readAsBytes();

      // Get all pages as images
      final images = Printing.raster(pdfData, dpi: dpi);

      List<Uint8List> result = [];
      await for (final page in images) {
        result.add(await page.toPng());
      }
      return result;
    } catch (e) {
      print('Error converting PDF pages to images: $e');
      return [];
    }
  }

  // Save image to device and share
  static Future<void> saveAndShareImage(Uint8List imageBytes, String fileName) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/$fileName.png';

      // Save image to file
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      // Share the image
      await Share.shareXFiles([XFile(imagePath)], text: 'PDF converted to image');
    } catch (e) {
      print('Error saving and sharing image: $e');
    }
  }
}

// Example Widget showing how to use the converter
class PdfToImageDemo extends StatefulWidget {
  @override
  _PdfToImageDemoState createState() => _PdfToImageDemoState();
}

class _PdfToImageDemoState extends State<PdfToImageDemo> {
  Uint8List? _imageBytes;
  bool _isLoading = false;

  // Example: Convert a sample PDF
  Future<void> _convertPdfToImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your PDF file path
      String pdfPath = '/path/to/your/file.pdf';

      final imageBytes = await PdfToImageConverter.convertPdfToImage(
        pdfPath: pdfPath,
        pageIndex: 0, // First page
        dpi: 300, // High quality
      );

      setState(() {
        _imageBytes = imageBytes;
        _isLoading = false;
      });

      if (imageBytes != null) {
        // Optionally share immediately
        await PdfToImageConverter.saveAndShareImage(imageBytes, 'pdf_page_${DateTime.now().millisecondsSinceEpoch}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF to Image Converter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator()
            else if (_imageBytes != null)
              Container(height: 400, child: Image.memory(_imageBytes!))
            else
              Text('No image converted yet'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _isLoading ? null : _convertPdfToImage, child: Text('Convert PDF to Image')),
            if (_imageBytes != null)
              ElevatedButton(
                onPressed: () async {
                  await PdfToImageConverter.saveAndShareImage(_imageBytes!, 'converted_pdf_${DateTime.now().millisecondsSinceEpoch}');
                },
                child: Text('Share Image'),
              ),
          ],
        ),
      ),
    );
  }
}
