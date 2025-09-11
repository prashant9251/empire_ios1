import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class fullScreenImg extends StatefulWidget {
  dynamic d;

  fullScreenImg({Key? key, required this.img_list, this.index, this.d}) : super(key: key);
  var index;
  List img_list;
  @override
  State<fullScreenImg> createState() => _fullScreenImgState();
}

class _fullScreenImgState extends State<fullScreenImg> {
  var iniindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: img()),
    );
  }

  Stack img() {
    return Stack(children: [
      PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        // enableRotation: true,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: imggetLocal(index),
            initialScale: PhotoViewComputedScale.contained * 1,
          );
        },
        itemCount: widget.img_list.length,
      ),
    ]);
  }

  imggetLocal(index) {
    return CachedNetworkImageProvider(widget.img_list[index]);
  }
}
