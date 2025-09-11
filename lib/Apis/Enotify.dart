import 'package:dio/dio.dart';
import 'package:empire_ios/Models/WhatsappContactModel.dart';
import 'package:empire_ios/main.dart';

class EnotifyApis {
  static const String baseUrl = "https://enotify.app/api/";
  static dynamic getQrCodeApi() async {
    var apiUrl = "${baseUrl}qrCode?token=${loginUserModel.enotifyInstance}";
    var response = await Dio().get(apiUrl);
    return response.data;
  }

  static dynamic sendContact(toPhone) async {
    // https://enotify.app/api/sendContact?token={{instance_id}}&phone={{Whatsapp_Number}}&contactName={{Name}}&contactPhone={{Number_with_Country_code}}
    var apiUrl =
        "${baseUrl}sendContact?token=${loginUserModel.enotifyInstance}&phone=${toPhone}&contactName=UNIQUE SOFTWRAES (WHATSAPP CHAT BOT NO. ONLY)&contactPhone=918890129938";
    var response = await Dio().get(apiUrl);
    return response.data;
  }

  static dynamic sendMsg(WhatsappContactModel whatsappContactModel, {toPhone, textMsg}) async {
    // https://enotify.app/api/sendContact?token={{instance_id}}&phone={{Whatsapp_Number}}&contactName={{Name}}&contactPhone={{Number_with_Country_code}}
    var apiUrl = "${baseUrl}sendText?token=${loginUserModel.enotifyInstance}&phone=${toPhone}&message=$textMsg";
    var response = await Dio().get(apiUrl);
    if (response.data["status"] == "success") {
      whatsappContactModel.issent = true;
    }
    return response.data;
  }

  static dynamic senFileWithCaption(WhatsappContactModel whatsappContactModel, {toPhone, textMsg, fileLink}) async {
    // https://enotify.app/api/sendFileWithCaption?token={{instance_id}}&phone={{Whatsapp_Number}}&link={{File_Url}}&message={{Text_Message}}
    var apiUrl = "${baseUrl}sendFileWithCaption?token=${loginUserModel.enotifyInstance}&phone=${toPhone}&link=${fileLink}&message=$textMsg";
    var response = await Dio().get(apiUrl);
    if (response.data["status"] == "success") {
      whatsappContactModel.issent = true;
    }
    return response.data;
  }

  static Future sendFileByLink({toPhone, textMsg, fileLink}) async {
    var apiUrl = "${baseUrl}sendFileWithCaption?token=${loginUserModel.enotifyInstance}&phone=${toPhone}&link=${fileLink}&message=$textMsg";
    var response = await Dio().get(apiUrl);
    return response.data;
  }
}
