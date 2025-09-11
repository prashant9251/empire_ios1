class BillForCsvModel {
  String? cNO;
  String? tYPE;
  String? vNO;
  String? cODE;
  String? GSTIN;
  String? bILL;
  String? dATE;
  String? bCODE;
  String? hASTE;
  String? tRANSPORT;
  String? sTATION;
  String? qUAL;
  String? pCS;
  String? uNIT;
  String? rATE;
  String? pACK;
  String? sRNO;
  String? cUT;
  String? aMT;
  String? mTR;
  String? dETAILS;
  String? vATRATE;
  String? cATEGORY;
  String? aLTQUAL;
  String? SETS;
  String? PCS_IN_SETS;
  String? TOTPCS;
  String? TOTMTS;
  String? COMPANY_GSTIN;
  String? CREATEDBY;
  String? GROSS_AMT;
  String? RMK;
  String? STATECODE;

  BillForCsvModel({
    this.cNO,
    this.tYPE,
    this.vNO,
    this.cODE,
    this.GSTIN,
    this.bILL,
    this.dATE,
    this.bCODE,
    this.hASTE,
    this.tRANSPORT,
    this.sTATION,
    this.qUAL,
    this.pCS,
    this.uNIT,
    this.rATE,
    this.pACK,
    this.sRNO,
    this.cUT,
    this.aMT,
    this.mTR,
    this.dETAILS,
    this.vATRATE,
    this.cATEGORY,
    this.aLTQUAL,
    this.SETS,
    this.PCS_IN_SETS,
    this.TOTPCS,
    this.TOTMTS,
    this.COMPANY_GSTIN,
    this.CREATEDBY,
    this.GROSS_AMT,
    this.STATECODE,
    this.RMK,
  });

  BillForCsvModel.fromJson(Map<String, dynamic> json) {
    cNO = json['CNO'] ?? '';
    tYPE = json['TYPE'] ?? '';
    vNO = json['VNO'] ?? '';
    COMPANY_GSTIN = json['COMPANY_GSTIN'] ?? '';
    cODE = json['CODE'] ?? '';
    GSTIN = json['GSTIN'] ?? '';
    bILL = json['BILL'] ?? '';
    dATE = json['DATE'] ?? '';
    bCODE = json['BCODE'] ?? '';
    hASTE = json['HASTE'] ?? '';
    tRANSPORT = json['TRANSPORT'] ?? '';
    sTATION = json['STATION'] ?? '';
    TOTPCS = json['TOTPCS'] ?? '';
    TOTMTS = json['TOTMTS'] ?? '';
    TOTMTS = json['GROSS_AMT'] ?? '';
    sRNO = json['SRNO'] ?? '';
    qUAL = json['QUAL'] ?? '';
    SETS = json['SETS'] ?? '';
    PCS_IN_SETS = json['PCS_IN_SETS'] ?? '';
    pCS = json['PCS'] ?? '';
    uNIT = json['UNIT'] ?? '';
    rATE = json['RATE'] ?? '';
    pACK = json['PACK'] ?? '';
    cUT = json['CUT'] ?? '';
    aMT = json['ITEM_AMT'] ?? '';
    mTR = json['MTR'] ?? '';
    dETAILS = json['DETAILS'] ?? '';
    vATRATE = json['VATRATE'] ?? '';
    cATEGORY = json['CATEGORY'] ?? '';
    aLTQUAL = json['ALTQUAL'] ?? '';
    RMK = json['RMK'] ?? '';
    CREATEDBY = json['CREATEDBY'] ?? '';
    STATECODE = json['STATECODE'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CNO'] = this.cNO ?? '';
    data['TYPE'] = this.tYPE ?? '';
    data['VNO'] = this.vNO ?? '';
    data['COMPANY_GSTIN'] = this.COMPANY_GSTIN ?? '';
    data['CODE'] = this.cODE ?? '';
    data['GSTIN'] = this.GSTIN ?? '';
    data['BILL'] = this.bILL ?? '';
    data['DATE'] = this.dATE ?? '';
    data['BCODE'] = this.bCODE ?? '';
    data['HASTE'] = this.hASTE ?? '';
    data['TRANSPORT'] = this.tRANSPORT ?? '';
    data['STATION'] = this.sTATION ?? '';
    data['TOTPCS'] = this.TOTPCS ?? '';
    data['TOTMTS'] = this.TOTMTS ?? '';
    data['GROSS_AMT'] = this.GROSS_AMT ?? '';
    data['SRNO'] = this.sRNO ?? '';
    data['QUAL'] = this.qUAL ?? '';
    data['SETS'] = this.SETS ?? '';
    data['PCS_IN_SETS'] = this.PCS_IN_SETS ?? '';
    data['PCS'] = this.pCS ?? '';
    data['UNIT'] = this.uNIT ?? '';
    data['RATE'] = this.rATE ?? '';
    data['PACK'] = this.pACK ?? '';
    data['CUT'] = this.cUT ?? '';
    data['ITEM_AMT'] = this.aMT ?? '';
    data['MTR'] = this.mTR ?? '';
    data['DETAILS'] = this.dETAILS ?? '';
    data['VATRATE'] = this.vATRATE ?? '';
    data['CATEGORY'] = this.cATEGORY ?? '';
    data['ALTQUAL'] = this.aLTQUAL ?? '';
    data['RMK'] = this.RMK ?? '';
    data['CREATEDBY'] = this.CREATEDBY ?? '';
    data['STATECODE'] = this.STATECODE ?? '';
    return data;
  }
}
