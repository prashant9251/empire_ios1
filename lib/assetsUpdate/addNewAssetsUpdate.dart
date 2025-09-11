import 'dart:typed_data';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddNewAssetsUpdate extends StatefulWidget {
  var UserObj;

  AddNewAssetsUpdate({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<AddNewAssetsUpdate> createState() => _AddNewAssetsUpdateState();
}

class _AddNewAssetsUpdateState extends State<AddNewAssetsUpdate> {
  var uploadFileName = "Select";
  late PlatformFile file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("SOFTWARES UPDATE"),
      ),
      body: ListView(
        children: [
          Container(width: 400, child: ElevatedButton(onPressed: () => pickFile(), child: Text("Pick File"))),
          SizedBox(height: 20),
          Center(child: Text(uploadFileName)),
          SizedBox(height: 20),
          Container(width: 500, child: FloatingActionButton.extended(onPressed: () => _save(), label: Text("Upload")))
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null) {
        file = result.files.first;
        //print('File picked: ${file.name}');
        uploadFileName = file.name;
        setState(() {});
      } else {
        // User canceled the picker.
      }
    } catch (e) {
      //print('Error picking file: $e');
    }
  }

  uploadStart(Uint8List bytes) async {
    var dt = await DateTime.now();
    var fileKey = "assest_${dt}.uenc";
    var mimeType = "zip"; //Myf.getMimeType(bytes);
    var url = await UploadFilePublic(bytes: bytes, name: "$fileKey", UserObj: widget.UserObj, mimetype: mimeType);
    return url;
  }

  static Future<String> UploadFilePublic({required Uint8List bytes, required name, required UserObj, required mimetype}) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child("assets").child(name);
      var b = await Myf.encryptBytes(
          bytes, "${firebaseSoftwaresName}Unique123456789@uniquesoftwares.com", "${firebaseSoftwaresName}Unique123456789@uniquesoftwares.com");
      final UploadTask uploadTask = storageReference.putData(b);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      //print("Error uploading file: $e");
      return ''; // Handle the error as needed, e.g., return an error message or throw an exception.
    }
  }

  _save() async {
    Myf.showBlurLoading(context);
    var bytes = await file.bytes;
    var url = await uploadStart(bytes!);
    if (url != null && url != "") {
      var id = DateTime.now().toString();
      Map<String, dynamic> obj = {};
      obj["ID"] = id;
      obj["link"] = url;
      obj["m_time"] = DateTime.now().millisecondsSinceEpoch.toString();
      await fireBCollection.collection("softwares").doc(firebaseSoftwaresName).collection("assets").doc(id).set(obj);
    }
    Navigator.pop(context);
    Myf.showMsg(context, "Upload", "successfully");
  }
}
