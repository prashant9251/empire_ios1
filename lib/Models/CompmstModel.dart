class CompmstModel {
  String? sft;
  String? year;
  String? cNO;
  String? fIRM;
  String? nAME;
  String? aDDRESS1;
  String? aDDRESS2;
  String? cITY1;
  String? aDDRESS3;
  String? aDDRESS4;
  String? sTATE1;
  String? pHONE1;
  String? pHONE3;
  String? pHONE4;
  String? pHONE2;
  String? mOBILE;
  String? fAX1;
  String? eMAIL;
  String? cOgrp;
  String? sHORTNAME;
  String? dIRECT;
  String? pANNO;
  String? wARD;
  String? oTHERRMK;
  String? cOMPANYGSTIN;
  String? cPINNO;

  CompmstModel(
      {this.sft,
      this.year,
      this.cNO,
      this.fIRM,
      this.nAME,
      this.aDDRESS1,
      this.aDDRESS2,
      this.cITY1,
      this.aDDRESS3,
      this.aDDRESS4,
      this.sTATE1,
      this.pHONE1,
      this.pHONE3,
      this.pHONE4,
      this.pHONE2,
      this.mOBILE,
      this.fAX1,
      this.eMAIL,
      this.cOgrp,
      this.sHORTNAME,
      this.dIRECT,
      this.pANNO,
      this.wARD,
      this.oTHERRMK,
      this.cOMPANYGSTIN,
      this.cPINNO});

  CompmstModel.fromJson(Map<String, dynamic> json) {
    sft = json['sft'];
    year = json['year'];
    cNO = json['CNO'];
    fIRM = json['FIRM'];
    nAME = json['NAME'];
    aDDRESS1 = json['ADDRESS1'];
    aDDRESS2 = json['ADDRESS2'];
    cITY1 = json['CITY1'];
    aDDRESS3 = json['ADDRESS3'];
    aDDRESS4 = json['ADDRESS4'];
    sTATE1 = json['STATE1'];
    pHONE1 = json['PHONE1'];
    pHONE3 = json['PHONE3'];
    pHONE4 = json['PHONE4'];
    pHONE2 = json['PHONE2'];
    mOBILE = json['MOBILE'];
    fAX1 = json['FAX1'];
    eMAIL = json['EMAIL'];
    cOgrp = json['COgrp'];
    sHORTNAME = json['SHORTNAME'];
    dIRECT = json['DIRECT'];
    pANNO = json['PANNO'];
    wARD = json['WARD'];
    oTHERRMK = json['OTHERRMK'];
    cOMPANYGSTIN = json['COMPANY_GSTIN'];
    cPINNO = json['CPINNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sft'] = this.sft;
    data['year'] = this.year;
    data['CNO'] = this.cNO;
    data['FIRM'] = this.fIRM;
    data['NAME'] = this.nAME;
    data['ADDRESS1'] = this.aDDRESS1;
    data['ADDRESS2'] = this.aDDRESS2;
    data['CITY1'] = this.cITY1;
    data['ADDRESS3'] = this.aDDRESS3;
    data['ADDRESS4'] = this.aDDRESS4;
    data['STATE1'] = this.sTATE1;
    data['PHONE1'] = this.pHONE1;
    data['PHONE3'] = this.pHONE3;
    data['PHONE4'] = this.pHONE4;
    data['PHONE2'] = this.pHONE2;
    data['MOBILE'] = this.mOBILE;
    data['FAX1'] = this.fAX1;
    data['EMAIL'] = this.eMAIL;
    data['COgrp'] = this.cOgrp;
    data['SHORTNAME'] = this.sHORTNAME;
    data['DIRECT'] = this.dIRECT;
    data['PANNO'] = this.pANNO;
    data['WARD'] = this.wARD;
    data['OTHERRMK'] = this.oTHERRMK;
    data['COMPANY_GSTIN'] = this.cOMPANYGSTIN;
    data['CPINNO'] = this.cPINNO;
    return data;
  }
}
