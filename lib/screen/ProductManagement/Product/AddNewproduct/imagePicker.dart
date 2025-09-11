import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';

class imgpick {
  static XFile? pdfFile = null;

  static showPhotoOptions(context, TextEditingController ctrlUploadType) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Type"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    ctrlUploadType.text = "PDF";
                    showPdfOption();
                  },
                  leading: const Icon(Icons.picture_as_pdf),
                  title: const Text("PDF"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    ctrlUploadType.text = "IMG";
                    showPhotoOptionsGallery(context);
                  },
                  leading: const Icon(Icons.image),
                  title: const Text("IMG"),
                ),
              ],
            ),
          );
        });
  }

  static void showPhotoOptionsGallery(context) {
    showDialog(
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
                    List<XFile>? imglist = await ImagePicker().pickMultiImage();
                    if (imglist == null) return;
                    if (imglist.isNotEmpty) {
                      uploadImgListSelect.sink.add(imglist);
                      // imagesList!.addAll(imglist);
                    }
                    // XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
                    // if (img == null) return;
                    // uploadImgListSelect.sink.add([img]);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context);
                    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      uploadImgListSelect.sink.add([pickedFile]);
                      // imagesList!.addAll(imglist);
                    }
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                ),
              ],
            ),
          );
        });
  }

  static void showPdfOption() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfFile = XFile(result.files.single.path!);
      if (pdfFile != null) {
        int fileSizeInBytes = await pdfFile!.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 10.0) {
          showSimpleNotification(Text("please select pdf file less then 10 MB"), background: Colors.red);
          return;
        }
        uploadImgListSelect.sink.add([pdfFile!]);
        // imagesList!.addAll(imglist);
      }
    } else {
      // User canceled the picker
    }
  }
}
