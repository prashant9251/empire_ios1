import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class OutstandingModel {
  String? code;
  double? PAMT;
  MasterModel? masterModel;
  MasterModel? brokerModel;
  CrmFollowUpModel? crmFollowUpModel;
  List<Billdetails>? billdetails;
  List<Billdetails>? allbilldetails;
  bool? isSelected = false;

  OutstandingModel(
      {this.code, this.isSelected, this.billdetails, this.allbilldetails, this.masterModel, this.PAMT, this.brokerModel, this.crmFollowUpModel});

  factory OutstandingModel.fromJson(Map<String, dynamic> json) {
    List<Billdetails> billDetails = [];
    if (json['billDetails'] != null) {
      for (var item in json['billDetails']) {
        if (item != null) billDetails.add(Billdetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    List<Billdetails> allbillDetails = [];
    if (json['allbillDetails'] != null) {
      for (var item in json['allbillDetails']) {
        if (item != null) allbillDetails.add(Billdetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    MasterModel masterModel = MasterModel();
    if (json['masterModel'] != null) {
      masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(json['masterModel']));
    }
    MasterModel brokerModel = MasterModel();
    if (json['brokerModel'] != null) {
      brokerModel = MasterModel.fromJson(Myf.convertMapKeysToString(json['brokerModel']));
    }
    CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel();
    if (json['crmFollowUpModel'] != null) {
      crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(json['crmFollowUpModel']));
    }

    return OutstandingModel(
      code: json["code"],
      PAMT: json["PAMT"],
      billdetails: billDetails,
      allbilldetails: allbillDetails,
      masterModel: masterModel,
      brokerModel: brokerModel,
      crmFollowUpModel: crmFollowUpModel,
      isSelected: json["isSelected"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['PAMT'] = this.PAMT;
    data['isSelected'] = this.isSelected;
    data['masterModel'] = this.masterModel!.toJson();
    if (this.brokerModel != null) {
      data['brokerModel'] = this.brokerModel!.toJson();
    }
    data['crmFollowUpModel'] = this.crmFollowUpModel!.toJson();
    if (this.billdetails != null) {
      data['billDetails'] = this.billdetails!.map((v) => v.toJson()).toList();
    }
    if (this.allbilldetails != null) {
      data['allbilldetails'] = this.allbilldetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Billdetails {
  String? iDE;
  String? cNO;
  String? tYPE;
  String? vNO;
  String? dATE;
  String? bCODE;
  String? cITY;
  String? bILL;
  String? pCS;
  String? mTS;
  String? fRM;
  String? gRSAMT;
  String? fAMT;
  String? cLAIMS;
  String? rECAMT;
  String? pAMT;
  String? pay;
  String? aTYPE;
  String? hST;
  String? gRD;
  String? dT;
  String? gST;
  String? r1;
  String? l1R;
  String? l1P;
  String? l2R;
  String? l2P;
  String? l3R;
  String? l3P;
  String? gD;
  int? days;
  String? dueType;
  bool? showSelect = true;

  Billdetails({
    this.iDE,
    this.cNO,
    this.tYPE,
    this.vNO,
    this.dATE,
    this.bCODE,
    this.cITY,
    this.bILL,
    this.pCS,
    this.mTS,
    this.fRM,
    this.gRSAMT,
    this.fAMT,
    this.cLAIMS,
    this.rECAMT,
    this.pAMT,
    this.pay,
    this.aTYPE,
    this.hST,
    this.gRD,
    this.dT,
    this.gST,
    this.r1,
    this.l1R,
    this.l1P,
    this.l2R,
    this.l2P,
    this.l3R,
    this.l3P,
    this.gD,
    this.days,
    this.showSelect,
    this.dueType,
  });

  Billdetails.fromJson(Map<String, dynamic> json) {
    iDE = json['IDE'];
    cNO = json['CNO'];
    tYPE = json['TYPE'];
    vNO = json['VNO'];
    dATE = json['DATE'];
    bCODE = json['BCODE'];
    cITY = json['CITY'];
    bILL = json['BILL'];
    pCS = json['PCS'];
    mTS = json['MTS'];
    fRM = json['FRM'];
    gRSAMT = json['GRSAMT'];
    fAMT = json['FAMT'];
    cLAIMS = json['CLAIMS'];
    rECAMT = json['RECAMT'];
    pAMT = json['PAMT'];
    pay = json['pay'];
    aTYPE = json['ATYPE'];
    hST = json['HST'];
    gRD = json['GRD'];
    dT = json['DT'];
    gST = json['GST'];
    r1 = json['R1'];
    l1R = json['L1R'];
    l1P = json['L1P'];
    l2R = json['L2R'];
    l2P = json['L2P'];
    l3R = json['L3R'];
    l3P = json['L3P'];
    gD = json['GD'];
    days = json['days'];
    showSelect = json['showSelect'] ?? true;
    dueType = json['  '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDE'] = this.iDE;
    data['CNO'] = this.cNO;
    data['TYPE'] = this.tYPE;
    data['VNO'] = this.vNO;
    data['DATE'] = this.dATE;
    data['BCODE'] = this.bCODE;
    data['CITY'] = this.cITY;
    data['BILL'] = this.bILL;
    data['PCS'] = this.pCS;
    data['MTS'] = this.mTS;
    data['FRM'] = this.fRM;
    data['GRSAMT'] = this.gRSAMT;
    data['FAMT'] = this.fAMT;
    data['CLAIMS'] = this.cLAIMS;
    data['RECAMT'] = this.rECAMT;
    data['PAMT'] = this.pAMT;
    data['pay'] = this.pay;
    data['ATYPE'] = this.aTYPE;
    data['HST'] = this.hST;
    data['GRD'] = this.gRD;
    data['DT'] = this.dT;
    data['GST'] = this.gST;
    data['R1'] = this.r1;
    data['L1R'] = this.l1R;
    data['L1P'] = this.l1P;
    data['L2R'] = this.l2R;
    data['L2P'] = this.l2P;
    data['L3R'] = this.l3R;
    data['L3P'] = this.l3P;
    data['GD'] = this.gD;
    data['days'] = this.days;
    data['showSelect'] = this.showSelect ?? true;
    data['duTyp'] = this.dueType;
    return data;
  }
}
