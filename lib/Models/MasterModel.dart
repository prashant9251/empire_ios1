class MasterModel {
  String? value;
  String? label;
  int? uID;
  String? partyname;
  String? city;
  String? broker;
  String? aTYPE;
  String? aD1;
  String? aD2;
  String? aD3;
  String? aD4;
  String? sT1;
  String? pH1;
  String? pH2;
  String? fX1;
  String? eML;
  String? mO;
  String? tRSPT;
  String? dhara;
  String? pCK;
  String? cTNM;
  String? sT;
  String? pNO;
  String? bAC;
  String? bNM;
  String? bCD;
  String? pTGD;
  String? gST;
  String? dST;
  String? gP;
  String? m;
  String? cRD;
  String? cUSTTYPE;

  MasterModel({
    this.value,
    this.label,
    this.uID,
    this.partyname,
    this.city,
    this.broker,
    this.aTYPE,
    this.aD1,
    this.aD2,
    this.aD3,
    this.aD4,
    this.sT1,
    this.pH1,
    this.pH2,
    this.fX1,
    this.eML,
    this.mO,
    this.tRSPT,
    this.dhara,
    this.pCK,
    this.cTNM,
    this.sT,
    this.pNO,
    this.bAC,
    this.bNM,
    this.bCD,
    this.pTGD,
    this.gST,
    this.dST,
    this.gP,
    this.m,
    this.cRD,
    this.cUSTTYPE,
  });

  MasterModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
    uID = json['UID'];
    partyname = json['partyname'];
    city = json['city'];
    broker = json['broker'];
    aTYPE = json['ATYPE'];
    aD1 = json['AD1'];
    aD2 = json['AD2'];
    aD3 = json['AD3'];
    aD4 = json['AD4'];
    sT1 = json['ST1'];
    pH1 = json['PH1'];
    pH2 = json['PH2'];
    fX1 = json['FX1'];
    eML = json['EML'];
    mO = json['MO'];
    tRSPT = json['TRSPT'];
    dhara = json['dhara'];
    pCK = json['PCK'];
    cTNM = json['CTNM'];
    sT = json['ST'];
    pNO = json['PNO'];
    bAC = json['BAC'];
    bNM = json['BNM'];
    bCD = json['BCD'];
    pTGD = json['PTGD'];
    gST = json['GST'];
    dST = json['DST'];
    gP = json['GP'];
    m = json['M'];
    cRD = json['CRD'];
    cUSTTYPE = json['CT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    data['UID'] = this.uID;
    data['partyname'] = this.partyname;
    data['city'] = this.city;
    data['broker'] = this.broker;
    data['ATYPE'] = this.aTYPE;
    data['AD1'] = this.aD1;
    data['AD2'] = this.aD2;
    data['AD3'] = this.aD3;
    data['AD4'] = this.aD4;
    data['ST1'] = this.sT1;
    data['PH1'] = this.pH1;
    data['PH2'] = this.pH2;
    data['FX1'] = this.fX1;
    data['EML'] = this.eML;
    data['MO'] = this.mO;
    data['TRSPT'] = this.tRSPT;
    data['dhara'] = this.dhara;
    data['PCK'] = this.pCK;
    data['CTNM'] = this.cTNM;
    data['ST'] = this.sT;
    data['PNO'] = this.pNO;
    data['BAC'] = this.bAC;
    data['BNM'] = this.bNM;
    data['BCD'] = this.bCD;
    data['PTGD'] = this.pTGD;
    data['GST'] = this.gST;
    data['DST'] = this.dST;
    data['GP'] = this.gP;
    data['M'] = this.m;
    data['CRD'] = this.cRD;
    data['CT'] = this.cUSTTYPE;
    return data;
  }
}
