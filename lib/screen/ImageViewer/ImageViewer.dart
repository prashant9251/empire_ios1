import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  final List<String> images;
  final int iniIndex;
  ImageViewer(this.images, {key, required this.iniIndex});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: widget.iniIndex);

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        } else if (event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              pageController: pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    "${widget.images[index]}",
                    headers: {
                      "Authorization": basicAuthForLocal,
                    },
                  ),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  heroAttributes: PhotoViewHeroAttributes(tag: "${widget.images[index]}", transitionOnUserGestures: true),
                );
              },
              itemCount: widget.images.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                  ),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
              ),
            )),
            Positioned(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn)),
              top: 80,
              // bottom: 0,
              left: 0,
            ),
            Positioned(
              child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () => pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn)),
              top: 80,
              // bottom: 0,
              right: 0,
            ),
          ],
        ),
      ),
    );
  }
}
