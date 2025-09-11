class AgAcGroupModel {
  AgAcGroupModel({
    this.value,
    this.label,
    this.mo,
  });

  String? value;
  String? label;
  String? mo;

  factory AgAcGroupModel.fromJson(Map<String, dynamic> json) {
    return AgAcGroupModel(
      value: json["value"],
      label: json["label"],
      mo: json["MO"],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
        "MO": mo,
      };
}

/*
{
	"value": "",
	"label": "",
	"MO": ""
}*/