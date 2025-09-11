import 'dart:async';
import 'dart:io';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductJsonList.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/CarouselSlider.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/imagePicker.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/inputwidgetlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddNewproduct extends StatefulWidget {
  AddNewproduct({Key? key, required this.QUL_OBJ, required this.UserObj}) : super(key: key);
  var QUL_OBJ;
  var UserObj;
  @override
  State<AddNewproduct> createState() => _AddNewproductState();
}

class _AddNewproductState extends State<AddNewproduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StreamController<String> productTagStream = StreamController<String>.broadcast();

  var ctrlProductName = TextEditingController(text: importProductObj["Name"]);
  var ctrlStock = TextEditingController();
  var ctrlRmk = TextEditingController();
  var ctrlUploadType = TextEditingController();

  List<XFile> uploadImgList = [];

  var ProductTagObj = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadImgListSelect.stream.listen((event) {
      // //print(event);
      uploadImgList = event;
    });
    ctrlProductName.text = widget.QUL_OBJ["label"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Add New Product"),
        actions: [],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              color: Colors.grey[200],
              height: 200,
              child: CarouselSliderCustom(ctrlUploadType: ctrlUploadType),
            ),
            IconButton(
                onPressed: () {
                  imgpick.showPhotoOptions(context, ctrlUploadType);
                },
                icon: Icon(
                  Icons.camera_alt,
                  size: 20,
                )),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey[400],
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Product Tag",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: StreamBuilder<Object>(
                          stream: productTagStream.stream,
                          builder: (context, snapshot) {
                            var d = snapshot.data;
                            d = d == null ? "" : d;
                            var msg = d == "" ? "" : "Please do not delete or Edit Product Name in your computer Accounting softwares";
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg,
                                  style: TextStyle(fontSize: 10, color: Colors.red),
                                ),
                                Row(
                                  children: [
                                    Text("$d", style: TextStyle(fontSize: 20)),
                                    snapshot.data != null && snapshot.data != ""
                                        ? IconButton(
                                            onPressed: () async {
                                              // ProductTagObj = {};
                                              // productTagStream.sink.add("");
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 15,
                                              color: Colors.red,
                                            ))
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ],
                            );
                          }),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                var v = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductJsonList(UserObj: widget.UserObj),
                                    ));
                                if (v != null) {
                                  ProductTagObj = v;
                                  productTagStream.sink.add(ProductTagObj["label"]);
                                  ctrlProductName.text.isEmpty ? ctrlProductName.text = ProductTagObj["label"] : null;
                                }
                              },
                              icon: Icon(
                                Icons.add_box_rounded,
                                color: Colors.white,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(),
            inputBoxClassWidget.InputField(
                ctrl: ctrlProductName, hint: "NAME / DESIGN NO", label: "NAME / DESIGN NO", validator: "ENTER NAME", textsize: 15.0, height: 60.0),
            inputBoxClassWidget.InputField(ctrl: ctrlRmk, hint: "DESCRIPTION", label: "DESCRIPTION", validator: "", textsize: 15.0, height: 60.0),
            Divider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Product Status"),
            //     Switch(
            //       activeColor: Colors.green,
            //       value: true,
            //       onChanged: (value) {},
            //     ),
            //     // Text("Image Compress"),
            //     // Switch(
            //     //   value: false,
            //     //   onChanged: (value) {},
            //     // ),
            //   ],
            // ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              child: ElevatedButton.icon(onPressed: () => validateAndSave(), icon: Icon(Icons.save), label: Text("SAVE")),
            )
          ],
        ),
      ),
    );
  }

  validateAndSave() async {
    if (_formKey.currentState!.validate()) {
      if (ProductTagObj["ID"] == null || ProductTagObj["ID"] == "") {
        Myf.showMsg(context, "Alert", "Please Select Producttag");
        return;
      }
      if (uploadImgList.length == 0) {
        Myf.showMsg(context, "Alert", "Please Select Image");
        return;
      }
      save();
    }
  }

  void save() async {
    Myf.showBlurLoading(context);
    var Imgobj = await uploadImage();
    if (Imgobj == null) {
      Navigator.pop(context);
      Myf.showMsg(context, "Error", "somthing went wrong please upload again");
      return;
    }
    Map<String, dynamic> obj = {};
    var objId = uuid.v1();
    var dt = await DateTime.now();

    obj["name"] = ctrlProductName.text.toString().toUpperCase();
    obj["img"] = Imgobj;
    obj["stock"] = ctrlStock.text.trim();
    obj["ID"] = objId;
    obj["time"] = dt.toString();
    obj["LID"] = "${ProductTagObj["ID"]}";
    await fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("PRODUCT").doc(objId).set(obj);
    await fireBCollection
        .collection("supuser")
        .doc(widget.UserObj["CLIENTNO"])
        .collection("PRODUCT_TAGS_ID")
        .doc("${ProductTagObj["ID"]}")
        .set({"LID": "${ProductTagObj["ID"]}"});
    hiveMainBox.put("PRODUCT", "value");
    Navigator.pop(context);
    Navigator.pop(context);
    // var url=UploadImage
  }

  Future<Map<String, dynamic>?> uploadImage() async {
    var sr = 0;
    Map<String, dynamic> obj = {};
    var err = false;
    await Future.wait(uploadImgList.map((e) async {
      var mimeType = Myf.getMimeType(e.path);
      File? cmpFile = null;
      if (mimeType == "pdf") {
        cmpFile = File(e.path);
      } else {
        cmpFile = await ProductListClass.testCompressAndGetFile((e));
      }
      if (cmpFile == null) {
        Myf.snakeBar(context, "cmp Error");
        err = true;
        return null;
      }
      var dt = await DateTime.now();
      var fileKey = "${ProductTagObj["ID"]}-$dt";
      var url = await ProductListClass.UploadFilePublic(path: cmpFile.path, name: "$fileKey${sr}", UserObj: widget.UserObj, mimetype: mimeType);
      if (url == null) {
        err = true;
      }
      ;
      obj["$sr"] = url;
      sr += 1;
      await ProductListClass.deleteFile(cmpFile);
    }).toList());
    if (err) {
      return null;
    }
    return obj;
  }
}
