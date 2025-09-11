class QrCodeLinkRespModel {
  QrCodeLinkRespModel({
    this.id,
    this.name,
    this.nodeId,
    this.userId,
    this.isNotifInstance,
    this.loginType,
    this.connectedNumeber,
    this.inboxEnabled,
    this.webhookEnabled,
    this.webhookUrl,
    this.deliveryEnabled,
    this.deliveryUrl,
    this.webhookMode,
    this.includeDocument,
    this.profilePicture,
    this.profileName,
    this.qrcode,
    this.attachMedia,
    this.isLoggedIn,
    this.quota,
    this.quotaValidity,
    this.unlimitedValidity,
    this.instanceUsage,
    this.todayUsage,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  String? nodeId;
  String? userId;
  bool? isNotifInstance;
  String? loginType;
  String? connectedNumeber;
  bool? inboxEnabled;
  bool? webhookEnabled;
  String? webhookUrl;
  bool? deliveryEnabled;
  String? deliveryUrl;
  String? webhookMode;
  bool? includeDocument;
  String? profilePicture;
  String? profileName;
  String? qrcode;
  bool? attachMedia;
  bool? isLoggedIn;
  int? quota;
  String? quotaValidity;
  dynamic unlimitedValidity;
  int? instanceUsage;
  int? todayUsage;
  String? createdAt;
  String? updatedAt;

  factory QrCodeLinkRespModel.fromJson(Map<String, dynamic> json) {
    return QrCodeLinkRespModel(
      id: json["id"],
      name: json["name"],
      nodeId: json["nodeId"],
      userId: json["userId"],
      isNotifInstance: json["isNotifInstance"],
      loginType: json["loginType"],
      connectedNumeber: json["connectedNumeber"],
      inboxEnabled: json["inboxEnabled"],
      webhookEnabled: json["webhookEnabled"],
      webhookUrl: json["webhookUrl"],
      deliveryEnabled: json["deliveryEnabled"],
      deliveryUrl: json["deliveryUrl"],
      webhookMode: json["webhookMode"],
      includeDocument: json["includeDocument"],
      profilePicture: json["profilePicture"],
      profileName: json["profileName"],
      qrcode: json["qrcode"],
      attachMedia: json["attachMedia"],
      isLoggedIn: json["isLoggedIn"],
      quota: json["quota"],
      quotaValidity: (json["quotaValidity"] ?? ""),
      unlimitedValidity: json["unlimitedValidity"],
      instanceUsage: json["instanceUsage"],
      todayUsage: json["todayUsage"],
      createdAt: (json["createdAt"] ?? ""),
      updatedAt: (json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nodeId": nodeId,
        "userId": userId,
        "isNotifInstance": isNotifInstance,
        "loginType": loginType,
        "connectedNumeber": connectedNumeber,
        "inboxEnabled": inboxEnabled,
        "webhookEnabled": webhookEnabled,
        "webhookUrl": webhookUrl,
        "deliveryEnabled": deliveryEnabled,
        "deliveryUrl": deliveryUrl,
        "webhookMode": webhookMode,
        "includeDocument": includeDocument,
        "profilePicture": profilePicture,
        "profileName": profileName,
        "qrcode": qrcode,
        "attachMedia": attachMedia,
        "isLoggedIn": isLoggedIn,
        "quota": quota,
        "quotaValidity": quotaValidity?.toString(),
        "unlimitedValidity": unlimitedValidity,
        "instanceUsage": instanceUsage,
        "todayUsage": todayUsage,
        "createdAt": createdAt?.toString(),
        "updatedAt": updatedAt?.toString(),
      };
}

/*
{
	"id": "61fcfa815438c3a2f5afe37e",
	"name": "Instance 1",
	"nodeId": "clpgjnqqr0000xxzismsih7xx",
	"userId": "clqa0ep4x00oikpvos1wsgycn",
	"isNotifInstance": false,
	"loginType": "QRCODE",
	"connectedNumeber": "918890129938",
	"inboxEnabled": true,
	"webhookEnabled": true,
	"webhookUrl": "https://us-central1-wa-uniq-enotify.cloudfunctions.net/whatsappWebhook?hub.verify_token=VERIFY_TOKEN",
	"deliveryEnabled": false,
	"deliveryUrl": "",
	"webhookMode": "HTTP",
	"includeDocument": false,
	"profilePicture": "https://pps.whatsapp.net/v/t61.24694-24/323051989_598524935530450_1525033802233093420_n.jpg?ccb=11-4&oh=01_Q5AaIAkyXw9vH7V-FKTAUqcVuMQ8clTSJfM9qiMcjbuoJf8_&oe=66FFC391&_nc_sid=5e03e0&_nc_cat=111",
	"profileName": "Unique Softwares",
	"qrcode": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEAAQMAAABmvDolAAAABlBMVEX///8AAABVwtN+AAAEuElEQVR42uyZMa7zoBaEB1HQhQ1EZhspLLGllO5MR5ktIbnINrCyAdK5QMzT4SbRffWNXbz3U/76fl1i5pwzA/i3/r+WIhksm0uXGYoVc1HNLZspJNNBQIYOtmSMF2Nthgn22c6jiSVDHwWsXGKxgL5Hq1jNdrUNOsxl5fJFIJS1jj4UtSbDopg1t6MBFvVIF/BJbtOVzJiJA4EMHQP5WEjYrO+RZYCOG34d1t4AyXizw3m8TOW5Lvd4Ow3ncZp+i/ZvgCxD5rOchc06mdvJsU7md/ntDKiVDNeSXYWxlrwzFGiS5bXHI4DsE8CVyzbRNlym65NVx2Dl/3wHWJdlm8vgmFBUHk2Y24ARxn40eQBQYYg1+222zSWzAXBLDGDf/hEAAB+sXR/Jk1DLnTc4oZndchCg1gRTrMueEVb2dWWDNNw2+O8AgGe42gxcZhSX/IaiHiL7jKMAtTLNlOlx3wpc9QEYXJoD1zziGACQoQa4amil/OcAlbWcxac9/BFQTCI5wKcZtgGfs8jDeBCAwS8kcR7R/YNhQe+0Iv50DKBYx+kqQ032qhaG+TToZZuKe9XmEUDSYbbqsdwjbNNkKe7Bzdjh8yX/CAC+moJBMxlC/u1q21nzd+ntDrhF/EM7w0QLjJ60zDrG0qVyCKCaTtMV7azThNMAs0E8jLQg/HzJvwNr9dsVjgvlzy7JFKgHN3AYXo50dwDQ1YgEEqYi/tyUp/jzAK4VxwCqQfoNzn4zRTW/zQGODCh4ddr9Abg6zuImkgnlpJbNBIifiXZt3wIGT97K4Opl+rFJty6RiWTFQQC8SABOZjel25fuzENRb8u6OyA+Kt4sq2e0XHuXc3k0LOv6JQCDT+YG9Kynsij9BE3JJJ+z2BtQ6yJnIRGz//Rtvklnn8m37PcHMEC+ynDWd7LAp0lCSzKBw4DvADJQWNjOepMcAkxzUdnHYJtjOgjII8zNOtFDeeYRkz0picF8h6D9AaifgQJ9p7Wsl7mopsUuuncK2h8YgLlw0OmC8hRNXi2rZmD7nOZfAQm9FJ8Iwyau2No1+2A+Vu0AwKURkHB5mfDMYx+sjwr0dnMMoJp0Wrqqt6mn/TkoPmTfXJcvAayYZjvI5IKV4Ff6DUbEoH7Kf39ABkqkdY9qAlq3DMzSbt6Z9whApXFCkc4umVec+QnizOnaSzD7Az0liS63iVDVk2KbGdlU+g4gpWwCWP2dhSK5XnoxoqmXYPYHVjLMaGffN8nNlNPL1ryD+QHAIpYBOhlSjOJ0fTZNSd/5daP1V6DbpFIGASxUwky4rBmtyuNRAHydYHHWG4qVkVrgHgujfU/eA4B+L//TY9kwXmYyuzpN78F6AKCkyC1c9jLUGi7mZhsg1fjqtF8AqibtoOvF/AyX8FwfyyY+aTkI6Pe0gRmjzNfuinsIikV9OszeQD+KmSt5f9lmFJwl867vifNnIEPHW1kzfKTKesMswU/Mf9ZHAf0FBEO3iyL7Oag1azmU308k+wPsPsrw5Crm0q1VsL8fmw4ACuEWRplwJt6gHku/ZvkW0N/UkM/y023zqX+NCsP/enTbFyAZg/QWH/sdKQug0wT7DmL7A//W/876TwAAAP//ftcQntCqH2oAAAAASUVORK5CYII=",
	"attachMedia": false,
	"isLoggedIn": true,
	"quota": 1359,
	"quotaValidity": "2025-03-23T05:34:09.279Z",
	"unlimitedValidity": null,
	"instanceUsage": 3641,
	"todayUsage": 0,
	"createdAt": "2023-12-17T21:44:15.078Z",
	"updatedAt": "2024-09-24T14:20:37.813Z"
}*/