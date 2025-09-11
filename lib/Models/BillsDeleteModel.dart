class BillsDeleteModel {
  String? ide;
  String? cno;
  String? type;
  String? vno;
  String? dBy;
  String? dTime;

  BillsDeleteModel({this.ide, this.cno, this.type, this.vno, this.dBy, this.dTime});

  BillsDeleteModel.fromJson(Map<String, dynamic> json) {
    ide = json['ide'];
    cno = json['cno'];
    type = json['type'];
    vno = json['vno'];
    dBy = json['dBy'];
    dTime = json['dTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ide'] = this.ide;
    data['cno'] = this.cno;
    data['type'] = this.type;
    data['vno'] = this.vno;
    data['dBy'] = this.dBy;
    data['dTime'] = this.dTime;
    return data;
  }
}
