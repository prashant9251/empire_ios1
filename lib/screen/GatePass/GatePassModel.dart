class GatePassModel {
  String? fIRM;
  String? cNO;
  String? tYPE;
  String? vNO;
  String? billNo;
  String? dATE;
  String? party;
  String? city;
  String? station;
  String? transport;
  String? totalPcs;
  String? billAmt;
  String? haste;
  String? totalMtr;
  String? gpdate;
  String? userStatus;
  String? dbStatus;
  String? error;
  String? unit;
  String? fetchStatus;
  String? updateGp;

  GatePassModel(
      {this.fIRM,
      this.cNO,
      this.tYPE,
      this.vNO,
      this.billNo,
      this.dATE,
      this.party,
      this.city,
      this.station,
      this.transport,
      this.totalPcs,
      this.billAmt,
      this.haste,
      this.totalMtr,
      this.userStatus,
      this.dbStatus,
      this.error,
      this.unit,
      this.fetchStatus,
      this.updateGp,
      this.gpdate});

  GatePassModel.fromJson(Map<String, dynamic> json) {
    fIRM = json['FIRM'];
    cNO = json['CNO'];
    tYPE = json['TYPE'];
    vNO = json['VNO'];
    billNo = json['billNo'];
    dATE = json['DATE'];
    party = json['party'];
    city = json['city'];
    station = json['station'];
    transport = json['transport'];
    totalPcs = json['totalPcs'];
    billAmt = json['billAmt'];
    haste = json['haste'];
    totalMtr = json['totalMtr'];
    gpdate = json['gpdate'];
    userStatus = json['userStatus'];
    dbStatus = json['dbStatus'];
    error = json['error'];
    unit = json['unit'];
    fetchStatus = json['fetchStatus'];
    updateGp = json['updateGp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FIRM'] = this.fIRM;
    data['CNO'] = this.cNO;
    data['TYPE'] = this.tYPE;
    data['VNO'] = this.vNO;
    data['billNo'] = this.billNo;
    data['DATE'] = this.dATE;
    data['party'] = this.party;
    data['city'] = this.city;
    data['station'] = this.station;
    data['transport'] = this.transport;
    data['totalPcs'] = this.totalPcs;
    data['billAmt'] = this.billAmt;
    data['haste'] = this.haste;
    data['totalMtr'] = this.totalMtr;
    data['gpdate'] = this.gpdate;
    data['userStatus'] = this.userStatus;
    data['dbStatus'] = this.dbStatus;
    data['error'] = this.error;
    data['unit'] = this.unit;
    data['fetchStatus'] = this.fetchStatus;
    data['updateGp'] = this.updateGp;
    return data;
  }
}
