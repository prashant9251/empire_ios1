import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/cubit/ProductFirebaseListCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart' as pp;

class ProductCardTileFirebaseCarouselSlider extends StatelessWidget {
  List imgL;
  var imgwidth;
  ProductCardTileFirebaseCarouselSlider({Key? key, required this.imgL, required this.imgwidth}) : super(key: key);

  static Widget view(String url) {
    return FutureBuilder<String>(
      future: loadPdf(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          var path = snapshot.data;
          return path == "" ? Center(child: Icon(Icons.error, color: Colors.red)) : Image.file(File(path!));
        }
      },
    );
  }

  static Future<String> loadPdf(String url) async {
    // PRODUCT_IMG_BOX.clear();
    try {
      var path = await PRODUCT_IMG_BOX!.get(url) ?? "";
      if (File(path).existsSync()) {
        return path;
      }
    } catch (e) {}
    try {
      Directory tempDir = await getTemporaryDirectory();
      var datetime = DateTime.now().toString();
      File nfile = await File("${tempDir.path}$datetime.png").create();
      File? f = await baseCacheManager.getSingleFile(url);
      var mimeType = Myf.getMimeType(f.path);
      if (mimeType == "pdf") {
        await for (var page in pp.Printing.raster(f.readAsBytesSync(), pages: [0], dpi: PdfPageFormat.cm)) {
          var image = await page.toPng();
          await nfile.writeAsBytes(image);
        }
        PRODUCT_IMG_BOX!.put(url, nfile.path);
        return nfile.path;
      } else {
        PRODUCT_IMG_BOX!.put(url, f.path);
        return f.path;
      }
    } catch (e) {
      return "";
    }
  }

  var activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    double margin = 10;
    return Stack(
      alignment: Alignment.center,
      children: [
        ...imgL.map((e) {
          var mimeType = Myf.getMimeType(e);
          margin = margin + 10;

          return Positioned(
              child: Container(
                  // margin: EdgeInsets.only(top: margin, left: margin),
                  color: Colors.grey,
                  child: view(e)));
        }).toList()
      ],
    );
  }
}
