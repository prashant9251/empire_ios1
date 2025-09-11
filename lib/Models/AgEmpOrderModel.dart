import 'package:empire_ios/Models/AgAcGroupModel.dart';
import 'package:empire_ios/Models/AgMasterModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class AgEmpOrderModel {
  AgEmpOrderModel({
    required this.ide,
    required this.cases,
    required this.VNO,
    required this.qty,
    required this.CNO,
    this.date,
    this.ordNo,
    this.suppOrdNo,
    this.cust,
    this.staff,
    this.supp,
    this.unit,
    this.close,
    this.rmk,
    this.transport,
    this.masterDet,
    this.acGroupDet,
    this.compmst,
    this.selected,
    this.mTime,
    this.cBy,
    this.status,
    this.fileKeyPath,
    this.url,
  });

  bool? selected;

  int VNO;
  String CNO;
  int cases;
  double qty;
  String ide;
  String? date;
  String? ordNo;
  String? suppOrdNo;
  String? cust;
  String? staff;
  String? supp;
  String? unit;
  String? close;
  String? rmk;
  String? cBy;
  String? mTime;
  String? status = "pending";

  String? transport;
  AgMasterModel? masterDet;
  AgAcGroupModel? acGroupDet;
  CompmstModel? compmst;
  String? fileKeyPath;
  String? url;

  factory AgEmpOrderModel.fromJson(Map<String, dynamic> json) {
    late CompmstModel compmst = CompmstModel();
    if (json['compmst'] != null) {
      compmst = CompmstModel.fromJson(Myf.convertMapKeysToString(json['compmst']));
    }

    late AgMasterModel masterDet = AgMasterModel();
    if (json['masterDet'] != null) {
      masterDet = AgMasterModel.fromJson(Myf.convertMapKeysToString(json['masterDet']));
    }
    late AgAcGroupModel acGroupDet = AgAcGroupModel();
    if (json['acGroupDet'] != null) {
      acGroupDet = AgAcGroupModel.fromJson(Myf.convertMapKeysToString(json['acGroupDet']));
    }

    return AgEmpOrderModel(
      status: json['ordCnfB'],
      CNO: json["CNO"] ?? "",
      compmst: compmst,
      acGroupDet: acGroupDet,
      masterDet: masterDet,
      cases: json["cases"],
      ide: json["ide"],
      cBy: json["cBy"],
      mTime: json["mTime"],
      qty: Myf.convertToDouble("${json["qty"]}"),
      VNO: json["VNO"],
      date: json["date"],
      ordNo: json["OrdNo"],
      suppOrdNo: json["SuppOrdNo"],
      cust: json["Cust"],
      staff: json["Staff"],
      supp: json["Supp"],
      unit: json["Unit"],
      close: json["Close"],
      rmk: json["Rmk"],
      transport: json["Transport"],
      selected: json['selected'] ?? false,
      fileKeyPath: json["fileKeyPath"] ?? "",
      url: json["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "compmst": this.compmst != null ? this.compmst!.toJson() : {},
        "acGroupDet": this.acGroupDet != null ? this.acGroupDet!.toJson() : {},
        "masterDet": this.masterDet != null ? this.masterDet!.toJson() : {},
        "CNO": CNO ?? "",
        "cases": cases,
        "ide": ide,
        "mTime": mTime,
        "VNO": VNO,
        "qty": qty,
        "date": date,
        "OrdNo": ordNo,
        "SuppOrdNo": suppOrdNo,
        "Cust": cust,
        "Staff": staff,
        "Supp": supp,
        "cBy": cBy,
        "Unit": unit,
        "Close": close,
        "Rmk": rmk,
        "selected": this.selected ?? false,
        'ordCnfB': this.status,
        "Transport": transport,
        "fileKeyPath": fileKeyPath ?? "",
        "url": url ?? "",
      };
}

/*
{
	"VNO": "",
	"date": "",
	"OrdNo": "",
	"SuppOrdNo": "",
	"Cust": "",
	"Staff": "",
	"Supp": "",
	"Unit": "",
	"Close": "",
	"Rmk": "",
	"Transport": ""
}*/