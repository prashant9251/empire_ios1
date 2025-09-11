import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class CrmFollowUpModel {
  String? iD;
  String? partyCode;
  MasterModel? masterModel;
  String? nextFollowupDate;
  String? date;
  String? followUpType;
  String? user;
  String? feedBack;
  String? rmk;
  String? type;
  String? tktclosedDate;
  bool? tktClose;
  String? mTime;
  String? brokerFollowUpId;
  List<CrmFollowRespModel>? CrmFollowRespList;

  CrmFollowUpModel({
    this.iD,
    this.partyCode,
    this.nextFollowupDate,
    this.date,
    this.masterModel,
    this.followUpType,
    this.user,
    this.feedBack,
    this.rmk,
    this.type,
    this.tktclosedDate,
    this.mTime,
    this.tktClose,
    this.brokerFollowUpId,
    this.CrmFollowRespList,
  });

  factory CrmFollowUpModel.fromJson(Map<String, dynamic> json) {
    List<CrmFollowRespModel> CrmFollowRespList = [];

    if (json['CrmFollowRespList'] != null) {
      for (var item in json['CrmFollowRespList']) {
        CrmFollowRespList.add(CrmFollowRespModel.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    late MasterModel masterDet = MasterModel();

    if (json['masterDet'] != null) {
      masterDet = MasterModel.fromJson(Myf.convertMapKeysToString(json['masterDet']));
    }

    return CrmFollowUpModel(
      iD: json['ID'],
      partyCode: json['pcode'],
      nextFollowupDate: json['nFDate'],
      masterModel: masterDet,
      date: json['date'],
      followUpType: json['flwType'],
      tktClose: json['tktClose'] ?? false,
      user: json['user'],
      feedBack: json['fdBk'],
      rmk: json['rmk'],
      type: json['type'],
      tktclosedDate: json['tkt'],
      mTime: json['mTime'],
      brokerFollowUpId: json['bFlwUpId'],
      CrmFollowRespList: CrmFollowRespList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['pcode'] = this.partyCode;
    data['nFDate'] = this.nextFollowupDate;
    data['date'] = this.date;
    data['flwType'] = this.followUpType;
    data['user'] = this.user;
    data['fdBk'] = this.feedBack;
    data['rmk'] = this.rmk;
    data['tktClose'] = this.tktClose ?? false;
    data['masterDet'] = this.masterModel != null ? this.masterModel!.toJson() : {};
    data['type'] = this.type;
    data['mTime'] = this.mTime;
    data['bFlwUpId'] = this.brokerFollowUpId;
    data['tkt'] = this.tktclosedDate;
    if (this.CrmFollowRespList != null) {
      data['CrmFollowRespList'] = this.CrmFollowRespList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CrmFollowRespModel {
  String? resp;
  String? time;
  String? user;
  String? type;
  String? followUpType;

  CrmFollowRespModel({this.resp, this.time, this.user, this.type, this.followUpType});

  CrmFollowRespModel.fromJson(Map<String, dynamic> json) {
    resp = json['resp'];
    time = json['time'];
    user = json['user'];
    type = json['type'];
    followUpType = json['flTyp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resp'] = this.resp;
    data['time'] = this.time;
    data['user'] = this.user;
    data['type'] = this.type;
    data['flTyp'] = this.followUpType;
    return data;
  }
}
