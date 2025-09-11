import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class OfficeRequestTabModel {
  String? shopName;
  List<Rplys>? rplys;
  String? refName;
  String? fname;
  String? resolveDate;
  bool? status;
  String? tktStatus;
  String? flwDate;
  String? dATE;
  String? tdATE;
  String? response;
  String? solution;
  String? mTime;
  String? cLNT;
  String? reqType;
  String? user;
  String? iD;
  String? remark;
  String? mobileNo;

  OfficeRequestTabModel(
      {this.shopName,
      this.rplys,
      this.refName,
      this.fname,
      this.resolveDate,
      this.status,
      this.tktStatus,
      this.dATE,
      this.flwDate,
      this.tdATE,
      this.response,
      this.solution,
      this.mTime,
      this.cLNT,
      this.reqType,
      this.user,
      this.iD,
      this.remark,
      this.mobileNo});

  factory OfficeRequestTabModel.fromJson(Map<String, dynamic> json) {
    List<Rplys> rplysList = [];
    if (json['rplys'] != null) {
      json['rplys'].forEach((v) {
        rplysList.add(Rplys.fromJson(Myf.convertMapKeysToString(v)));
      });
    }

    return OfficeRequestTabModel(
      shopName: json['shopName'],
      rplys: rplysList,
      refName: json['refName'],
      fname: json['fname'],
      resolveDate: json['resolveDate'],
      status: json['status'],
      tktStatus: json['tktStatus'],
      dATE: json['DATE'],
      tdATE: json['tDATE'],
      flwDate: json['flwDate'],
      response: json['response'],
      solution: json['solution'],
      mTime: json['m_time'],
      cLNT: json['CLNT'],
      reqType: json['reqType'],
      user: json['user'],
      iD: json['ID'],
      remark: json['remark'],
      mobileNo: json['MobileNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    if (this.rplys != null) {
      data['rplys'] = this.rplys!.map((v) => v.toJson()).toList();
    } else {
      data['rplys'] = [];
    }
    data['refName'] = this.refName;
    data['fname'] = this.fname;
    data['resolveDate'] = this.resolveDate;
    data['status'] = this.status;
    data['tktStatus'] = this.tktStatus;
    data['DATE'] = this.dATE;
    data['flwDate'] = this.flwDate;
    data['tDATE'] = this.tdATE;
    data['response'] = this.response;
    data['solution'] = this.solution;
    data['m_time'] = this.mTime;
    data['CLNT'] = this.cLNT;
    data['reqType'] = this.reqType;
    data['user'] = this.user;
    data['ID'] = this.iD;
    data['remark'] = this.remark;
    data['MobileNo'] = this.mobileNo;
    return data;
  }
}

class Rplys {
  String? type;
  String? user;
  String? ans;
  String? time;
  String? from;

  Rplys({this.type, this.user, this.ans, this.time, this.from});

  Rplys.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? "";
    user = json['user'] ?? "";
    ans = json['ans'] ?? "";
    time = json['time'] ?? "";
    from = json['from'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type ?? "";
    data['user'] = this.user ?? "";
    data['ans'] = this.ans ?? "";
    data['time'] = this.time ?? "";
    data['from'] = this.from ?? "";
    return data;
  }
}
