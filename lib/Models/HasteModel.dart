class HasteModel {
  String? hS;
  String? sT;
  String? tR;
  String? aD;

  HasteModel({this.hS, this.sT, this.tR, this.aD});

  HasteModel.fromJson(Map<String, dynamic> json) {
    hS = json['HS'];
    sT = json['ST'];
    tR = json['TR'];
    aD = json['AD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HS'] = this.hS;
    data['ST'] = this.sT;
    data['TR'] = this.tR;
    data['AD'] = this.aD;
    return data;
  }
}
