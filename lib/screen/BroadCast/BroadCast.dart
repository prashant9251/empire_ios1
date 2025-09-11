import 'dart:typed_data';

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BroadCast extends StatefulWidget {
  dynamic UserObj;

  BroadCast({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<BroadCast> createState() => _BroadCastState();
}

class _BroadCastState extends State<BroadCast> {
  late PlatformFile file;

  String uploadFileName = "";

  var ctrltitle = TextEditingController();

  var ctrlMsg = TextEditingController();

  var ctrlType = TextEditingController(text: "img");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("In App broadcast"),
      ),
      body: ListView(children: [
        TextinputField(title: "title", ctrl: ctrltitle, readOnly: false),
        TextinputField(title: "Msg", ctrl: ctrlMsg, readOnly: false),
        Row(
          children: [
            IconButton(onPressed: () => pickFile(), icon: Icon(Icons.attach_file_outlined)),
            Text("$uploadFileName"),
          ],
        ),
        DropdownButton<String>(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          value: ctrlType.text,
          onChanged: (newValue) {
            setState(() {
              ctrlType.text = newValue!;
            });
          },
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'img',
              child: Chip(label: Text('img')),
            ),
            DropdownMenuItem<String>(
              value: 'video',
              child: Chip(label: Text('video')),
            ),
            DropdownMenuItem<String>(
              value: 'pdf',
              child: Chip(label: Text('pdf')),
            ),
          ],
        ),
        ElevatedButton(onPressed: () => _save(), child: Text("Save"))
      ]),
    );
  }

  _save() async {
    Myf.showBlurLoading(context);
    var bytes = await file.bytes;
    var url = await uploadStart(bytes!);
    if (url != null && url != "") {
      var id = DateTime.now().toString();
      Map<String, dynamic> obj = {};
      obj["ID"] = id;
      obj["url"] = url;
      obj["c_time"] = DateTime.now().toString();
      obj["title"] = ctrltitle.text.toUpperCase().trim();
      obj["msg"] = ctrlMsg.text.toUpperCase().trim();
      await fireBCollection.collection("softwares").doc("EMPIRE").collection("broadcast").doc(id).set(obj);
    }
    Navigator.pop(context);
    Myf.showMsg(context, "Upload", "successfully");
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
    var fileKey = "$uploadFileName${dt}";
    var mimeType = "zip"; //Myf.getMimeType(bytes);
    var url = await UploadFilePublic(bytes: bytes, name: "$fileKey", UserObj: widget.UserObj, mimetype: mimeType);
    return url;
  }

  static Future<String> UploadFilePublic({required Uint8List bytes, required name, required UserObj, required mimetype}) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child("broadcast").child(name);
      final UploadTask uploadTask = storageReference.putData(bytes);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      //print("Error uploading file: $e");
      return ''; // Handle the error as needed, e.g., return an error message or throw an exception.
    }
  }

  Container TextinputField(
      {required String title, hint, ctrl, prefixIcon = const Icon(Icons.search), pushScreen, readOnly = true, validator, loading = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.length == 0) {
            return validator;
          }
          return null;
        },
        style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor),
        controller: ctrl,
        readOnly: readOnly,
        textInputAction: TextInputAction.none,
        onTap: () async {},
        decoration: InputDecoration(
          prefixIcon: loading ? Transform.scale(scale: .75, child: CircularProgressIndicator(color: Colors.black)) : prefixIcon,
          labelText: '$title',
          hintText: '${hint ?? ""}',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
          ),
        ),
      ),
    );
  }
}
