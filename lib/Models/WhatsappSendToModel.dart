// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class WhatsappSendToModel {
  String? pname;
  String? pcode;
  String? city;
  String? filePath;
  Uint8List? fileBytes;
  String? fileExtension;
  String? fileName;
  String? type;
  List<WhatsappSendToContactModel>? contactList;
  WhatsappSendToModel({
    this.pname,
    this.pcode,
    this.city,
    this.filePath,
    this.fileBytes,
    this.fileExtension,
    this.fileName,
    this.contactList,
    this.type,
  });

  WhatsappSendToModel copyWith({
    String? pname,
    String? pcode,
    String? filePath,
    Uint8List? fileBytes,
    String? fileExtension,
    String? fileName,
    List<WhatsappSendToContactModel>? contactList,
  }) {
    return WhatsappSendToModel(
      pname: pname ?? this.pname,
      pcode: pcode ?? this.pcode,
      city: city ?? this.city,
      filePath: filePath ?? this.filePath,
      fileBytes: fileBytes ?? this.fileBytes,
      fileExtension: fileExtension ?? this.fileExtension,
      fileName: fileName ?? this.fileName,
      contactList: contactList ?? this.contactList,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pname': pname,
      'pcode': pcode,
      'city': city,
      'filePath': filePath,
      'fileBytes': fileBytes,
      'type': type,
      'contactList': contactList!.map((x) => x.toMap()).toList(),
    };
  }

  factory WhatsappSendToModel.fromMap(Map<String, dynamic> map) {
    return WhatsappSendToModel(
      pname: map['pname'] != null ? map['pname'] as String : null,
      pcode: map['pcode'] != null ? map['pcode'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      filePath: map['filePath'] != null ? map['filePath'] as String : null,
      fileBytes: map['fileBytes'] != null ? map['fileBytes'] as Uint8List : null,
      contactList: map['contactList'] != null
          ? List<WhatsappSendToContactModel>.from(
              (map['contactList'] as List<int>).map<WhatsappSendToContactModel?>(
                (x) => WhatsappSendToContactModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WhatsappSendToModel.fromJson(String source) => WhatsappSendToModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WhatsappSendToModel(pname: $pname, pcode: $pcode, filePath: $filePath, contactList: $contactList)';
  }

  @override
  bool operator ==(covariant WhatsappSendToModel other) {
    if (identical(this, other)) return true;

    return other.pname == pname && other.pcode == pcode && other.filePath == filePath && listEquals(other.contactList, contactList);
  }

  @override
  int get hashCode {
    return pname.hashCode ^ pcode.hashCode ^ filePath.hashCode ^ contactList.hashCode;
  }
}

class WhatsappSendToContactModel {
  String? name;
  String? phone;
  String? status;
  bool? selected = true;
  String? noType;
  String? uType;
  WhatsappSendToContactModel({
    this.name,
    this.phone,
    this.status,
    this.selected = true,
    this.noType,
    this.uType,
  });

  WhatsappSendToContactModel copyWith({
    String? name,
    String? phone,
    String? status,
    bool? selected,
    String? noType,
    String? uType,
  }) {
    return WhatsappSendToContactModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      selected: selected ?? this.selected,
      noType: noType ?? this.noType,
      uType: uType ?? this.uType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'status': status,
      'selected': selected,
      'noType': noType,
      'uType': uType,
    };
  }

  factory WhatsappSendToContactModel.fromMap(Map<String, dynamic> map) {
    return WhatsappSendToContactModel(
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      selected: map['selected'] != null ? map['selected'] as bool : null,
      noType: map['noType'] != null ? map['noType'] as String : null,
      uType: map['uType'] != null ? map['uType'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WhatsappSendToContactModel.fromJson(String source) => WhatsappSendToContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WhatsappSendToContactModel(name: $name, phone: $phone, status: $status, selected: $selected, noType: $noType, uType: $uType)';
  }

  @override
  bool operator ==(covariant WhatsappSendToContactModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.phone == phone &&
        other.status == status &&
        other.selected == selected &&
        other.noType == noType &&
        other.uType == uType;
  }

  @override
  int get hashCode {
    return name.hashCode ^ phone.hashCode ^ status.hashCode ^ selected.hashCode ^ noType.hashCode ^ uType.hashCode;
  }
}
