class ColorModel {
  String? clName;
  String? clQty;
  String? clRate;
  String? clRmk;
  String? category;
  String? url;
  bool selected;

  ColorModel({
    this.clName,
    this.clQty,
    this.clRate,
    this.clRmk,
    this.category,
    this.url,
    this.selected = false,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      clName: json['clName'],
      clQty: json['clQty'],
      clRate: json['clRate'],
      clRmk: json['clRmk'],
      category: json['CT'],
      url: json['url'],
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clName'] = this.clName;
    data['clQty'] = this.clQty;
    data['clRate'] = this.clRate;
    data['clRmk'] = this.clRmk;
    data['CT'] = this.category;
    data['url'] = this.url;
    data['selected'] = this.selected;
    return data;
  }
}
