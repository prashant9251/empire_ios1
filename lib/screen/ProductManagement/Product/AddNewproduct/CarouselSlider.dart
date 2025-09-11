import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/imagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../main.dart';

class CarouselSliderCustom extends StatefulWidget {
  CarouselSliderCustom({Key? key, required this.ctrlUploadType}) : super(key: key);
  TextEditingController ctrlUploadType;
  @override
  State<CarouselSliderCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<CarouselSliderCustom> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<XFile>>(
        stream: uploadImgListSelect.stream,
        builder: (context, snapshot) {
          List<XFile>? l = snapshot.data != null ? snapshot.data : [];
          if (l!.length > 0) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                  disableGesture: true,
                  options: CarouselOptions(

                      // height: 300,
                      // autoPlay: true,
                      // autoPlayInterval: const Duration(seconds: 1),
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) => setState(() => activeIndex = index)),
                  itemCount: l.length,
                  itemBuilder: (context, index, realindex) {
                    // //print(l[index].path);
                    var mimeType = Myf.getMimeType(l[index].path);
                    return mimeType == "pdf"
                        ? pdfView(l[index].path)
                        : GestureDetector(
                            onTap: () {
                              OpenFilex.open(l[index].path);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  color: Colors.grey,
                                  child: Image.file(
                                    File(l[index].path),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      l.remove(l[index]);
                                      uploadImgListSelect.sink.add(l);
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: l.length,
                  ),
                )
              ],
            );
          } else {
            return InkWell(
              onTap: () => imgpick.showPhotoOptions(context, widget.ctrlUploadType),
              child: Icon(
                Icons.camera_front_rounded,
                color: Colors.grey,
                size: 100,
              ),
            );
          }
        });
  }

  Widget pdfView(String path) {
    // OpenFile.open(f);

    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: PDF(defaultPage: 1).fromPath(path),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              uploadImgListSelect.sink.add([]);
            },
            child: const Icon(Icons.delete, color: Colors.red, size: 30),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: ElevatedButton(
              child: Text("OPEN"),

              onPressed: () => OpenFilex.open(path), //Myf.Navi(context, PdfView(pdfFile: File(path))),
            ))
      ],
    );
  }
}
