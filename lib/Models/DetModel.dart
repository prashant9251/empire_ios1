import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class DetModel {
  String? IDE;
  String? CNO;
  String? TYPE;
  String? VNO;
  List<DetBillDetails>? billdetails = [];

  DetModel({
    this.IDE,
    this.billdetails,
    this.CNO,
    this.TYPE,
    this.VNO,
  });

  factory DetModel.fromJson(Map<String, dynamic> json) {
    List<DetBillDetails> billDetails = [];
    if (json['billDetails'] != null) {
      for (var item in json['billDetails']) {
        if (item != null) billDetails.add(DetBillDetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }

    return DetModel(
      billdetails: billDetails,
      IDE: json["IDE"],
      CNO: json["CNO"],
      TYPE: json["TYPE"],
      VNO: json["VNO"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDE'] = this.IDE;
    if (this.billdetails != null) {
      data['billDetails'] = this.billdetails!.map((v) => v.toJson()).toList();
    }
    data['CNO'] = this.CNO;
    data['TYPE'] = this.TYPE;
    data['VNO'] = this.VNO;

    return data;
  }
}

class DetBillDetails {
  DetBillDetails({
    this.sr,
    this.itsr,
    this.pcsParSet,
    this.pck,
    this.qual,
    this.rate,
    this.mts,
    this.cut,
    this.pcs,
    this.tallyPcs,
    this.unit,
    this.amt,
    this.disamt,
    this.dr,
    this.ctgry,
    this.cn,
    this.det,
    this.bsql,
    this.altql,
    this.dtvtret,
    this.dtvtamt,
    this.hsn,
    this.lf,
  });

  String? sr;
  String? itsr;
  String? pcsParSet;
  String? pck;
  String? qual;
  String? rate;
  String? mts;
  String? cut;
  String? pcs;
  String? tallyPcs;
  String? get tallyPendingPcs => (Myf.convertToDouble(pcs ?? "0") - Myf.convertToDouble(tallyPcs ?? "0")).toInt().toString();
  String? unit;
  String? amt;
  String? disamt;
  String? dr;
  String? ctgry;
  String? cn;
  String? det;
  String? bsql;
  String? altql;
  String? dtvtret;
  String? dtvtamt;
  String? hsn;
  String? lf;

  factory DetBillDetails.fromJson(Map<String, dynamic> json) {
    return DetBillDetails(
      itsr: (json["ITSR"] ?? "").toString(),
      pcsParSet: (json["PPS"] ?? "").toString(),
      sr: (json["SR"] ?? "").toString(),
      pck: (json["PCK"] ?? "").toString(),
      qual: (json["qual"] ?? "").toString(),
      rate: (json["RATE"] ?? "").toString(),
      mts: (json["MTS"] ?? "").toString(),
      cut: (json["CUT"] ?? "").toString(),
      pcs: (json["PCS"] ?? "").toString(),
      tallyPcs: (json["tllyp"] ?? "").toString(),
      unit: (json["UNIT"] ?? "").toString(),
      amt: (json["AMT"] ?? "").toString(),
      disamt: (json["disamt"] ?? "").toString(),
      dr: (json["DR"] ?? "").toString(),
      ctgry: (json["CTGRY"] ?? "").toString(),
      cn: (json["CN"] ?? "").toString(),
      det: (json["DET"] ?? "").toString(),
      bsql: (json["BSQL"] ?? "").toString(),
      altql: (json["altql"] ?? "").toString(),
      dtvtret: (json["DTVTRET"] ?? "").toString(),
      dtvtamt: (json["DTVTAMT"] ?? "").toString(),
      hsn: (json["hsn"] ?? "").toString(),
      lf: (json["LF"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "ITSR": itsr.toString(),
        "PPS": pcsParSet.toString(),
        "SR": sr.toString(),
        "PCK": pck.toString(),
        "qual": qual.toString(),
        "RATE": rate.toString(),
        "MTS": mts.toString(),
        "CUT": cut.toString(),
        "PCS": pcs.toString(),
        "tllyp": tallyPcs.toString(),
        "UNIT": unit.toString(),
        "AMT": amt.toString(),
        "disamt": disamt.toString(),
        "DR": dr.toString(),
        "CTGRY": ctgry.toString(),
        "CN": cn.toString(),
        "DET": det.toString(),
        "BSQL": bsql.toString(),
        "altql": altql.toString(),
        "DTVTRET": dtvtret.toString(),
        "DTVTAMT": dtvtamt.toString(),
        "hsn": hsn.toString(),
        "LF": lf.toString(),
      };
}

/*
{
	"SR": "1492",
	"PCK": "BOX",
	"qual": "BLACK BERRY",
	"RATE": "177",
	"MTS": "660",
	"CUT": "6",
	"PCS": "110",
	"UNIT": "PCS",
	"AMT": "19470",
	"disamt": "",
	"DR": "0",
	"CTGRY": "",
	"CN": "",
	"DET": "",
	"BSQL": "",
	"altql": "BLACK BERRY",
	"DTVTRET": "5",
	"DTVTAMT": "0",
	"hsn": "5407",
	"LF": "0"
}*/