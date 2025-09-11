import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class BillDetModel {
  String? sR;
  String? qUAL;
  String? pCS;
  bool? pcSManualEntered;
  String? sets;
  String? pcsInSets;
  String? uNIT;
  String? category;
  String? rATE;
  String? aMT;
  String? cUT;
  String? mTR;
  String? rmk;
  String? dno;
  String? packing;
  String? imageUrl;
  String? vatRate;
  String? mainScreen;
  String? packingRate;
  bool? select;

  List<ColorModel>? colorDetails;

  bool? rateEnteredManual;

  String? iniPacking;

  BillDetModel({
    this.sR,
    this.sets,
    this.pcsInSets,
    this.qUAL,
    this.pCS,
    this.pcSManualEntered,
    this.rateEnteredManual,
    this.uNIT,
    this.rATE,
    this.aMT,
    this.category,
    this.cUT,
    this.mTR,
    this.rmk,
    this.dno,
    this.packing,
    this.iniPacking,
    this.packingRate,
    this.imageUrl,
    this.vatRate,
    this.colorDetails,
    this.mainScreen,
    this.select,
  });

  BillDetModel.fromJson(Map<String, dynamic> json) {
    sR = json['SR'];
    sets = json['SET'];
    pcsInSets = json['PIS'];
    qUAL = json['QUAL'];
    pCS = json['PCS'];
    pcSManualEntered = json['PM'] ?? false; //manualEntered
    rateEnteredManual = json['RM'] ?? true; //manualEntered
    uNIT = json['UNIT'];
    rATE = json['RATE'];
    aMT = json['AMT'];
    cUT = json['CUT'];
    category = json['CT'];
    vatRate = json['VR'];
    mTR = json['MTR'];
    rmk = json['rmk'];
    dno = json['dno'];
    iniPacking = json['ipck'] ?? "";
    packing = json['pack'];
    packingRate = json['pckR'] ?? "0";
    imageUrl = json['url'];
    mainScreen = json['MS'];
    select = json['SLT'] ?? false;
    if (json['colorDetails'] != null) {
      colorDetails = <ColorModel>[];
      json['colorDetails'].forEach((v) {
        colorDetails!.add(new ColorModel.fromJson(Myf.convertMapKeysToString(v)));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SR'] = this.sR;
    data['SET'] = this.sets;
    data['PIS'] = this.pcsInSets;
    data['QUAL'] = this.qUAL;
    data['PCS'] = this.pCS;
    data['PM'] = this.pcSManualEntered ?? false;
    data['RM'] = this.rateEnteredManual ?? true;
    data['UNIT'] = this.uNIT;
    data['RATE'] = this.rATE;
    data['AMT'] = this.aMT;
    data['CUT'] = this.cUT;
    data['CT'] = this.category;
    data['MTR'] = this.mTR;
    data['rmk'] = this.rmk;
    data['dno'] = this.dno;
    data['VR'] = this.vatRate;
    data['ipck'] = this.iniPacking;
    data['pack'] = this.packing;
    data['pckR'] = this.packingRate ?? "0";
    data['url'] = imageUrl;
    data['MS'] = mainScreen;
    data['SLT'] = select ?? false;
    if (this.colorDetails != null) {
      data['colorDetails'] = this.colorDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
