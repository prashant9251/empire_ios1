import 'dart:typed_data';

class GalleryModel {
  GalleryModel({
    this.value,
    this.id,
    this.keypath,
    this.type,
    this.name,
    this.url,
    this.size,
    this.mTime,
    this.bytes,
    this.progress = 0.0,
  });

  String? value;
  String? id;
  String? keypath;
  String? type;
  String? name;
  String? url;
  int? size;
  Uint8List? bytes;
  double progress = 0.0;
  String? mTime = DateTime.now().millisecondsSinceEpoch.toString();

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      value: json["value"],
      id: json["id"],
      keypath: json["keypath"],
      type: json["type"],
      name: json["name"],
      url: json["url"],
      mTime: json["mTime"],
      size: json["size"],
      bytes: json["bytes"],
      progress: double.parse("${json["progress"] ?? "0"}"),
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "id": id,
        "keypath": keypath,
        "type": type,
        "name": name,
        "url": url,
        "mTime": mTime,
        "size": size,
        "bytes": bytes,
        "progress": progress,
      };
}

/*
{
	"keypath": "111/gallery/dhamaal",
	"type": "folder",
	"name": "dhamaal"
}*/