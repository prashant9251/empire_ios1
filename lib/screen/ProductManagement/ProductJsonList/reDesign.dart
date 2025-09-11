import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

class Redesign extends StatefulWidget {
  Redesign({Key? key, this.QUL_OBJ}) : super(key: key);
  dynamic QUL_OBJ;
  @override
  State<Redesign> createState() => _RedesignState();

  static imageStack2Test(context, {required QUL_OBJ, required GlobalKey<State<StatefulWidget>> boundaryKey}) async {
    return await RepaintBoundary(
      key: boundaryKey,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.file(
                  File(QUL_OBJ["cacheFilePath"]),
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: opColors,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          child: Visibility(
                              visible: shareSettingObj["v_name"].toString().contains("true"),
                              child: Text("Name:${QUL_OBJ["value"]}",
                                  style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                  visible: shareSettingObj["v_mainscreen"].toString().contains("true"),
                                  child:
                                      Text("${QUL_OBJ["MS"]}", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                              Visibility(
                                  visible: shareSettingObj["v_fabrics"].toString().contains("true"),
                                  child:
                                      Text("${QUL_OBJ["BQ"]}", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                              Visibility(
                                  visible: shareSettingObj["v_rate"].toString().contains("true"),
                                  child: Text("RATE : ${QUL_OBJ["S1"]}/-",
                                      style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget imageStack(context, {required QUL_OBJ}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.file(
                File(QUL_OBJ["cacheFilePath"]),
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: opColors,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width * 50 / 100,
                        child: Visibility(
                            visible: shareSettingObj["v_name"].toString().contains("true"),
                            child:
                                Text("Name:${QUL_OBJ["value"]}", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 50 / 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                                visible: shareSettingObj["v_mainscreen"].toString().contains("true"),
                                child: Text("${QUL_OBJ["MS"]}", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                            Visibility(
                                visible: shareSettingObj["v_fabrics"].toString().contains("true"),
                                child: Text("${QUL_OBJ["BQ"]}", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                            Visibility(
                                visible: shareSettingObj["v_rate"].toString().contains("true"),
                                child: Text("RATE : ${QUL_OBJ["S1"]}/-",
                                    style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<Uint8List> widgetPrint(Widget widget, BuildContext context) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var bytes = await screenshotController.captureFromWidget(Material(child: widget), pixelRatio: pixelRatio);
    return bytes;
  }

  static Future<File> reDesignImgSave(context, {required QUL_OBJ}) async {
    Widget w = imageStack(context, QUL_OBJ: QUL_OBJ);
    Uint8List bytes = await widgetPrint(w, context);
    Directory tempDir = await getApplicationDocumentsDirectory();
    var dt = DateTime.now();
    String datetime = dt.toString();
    var path = "${tempDir.path}/";
    if (!Directory(path).existsSync()) {
      Directory(path).createSync();
    }
    File file = await File("$path$datetime.jpeg").create();
    final buffer = bytes.buffer;
    return await File(file.path).writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }
}

class _RedesignState extends State<Redesign> {
  GlobalKey globalKey = GlobalKey();
  final BaseCacheManager baseCacheManager = DefaultCacheManager();
  var loading = true;

  void getData() async {
    var url = widget.QUL_OBJ["img"]["0"];
    var file = await baseCacheManager.getSingleFile(url);
    final bytes = file.readAsBytesSync();
    final buffer = Uint8List.fromList(bytes);

    final codec = await ui.instantiateImageCodec(buffer);
    final frame = await codec.getNextFrame();
    final height = frame.image.height;
    final width = frame.image.width;
    widget.QUL_OBJ["imageWidth"] = width;
    widget.QUL_OBJ["imageHeight"] = height;
    widget.QUL_OBJ["cacheFilePath"] = file.path;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Save Image with Text"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : RepaintBoundary(key: globalKey, child: Redesign.imageStack(context, QUL_OBJ: widget.QUL_OBJ)),
      floatingActionButton: FloatingActionButton(
        onPressed: saveImage,
        child: Icon(Icons.share),
      ),
    );
  }

  void _saveImage() async {
    var f = await Redesign.reDesignImgSave(context, QUL_OBJ: widget.QUL_OBJ);
    Share.shareXFiles([await XFile(f.path)]);
  }

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void saveImage() async {
    Uint8List pngBytes = await _capturePng();

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_image.png');
    await file.writeAsBytes(pngBytes);
    Share.shareXFiles([XFile(file.path)]);
  }

  save2() async {
    await saveLayoutAsImage(context, fileName: 'my_layout.png');
  }

  Future<void> saveLayoutAsImage(BuildContext context, {String fileName = 'layout.png'}) async {
    final GlobalKey boundaryKey = GlobalKey();
    var layout = await Redesign.imageStack2Test(context, QUL_OBJ: widget.QUL_OBJ, boundaryKey: boundaryKey);
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    await completer.future;

    final RenderBox boundaryBox = boundaryKey.currentContext!.findRenderObject() as RenderBox;

    final ui.Image image = await boundary.toImage(pixelRatio: devicePixelRatio);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);

    await file.writeAsBytes(pngBytes);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Layout saved as $fileName'),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Open',
        onPressed: () {
          Share.shareXFiles([XFile(file.path)]);
        },
      ),
    ));
  }
}
