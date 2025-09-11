class HideUnhideModel {
  String reportName;
  String id;
  String caption;
  bool view;
  int index = 0;

  HideUnhideModel({required this.id, required this.caption, required this.view, required this.reportName, required this.index});

  factory HideUnhideModel.fromJson(Map<String, dynamic> json) {
    return HideUnhideModel(
      id: json['id'],
      caption: json['c'],
      view: json['v'],
      reportName: json['rpn'],
      index: json['i'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'c': caption,
      'v': view,
      'rpn': reportName,
      'i': index,
    };
  }
}
