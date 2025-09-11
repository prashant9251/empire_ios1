import 'package:empire_ios/Models/DetModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';

class BillDispatchModel {
  String? CNO;
  String? TYPE;
  String? VNO;
  MasterModel? masterModel;
  String? date;
  String? bill;
  String? bcode;
  List<DetBillDetails>? billDispatchDetails;
  String? cBy;
  String? cTime;

  BillDispatchModel({
    this.CNO,
    this.TYPE,
    this.VNO,
    this.masterModel,
    this.date,
    this.bill,
    this.bcode,
    this.billDispatchDetails,
    this.cBy,
    this.cTime,
  });

  factory BillDispatchModel.fromJson(Map<String, dynamic> json) {
    return BillDispatchModel(
      CNO: json['CNO'],
      TYPE: json['TYPE'],
      VNO: json['VNO'],
      masterModel: json['masterModel'] != null ? MasterModel.fromJson(json['masterModel']) : MasterModel(),
      date: json['date'],
      bill: json['bill'],
      bcode: json['bcode'],
      billDispatchDetails:
          json['billDispatchDetails'] != null ? (json['billDispatchDetails'] as List).map((i) => DetBillDetails.fromJson(i)).toList() : null,
      cBy: json['cBy'],
      cTime: json['cTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CNO': CNO,
      'TYPE': TYPE,
      'VNO': VNO,
      'masterModel': masterModel?.toJson(),
      'date': date,
      'bill': bill,
      'bcode': bcode,
      'billDispatchDetails': billDispatchDetails?.map((i) => i.toJson()).toList(),
      'cBy': cBy,
      'cTime': cTime,
    };
  }
}
