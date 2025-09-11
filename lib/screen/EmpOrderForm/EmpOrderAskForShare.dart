import 'dart:async';
import 'dart:typed_data';

import 'package:empire_ios/Classes/PdfToImageConverter.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class EmpOrderAskForShare {
  static start(context, Uint8List bytes, String name) async {
    var completer = Completer();
    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Scaffold(
            body: Container(
              // color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Share", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.open_in_new, color: Colors.black54),
                        onPressed: () {
                          if (kIsWeb) {
                            viewPdf(bytes, fileName: name);
                            Navigator.pop(context);
                            return;
                          }
                          Myf.saveFileFromBytes(bytes, name: name).then((file) {
                            if (file != null) {
                              OpenFilex.open(file.path, type: "application/pdf").then((value) {
                                if (value.type == ResultType.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error opening file: ${value.message}")));
                                } else {
                                  completer.complete(file);
                                  Navigator.of(context).pop();
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving file")));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  GFListTile(
                    onTap: () {
                      Myf.saveFileFromBytes(bytes, name: name).then((file) async {
                        if (file != null) {
                          await SharePlus.instance.share(ShareParams(text: "Check out this report!", files: [XFile(file.path)]));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving file")));
                        }
                      });
                    },
                    titleText: "Share as PDF",
                    subTitleText: "Share the report as a PDF file",
                    icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  Divider(),
                  GFListTile(
                    onTap: () {
                      PdfToImageConverter.convertPdfBytesToImage(pdfBytes: bytes).then((image) async {
                        if (image != null) {
                          var f = await Myf.saveFileFromBytes(image, name: name.replaceAll(".pdf", ".png"));
                          await SharePlus.instance.share(ShareParams(text: "", files: [XFile(f!.path)]));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error converting PDF to image")));
                        }
                      });
                    },
                    titleText: "Share as Image",
                    subTitleText: "Share the report as an image file",
                    icon: Icon(Icons.image, color: Colors.blue),
                  ),
                  GFListTile(
                    onTap: () {
                      PdfToImageConverter.convertPdfBytesToImage(pdfBytes: bytes).then((image) async {
                        if (image != null) {
                          var f = await Myf.saveFileFromBytes(image, name: name.replaceAll(".pdf", ".png"));
                          OpenFilex.open(f!.path, type: "image/png").then((value) {
                            if (value.type == ResultType.error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error opening file: ${value.message}")));
                            } else {
                              completer.complete(f);
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error converting PDF to image")));
                        }
                      });
                    },
                    titleText: "Direct share to Contacts",
                    subTitleText: "Share the report directly with contacts",
                    icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  Divider(),
                  GFButton(
                    onPressed: () {
                      completer.complete(null);
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    fullWidthButton: true,
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return await completer.future;
  }
}
