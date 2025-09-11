import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/pdfView/pdfView.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:empire_ios/screen/videoPlayer/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class MainHelp extends StatefulWidget {
  const MainHelp({Key? key}) : super(key: key);

  @override
  State<MainHelp> createState() => _MainHelpState();
}

class _MainHelpState extends State<MainHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        backgroundColor: jsmColor,
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireBCollection
                  .collection("softwares")
                  .doc("$firebaseSoftwaresName")
                  .collection("help")
                  .orderBy("sr", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error in Category"));
                } else if (!snapshot.hasData) {
                  return Center(child: Text("No data"));
                } else {
                  var snp = snapshot.data!.docs;

                  if (snp.length > 0) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snp.length,
                        itemBuilder: (context, index) {
                          dynamic d = snp[index].data();
                          return d["title"] != null && d["title"] != ""
                              ? Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        if ("${d["linkType"]}".contains("pdf")) {
                                          var oldFile = await baseCacheManager.getSingleFile("${d["link"]}");
                                          Myf.Navi(context, PdfView(pdfFile: XFile(oldFile.path)));
                                        } else if ("${d["linkType"]}".contains("img")) {
                                          Myf.Navi(context, fullScreenImg(img_list: ["${d["link"]}"], d: d));
                                        } else if ("${d["linkType"]}".contains("video")) {
                                          Myf.Navi(context, VideoPlayFromUrl(url: "${d["link"]}", d: d));
                                        }
                                      },
                                      leading: CircleAvatar(child: Text("${d["sr"]}")),
                                      title: Text("${d["title"]}"),
                                      subtitle: Text("${d["msg"]}"),
                                      trailing: Icon(
                                        "${d["linkType"]}".contains("video")
                                            ? Icons.video_camera_back_outlined
                                            : "${d["linkType"]}".contains("img")
                                                ? Icons.photo
                                                : "${d["linkType"]}".contains("pdf")
                                                    ? Icons.picture_as_pdf
                                                    : Icons.arrow_circle_right_outlined,
                                      ),
                                    ),
                                    Divider(color: Colors.black)
                                  ],
                                )
                              : SizedBox.shrink();
                        });
                  } else {
                    return Center(child: Text("No data found"));
                  }
                }
              })
        ],
      ),
    );
  }
}
