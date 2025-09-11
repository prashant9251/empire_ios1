class InstructionModel {
  String? id;
  String? title;
  String? msg;
  String? url;
  String? urlType;
  String? cTime;
  String? software_name;
  String? sql_;

  InstructionModel({this.id, this.title, this.msg, this.url, this.urlType, this.cTime, this.software_name, this.sql_});

  InstructionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    msg = json['msg'];
    url = json['url'];
    urlType = json['urlType'];
    cTime = json['cTime'];
    software_name = json['software_name'];
    sql_ = json['sql_'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['msg'] = this.msg;
    data['url'] = this.url;
    data['urlType'] = this.urlType;
    data['cTime'] = this.cTime;
    data['software_name'] = this.software_name;
    data['sql_'] = this.sql_;
    return data;
  }
}
