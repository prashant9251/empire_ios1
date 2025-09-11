class PackingStyleModel {
  String? packingStyle;
  String? packingAdd;
  String? boxRate;

  PackingStyleModel({this.packingStyle, this.packingAdd, this.boxRate});

  PackingStyleModel.fromJson(Map<String, dynamic> json) {
    packingStyle = json['PK'];
    packingAdd = json['PA'];
    boxRate = json['BR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK'] = this.packingStyle;
    data['PA'] = this.packingAdd;
    data['BR'] = this.boxRate;
    return data;
  }
}
