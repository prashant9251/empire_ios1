import 'dart:io';
import 'dart:ui' as ui;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/imagePicker.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/reDesign.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/sharePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductListClass {
  static selectImg() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    return file;
  }

  static showPhotoOptionsGallery(context) async {
    var pickedSingleFileReturn = null;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Category Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      pickedSingleFileReturn = pickedFile;
                    }
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      pickedSingleFileReturn = pickedFile;
                    }
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                ),
              ],
            ),
          );
        });
    return pickedSingleFileReturn;
  }

  static void askForUpload({required context, required XFile file, required QualId, required UserObj}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Container(
                //     height: 100,
                //     child: Image.file(
                //       File(file.path),
                //       filterQuality: FilterQuality.low,
                //     )),
                Text("Do you want to upload this image to product"),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () async {
                Myf.showLoading(context, "Uploading");
                var dt = await DateTime.now();
                var fileKey = "${QualId}$dt";
                File? cmpFile = await testCompressAndGetFile((file));
                if (cmpFile == null) {
                  Myf.snakeBar(context, "cmp Error");
                  return;
                }
                var mimeType = Myf.getMimeType(cmpFile.path);
                var url = await UploadFilePublic(path: cmpFile.path, name: fileKey, UserObj: UserObj, mimetype: mimeType);
                if (url != "") {
                  Map<String, dynamic> obj = {};
                  obj["ID"] = QualId;
                  obj["url"] = url;
                  obj["time"] = dt.toString();
                  obj["key"] = fileKey;
                  await fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("PRODUCT").doc("${QualId}").set(obj);
                  deleteFile(cmpFile);
                }
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<File?> testCompressAndGetFile(XFile file) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      file.path + "cmp.jpeg",
      quality: 88,
      // rotate: 180,
    );

    return await File(result!.path);
  }

  static Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  static Future<String?> UploadFilePublic({required path, required name, required UserObj, required mimetype}) async {
    String url = "";

    try {
      // upload file to Firebase Storage
      var imgKeypath = '${UserObj["CLIENTNO"]}/$name.$mimetype';

      var data = await File(path).readAsBytesSync();
      var url = await Myf.saveMediaToFireStorage(imgKeypath, data);
      return url;
    } catch (e) {
      //print('Error uploading file: $e');
      return null;
    }
  }

  static showHideShareButtonProcess({required ProductModel product}) {
    selectit(product: product);
  }

  static selectit({required ProductModel product}) async {
    var find = false;
    await Future.wait(tempSelectImglist.map((e) async {
      if (e.iD == product.iD) {
        find = true;
      }
    }).toList());
    if (find == true) {
      (tempSelectImglist.removeWhere((element) {
        return element.iD == product.iD;
      }));
    } else {
      if (product.img != null) {
        Map<String, dynamic>? img = product.img;
        var entryList = await img!.entries.toList();
        await Future.wait(entryList.map((image) async {
          var url = image.value;
          File? fileOld = null;
          fileOld = await baseCacheManager.getSingleFile(url);
          if (fileOld.path.isNotEmpty) {
            ProductModel model = ProductModel.fromJson(product.toJson());
            // nobj = product;
            model.cacheFilePath = fileOld.path;
            model.cacheUrl = url;
            tempSelectImglist.add(model);
          }
        }));
      }
    }
    shareImgObjList.sink.add(tempSelectImglist);
    if (tempSelectImglist.length > 0) {
      shareButtonBool.sink.add(true);
    } else {
      shareButtonBool.sink.add(false);
    }
  }

  static deleteImg({required context, required ProductModel QUL_OBJ, required UserObj}) {
    Map<String, dynamic> img = {};

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Alert",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.redAccent,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  "Are you sure you want to delete this Product?",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Yes'),
              onPressed: () async {
                Myf.showLoading(context, "Deleting please wait");

                await deleteFInalProcess(UserObj, QUL_OBJ);
                hiveMainBox.put("PRODUCT", "value");

                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> deleteFInalProcess(UserObj, ProductModel QUL_OBJ) async {
    var imgKeypath = 'images/${UserObj["CLIENTNO"]}/';
    Map<String, dynamic> img = {};
    if (QUL_OBJ.img != null) {
      img = QUL_OBJ.img!;
    }
    img.forEach((key, value) async {
      Uri uri = Uri.parse(value);
      String name = uri.pathSegments.last;
      var keyName = "$imgKeypath$name";
      await AmplifyDeleteImg(key: keyName);
      try {
        await DefaultCacheManager().removeFile(value);
      } catch (e) {}
    });
    await fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("PRODUCT").doc(QUL_OBJ.iD).delete().then((value) {
      Map<String, dynamic> dobj = {};
      dobj["time"] = DateTime.now().toString();
      dobj["P_ID"] = QUL_OBJ.iD;
      dobj["n"] = QUL_OBJ.name;
      fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("PRODUCT_DELETED").doc(QUL_OBJ.iD).set(dobj);
    });
    imgCacheUrlById.remove(QUL_OBJ.name);
    imgFirebaseObjById.remove(QUL_OBJ.name);
  }

  static AmplifyDeleteImg({required key}) async {
    try {
      var result = await Amplify.Storage.remove(
        path: StoragePath.fromString(key),
        options: StorageRemoveOptions(
            // accessLevel: StorageAccessLevel.guest,
            // contentType: "multipart/form-data",
            ),
      );
      //print('File deleted successfully: ${result}');
    } catch (e) {
      //print('Error deleting file from S3: $e');
    }
  }

  static shareAllSelectedFile(context, {required List<ProductModel> productList}) async {
    Myf.showLoading(context, "Please wait");
    List<XFile> I = [];
    await Future.wait(productList.map((e) async {
      var nobj = e;
      var fileOld = File("${e.cacheFilePath}");
      var boolviewDno = shareSettingObj["v_name"] ?? false;
      var boolviewPrice = shareSettingObj["v_rate"] ?? false;
      var boolviewMainScreenName = shareSettingObj["v_mainscreen"] ?? false;
      var boolviewFabricsName = shareSettingObj["v_fabrics"] ?? false;
      var mimeType = Myf.getMimeType(fileOld.path);
      var f = null;
      if (boolviewDno || boolviewPrice || boolviewMainScreenName || boolviewFabricsName) {
        if (mimeType == "pdf") {
          f = await Myf.reNameFile(context, QUL_OBJ: nobj);
        } else {
          f = await Myf.editFile(context, QUL_OBJ: nobj);
        }
      }
      if (f == null) {
        f = fileOld;
      }
      I.add(XFile(f.path));
    }).toList());
    if (I.length > 0) {
      await SharePlus.instance.share(ShareParams(
        sharePositionOrigin: null,
        downloadFallbackEnabled: false,
        files: I,
      ));
      // await Myf.Navi(context, SharePage(I: I));
      Navigator.pop(context);
    }
  }
}
