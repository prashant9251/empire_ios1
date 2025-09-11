import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class AgMasterModel {
  AgMasterModel({
    this.value,
    this.label,
    this.partyname,
    this.city,
    this.broker,
    this.brokerCode,
    this.atype,
    this.ad1,
    this.ad2,
    this.st1,
    this.ph1,
    this.ph2,
    this.fx1,
    this.eml,
    this.mo,
    this.gcode,
    this.trspt,
    this.dhara,
    this.pck,
    this.ctnm,
    this.st,
    this.pno,
    this.bac,
    this.bnm,
    this.bcd,
    this.ptgd,
    this.gst,
    this.dst,
    this.wm,
    this.wm2,
    this.wm3,
    this.wm4,
    this.brokerModel,
  });

  AgMasterModel? brokerModel;
  String? value;
  String? label;
  String? partyname;
  String? city;
  String? broker;
  String? brokerCode;
  String? atype;
  String? ad1;
  String? ad2;
  String? st1;
  String? ph1;
  String? ph2;
  String? fx1;
  String? eml;
  String? mo;
  String? gcode;
  String? trspt;
  String? dhara;
  String? pck;
  String? ctnm;
  String? st;
  String? pno;
  String? bac;
  String? bnm;
  String? bcd;
  String? ptgd;
  String? gst;
  String? dst;
  String? wm;
  String? wm2;
  String? wm3;
  String? wm4;

  factory AgMasterModel.fromJson(Map<String, dynamic> json) {
    late AgMasterModel brokerModel = AgMasterModel();
    if (json["bcdModal"] != null) {
      brokerModel = AgMasterModel.fromJson(Myf.convertMapKeysToString(json["bcdModal"]));
    }

    return AgMasterModel(
      brokerModel: brokerModel,
      value: json["value"],
      brokerCode: json["B"],
      label: json["label"],
      partyname: json["partyname"],
      city: json["city"],
      broker: json["broker"],
      atype: json["ATYPE"],
      ad1: json["AD1"],
      ad2: json["AD2"],
      st1: json["ST1"],
      ph1: json["PH1"],
      ph2: json["PH2"],
      fx1: json["FX1"],
      eml: json["EML"],
      mo: json["MO"],
      gcode: json["GCODE"],
      trspt: json["TRSPT"],
      dhara: json["dhara"],
      pck: json["PCK"],
      ctnm: json["CTNM"],
      st: json["ST"],
      pno: json["PNO"],
      bac: json["BAC"],
      bnm: json["BNM"],
      bcd: json["BCD"],
      ptgd: json["PTGD"],
      gst: json["GST"],
      dst: json["DST"],
      wm: json["WM"],
      wm2: json["WM2"],
      wm3: json["WM3"],
      wm4: json["WM4"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bcdModal": brokerModel != null ? brokerModel!.toJson() : {},
        "value": value,
        "label": label,
        "B": brokerCode,
        "partyname": partyname,
        "city": city,
        "broker": broker,
        "ATYPE": atype,
        "AD1": ad1,
        "AD2": ad2,
        "ST1": st1,
        "PH1": ph1,
        "PH2": ph2,
        "FX1": fx1,
        "EML": eml,
        "MO": mo,
        "GCODE": gcode,
        "TRSPT": trspt,
        "dhara": dhara,
        "PCK": pck,
        "CTNM": ctnm,
        "ST": st,
        "PNO": pno,
        "BAC": bac,
        "BNM": bnm,
        "BCD": bcd,
        "PTGD": ptgd,
        "GST": gst,
        "DST": dst,
        "WM": wm,
        "WM2": wm2,
        "WM3": wm3,
        "WM4": wm4,
      };
}

/*
{
	"value": "XXX02",
	"label": "DISCOUNT A/C PURCHASE , ADDRESS1 ADDRESS2  ,   ,    ,  23",
	"partyname": "DISCOUNT A/C PURCHASE",
	"city": "",
	"broker": "",
	"ATYPE": "10",
	"AD1": "ADDRESS1",
	"AD2": "ADDRESS2",
	"ST1": "",
	"PH1": "",
	"PH2": "",
	"FX1": "",
	"EML": "",
	"MO": "",
	"GCODE": "",
	"TRSPT": "",
	"dhara": "0",
	"PCK": "0",
	"CTNM": "",
	"ST": "",
	"PNO": "",
	"BAC": "",
	"BNM": "",
	"BCD": "",
	"PTGD": "",
	"GST": "23",
	"DST": "",
	"WM1": "",
	"WM2": "",
	"WM3": "",
	"WM4": ""
}*/