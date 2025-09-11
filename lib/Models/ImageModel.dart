import 'dart:typed_data';

class ImageModel {
  String? name;
  String? url;
  String? type; //file,url,bytes
  String? filePath;
  String? key;
  String? mimeType;
  Uint8List? bytes;

  ImageModel({
    this.name,
    this.url,
    this.type,
    this.filePath,
    this.key,
    this.mimeType,
    this.bytes,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      name: json["nm"],
      url: json["url"],
      type: json["type"] ?? "url",
      filePath: json["fPath"],
      key: json["key"],
      mimeType: json["mType"],
      bytes: json["bytes"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nm": name,
        "url": url,
        "type": type,
        "fPath": filePath,
        "key": key,
        "mType": mimeType,
        "bytes": bytes,
      };
}
