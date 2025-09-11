import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class BillsModel {
  String ide;
  String cNO;
  CompmstModel? compmstDet;
  MasterModel? masterDet;
  MasterModel? brokerDet;
  String tYPE;
  int vNO;
  int? billSr;
  String? pcode;
  String? date;
  String? bill;
  String? totPcs;
  String? totMts;
  String? bcode;
  String? haste;
  String? trnsp;
  String? st;
  List<BillDetModel>? billDetails;
  String? cBy;
  String? cTime;
  String? uBy;
  String? uTime;
  String? mTime;
  String? rmk;
  String? grossAmt;
  String? stateCode;

  String? dBy;
  String? dTime;
  String? empSyncTime;
  String? pack;
  String? orderGivenBy;
  String? status = "pending";
  bool? selected;

  BillsModel({
    required this.ide,
    required this.cNO,
    this.compmstDet,
    this.masterDet,
    this.brokerDet,
    required this.tYPE,
    required this.vNO,
    this.pcode,
    this.date,
    this.bill,
    this.totPcs,
    this.totMts,
    this.bcode,
    this.haste,
    this.trnsp,
    this.selected,
    this.st,
    this.billDetails,
    this.cBy,
    this.cTime,
    this.uBy,
    this.uTime,
    this.mTime,
    this.rmk,
    this.empSyncTime,
    this.status,
    this.dBy,
    this.dTime,
    this.pack,
    this.billSr,
    this.grossAmt,
    this.stateCode,
    this.orderGivenBy,
  });
  factory BillsModel.fromJson(Map<String, dynamic> json) {
    List<BillDetModel> billDetails = [];

    if (json['billDetails'] != null) {
      for (var item in json['billDetails']) {
        billDetails.add(BillDetModel.fromJson(Myf.convertMapKeysToString(item)));
      }
    }

    late CompmstModel compmstDet = CompmstModel();

    if (json['compmstDet'] != null) {
      compmstDet = CompmstModel.fromJson(Myf.convertMapKeysToString(json['compmstDet']));
    }
    late MasterModel masterDet = MasterModel();

    if (json['masterDet'] != null) {
      masterDet = MasterModel.fromJson(Myf.convertMapKeysToString(json['masterDet']));
    }
    MasterModel? brokerDet = MasterModel();
    if (json['brokerDet'] != null) {
      brokerDet = MasterModel.fromJson(Myf.convertMapKeysToString(json['brokerDet']));
    }

    return BillsModel(
      ide: json['ide'] ?? '',
      cNO: json['CNO'],
      compmstDet: compmstDet,
      masterDet: masterDet,
      brokerDet: brokerDet,
      tYPE: json['TYPE'],
      vNO: json['VNO'],
      pcode: json['pcode'],
      date: json['date'],
      bill: json['bill'],
      totPcs: json['totPcs'],
      totMts: json['totMts'],
      bcode: json['bcode'] ?? '',
      haste: json['haste'] ?? '',
      trnsp: json['trnsp'] ?? '',
      grossAmt: json['GAMT'],
      st: json['st'] ?? '',
      billDetails: billDetails, // Assign the billDetails list here
      cBy: json['cBy'],
      cTime: json['cTime'],
      uBy: json['uBy'],
      uTime: json['uTime'],
      mTime: json['mTime'],
      rmk: json['rmk'],
      empSyncTime: json['empSyncTime'],
      status: json['ordCnfB'],
      dBy: json['dBy'],
      dTime: json['dTime'],
      pack: json['pack'],
      billSr: json['billSr'],
      selected: json['selected'] ?? false,
      stateCode: json['state'],
      orderGivenBy: json['oGBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ide'] = this.ide;
    data['CNO'] = this.cNO;
    data['compmstDet'] = this.compmstDet != null ? this.compmstDet!.toJson() : {};
    data['masterDet'] = this.masterDet != null ? this.masterDet!.toJson() : {};
    data['brokerDet'] = this.brokerDet != null ? this.brokerDet!.toJson() : {};
    data['TYPE'] = this.tYPE;
    data['VNO'] = this.vNO;
    data['pcode'] = this.pcode;
    data['date'] = this.date;
    data['bill'] = this.bill;
    data['totPcs'] = this.totPcs;
    data['totMts'] = this.totMts;
    data['bcode'] = this.bcode ?? '';
    data['haste'] = this.haste ?? '';
    data['trnsp'] = this.trnsp ?? '';
    data['st'] = this.st ?? '';
    if (this.billDetails != null) {
      data['billDetails'] = this.billDetails!.map((v) => v.toJson()).toList();
    }
    data['cBy'] = this.cBy;
    data['cTime'] = this.cTime;
    data['uBy'] = this.uBy;
    data['GAMT'] = this.grossAmt;
    data['uTime'] = this.uTime;
    data['mTime'] = this.mTime;
    data['rmk'] = this.rmk;
    data['dBy'] = this.dBy;
    data['dTime'] = this.dTime;
    data['empSyncTime'] = this.empSyncTime;
    data['ordCnfB'] = this.status;
    data['pack'] = this.pack;
    data['billSr'] = this.billSr;
    data['selected'] = this.selected ?? false;
    data['state'] = this.stateCode;
    data['oGBy'] = this.orderGivenBy;
    return data;
  }
}
