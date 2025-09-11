import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class BarCodeScaneGoogleMlKit {
  static Future<String?> startScane() async {
    XFile? f = await ImagePicker().pickImage(source: ImageSource.camera);
    var rawValue = "";
    if (f != null) {
      final List<BarcodeFormat> formats = [BarcodeFormat.all];
      final barcodeScanner = BarcodeScanner(formats: formats);
      final List<Barcode> barcodes = await barcodeScanner.processImage(
        InputImage.fromFilePath(f.path),
      );
      barcodeScanner.close();
      for (Barcode barcode in barcodes) {
        // final BarcodeType type = barcode.type;
        // final Rect boundingBox = barcode.boundingBox;
        // final String? displayValue = barcode.displayValue;
        rawValue = barcode.rawValue!;
        break; // Return the first barcode found
      }
    }
    return rawValue;
  }
}
