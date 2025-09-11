class LayoutInfoModel {
  LayoutInfoModel({
    this.widthIsFor,
    this.width,
    this.height,
  });

  final String? widthIsFor;
  final double? width;
  final double? height;

  factory LayoutInfoModel.fromJson(Map<String, dynamic> json) {
    return LayoutInfoModel(
      widthIsFor: json["widthIsFor"],
      width: json["width"],
      height: json["height"],
    );
  }

  Map<String, dynamic> toJson() => {
        "widthIsFor": widthIsFor,
        "width": width,
        "height": height,
      };
}

/*
{
	"widthIsFor": "",
	"width": 0
}*/