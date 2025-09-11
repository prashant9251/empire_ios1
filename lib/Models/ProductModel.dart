import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class ProductModel {
  Map<String, dynamic>? img;
  String? lID;
  String? name;
  String? time;
  String? iD;
  String? stock;
  QualModel? qualModel;
  bool selected;
  String? cacheFilePath;
  String? cacheUrl;

  ProductModel({
    this.img,
    this.lID,
    this.name,
    this.time,
    this.iD,
    this.stock,
    this.qualModel,
    this.selected = false, // Provide a default value here
    this.cacheFilePath,
    this.cacheUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    late QualModel qualModel = QualModel();

    if (json['qualModel'] != null) {
      qualModel = QualModel.fromJson(Myf.convertMapKeysToString(json['qualModel']));
    }
    return ProductModel(
      qualModel: qualModel,
      img: json['img'] != null ? Myf.convertMapKeysToString(json['img']) : null,
      lID: json['LID'],
      name: json['name'],
      time: json['time'],
      iD: json['ID'],
      stock: json['stock'],
      cacheFilePath: json['cacheFilePath'],
      cacheUrl: json['cacheUrl'],
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.img != null) {
      data['img'] = this.img!;
    }
    data['qualModel'] = this.qualModel!.toJson();
    data['LID'] = this.lID;
    data['name'] = this.name;
    data['time'] = this.time;
    data['ID'] = this.iD;
    data['stock'] = this.stock;
    data['selected'] = this.selected;
    data['cacheFilePath'] = this.cacheFilePath;
    data['cacheUrl'] = this.cacheUrl;
    return data;
  }
}
