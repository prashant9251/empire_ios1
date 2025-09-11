// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class QualModel {
  String? LID;
  String? value;
  String? label;
  String? s1;
  String? s2;
  String? s3;
  String? baseQual;
  String? iB;
  String? mainScreen;
  String? category;
  String? qT;
  String? cut;
  String? packing;
  String? finishStock;
  String? imageUrl;
  String? pcsPerSet;
  String? vatRate;
  String? itemSrNo;
  String? unit;
  String? localphoto;
  String? qual_path;
  bool selected;

  QualModel({
    this.LID,
    this.value,
    this.label,
    this.s1,
    this.s2,
    this.s3,
    this.baseQual,
    this.iB,
    this.mainScreen,
    this.category,
    this.qT,
    this.cut,
    this.packing,
    this.finishStock,
    this.imageUrl,
    this.pcsPerSet,
    this.vatRate,
    this.itemSrNo,
    this.unit,
    this.localphoto,
    this.qual_path,
    this.selected = false, // Provide a default value here
  });
// "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"
  factory QualModel.fromJson(Map<String, dynamic> json) {
    return QualModel(
        LID: json['LID'],
        value: json['value'],
        label: json['label'],
        s1: json['S1'],
        s2: json['S2'],
        s3: json['S3'],
        cut: json['C'],
        baseQual: json['BQ'],
        iB: json['IB'],
        mainScreen: json['MS'],
        category: json['CT'],
        qT: json['QT'],
        unit: json['U'],
        pcsPerSet: json['PS'],
        vatRate: json['VR'],
        itemSrNo: json['ISR'],
        packing: json['PCK'],
        finishStock: json['FS'],
        localphoto: json['LP'],
        qual_path: json['P'],
        imageUrl: json['url'] ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
        selected: json['selected'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['LID'] = LID;
    data['value'] = value;
    data['label'] = label;
    data['S1'] = s1;
    data['S2'] = s2;
    data['S3'] = s3;
    data['C'] = cut;
    data['BQ'] = baseQual;
    data['IB'] = iB;
    data['MS'] = mainScreen;
    data['CT'] = category;
    data['QT'] = qT;
    data['PCK'] = packing;
    data['FS'] = finishStock;
    data['url'] = imageUrl;
    data['selected'] = selected;
    data['PS'] = pcsPerSet;
    data['VR'] = vatRate;
    data['ISR'] = itemSrNo;
    data['U'] = unit;
    data['LP'] = localphoto;
    data['P'] = qual_path;
    return data;
  }
}
