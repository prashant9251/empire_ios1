// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WhatsappContactModel {
  String? CompanyName;
  String? phone;
  String? userName;
  String? clnt;
  String? PAY;
  bool? issent;

  WhatsappContactModel({
    this.CompanyName,
    this.phone,
    this.userName,
    this.clnt,
    this.PAY,
    this.issent,
  });

  WhatsappContactModel copyWith({
    String? CompanyName,
    String? phone,
    String? userName,
    String? clnt,
    String? PAY,
    bool? issent,
  }) {
    return WhatsappContactModel(
      CompanyName: CompanyName ?? this.CompanyName,
      phone: phone ?? this.phone,
      userName: userName ?? this.userName,
      clnt: clnt ?? this.clnt,
      PAY: PAY ?? this.PAY,
      issent: issent ?? this.issent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'CompanyName': CompanyName,
      'phone': phone,
      'userName': userName,
      'clnt': clnt,
      'PAY': PAY,
      'issent': issent,
    };
  }

  factory WhatsappContactModel.fromMap(Map<String, dynamic> map) {
    return WhatsappContactModel(
      CompanyName: map['CompanyName'] != null ? map['CompanyName'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      clnt: map['clnt'] != null ? map['clnt'] as String : null,
      PAY: map['PAY'] != null ? map['PAY'] as String : null,
      issent: map['issent'] != null ? map['issent'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WhatsappContactModel.fromJson(String source) => WhatsappContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WhatsappContactModel(CompanyName: $CompanyName, phone: $phone, userName: $userName, clnt: $clnt, PAY: $PAY, issent: $issent)';
  }

  @override
  bool operator ==(covariant WhatsappContactModel other) {
    if (identical(this, other)) return true;

    return other.CompanyName == CompanyName &&
        other.phone == phone &&
        other.userName == userName &&
        other.clnt == clnt &&
        other.PAY == PAY &&
        other.issent == issent;
  }

  @override
  int get hashCode {
    return CompanyName.hashCode ^ phone.hashCode ^ userName.hashCode ^ clnt.hashCode ^ PAY.hashCode ^ issent.hashCode;
  }
}
