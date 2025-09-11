import 'dart:typed_data';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/LayoutInfoModel.dart';
import 'package:empire_ios/Models/TemplateModel.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemplateWidget extends StatelessWidget {
  TemplateModel templateModel;
  LayoutInfoModel layoutInfo;
  PlatformFile? platformFile;
  Function(Button? message)? callBackfunction;
  TemplateWidget({key, required this.templateModel, required this.layoutInfo, this.platformFile, this.callBackfunction});
  Uint8List? fileBytes = null;
  @override
  Widget build(BuildContext context) {
    if (platformFile != null) {
      fileBytes = platformFile!.bytes;
    }
    return Container(
      margin: EdgeInsets.only(left: 16),
      width: layoutInfo.width! * 0.4,
      child: Bubble(
        margin: BubbleEdges.only(top: 10),
        stick: true,
        nip: BubbleNip.no,
        child: Container(
          width: layoutInfo.width! * 0.4,
          // margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (templateModel.header!.headerType!.toLowerCase() == "text")
                SelectableText(
                  "${templateModel.header!.title ?? ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (templateModel.header!.headerType!.toLowerCase() == "media")
                fileBytes != null
                    ? Card(
                        child: Container(
                          height: 70,
                          width: layoutInfo.width! * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.music_albums_fill, size: 40, color: Colors.red),
                              Container(
                                width: layoutInfo.width! * 0.2,
                                child: Text(
                                  platformFile!.name ?? "",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : templateModel.header!.url != null
                        ? CachedNetworkImage(
                            imageUrl: templateModel.header!.url!,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            placeholder: (context, url) => CircularProgressIndicator(),
                            fit: BoxFit.cover,
                            height: 70,
                            width: layoutInfo.width! * 0.5,
                          )
                        : Text('No Document selected.'),
              if (templateModel.body != null)
                SelectableText(
                  "${templateModel.body ?? ""}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              if (templateModel.buttons != null)
                Container(
                  width: layoutInfo.width! * 0.4,
                  child: Column(
                    // spacing: 3,
                    // runSpacing: 3,
                    children: templateModel.buttons!.map((e) {
                      return Container(
                        width: layoutInfo.width! * 0.4,
                        padding: const EdgeInsets.all(2.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (callBackfunction != null) callBackfunction!(e);
                          },
                          child: SelectableText(e.title ?? ""),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
