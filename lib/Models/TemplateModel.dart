class TemplateModel {
  TemplateModel({
    this.name,
    this.status,
    this.header,
    this.body,
    this.buttons,
  });

  Header? header;
  String? body;
  String? name;
  String? status;
  List<Button>? buttons;

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      header: json["header"] == null ? null : Header.fromJson(json["header"]),
      body: json["body"],
      name: json["name"],
      status: json["status"],
      buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "header": header?.toJson(),
        "body": body,
        "name": name,
        "status": status,
        "buttons": buttons!.map((x) => x.toJson()).toList(),
      };
}

class Button {
  Button({
    this.type,
    this.title,
    this.payload,
    this.id,
  });

  String? type;
  String? title;
  String? payload;
  String? id;

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      type: json["type"],
      title: json["title"],
      payload: json["payload"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "payload": payload,
        "id": id,
      };
}

class Header {
  Header({
    this.headerType,
    this.url,
    this.title,
  });

  String? headerType;
  String? url;
  String? title;

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      headerType: json["headerType"],
      url: json["url"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
        "headerType": headerType,
        "url": url,
        "title": title,
      };
}

/*
{
	"header": {
		"headerType": "media",
		"url": "clxydq4sf18dt142j0kxdfkrj",
		"title": "Text Header here"
	},
	"body": "Welcome to our service! How can we assist you today?",
	"buttons": [
		{
			"type": "url",
			"title": "Visit Website",
			"payload": "https://www.yourwebsite.com",
			"id": "visit_website_btn"
		},
		{
			"type": "quickReply",
			"title": "More Information",
			"payload": "more_info",
			"id": "more_info_btn"
		},
		{
			"type": "call",
			"title": "Call Us",
			"payload": "+1234567890",
			"id": "call_us_btn"
		}
	]
}*/