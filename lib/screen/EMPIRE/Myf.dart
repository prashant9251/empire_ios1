// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, unused_local_variable, unnecessary_null_comparison, body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/ImageModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/NotificationService/FirebaseApi.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

// import 'dart:io' as io;
import 'package:empire_ios/Models/LayoutInfoModel.dart';
import 'package:empire_ios/functions/htmlToPdf.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/EmpOrderSettingModel.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/screen/SyncDataIsolate/SyncDataIsolateClass.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/src/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_filex/open_filex.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:encrypt/encrypt.dart' as enc;

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/IosDenied.dart';
import 'package:empire_ios/screen/EMPIRE/syncScreen.dart';
import 'package:empire_ios/screen/ProductManagement/editImage.dart';
// import 'package:empire_ios/MyfCmn.dart';
import 'package:empire_ios/screen/demoExpired.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ndialog/ndialog.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'dart:math' as math;

import '../../main.dart';

import 'package:html/dom.dart' as dom;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pp;

import '../FirebaseUserEnter/firebaseUserEnter.dart';
import 'package:empire_ios/screen/pdf_viewer/pdf_viewer.dart'; // Import the conditional import file

class Myf {
  static String? getSubstring(String text, {int length = 80}) {
    return text.substring(0, text.length > length ? length : text.length);
  }

  final value = NumberFormat.currency(locale: 'en_IN');
  late BuildContext mcontext;

  static bool autoSyncIs() {
    if (firebaseCurrntUserObj["autoSync"] != null && firebaseCurrntUserObj["autoSync"] != "") {
      autoSync = "${firebaseCurrntUserObj["autoSync"]}".contains("true") ? true : false;
    }

    return autoSync;
  }

  static Future<String> getCss(String url) async {
    var css = "";
    if (url.indexOf('AJX') > -1 || url.indexOf('master.html') > -1 || url.indexOf('QualChart.html') > -1) {
      String software_type = GLB_CURRENT_USER["ACTYPE"];
      if (software_type.contains("AGENCY")) {
        css += await rootBundle.loadString('assets/agency/css/style.css');
      } else {
        css += await rootBundle.loadString('assets/uniquesoftwares/css/style.css');
      }
    }
    return css;
  }

  static Future<String> UrlLinkUser(dynamic CURRENT_USER, url) async {
    var login_user = CURRENT_USER['login_user'] ?? "";
    IosPlateForm = isIos();
    var ID = CURRENT_USER['ID'];
    var year = CURRENT_USER['yearSelected'];
    var privateNetWorkSync = CURRENT_USER['privateNetWorkSync'];
    var LINE1 = await prefs!.getString("deviceId");
    var AddData = "";
    var databaseId = Myf.databaseId(CURRENT_USER);
    var CLDB = CURRENT_USER['customerDBname'];
    var CLNT = stringToBase64.decode(CLDB);
    var Curentyearforlocalstorage = CURRENT_USER['Curentyearforlocalstorage'];
    var localTimeInMili = await getValFromSavedPref(CURRENT_USER, "localTimeInMili");
    if (url.toString().contains("settingSelection.php") || url.toString().contains("newUserByAuth.php") || kIsWeb) {
      AddData += "&userGstin=${CURRENT_USER['GSTIN']}";
      AddData += "&OTP=${CURRENT_USER['CUOTP']}";
      AddData += "&email=${CURRENT_USER['emailadd']}";
      AddData += "&mobileNo=${CURRENT_USER['mobileno_user']}";
      AddData += "&mobileno_user=${CURRENT_USER['mobileno_user']}";
      AddData += "&requestFrom=IOSCONFIG";
    }

    if (firebaseCurrntUserObj['FIX_FIRM'] != null) {
      AddData += "&FIX_FIRM=${firebaseCurrntUserObj['FIX_FIRM']}";
    }
    AddData += "&MCNO=${fireUserModel.MCNO}";
    if (firebaseCurrntUserObj['MTYPE'] != null) {
      AddData += "&MTYPE=${firebaseCurrntUserObj['MTYPE']}";
    } else {
      AddData += "&MTYPE=${CURRENT_USER['MTYPE']}";
    }
    if (firebaseCurrntUserObj['iconPermissionSet'] != null) {
      AddData += "&iconPermissionSet=${firebaseCurrntUserObj['iconPermissionSet']}";
    }
    if (firebaseCurrntUserObj['LFolder'] != null && firebaseCurrntUserObj['LFolder'] != "") {
      AddData += "&LFolder=${firebaseCurrntUserObj['LFolder']}";
      lFolder = "${firebaseCurrntUserObj['LFolder']}";
    } else {
      AddData += "&LFolder=${CURRENT_USER['LFolder']}";
      lFolder = "${CURRENT_USER['LFolder']}";
    }
    var mobileNoChoose = firebaseCurrntUserObj['mobileNoChoose'] ?? "MO";

    AddData += "&mobileNoChoose=${mobileNoChoose}";
    AddData += "&http=${CURRENT_USER['http']}";
    AddData += "&ServerLocation=${CURRENT_USER['android']}";
    AddData += "&privateNetworkIp=${ipController.text}";
    AddData += "&login_user=${Uri.encodeComponent(login_user)}";
    AddData += "&ID=$ID";
    AddData += "&LINE1=$LINE1";
    AddData += "&AppLocalStorage=${CURRENT_USER['AppLocalStorage']}";
    AddData += "&IosPlateForm=$IosPlateForm";
    AddData += "&deviceIsIos=$IosPlateForm";
    AddData += "&databaseId=$databaseId";
    AddData += "&CLDB=$CLDB";
    AddData += "&CLNT=$CLNT";
    AddData += "&DatabaseSource=${databaseId}";
    AddData += "&Currentyear=$year";
    AddData += "&Curentyearforlocalstorage=$Curentyearforlocalstorage";
    var CrntYearStartdate = _calculateStartDate(CURRENT_USER["yearSelected"]);
    AddData += "&CrntYearStartdate=${dateFormateInDDMMYYYY(CrntYearStartdate.toString())}";
    AddData += "&pdfBillType=${CURRENT_USER['pdfbillFormat']}";
    AddData += "&${privateNetWorkSync}";
    AddData += "&${privateNetWorkSync}";
    AddData += "&localTimeInMili=${localTimeInMili}";
    AddData += "&FILE_NAME=${CURRENT_USER['FILE_NAME']}";
    AddData += "&ACTYPE=${CURRENT_USER['ACTYPE']}";
    AddData += "&line_code=${CURRENT_USER['line_code']}";
    AddData += "&SHOPNAME=${CURRENT_USER['SHOPNAME']}";
    AddData += "&upi=${firebaseCurrntSupUserObj['upi']}";
    AddData += "&kIsWeb=${kIsWeb}";
    AddData += "&ORDER_FORM_ENABLE=${loginUserModel.oRDERFORMENABLE}";

    return AddData;
  }

  static DateTime _calculateStartDate(String timeRange) {
    // Parse the year from the selected time range
    int year = int.parse("${20}${timeRange.substring(0, 2)}");

    // Set the start date to April 1st of the parsed year
    return DateTime(year, 4, 1);
  }

  currency(val) {
    return value.format(val);
  }

  toFix(val) {
    val = double.parse(val);
    return val.toStringAsFixed(2);
  }

  Future<void> inital(BuildContext context) async {
    mcontext = context;
  }

  Future<String?> getStr(key) async {
    return prefs!.getString(key);
  }

  static nullC(val) {
    if (val == null) {
      return "";
    } else {
      return val;
    }
  }

  dateF(date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }

  static Future<String> removeScriptTags(String html) async {
    dom.Document document = await parse(html);
    document.querySelectorAll('script').forEach((element) => element.remove());
    return await document.outerHtml;
  }

  static Future<File?> createPdfhtml(BuildContext context, htmlContent, Name, showLoader, {url = ""}) async {
    final directory = await getApplicationDocumentsDirectory();
    final filepath = directory.path;
    var path = "$filepath/";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yy h:mm a', 'en_US').format(now);
    var pdfName = "$Name(PDF GENERATED ON $formattedDate)";
    File file = File("$path$pdfName.pdf");
    final document = parse(htmlContent);
    for (dom.Element child in document.head?.children ?? []) {
      if (child.localName == "link" && child.attributes["rel"] == "stylesheet") {
        var cssContent = "";
        try {
          cssContent = await rootBundle.loadString("assets$assethtmlFolder$assethtmlSubFolder/${child.attributes["href"]}");
        } catch (e) {}
        htmlContent = htmlContent.replaceAll(child.outerHtml, "<style>\n$cssContent\n</style>");
      } else if (child.localName == "script") {
        htmlContent = htmlContent.replaceAll(child.outerHtml, "");
      }
      // else if (child.localName == "link") {
      //   htmlContent = htmlContent.replaceAll(child.outerHtml, "");
      // }
    }
    htmlContent = await removeScriptTags(htmlContent);
    //logger.d(htmlContent);
    if (Platform.isAndroid) {
      // await Myf.deleteFile(file);
      showLoader ? pdfStatus.sink.add("creating pdf...") : null;
      await Future.delayed(const Duration(milliseconds: 100));

      showLoader ? pdfStatus.sink.add("creating pdf.....") : null;
      final arg = {"html": htmlContent, "url": url};

      var path = await AndroidChennal.invokeMethod("createPdfFromWebView", arg);
      file = File(path);
      // await file.writeAsBytes(await pdf.buffer.asUint8List());
      // file = await file.writeAsBytes(pdf.buffer.asUint8List());
      showLoader ? pdfStatus.sink.add("pdf done") : null;

      showLoader ? pdfStatus.sink.add("") : null;
      // await Share.shareFiles([file.path]);
    } else if (isIos()) {
      showLoader ? showLoading(context, "Creating PDF") : null;

      await Myf.deleteFile(file);
      await Future.delayed(const Duration(milliseconds: 100));
      // if (url.toString().contains("Billpdf.html")) {
      // var pdf = await Printing.convertHtml(
      //   format: PdfPageFormat.a3,
      //   html: await htmlContent,
      // );

      // await file.writeAsBytes(await pdf.buffer.asUint8List());
      file = await htmlToPdf(htmlContent, pdfName);

      // await htmlToPdf();
      // } else {
      //   file = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, filepath, pdfName);
      // }

      showLoader ? Navigator.pop(context) : null;
    }
    // printingPageAndView(htmlContent, "xyz");
    return file;
  }

  static String removeSpecialCharacters(String text) {
    // Define a regular expression for matching special characters
    RegExp specialChars = RegExp(r'[^\w\s]+');

    // Replace special characters with an empty string
    return text.replaceAll(specialChars, '');
  }

  static Future<bool> printing(html) async {
    await Printing.layoutPdf(
        dynamicLayout: true,
        format: PdfPageFormat.a3,
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
              html: html.toString(),
            ));
    return true;
  }

  Future<bool> printingA4(html) async {
    await Printing.layoutPdf(
        dynamicLayout: true,
        format: PdfPageFormat.a4,
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
              html: html.toString(),
            ));
    return true;
  }

  Future<List<dynamic>> getListByKey(SharedPreferences pref, key) async {
    String? Data = pref.getString(key);
    var List = await jsonIsolate.decode(Data!);
    if (List.length > 0) {
      return List;
    } else {
      return [];
    }
  }

//-----create pdf call

//-----create pdf call

  printingPageAndView(htmlContent, Name) async {
    var printed = await Printing.layoutPdf(
        dynamicLayout: true,
        format: PdfPageFormat.a3,
        onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
              format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
              html: await htmlContent,
            ));
  }

  static Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }

  static showMsg(BuildContext context, title, msg, {titleColor = Colors.black}) async {
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      content: Text(msg),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ok'))
      ],
    ).show(context);
  }

  static showLoading(BuildContext context, title) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            actionsAlignment: MainAxisAlignment.end,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        });
  }

  static showBlurLoading(BuildContext context) {
    if (context != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator());
          });
    }
  }

  static databaseId(dynamic CURRENT_USER) {
    var extraPath = CURRENT_USER["extraPathSelected"] != null ? CURRENT_USER["extraPathSelected"] : "";
    var year = CURRENT_USER["yearSelected"] != null ? CURRENT_USER["yearSelected"] : "";
    var databaseID = "${CURRENT_USER["customerDBname"]}$extraPath$year";
    return databaseID;
  }

  static databaseIdCurrent(dynamic CURRENT_USER) {
    var extraPath = CURRENT_USER["extraPathSelected"] != null ? CURRENT_USER["extraPathSelected"] : "";
    var year = CURRENT_USER["Curentyearforlocalstorage"] != null ? CURRENT_USER["Curentyearforlocalstorage"] : "";
    var databaseID = "${CURRENT_USER["customerDBname"]}$extraPath$year";
    return databaseID;
  }

  Future checkPermission(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      //print("--granted");
    } else if (status.isDenied) {
      //print("--denied");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Camera Permission'),
                content: const Text('This app needs camera access to take pictures for upload user profile photo'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: const Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
  }

  pop(BuildContext context) {
    Navigator.pop(context);
  }

  static Future gotohomeBack(BuildContext context) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static Future<String?> getId() async {
    try {
      if (isIos()) {
        var deviceInfo = DeviceInfoPlugin();
        // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
      } else if (isAndroid()) {
        var deviceInfo = DeviceInfoPlugin();
        var androidDeviceInfo = await deviceInfo.androidInfo;
        var androidVersion = Myf.convertToDouble(androidDeviceInfo.version.release);
        if (androidVersion > 13) {
          boolHardwareAcceleration = false;
        }
        return androidDeviceInfo.id; // Unique ID on Android
      }
    } catch (e) {
      return "desktop";
    }
  }

  static isAndroid() {
    var returnVal = false;
    try {
      returnVal = defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {}
    return returnVal;
  }

  static isIos() {
    var returnVal = false;
    try {
      returnVal = defaultTargetPlatform == TargetPlatform.iOS;
    } catch (e) {}
    return returnVal;
  }

  static Future<bool> SaveToLocal(args, {HiveBox}) async {
    var key = await args[0];
    var value = await args[1];

    if (key.toString().contains("settOTG")) {
      var save = await prefs!.setString(key, value);
      return save;
    }
    Directory appStorage = Directory("");
    if (!kIsWeb) {
      appStorage = await getApplicationDocumentsDirectory();
    }
    return await compute(SaveToLocalByKeyValIsolate, {"key": key, "value": value, "appStoragePath": appStorage.path, "UserObj": GLB_CURRENT_USER});
  }

  static Future<String?> GetFromLocal(args, {HiveBox}) async {
    var key = await args[0];
    //print(key);
    if (key.toString().contains("settOTG")) {
      var value = await prefs!.getString(key);
      value = await value == null || value == "" ? "[]" : value;
      return value;
    }
    var CuHiveBox = await Hive.openBox(key);
    final jsonArray = await CuHiveBox.get(key, defaultValue: []) as List<dynamic>;
    await CuHiveBox.close();
    var value = await jsonIsolate.encode(jsonArray);
    value = await value == null || value == "" ? "[]" : value;
    return value;
  }

  static Future<Object?> GetFromLocalInJsonFromIsolate(args) async {
    var key = args[0];
    final jsonArray = [];
    if (key.toString().contains("settOTG")) {
      var value = await prefs!.getString(key) ?? "[]";
      return await jsonIsolate.decode(value);
    } else {
      final message = {'key': '$key'};
      sendPort.send(message);
      var broadcastStream = await receivePort.toList();
      return jsonArray;
    }
  }

  static loadIsoLate() async {
    final isolate = await Isolate.spawn(hiveIsolateMain, [receivePort.sendPort, appDocumentDir.path]);
    receivePort.listen((message) {
      if (message is SendPort) {
        sendPort = message;
        receivePort.close();
      }
    });
    isolate.addOnExitListener(receivePort.sendPort);
  }

  static Future<Object?> GetFromLocalInJson(args) async {
    var key = args[0];

    if (key.toString().contains("settOTG")) {
      var value = await prefs!.getString(key) ?? "[]";
      return await jsonIsolate.decode(value);
    } else {
      var CuHiveBox = await Hive.openLazyBox(key);
      var jsonArray = await CuHiveBox.get(key, defaultValue: []);
      // await CuHiveBox.compact();
      await CuHiveBox.close();
      hiveBoxOpenedMap.putIfAbsent(key, () => key);
      if (jsonArray == null || jsonArray.isEmpty) {
        return [];
      } else {
        return jsonArray;
      }
    }
  }

  static Future<List<dynamic>> GetFromLocalInList(args, {HiveBox}) async {
    var key = await args[0];
    var CuHiveBox = await Hive.openLazyBox(key);
    final jsonArray = await CuHiveBox.get(key, defaultValue: []) as List<dynamic>;
    await CuHiveBox.close();
    return jsonArray;
  }

  //  static Future<bool> SaveToLocal(args) async {
  //   var key = await args[0];
  //   var value = await args[1];
  //   //print(key);
  //   // //print(value);
  //   var save = await prefs!.setString(key, value);
  //   return save;
  // }

  // static Future<String?> GetFromLocal(args) async {
  //   var key = await args[0];
  //   //print(key);
  //   var value = await prefs!.getString(key);
  //   value = await value == null || value == "" ? "[]" : value;
  //   return value;
  // }

  static Future<void> logout(BuildContext context, encClDb, login_user, NavClose) async {
    var DID = await getId();
    var loginUrl = "${urldata.syncDataUrlDomain}/LOGINIOS/mlogout.php?LINE1=$DID&encClDb=$encClDb&login_user=$login_user";
    //print(loginUrl);
    var res = '[]';

    try {
      final dio = Dio();
      final response = await dio.get(loginUrl);

      res = response.data.toString();

      if (res.contains("logout")) {
        await logoutremoveUser(encClDb);
      }
      Navigator.popUntil(context, (route) => route.isFirst);
      if (NavClose == "") {
        showSimpleNotification(Text("User Logged Out"), background: Colors.red);
      } else {
        showSimpleNotification(Text("User Auto Logged Out"), background: Colors.red);
      }
      // if (NavClose != "") {
      //   Navigator.pop(context);
      //   Navigator.of(context).pop("AccountRemove");
      // } else {
      //   Navigator.of(context).pop("AccountRemove");
      // }
    } catch (e) {}
  }

  static Future<List<String>> getNameOfHiveBoxs() async {
    var appDir = await getApplicationDocumentsDirectory();

    final directory = Directory(appDir.path);
    final List<FileSystemEntity> entities = await directory.list().toList();

    final List<String> boxNames =
        entities.where((file) => file.path.endsWith('.hive')).map((file) => file.path.split('/').last.split('.hive').first).toList();
    print("Box Names: $boxNames");

    return boxNames;
  }

  static Future deletehiveOnLogout(customerDBname) async {
    if (kIsWeb) return;
    var appDir = await getApplicationDocumentsDirectory();

    final directory = Directory(appDir.path);
    final List<FileSystemEntity> entities = await directory.list().toList();

    final List<String> boxNames =
        entities.where((file) => file.path.endsWith('.hive')).map((file) => file.path.split('/').last.split('.hive').first).toList();
    print("Box Names: $boxNames");
    await Future.wait(boxNames.map((e) async {
      if (e.toString().contains("$customerDBname".toLowerCase())) {
        await Myf.deleteHiveBoxName(e.toString());
      }
    }).toList());
  }

  static deleteHiveBoxName(String name) async {
    try {
      // Check if the box exists
      if (Hive.isBoxOpen("$name")) {
        // Close the box
        await Hive.box("$name").close();
      } else {
        // Open the box if it doesn't exist
        await Hive.openBox("$name");
      }

      // Delete the box from disk
      await Hive.deleteBoxFromDisk("$name");
    } catch (e) {}
  }

  static Future<bool> logoutremoveUser(encClDb) async {
    bool foundUser = false;
    var AccountUser = prefs!.getString("AccountUser");
    AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
    List AccountUserList = jsonDecode(AccountUser);
    for (var i = 0; i < AccountUserList.length; i++) {
      var customerDBname = AccountUserList[i]['0']['customerDBname'];
      await Myf.saveValToSavedPref(AccountUserList[i]['0'], "MPIN", "");
      if (customerDBname == encClDb) {
        foundUser = true;
        AccountUserList.removeWhere((item) => item['0']['customerDBname'] == customerDBname);
        await deletehiveOnLogout(customerDBname);
        // erese all data from hive box
      }
    }
    prefs!.setString("AccountUser", jsonEncode(AccountUserList));
    return foundUser;
  }

  // Future setCookies(key, value) async {
  //   final expiresDate = DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
  //   final url = Uri.parse(urldata().gotoSettings);
  //   CookieManager cookieManager = CookieManager.instance();
  //   await cookieManager.setCookie(
  //     url: url,
  //     name: key,
  //     value: value,
  //     domain: urldata.syncDataUrlDomain,
  //     expiresDate: expiresDate,
  //     isSecure: true,
  //   );
  // }

  static Future<void> getCurrentYearApi(BuildContext context) async {
    var res = '[]';
    try {
      var url = Uri.parse(urldata.yearArrayUrl);
      var response = await http.get(url);
      res = (response.body);
      List resUser = jsonDecode(res);
      if (resUser.length > 0) {
        //print(res);
        prefs!.setString("currentYears", await jsonIsolate.encode(resUser));
      }
      // //print(loginUrl);
    } catch (e) {}
  }

  static Future saveToAccountList(BuildContext context, List AccountUserList, resJson) async {
    bool foundUser = false;
    for (var i = 0; i < AccountUserList.length; i++) {
      var userID = AccountUserList[i]['userID'];
      if (userID == resJson['userID']) {
        foundUser = true;
        var DID = getId();
        AccountUserList.forEach((item) {
          if (item['userID'] == userID) {
            return item["0"] = resJson["0"];
          }
        });
      }
    }
    // if ((!foundUser || AccountUserList.isEmpty)) {
    //   //print("${resJson['userID']}$foundUser");
    //   AccountUserList.add(resJson);
    // }
    // //print('----Login${jsonEncode(AccountUserList)}');

    prefs!.setString("AccountUser", jsonEncode(AccountUserList));
  }

  static Future logoutToAccountList(BuildContext context, List AccountUserList, resJson, prUserRemove) async {
    FirebaseApi().unsubscribeFromTopic(loginUserModel.softwareName.toString().replaceAll(" ", "_"));
    FirebaseApi().unsubscribeFromTopic(loginUserModel.cLIENTNO);
    bool foundUser = false;
    for (var i = 0; i < AccountUserList.length; i++) {
      var userID = AccountUserList[i]['userID'];
      if (userID == resJson['userID']) {
        foundUser = true;
        logout(context, AccountUserList[i]['0']['customerDBname'], AccountUserList[i]['0']['login_user'], "AccountRemove");
        AccountUserList.removeWhere((item) => item['userID'] == userID);
      }
    }
    prefs!.setString("AccountUser", jsonEncode(AccountUserList));
  }

  static Future<void> verify(BuildContext context, dynamic UserObj) async {
    var deviceId = await getId();
    var userGstin = UserObj["GSTIN"];
    var email = UserObj["emailadd"];
    var mobileNo = UserObj["mobileno_user"];
    var OTP = UserObj["CUOTP"];
    var loginUrl =
        "${urldata.syncDataUrlDomain}/LOGINIOS/appLoginVerification.php?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&OTP=$OTP&DID=$deviceId";
    var res = '[]';

    try {
      final dio = Dio();
      final response = await dio.get(loginUrl);

      if (response.statusCode == 200) {
        res = response.data.toString();
        var AccountUser = prefs!.getString("AccountUser");
        AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
        List AccountUserList = jsonDecode(AccountUser);

        if (res != null) {
          var resJson = jsonDecode(res);
          var user = resJson['user'];

          if (user == "valid") {
            var OTP = resJson['OTP'];

            if (OTP == "verify") {
              await saveToAccountList(context, AccountUserList, resJson);
            } else {
              await logoutToAccountList(context, AccountUserList, resJson, true);
            }
          } else {
            resJson["userID"] = UserObj["ID"];
            await logoutToAccountList(context, AccountUserList, resJson, true);
          }
        } else {
          //print("User Not Valid");
        }
      }
    } catch (e) {
      //print(e);
    }
  }

  static checkHostStatus() async {
    var host = Myf.getLocalHostUrl();
    await Myf.launchurl(Uri.parse(host));
  }

  static void gotoExpiredPage(BuildContext context, List CURRENT_USER) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DemoExpired(UserObj: CURRENT_USER[0]),
        ));
  }

  static String getPrivateNetWorkIp(dynamic CURRENT_USER) {
    var privateNetworkIp = getValFromSavedPref(CURRENT_USER, "privateNetworkIp");
    privateNetworkIp = privateNetworkIp == "" || privateNetworkIp == null ? CURRENT_USER['privateNetworkIp'] : privateNetworkIp;
    privateNetworkIp = nullC(privateNetworkIp);
    return privateNetworkIp;
  }

  // static checkForSyncMini(context) async {
  //   var databaseId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   fireBCollection.collection("supuser").doc(loginUserModel.cLIENTNO).collection("database").doc("1").snapshots().listen((value) async {
  //     if (value.exists) {
  //       dynamic d = value.data();
  //       double CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLI = Myf.convertToDouble(d["CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLI"]) == 0
  //           ? 1.0
  //           : Myf.convertToDouble(d["CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLI"]);
  //       double CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLILocal = Myf.convertToDouble(await hiveMainBox.get("${databaseId}EMP_FAST_SYNC") ?? "0");
  //       if (CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLI > CURRENT_YEAR_FAST_SYNC_CREATETIME_MILLILocal) {
  //         DownloadData downloadData = DownloadData(GLB_CURRENT_USER, appStorage.path, receivePort.sendPort, "", true);
  //         var f = await downloadFileFromS3(downloadData);
  //         if (f != null) {
  //           if (loginUserModel.zipPassword != null && loginUserModel.zipPassword != "") {
  //             try {
  //               final appStorage = await getApplicationDocumentsDirectory();
  //               var outputFile = await File("${appStorage.path}/${databaseId}_DNC_FAST_SYNC.zip");
  //               f = (await Myf.decryptFile(context, inputFile: f.path, outputFile: outputFile.path))!;
  //               if (f == null) {
  //                 backgroundSyncInProcess = false;
  //                 return;
  //               }
  //             } catch (e) {
  //               Myf.snakeBar(context, "$e");
  //               // showInputBoxForPasswordZip();
  //               SyncStatus.sink.add("$e");
  //               backgroundSyncInProcess = false;
  //               return;
  //             }
  //           }
  //           DownloadData downloadData = DownloadData(GLB_CURRENT_USER, f.path, receivePort.sendPort, "", false);
  //           await compute(isolateLocalSave, downloadData);
  //           hiveMainBox.put("${databaseId}EMP_FAST_SYNC", DateTime.now().millisecondsSinceEpoch.toString());
  //         }
  //       }
  //     }
  //   });
  // }

  static snakeBar(BuildContext context, msg) {
    GFToast.showToast(msg, context, toastDuration: 1);
  }

  static void shareText(List args) async {
    var text = args[0];
    String url = "whatsapp://send?&text=$text";
    launchUrl(Uri.parse(url));
  }

  // static void dialNo2(List args, context) async {
  //   var mo = args[0];
  //   var url = "tel:$mo";
  //   var find = false;
  //   await Future.wait(contacts.map((e) async {
  //     await Future.wait(e.phones!.map((c) async {
  //       if (c.value!.contains(mo)) {
  //         find = true;
  //       }
  //     }).toList());
  //   }).toList());

  //   if (!find) {
  //     Contact contact = new Contact();

  //     contact.givenName = "";
  //     contact.phones = [Item(label: "mobile", value: "$mo")];
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Do you want to save "),
  //           content: Text("This contact not found in your contact "),
  //           actions: [
  //             ElevatedButton(onPressed: () => ContactsService.addContact(contact), child: Text("SAVE")),
  //             ElevatedButton(onPressed: () => launchUrl(Uri.parse(url)), child: Text("CALL")),
  //             ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL")),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     launchUrl(Uri.parse(url));
  //   }
  // }

  static void dialNo(List args, context) async {
    var mo = args[0];
    var url = "tel:$mo";
    launchUrl(Uri.parse(url));
  }

  static Widget showImg(ImageModel? imgModel, {fit = BoxFit.cover}) {
    return (() {
      if (imgModel == null) return Container();
      switch (imgModel.type) {
        case "url":
          return CachedNetworkImage(
            // color: Colors.black,
            colorBlendMode: BlendMode.darken,
            imageUrl: imgModel.url ?? "",
            fit: fit,
            httpHeaders: {
              "Authorization": basicAuthForLocal,
            },
            placeholder: (context, url) => Skelton(height: 200, width: 200),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade100,
              child: Icon(
                Icons.image,
                size: 100,
                color: Colors.grey,
              ),
            ),
          );
        case "bytes":
          return Image.memory(
            imgModel.bytes!,
            fit: fit,
          );
        case "file":
          return Image.file(
            File(imgModel.filePath!),
            fit: fit,
          );
        default:
          return Container(
            color: Colors.grey.shade100,
            child: Icon(
              Icons.image,
              color: Colors.grey,
            ),
          );
      }
    })();
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static saveValToSavedPref(dynamic CURRENT_USER, key, val) async {
    var databaseID = await databaseId(CURRENT_USER);
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs!.setString("$key$databaseID", val);
  }

  static getValFromSavedPref(dynamic CURRENT_USER, key) {
    var databaseID = databaseId(CURRENT_USER);
    var val = prefs!.getString("$key$databaseID") == null ? "" : prefs!.getString("$key$databaseID")!;
    val = nullC(val);
    return val;
  }

  static saveIntToSavedPref(dynamic CURRENT_USER, key, val) async {
    var databaseID = await databaseId(CURRENT_USER);
    prefs!.setInt("$key$databaseID", val);
  }

  static getIntFromSavedPref(dynamic CURRENT_USER, key) {
    var databaseID = databaseId(CURRENT_USER);
    var val = prefs!.getInt("$key$databaseID") == null ? "" : prefs!.getInt("$key$databaseID")!;
    val = nullC(val);
    return val;
  }

  static Future<dynamic> Navi(BuildContext context, screen) async {
    try {
      return await Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> showEntryDialog(context, dynamic ctrltext, title) async {
    var ctrlDno = TextEditingController(text: ctrltext);
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: TextFormField(
        maxLines: 3,
        autofocus: true,
        controller: ctrlDno,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(label: Text("$title")),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            ctrltext = ctrlDno.text;
            Navigator.pop(context, ctrltext);
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show(context);
    return ctrltext;
  }

  static toast(title, {required context}) {
    // EasyLoading.showToast(title);
    snakeBar(context, title);
  }

  static Future<dynamic> goToHome(navVal, BuildContext context, dynamic UserObj) async {
    navVal = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirebaseSupUserEnter(UserObj: UserObj),
        ));
    return navVal;
  }

  static Future<void> showMyDialog(context, title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showMyDialogExit(context, title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static sendFileEmail(email, filePath, subj, msg) async {
    var platformResponse = "";
    final MailOptions mailOptions = MailOptions(
      body: '$msg',
      subject: '$subj',
      recipients: ['$email'],
      isHTML: false,
      // bccRecipients: ['other@example.com'],
      // ccRecipients: ['third@example.com'],
      attachments: [
        '$filePath',
      ],
    );

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    switch (response) {
      case MailerResponse.saved:

        /// ios only
        platformResponse = 'mail was saved to draft';
        break;
      case MailerResponse.sent:

        /// ios only
        platformResponse = 'mail was sent';
        break;
      case MailerResponse.cancelled:

        /// ios only
        platformResponse = 'mail was cancelled';
        break;
      case MailerResponse.android:
        platformResponse = 'intent was successful';
        break;
      default:
        platformResponse = 'unknown';
        break;
    }
  }

  static Future<File?> downLoadFile(String url, String name) async {
    File? file = null;
    final appStorage = await getApplicationDocumentsDirectory();
    file = await File("${appStorage.path}/$name");
    try {
      var response = await Dio().get(url, onReceiveProgress: (count, total) {
        var progressbar = ((count / total) * 100);
      },
          options: Options(
            responseType: ResponseType.bytes,
          ));
      if (response.statusCode == 200) {
        final raf = await file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
      }
    } catch (e) {
      file = null;
    }

    return file;
  }

  static Future<Uint8List?> downLoadBytes(String url) async {
    Uint8List? fileBytes;
    try {
      var response = await Dio().get(url, onReceiveProgress: (count, total) {
        var progressbar = ((count / total) * 100);
        print('Progress: $progressbar%');
      },
          options: Options(
            responseType: ResponseType.bytes, // Get response as bytes
          ));

      if (response.statusCode == 200) {
        fileBytes = response.data; // Response data is already Uint8List
      }
    } catch (e) {
      print('Download failed: $e');
      fileBytes = null;
    }
    return fileBytes;
  }

  static domainVerifyApi() {
    var domainVerifyApi = getCurrentApi();
    if (firebaseCurrntSupUserObj["domainApi"] != null && firebaseCurrntSupUserObj["domainApi"] != "") {
      domainVerifyApi = firebaseCurrntSupUserObj["domainApi"];
    }
    return domainVerifyApi;
  }

  static getCurrentApi() {
    DateTime date1 = DateTime.now();
    DateTime date2 = DateTime(2023, 03, 31);
    var retVal = "https://aashaimpex.com";
    // if (date1.isAfter(date2)) {
    // }
    retVal = firebSoftwraesInfo["server"] ?? retVal;
    return retVal;
  }

  static void gotoIosPermissionDenied(BuildContext context, List CURRENT_USER) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IosDenied(CURRENT_USER: CURRENT_USER),
        ));
  }

  static String? getUrlParams(url, key) {
    String codeParam = "";
    Uri uri = new Uri.dataFromString(url);
    Map<String, String> params = uri.queryParameters;
    codeParam = params[key] ?? "";
    return codeParam;
  }

  static Future<File> cacheFilebyUrl(url) async {
    final BaseCacheManager baseCacheManager = DefaultCacheManager();
    var file = await baseCacheManager.getSingleFile(url);
    return file;
  }

  static dateFormate(date) {
    if (date == null || date == "") {
      return "";
    }
    try {
      final DateTime now = DateTime.parse(date);
      // final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
      final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
      final String formatted = formatter.format(now);
      return formatted;
    } catch (e) {
      return "";
    }
  }

  static datetimeFormateFromMilli(millisecondsSinceEpoch, {format = "dd-MM-yyyy hh:mm a"}) {
    if (millisecondsSinceEpoch == null || millisecondsSinceEpoch == "") {
      return "";
    }

    try {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse("${millisecondsSinceEpoch}"));
      String formattedDate = DateFormat(format).format(date);
      return formattedDate;
    } catch (e) {
      return "";
    }
  }

  static dateFormateYYYYMMDD(date, {formate = 'yyyy-MM-dd'}) {
    if (date == null || date == "" || date == "null") {
      return "";
    }
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat(formate);
    try {
      final String formatted = formatter.format(dateTime);
      return formatted;
    } catch (e) {
      return "";
    }
  }

  static dateFormateInDDMMYYYY(date) {
    if (date == null || date == "") {
      return "";
    }
    final DateTime now = DateTime.parse(date);
    // final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    return formatted;
  }

  static Future<File> editFile(context, {required ProductModel QUL_OBJ}) async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    var dt = DateTime.now();
    String datetime = dt.toString();
    var path = "${tempDir.path}/";
    if (!Directory(path).existsSync()) {
      Directory(path).createSync();
    }
    File nfile = await File("$path$datetime.png").create();
    var p = QUL_OBJ.cacheFilePath;
    var file = await File("${QUL_OBJ.cacheFilePath}");
    final pdf = await pw.Document();
    final buildedImage = await buildPDFImageClass.buildPDFImage(QUL_OBJ: QUL_OBJ);
    pdf.addPage(pw.Page(
        margin: pw.EdgeInsets.all(0),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: buildedImage);
        })); // Page

    var readyPDF = await pdf.save();

    var page = await pp.Printing.raster(readyPDF, pages: [0], dpi: PdfPageFormat.inch);
    // //print(await page.toPng());
    await for (var page in pp.Printing.raster(readyPDF, pages: [0], dpi: PdfPageFormat.inch)) {
      var image = await page.toPng();
      await nfile.writeAsBytes(image);
    }
    try {} catch (e) {
      //print(e);
    }
    return nfile;
  }

  static reNameFile(context, {required ProductModel QUL_OBJ}) async {
    final file = await buildPDFImageClass.rename(QUL_OBJ: QUL_OBJ);
    return file;
  }

  static String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    return path.split('/').last;
  }

  static Future<int> findFreePort() async {
    int? localSavedPort = await prefs!.getInt("localSavedPort");

    if (localSavedPort == null) {
      try {
        final serverSocket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
        localSavedPort = serverSocket.port;
        await prefs!.setInt("localSavedPort", localSavedPort);
        await serverSocket.close();
        boolPortChanged = true;
      } catch (e) {
        // Handle the exception if needed
      }
    }
    return localSavedPort ?? 8080;
  }

  // static void syncAlert(context, UserObj) {
  //   if (boolPortChanged) {
  //     Future.delayed(Duration.zero, () {
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("अपडेट Alert", style: TextStyle(color: Colors.red)),
  //             content: Text("साल 22-23 और 23-24 को दोबारा से sync करें फिर दोबारा App को रीस्टार्ट करें"),
  //             actions: <Widget>[
  //               ElevatedButton(
  //                   onPressed: () async {
  //                     Navigator.pop(context);
  //                     List currentYears = jsonDecode(UserObj['year']);
  //                     UserObj["Curentyearforlocalstorage"] = currentYears[0].toString().replaceAll("-", "");

  //                     var year = currentYears[1];
  //                     var yearVal = year.toString().replaceAll("-", "");
  //                     UserObj["yearSelected"] = yearVal;
  //                     UserObj["yearVal"] = year;
  //                     UserObj["FILE_NAME"] = Myf.getFileNameYear(yearVal: yearVal, currentYears: currentYears);
  //                     await Navigator.push(context, MaterialPageRoute(builder: (context) => SyncScreen(CURRENT_USER: UserObj)));

  //                     year = currentYears[0];
  //                     yearVal = year.toString().replaceAll("-", "");
  //                     UserObj["yearSelected"] = yearVal;
  //                     UserObj["yearVal"] = year;
  //                     UserObj["FILE_NAME"] = Myf.getFileNameYear(yearVal: yearVal, currentYears: currentYears);
  //                     lastUpdateDateControl.sink.add("event");
  //                     // UserObj["privateNetWorkSync"] = 'false';
  //                     // firebaseCurrntUserObj["autoSync"] = true;
  //                     // Navigator.push(context, MaterialPageRoute(builder: (context) => SyncScreen(CURRENT_USER: UserObj)));
  //                     // await Future.delayed(Duration(seconds: 2));
  //                     // Navigator.pop(context);
  //                     boolPortChanged = false;
  //                   },
  //                   child: Text("OK"))
  //             ],
  //           );
  //         },
  //       );
  //     });
  //   }
  // }

  static Future<VersionStatus?> checkNewVersion(context) async {
    try {
      final newVersion = NewVersionPlus(androidId: "$androidId", iOSAppStoreCountry: "91", iOSId: "$IosId");
      VersionStatus? newVersionStatus = (await newVersion.getVersionStatus()) ?? null;
      prefs!.setBool("checkForAppUpdate", true);
      return newVersionStatus;
      // newVersion.showAlertIfNecessary(context: context, launchModeVersion: LaunchModeVersion.external);
    } catch (e) {}
    return null;
  }

  static startServerSync(context, {required UserObj}) async {
    var privateNetWorkSync = "false";
    UserObj["privateNetWorkSync"] = privateNetWorkSync;
    firebaseCurrntUserObj["autoSync"] = true;

    await Myf.Navi(context, SyncScreen(CURRENT_USER: UserObj));
    // return Myf.popScreen(context);
  }

  static startMyComputerSync(context, {required UserObj, setLastUpdateDate}) async {
    firebaseCurrntUserObj["autoSync"] = true;
    Myf.saveValToSavedPref(UserObj, "privateNetworkIp", ipController.text);
    if (mycomputerSyncAccess == true) {
      var privateNetWorkSync = "true";
      UserObj["privateNetWorkSync"] = privateNetWorkSync;
    } else {
      var privateNetWorkSync = "false";
      UserObj["privateNetWorkSync"] = privateNetWorkSync;
    }
    await Myf.Navi(context, SyncScreen(CURRENT_USER: UserObj));
  }

  static popScreen(context) async {
    if (context.mounted) {
      Navigator.pop(context);
    } else {
      // Handle the error or show an error message
    }
  }

  static getFileNameYear({yearVal, currentYears}) {
    var v = yearVal == currentYears[0] ? "CURRENT_YEAR" : "LAST_YEAR";
    return v;
  }

  static Future<String?> saveMediaToFireStorage(fileKeyPath, Uint8List data) async {
    try {
      // Get reference to the Firebase Storage bucket
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("$fileKeyPath");
      UploadTask uploadTask = ref.putData(data);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Return the download URL
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static Future<bool> deleteMediaFromFireStorage(fileKeyPath) async {
    try {
      // Get reference to the Firebase Storage bucket
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("$fileKeyPath");
      await ref.delete();

      return true; // Return the download URL
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }

  static Future<Uint8List?> getMediaFromFireStorage(fileKeyPath) async {
    try {
      // Get reference to the Firebase Storage bucket
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("$fileKeyPath");
      Uint8List? data = await ref.getData();
      mediaBox!.put(fileKeyPath, data);
      return data;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static saveOrderToFirestore(List args, context, {required UserObj}) async {
    Myf.showBlurLoading(context);
    var order = args[0];
    var OrderID = order["OrderID"];
    var OrderNo = 1;
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("ORDER")
        .orderBy("BK_DATE", descending: true)
        .limit(1)
        .get()
        .then((value) async {
      var snp = value.docs;
      await Future.wait(snp.map((e) async {
        dynamic d = e.data();
        dynamic value = d["OrderNo"];
        if (value != null && num.tryParse(value.toString()) != null) {
          OrderNo = value + 1;
        } else {
          OrderNo = 1;
        }
      }).toList());
    });
    var dt = await DateTime.now();

    order["OrderNo"] = OrderNo;
    order["cu_time_milli"] = dt.millisecondsSinceEpoch;
    order["r_time"] = dt.millisecondsSinceEpoch.toString();
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("ORDER")
        .doc("${OrderID}")
        .set(order)
        .then((value) {})
        .onError((error, stackTrace) {
      Myf.showMyDialog(context, "error", "$error");
    });
    Navigator.pop(context);
    return order;
  }

  static deleteOrderToFirestore(List args, context, {required UserObj}) async {
    var OrderID = args[0];
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Alert'),
              content: const Text('Aru you sure you want to delete this order'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: const Text('Yes'),
                  onPressed: () async {
                    Myf.showBlurLoading(context);
                    await fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("ORDER").doc(OrderID).delete().then((value) {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  static Future saveLastPdfSentDate(context, MasterModel masterModel) async {
    await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("EMP_MST").doc(masterModel.value).set({
      "partyname": masterModel.partyname,
      "partycode": masterModel.value,
      "lastPdfSent": DateTime.now().toString(),
    }, SetOptions(merge: true));
  }

  static Future<Uint8List?> compressImage(Uint8List? bytes) async {
    var result = await FlutterImageCompress.compressWithList(
      bytes!,
      quality: 88,

      // rotate: 180,
    );

    return await result;
  }

  static Future<Box?> openHiveBox(String boxName) async {
    if (currentHiveBox != null) {
      await currentHiveBox!.close();
    }
    currentHiveBox = await Hive.openBox(boxName);
    return currentHiveBox;
  }

  static Future getMasterObjectFromList({required List ARR, code}) async {
    var A = ARR.where((element) {
      return element["partyname"] == code;
    }).toList();
    return A[0];
  }

  static Future getQulObjectFromListByCode({required List ARR, hashcodeId}) async {
    var A = ARR.where((element) {
      return element["label"].toString().toUpperCase().hashCode == hashcodeId;
    }).toList();
    return A[0];
  }

  static Future getCompMasterObjectFromList({required List ARR, Id}) async {
    var A = ARR.where((element) {
      return element["FIRM"] == Id;
    }).toList();
    return A[0];
  }

  static showSnakeBarOnTop(msg) {
    showSimpleNotification(Text("$msg"), background: Colors.green);
  }

  // static void userDetailsUpdateToFirebase({required firebaseCurrntSupUserObj, required UserObj}) async {
  //   if (!firebaseUserEnterForFirstTimeUpdate) {
  //     Map<String, dynamic> obj = {};
  //     obj["GSTIN"] = UserObj["GSTIN"];
  //     obj["CLIENTNO"] = UserObj["CLIENTNO"];
  //     obj["customerDBname"] = UserObj["customerDBname"];
  //     obj["ORDERFORM_ENABLE"] = UserObj["ORDERFORM_ENABLE"];
  //     obj["PAY"] = UserObj["PAY"];
  //     obj["Activetiondate"] = UserObj["Activetiondate"];
  //     obj["expiryDays"] = UserObj["expiryDays"];
  //     obj["http"] = UserObj["http"];
  //     obj["android"] = UserObj["android"];
  //     obj["ACTYPE"] = UserObj["ACTYPE"];
  //     obj["SHOPNAME"] = UserObj["SHOPNAME"];

  //     if (UserObj["admin"] == true) {
  //       obj["mobileno_user"] = UserObj["mobileno_user"];
  //       obj["emailadd"] = UserObj["emailadd"];
  //     }
  //     fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).set(obj);
  //     firebaseUserEnterForFirstTimeUpdate = true;
  //   }
  // }

  static Future<void> launchurl(Uri url) async {
    await canLaunchUrl(url) ? await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication) : null;
  }

  static productSyncLocal(context, {UserObj}) async {
    var databaseId = await Myf.databaseIdCurrent(UserObj);
    var dt = await DateTime.now();
    var orderLocalSyncTime =
        Myf.getValFromSavedPref(UserObj, "orderLocalSyncTime") == "" ? "0" : Myf.getValFromSavedPref(UserObj, "orderLocalSyncTime");
    var orderLocalSyncDeleteTime =
        Myf.getValFromSavedPref(UserObj, "orderLocalSyncDeleteTime") == "" ? "0" : Myf.getValFromSavedPref(UserObj, "orderLocalSyncDeleteTime");
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("PRODUCT")
        .where("time", isGreaterThan: orderLocalSyncTime)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        var productBox = await SyncLocalFunction.openBoxCheck("PRODUCT");
        await Future.wait(snp.map((e) async {
          final id = e.id;
          dynamic d = e.data();
          await productBox.put(id, d);
        }).toList());
        await productBox.close();
        orderLocalSyncTime = dt.toString();
        Myf.saveValToSavedPref(UserObj, "orderLocalSyncTime", orderLocalSyncTime);
      }
    });
    await fireBCollection
        .collection("supuser")
        .doc(UserObj["CLIENTNO"])
        .collection("PRODUCT_DELETED")
        .where("time", isGreaterThan: orderLocalSyncDeleteTime)
        .get()
        .then((event) async {
      var snp = event.docs;
      if (snp.length > 0) {
        var productBox = await Hive.openBox("${databaseId}PRODUCT");
        await Future.wait(snp.map((e) async {
          dynamic d = e.data();
          final id = d["P_ID"];
          await productBox.delete(id);
        }).toList());
        await productBox.close();
        orderLocalSyncDeleteTime = dt.toString();
        Myf.saveValToSavedPref(UserObj, "orderLocalSyncDeleteTime", orderLocalSyncDeleteTime);
      }
    });
  }

  static Future<File?> downloadFileFromFirestore(String url, String name) async {
    try {
      Uint8List? fileData = await Myf.downLoadBytes(url);
      if (fileData != null) {
        if (kIsWeb) {
          viewPdf(fileData, fileName: '${name}');
          return null;
        } else {
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/${name}');
          await file.writeAsBytes(fileData);
          return file;
        }
        // You can now work with the fileData as bytes
      } else {
        print('No data found at the given file path.');
        return null;
      }
    } catch (e) {
      print('Download failed: $e');
      return null;
    }
  }

  static checkForRating(context) async {
    var _appClosures = prefs!.getInt('appClosures') ?? 0;
    // var appRatedOnPlayStore = firebaseCurrentUserObj["appRatedOnPlayStore"];
    // if (appRatedOnPlayStore == 1) return;
    if (_appClosures > 4) {
      // if (_appClosures > 4 && !IosPlateForm) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        if (!GLB_CURRENT_USER["login_user"].toString().contains("111")) {
          inAppReview.requestReview();
        }
      }
      _appClosures = 0; // Reset the counter after showing the review prompt
      prefs!.setInt("appClosures", _appClosures);
    } else {
      _appClosures = _appClosures + 1;
      prefs!.setInt("appClosures", _appClosures);
    }
  }

  static getPublicIPAddress() async {
    var url = Uri.parse('https://api.ipify.org?format=json');
    var ipAddress = "";
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        ipAddress = response.body;
        //print('Public IP Address: $ipAddress');
      } else {
        //print('Failed to retrieve public IP address. Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error retrieving public IP address: $e');
    }

    return ipAddress;
  }

  static void savePdfHistoryToFireBase({required UserObj, required taskID, required taskObj}) async {
    var ID = DateTime.now().toString();
    taskObj["ID"] = ID;
    taskObj["TID"] = taskID;
    taskObj["c_time"] = DateTime.now().toString();
    fireBCollection.collection("supuser").doc(UserObj["CLIENTNO"]).collection("autoPdfTask").doc(ID).set(taskObj).then((value) {});
  }

  static restartApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runApp(MyApp());
    });
  }

  static String convertFileToDataUrl(String filePath, String mimeType) {
    // Read file data
    final file = File(filePath);
    final fileData = file.readAsBytesSync();

    // Encode file data using Base64
    final encodedData = base64Encode(fileData);

    // Construct the data URL
    final dataUrl = "data:$mimeType;base64,$encodedData";

    return dataUrl;
  }

  static String getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    // Check if the extension exists in the map
    return extension;
  }

  static noteError(er) {
    //print(er);
    // try {
    //   Map<String, dynamic> obj = {};
    //   var id = DateTime.now().toString();
    //   obj["ID"] = id;
    //   obj["e"] = er.toString();
    //   obj["p"] = firebaseSoftwaresName;
    //   obj["c"] = loginUserModel.cLIENTNO;
    //   fireBCollection.collection("error").doc(id).set(obj);
    // } catch (e) {}
  }

  static MainAppIcon(context) {
    return [
      Image.asset(
        "assets/img/1024.png",
        fit: BoxFit.contain,
        height: 100,
      ),
      SizedBox(height: 10),
      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 50),
          children: <TextSpan>[
            TextSpan(text: 'UNIQUE', style: TextStyle(color: jsmColor, fontSize: 50, fontWeight: FontWeight.bold)),
          ],
        ),
        textScaler: TextScaler.linear(0.5),
      ),
      // Add a line between the texts
      Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        width: 120,
        height: 2,
        color: Colors.black,
      ),
      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 50),
          children: <TextSpan>[
            TextSpan(text: 'Softwares', style: TextStyle(color: Colors.black)),
          ],
        ),
        textScaler: TextScaler.linear(0.5),
      ),
    ];
  }

  static toIntVal(String text) {
    var intVal = 0;
    if (text == null || text == "" || text.contains("null")) {
      text = "0";
    }
    try {
      intVal = double.parse(text).toInt();
      //logger.d(intVal);
    } catch (e) {}
    return intVal;
  }

  static Future<Uint8List> encryptBytes(Uint8List bytes, String encryptionKey, String enciv) async {
    var keyString = encryptionKey;
    var ivString = enciv;

    Uint8List keyData = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
    Uint8List ivData = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));

    final key = enc.Key(keyData);
    final iv = enc.IV(ivData);

    final dataToEncrypt = bytes;

    final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
    final encryptedData = await encrypter.encryptBytes(dataToEncrypt, iv: iv);
    return Uint8List.fromList(encryptedData.bytes);
  }

  static Future<Uint8List> decryptBytes(Uint8List bytes, String encryptionKey, String enciv) async {
    var keyString = encryptionKey;
    var ivString = enciv;

    Uint8List keyData = await Uint8List.fromList(utf8.encode(keyString.substring(0, math.min(16, keyString.length))));
    Uint8List ivData = await Uint8List.fromList(utf8.encode(ivString.substring(0, math.min(16, ivString.length))));

    final key = enc.Key(keyData);
    final iv = enc.IV(ivData);

    // Read the encrypted file into memory
    final encryptedData = bytes;
    // Decrypt the data using the key and IV
    final encrypter = await enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc, padding: "PKCS7"));
    final decryptedData = await encrypter.decryptBytes(enc.Encrypted(encryptedData), iv: iv);
    return Uint8List.fromList(decryptedData);
  }

  static Future<File> saveAsPdf(Uint8List data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName.pdf';
    final file = File(filePath);

    await file.writeAsBytes(data);
    return file;
  }

  static Future<void> copyAllAssetsToDirectory(context, String targetDirectoryPath, int currentTimestamp) async {
    Myf.showBlurLoading(context);
    try {
      final manifestJson = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestJson);

      final List<String> assetPaths = manifest.keys.toList();

      for (final assetPath in assetPaths) {
        if (!assetPath.contains("DS_Store")) {
          ;
          try {
            final ByteData data = await rootBundle.load(assetPath);
            final Uint8List bytes = await data.buffer.asUint8List();
            var stAssetsPath = assetPath.replaceFirst("assets/", "");
            final File targetFile = File('$targetDirectoryPath/$stAssetsPath');

            // Create the target directory if it doesn't exist
            targetFile.parent.createSync(recursive: true);
            // Write the asset data to the target file
            await targetFile.writeAsBytes(bytes);
            //print("Copied: ${targetFile.path}");
          } catch (e) {
            //print('Error copying assets: $e');
          }
        }
      }
      prefs!.setString("loadFirstTimeAssets", "true");
      prefs!.setInt('last_load_timestamp', currentTimestamp);
      //print('All assets copied to $targetDirectoryPath');
    } catch (e) {
      //print('Error copying assets: $e');
    }
    Navigator.pop(context);
  }

  static Map<String, dynamic> convertMapKeysToString(Map<dynamic, dynamic> originalMap) {
    Map<String, dynamic> convertedMap = {};

    originalMap.forEach((key, value) {
      convertedMap[key.toString()] = value;
    });

    return convertedMap;
  }

  static LayoutInfoModel getWidthInfo(BoxConstraints constraints) {
    var maxWidth = constraints.maxWidth;
    var widthIsFor = "";
    var width = maxWidth;
    var height = constraints.maxHeight;

    if (maxWidth >= 1024) {
      widthIsFor = "WEB";
      width = 0.5 * maxWidth; // Half the width for Web layout
    } else if (maxWidth >= 600) {
      widthIsFor = "TAB";
      width = maxWidth; // Full width for Tablet layout
    } else {
      widthIsFor = "MOBILE";
      width = maxWidth; // Full width for Mobile layout
    }
    LayoutInfoModel infoModel = LayoutInfoModel(widthIsFor: widthIsFor, width: width, height: height);
    return infoModel;
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      // Handle the selected date (e.g., update a text field)
      return pickedDate.toLocal();
    }
    return null;
  }

  static double convertToDouble(String? value) {
    if (value == null || value.isEmpty) {
      // Handle the case where the input is null or an empty string
      return 0.0; // You can return a default value or handle it based on your requirements
    }

    try {
      return double.parse(value);
    } catch (e) {
      // Handle the case where the input is not a valid double
      return 0.0; // You can return a default value or handle it based on your requirements
    }
  }

  static void checkForBroadCast(BuildContext context, dynamic UserObj) async {
    var databaseId = await Myf.databaseIdCurrent(UserObj);
    var dt = await DateTime.now();

    var lastBroadcastViewTime = firebaseCurrntUserObj["lastbroadcastViewTime"] ?? firebSoftwraesInfo["lastbroadcastTime"];
    fireBCollection
        .collection("softwares")
        .doc("EMPIRE")
        .collection("broadcast")
        .where("c_time", isGreaterThan: lastBroadcastViewTime)
        .get()
        .then((value) async {
      var snp = value.docs;
      snp.map((e) {
        dynamic d = e.data();
        viewBroadCast(context, d);
      }).toList();
    });
  }

  static void viewBroadCast(context, d) async {
    await NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        "${d["title"]}",
        style: TextStyle(color: Colors.red),
      ),
      content: Text("${d["msg"]}"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ok'))
      ],
    ).show(context);
  }

  static String getLocalHostUrl() {
    var url = 'https://${ipController.text}/${firebaseCurrntSupUserObj["Lfolder"]}';
    if (ipController.text.contains("8098")) {
      url = 'http://${ipController.text}/${firebaseCurrntSupUserObj["Lfolder"]}';
    }
    return url;
  }

  static Future<bool> askForCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      var result = await Permission.camera.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isRestricted || status.isPermanentlyDenied) {
      return false;
    }
    return false;
  }

  static Future<void> getsettings() async {
    try {
      await fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("SETTINGS").doc("EMP_ORDER").get(fireGetOption).then(
        (value) {
          if (value.exists && value != null) {
            dynamic d = value.data();
            empOrderSettingModel = EmpOrderSettingModel.fromJson(Myf.convertMapKeysToString(d));
          } else {
            empOrderSettingModel = EmpOrderSettingModel(
              colorSystemOn: false,
              setsSystemOn: false,
              showRateSelectionOnEntryFormOrder: false,
              showFrmDate: true,
              showPackingSelectionAtBottom: false,
              packingRateAddInProductRate: true,
              frmItmShowSets: false,
              frmItmPcsInSets: false,
              frmItmPacking: true,
              frmItmCut: false,
              frmItmMtr: false,
              frmItmRate: true,
              frmItmRmk: false,
              pdfItmcategory: false,
              pdfItmSets: false,
              pdfItmPacking: true,
              pdfItmCut: false,
              pdfItmRate: true,
              pdfItmRmk: false,
              pdfItmAmt: false,
              pdfPackingAtBottom: false,
              pdfHeaderDetails: true,
              askForSharePdfRate: false,
              photoOnWifi: true,
              pdfProductViewLimit: 15,
            );
          }
        },
      );
    } catch (e) {}
    var firebasecollection = await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("SETTINGS")
        .doc("EMP_ORDER")
        .snapshots()
        .listen((value) async {
      if (value.exists && value != null) {
        dynamic d = await value.data();
        empOrderSettingModel = await EmpOrderSettingModel.fromJson(Myf.convertMapKeysToString(d));
      }
    });
  }

  static askForShareOption(context, billsModel) async {
    final Completer _completer = Completer();
    var pdfRateShow = empOrderSettingModel.pdfItmRate ?? false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Order pdf share with rate?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                empOrderSettingModel.pdfItmRate = false;
                var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context);
                empOrderSettingModel.pdfItmRate = pdfRateShow;
                _completer.complete();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                empOrderSettingModel.pdfItmRate = true;
                var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context);
                empOrderSettingModel.pdfItmRate = pdfRateShow;
                _completer.complete();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
    return _completer.future;
  }

  static Future<void> cacheClear({required context, required CURRENT_USER, required InAppWebViewController? webController}) async {
    await webController!.clearCache();
    showMsgForSync(context: context, CURRENT_USER: CURRENT_USER);
  }

  static yesNoShowDialod(context, {title, msg}) async {
    Completer completer = Completer();

    await NAlertDialog(
      dismissable: false,
      blur: 2,
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(
        "$title",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text("$msg"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                completer.complete(true);
                Navigator.pop(context, true);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.white))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                completer.complete(false);
                Navigator.pop(context, false);
              },
              child: const Text('No', style: TextStyle(color: Colors.white))),
        ),
      ],
    ).show(context);
    return completer.future;
  }

  static showMsgForSync({required context, required CURRENT_USER}) async {
    await NAlertDialog(
      dismissable: false,
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text("Success fully cache cleared"),
      content: Text("Please  Sync again (Current Year)"),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              await Myf.startServerSync(context, UserObj: CURRENT_USER);

              await NAlertDialog(
                dialogStyle: DialogStyle(titleDivider: true),
                title: Text("Do you want to sync Last year"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () async {
                        List currentYears = await jsonIsolate.decode(CURRENT_USER['year']);
                        CURRENT_USER["yearSelected"] = currentYears[1].toString().replaceAll("-", "");
                        CURRENT_USER["yearVal"] = currentYears[1];
                        CURRENT_USER["FILE_NAME"] = Myf.getFileNameYear(yearVal: CURRENT_USER["yearVal"], currentYears: currentYears);
                        await Myf.startServerSync(context, UserObj: CURRENT_USER);
                        popScreen(context);
                        popScreen(context);
                      },
                      child: const Text('Yes'))
                ],
              ).show(context);
            },
            child: const Text('Yes'))
      ],
    ).show(context);
  }

  static FutureBuilder<VersionStatus?> checkForAppUpdate(BuildContext context) {
    return FutureBuilder<VersionStatus?>(
      future: kIsWeb ? null : Myf.checkNewVersion(context),
      builder: (context, snapshot) {
        try {
          if (snapshot.data != null) {
            if (snapshot.data!.canUpdate) {
              VersionStatus? v = snapshot.data;
              return Card(
                  // decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                trailing: Icon(Icons.download),
                title: Text(
                  "App Update Available",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
                children: [
                  ListTile(
                    onTap: () {
                      var link = "${v == null ? "" : v.appStoreLink}";
                      Myf.launchurl(Uri.parse(link));
                    },
                    title: Text("${v == null ? "" : v.originalStoreVersion ?? ""}"),
                    subtitle: Text("${v == null ? "" : v.releaseNotes ?? ""}"),
                    trailing: IconButton(
                        onPressed: () {
                          var link = "${v == null ? "" : v.appStoreLink}";
                          Myf.launchurl(Uri.parse(link));
                        },
                        icon: Icon(Icons.download)),
                  ),
                ],
              ));
            }
          }
        } catch (e) {}
        return SizedBox.shrink();
      },
    );
  }

  static Future<void> savePdfToFile(Uint8List? pdfBytes, {fileName = "example.pdf"}) async {
    if (pdfBytes == null) {
      //print('Error: Uint8List is null');
      return;
    }

    // Get the document directory using path_provider
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    // Combine the document directory path and the filename
    String filePath = '${documentDirectory.path}/$fileName';

    // Write the PDF bytes to a file
    File file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    OpenFilex.open(file.path);
    //print('PDF saved to: $filePath');
  }

  static int daysCalculate(String? dATE, {DateTime? date2}) {
    date2 ??= DateTime.now();
    DateTime? date1 = DateTime.tryParse(dATE!);

    if (date1 != null) {
      // Calculate the difference in days
      Duration difference = date2.difference(date1);
      return difference.inDays;
    } else {
      // Handle the case where the input date is invalid
      return -1; // or any other suitable value or throw an exception
    }
  }

  static String abbreviateName(String fullName) {
    List<String> names = fullName.split(' ');
    String abbreviation = '';

    for (String name in names) {
      abbreviation += name[0];
    }

    return abbreviation.toUpperCase();
  }

  static getCurrentloginUser() {
    var userSplit = GLB_CURRENT_USER["login_user"].toString().split("@");
    return userSplit[0];
  }

  static getUserNameString(String userName) {
    var userSplit = userName.toString().split("@");
    return userSplit[0];
  }

  static qualImgLink(QualModel qualModel) {
    var url = "";
    var qualPath = qualModel.qual_path;
    var host = Myf.getLocalHostUrl();
    if (qualPath != null && qualPath != "") {
      url =
          "${host}/photoLink.php?CL=${loginUserModel.cLIENTNO}&CLDB=${loginUserModel.customerDBname}&p=${Uri.encodeComponent(qualModel.qual_path!)}";
    }
    return url;
  }

  static double getPackingRate(BillDetModel billDetModel) {
    return Myf.convertToDouble(billDetModel.rATE!) + Myf.convertToDouble(billDetModel.packingRate ?? "0.0");
  }

  static Future shareOnlyAndroidWhatsApp(path, mobile) async {
    if (Myf.isAndroid()) {
      final arg = {"path": "$path", "mobile": mobile};
      var name = await AndroidChennal.invokeMethod('share', arg);
    } else {
      SharePlus.instance.share(ShareParams(
        text: "Check this out!",
        title: "Share via WhatsApp",
        files: [XFile(path)],
      ));
    }
  }

  static String mainUrl() {
    var ios_assets_path = firebaseCurrntSupUserObj["ios_assets_path"] ?? "";
    var android_assets_path = firebaseCurrntSupUserObj["android_assets_path"] ?? "";
    String mainurl = kIsWeb
        ? "http://localhost:8887/assets"
        : IosPlateForm
            ? 'file://${myUniqueApp.path}'
            : android_assets_path != null && android_assets_path != ""
                ? android_assets_path
                : "http://localhost:$serverPort/assets"; //"file:///android_asset/flutter_assets/assets" this only for temp next year all user allow on this

    if ((loginUserModel.loginUser.toString().contains("58385") ||
            loginUserModel.loginUser.toString().contains("111") ||
            loginUserModel.loginUser.toString().contains("51035") ||
            loginUserModel.loginUser.toString().contains("100") ||
            loginUserModel.loginUser.toString().contains("prashant3009")) &&
        Myf.isAndroid() == true) {
      mainurl = "http://localhost:$serverPort/assets";
      print("Main url : $mainurl");
    }
    return mainurl;
  }

  static String encryptAesString(String plainText) {
    final keyBytes = encrypt.Key.fromUtf8(dotenv.get('aesKey'));
    final ivBytes = encrypt.IV.fromUtf8(dotenv.get('aesIv'));
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: ivBytes);

    return encrypted.base64;
  }

  static String decryptString(String encryptedText) {
    final keyBytes = encrypt.Key.fromUtf8(dotenv.get('aesKey'));
    final ivBytes = encrypt.IV.fromUtf8(dotenv.get('aesIv'));
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: ivBytes);

    return decrypted;
  }

  static Future<PlatformFile?> pickImageInBytes({fileType = FileType.image, allowMultiple = false, allowedExtensions}) async {
    if (kIsWeb) {
    } else {
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          return null;
        }
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions ?? null,
    );

    if (result != null) {
      // result.files.single
      return result.files.single;
    }
    return null;
  }

  static getOnlineTimeInMili(CURRENT_USER) {
    String FILE_NAME = CURRENT_USER["FILE_NAME"];
    String onlineTimeInMili = "0"; // Initialize with a default value

    if (firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"] != null && firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"] != "") {
      onlineTimeInMili = "${firebaseCurrntSupUserObj["${FILE_NAME}_CREATETIME_MILLI"]}";
      onlineTimeInMili = onlineTimeInMili == "null" || onlineTimeInMili == "" ? "0" : onlineTimeInMili;
    }
    return onlineTimeInMili;
  }

  static Future<bool> checkBioMetricIsAvailable() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<void> authenticate(BuildContext context, {required UserObj}) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available on web!')),
      );
      return;
    }
    var isAvailable = await Myf.checkBioMetricIsAvailable();
    if (!isAvailable) {
      return;
    }
    final bool didAuthenticate = await LocalAuthentication()
        .authenticate(
      localizedReason: 'Please authenticate to access the app',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
        useErrorDialogs: true,
      ),
    )
        .catchError((e) {
      if (e == auth_error.lockedOut) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Too many failed attempts!')),
        );
      } else if (e == auth_error.notAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed!')),
        );
      }
      return false; // Ensure a boolean value is returned
    });
    if (didAuthenticate) {
      var navVal;
      Navigator.popUntil(context, (route) => route.isFirst);
      Myf.goToHome(navVal, context, UserObj);
      // Navigate to the next screen or perform the action
    }
  }

  static getBasicAuthForLocal() {
    // print(loginUserModel.api);
    // print("${loginUserModel.ltoken}${loginUserModel.bearer}");
    return 'Basic ' + base64Encode(utf8.encode('${loginUserModel.api}:${loginUserModel.ltoken}'));
  }

  static Future<File?> saveFileFromBytes(Uint8List bytes, {String? name}) async {
    if (name == null) return null;
    final Directory? directory = await getApplicationCacheDirectory();
    final String filePath = '${directory?.path}/$name';
    final File file = File(filePath);
    return await file.writeAsBytes(bytes);
  }

  static Future<bool?> connectionCheckPrivateNetwork() async {
    var host = Myf.getLocalHostUrl();
    var basicAuthForLocal = Myf.getBasicAuthForLocal();
    var url = Uri.parse("${host}/GP/connectionCheck.php");
    try {
      final dio = Dio();
      final response = await dio.post(
        url.toString(),
        options: Options(
          headers: {"Authorization": basicAuthForLocal},
          responseType: ResponseType.json,
        ),
      );
      if (response.statusCode == 200) {
        var responseData = response.data;
        return responseData["status"] == "success";
      } else {
        return false;
      }
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  static Future<void> disableFirebasePersistence() async {
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    print("🔥 Firestore persistence disabled");
  }

  /// Enable persistence (default caching)
  static Future<void> enableFirebasePersistence() async {
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    print("🔥 Firestore persistence enabled");
  }
}

String privateNetworkIp = Myf.getPrivateNetWorkIp(GLB_CURRENT_USER);
