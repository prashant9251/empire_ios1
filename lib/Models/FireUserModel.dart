import 'package:empire_ios/main.dart';

class FireUserModel {
  String? userID;
  String? cLIENTNO;
  String? screenZoom;
  String? MCNO;
  String? MTYPE;
  bool? qualReportOldStyle;
  bool? masterReportOldStyle;

  FireUserModel({
    this.userID,
    this.cLIENTNO,
    this.screenZoom,
    this.MCNO,
    this.MTYPE,
    this.qualReportOldStyle,
    this.masterReportOldStyle,
  });

  factory FireUserModel.fromJson(Map<String, dynamic> json) {
    return FireUserModel(
      userID: json['userID'],
      cLIENTNO: json['cLIENTNO'],
      MTYPE: json['MTYPE'],
      qualReportOldStyle: json['qualReportOldStyle'] ?? false,
      masterReportOldStyle: json['masterReportOldStyle'] ?? false,
      screenZoom: json['screenZoom'] ?? (loginUserModel.wEB) ?? "200",
      MCNO: json['MCNO'] ?? firebaseCurrntUserObj['MCNO'] ?? loginUserModel.mCNO ?? "1",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'cLIENTNO': cLIENTNO,
      'MTYPE': MTYPE,
      'qualReportOldStyle': qualReportOldStyle ?? false,
      'masterReportOldStyle': masterReportOldStyle ?? false,
      'screenZoom': screenZoom ?? (loginUserModel.wEB) ?? 200,
      'MCNO': MCNO ?? firebaseCurrntUserObj['MCNO'] ?? loginUserModel.mCNO ?? "1",
    };
  }
}
