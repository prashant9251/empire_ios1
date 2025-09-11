class WebViewDataModel {
  String? url;
  String? urlLinkUser;
  String? lastUpdatetime;
  int? minimumFontSize;
  int? initialScale;
  String? databaseID;

  WebViewDataModel({this.url, this.lastUpdatetime, this.urlLinkUser, this.minimumFontSize, this.initialScale, this.databaseID});

  WebViewDataModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    urlLinkUser = json['UrlLinkUser'];
    lastUpdatetime = json['lastUpdatetime'];
    minimumFontSize = json['minimumFontSize'];
    initialScale = json['initialScale'];
    databaseID = json['databaseID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['lastUpdatetime'] = this.lastUpdatetime;
    data['UrlLinkUser'] = this.urlLinkUser;
    data['minimumFontSize'] = this.minimumFontSize;
    data['initialScale'] = this.initialScale;
    data['databaseID'] = this.databaseID;
    return data;
  }
}
