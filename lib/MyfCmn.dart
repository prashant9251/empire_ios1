// // ignore_for_file: file_names, non_constant_identifier_names, avoid_print, unused_local_variable, unnecessary_null_comparison

// import 'dart:convert';
// // import 'dart:io' as io;
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/demoExpired.dart';
// import 'package:empire_ios/screen/EMPIRE/urlData.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:ndialog/ndialog.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:share/share.dart';

// import 'IosDenied.dart';
// import 'main.dart';

// class CMN {
//   final value = NumberFormat.currency(locale: 'en_IN');
//   late BuildContext mcontext;
//   currency(val) {
//     return value.format(val);
//   }

//   toFix(val) {
//     val = double.parse(val);
//     return val.toStringAsFixed(2);
//   }

//   Future<void> inital(BuildContext context) async {
//     mcontext = context;
//   }

//   Future<String?> getStr(key) async {
//     return prefs.getString(key);
//   }

//   static nullC(val) {
//     if (val == null) {
//       return "";
//     } else {
//       return val;
//     }
//   }

//   dateF(date) {
//     return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
//   }

//   Future<bool> printing(html) async {
//     await Printing.layoutPdf(
//         dynamicLayout: true,
//         format: PdfPageFormat.a3,
//         onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
//               format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
//               html: html.toString(),
//             ));
//     return true;
//   }

//   Future<bool> printingA4(html) async {
//     await Printing.layoutPdf(
//         dynamicLayout: true,
//         format: PdfPageFormat.a4,
//         onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
//               format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
//               html: html.toString(),
//             ));
//     return true;
//   }

//   Future<List<dynamic>> getListByKey(SharedPreferences pref, key) async {
//     String? Data = pref.getString(key);
//     var List = await jsonDecode(Data!);
//     if (List.length > 0) {
//       return List;
//     } else {
//       return [];
//     }
//   }

// //-----create pdf call
//   Future<bool> createPdfhtml(BuildContext context, htmlContent, Name) async {
//     ProgressDialog progressDialog = ProgressDialog(context, title: null, message: null);
//     // progressDialog.setTitle(Text('$htmlContent'));
//     progressDialog.setMessage(const Text('Please wait'));
//     progressDialog.show();

//     if (Platform.isAndroid) {
//       var status = await Permission.storage.status;
//       if (status.isGranted) {
//         //print("--granted");
//       } else if (status.isDenied) {
//         //print("--denied");
//         await Permission.storage.request();
//         return false;
//       }
//       final directory = await getTemporaryDirectory();
//       final filepath = directory.path;
//       final file = File("$filepath/$Name.pdf");
//       await deleteFile(file);
//       progressDialog.dismiss();

//       var pdf = await Printing.convertHtml(
//         baseUrl: "",
//         format: PdfPageFormat.standard,
//         html: await htmlContent,
//       );
//       await file.writeAsBytes(pdf.buffer.asUint8List());
//       progressDialog.dismiss();
//       await Share.shareFiles([file.path]);
//     } else if (Platform.isIOS) {
//       final directory = await getApplicationDocumentsDirectory();
//       String filepath = directory.path;
//       //print(filepath);
//       final file = File("$filepath/$Name.pdf");
//       await deleteFile(file);
//       var pdf = await Printing.convertHtml(
//         format: PdfPageFormat.a3,
//         html: await htmlContent,
//       );
//       await file.writeAsBytes(pdf.buffer.asUint8List());
//       progressDialog.dismiss();
//       await Share.shareFiles([file.path]);
//     }
//     // printingPageAndView(htmlContent, "xyz");
//     return true;
//   }

//   printingPageAndView(htmlContent, Name) async {
//     var printed = await Printing.layoutPdf(
//         dynamicLayout: true,
//         format: PdfPageFormat.a3,
//         onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
//               format: format.copyWith(marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0),
//               html: await htmlContent,
//             ));
//   }

//   Future<void> deleteFile(File file) async {
//     try {
//       if (await file.exists()) {
//         await file.delete();
//       }
//     } catch (e) {
//       // Error in getting access to the file.
//     }
//   }

//   showMsg(BuildContext context, title, msg) async {
//     await NAlertDialog(
//       dialogStyle: DialogStyle(titleDivider: true),
//       title: Text(title),
//       content: Text(msg),
//       actions: <Widget>[
//         TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('ok'))
//       ],
//     ).show(context);
//   }

//   Future checkPermission(BuildContext context) async {
//     var status = await Permission.storage.status;
//     if (status.isGranted) {
//       //print("--granted");
//     } else if (status.isDenied) {
//       //print("--denied");
//     } else {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) => CupertinoAlertDialog(
//                 title: const Text('Camera Permission'),
//                 content: const Text('This app needs camera access to take pictures for upload user profile photo'),
//                 actions: <Widget>[
//                   CupertinoDialogAction(
//                     child: const Text('Deny'),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                   CupertinoDialogAction(
//                     child: const Text('Settings'),
//                     onPressed: () => openAppSettings(),
//                   ),
//                 ],
//               ));
//     }
//   }

//   static pop(BuildContext context) {
//     Navigator.pop(context);
//   }

//   Future gotohome(BuildContext context) async {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//   }

//   Future<String?> getId() async {
//     var deviceInfo = DeviceInfoPlugin();
//     if (Platform.isIOS) {
//       // import 'dart:io'
//       var iosDeviceInfo = await deviceInfo.iosInfo;
//       return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
//     } else {
//       var androidDeviceInfo = await deviceInfo.androidInfo;
//       return androidDeviceInfo.id; // Unique ID on Android
//     }
//   }

//   static Future<bool> SaveToLocal(args) async {
//     var key = await args[0];
//     var value = await args[1];
//     //print(key);
//     // //print(value);
//     var save = await prefs.setString(key, value);
//     return save;
//   }

//   static Future<String?> GetFromLocal(args) async {
//     var key = await args[0];
//     //print("=========$key");
//     var value = await prefs.getString(key);
//     value = await value == null || value == "" ? "[]" : value;
//     return value;
//   }

//   Future<void> logout(BuildContext context, encClDb, login_user, NavClose) async {
//     late ProgressDialog progressDialog = ProgressDialog(
//       context,
//       message: null,
//       title: null,
//     );
//     progressDialog.setTitle(const Text("Loading"));
//     progressDialog.setMessage(const Text("Please wait"));
//     progressDialog.show();
//     var DID = await getId();
//     var loginUrl = "http://aashaimpex.com/LOGINIOS/mlogout.php?LINE1=$DID&encClDb=$encClDb&login_user=$login_user";
//     //print(loginUrl);
//     var res = '[]';
//     try {
//       var url = Uri.parse(loginUrl);
//       var response = await http.get(url);
//       res = (response.body);
//       if (res.contains("logout")) {
//         await logoutremoveUser(encClDb);
//       }
//       progressDialog.dismiss();
//       if (NavClose != "") {
//         Navigator.pop(context);
//         Navigator.of(context).pop("AccountRemove");
//       } else {
//         Navigator.of(context).pop("AccountRemove");
//       }
//       // //print(loginUrl);
//     } catch (e) {}
//   }

//   Future<bool> logoutremoveUser(encClDb) async {
//     bool foundUser = false;
//     var AccountUser = prefs.getString("AccountUser");
//     AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
//     List AccountUserList = jsonDecode(AccountUser);
//     for (var i = 0; i < AccountUserList.length; i++) {
//       var customerDBname = AccountUserList[i]['0']['customerDBname'];
//       if (customerDBname == encClDb) {
//         foundUser = true;
//         AccountUserList.removeWhere((item) => item['0']['customerDBname'] == customerDBname);
//       }
//     }
//     prefs.setString("AccountUser", jsonEncode(AccountUserList));
//     return foundUser;
//   }

//   Future setCookies(key, value) async {
//     final expiresDate = DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
//     final url = Uri.parse(urldata().gotoSettings);
//     CookieManager cookieManager = CookieManager.instance();
//     await cookieManager.setCookie(
//       url: url,
//       name: key,
//       value: value,
//       domain: urldata.syncDataUrlDomain,
//       expiresDate: expiresDate,
//       isSecure: true,
//     );
//   }

//   Future<void> getCurrentYearApi(BuildContext context) async {
//     var res = [];
//     try {
//       var url = Uri.parse(urldata.yearArrayUrl);
//       var response = await Dio().get(urldata.yearArrayUrl);
//       if (response.statusCode == 200) {
//         res = (response.data);
//         // List resUser = jsonDecode(res);
//         if (res.length > 0) {
//           //print(res);
//           prefs.setString("currentYears", jsonEncode(res));
//         }
//       }
//       // //print(loginUrl);
//     } catch (e) {}
//   }

//   Future<String> getCss(url) async {
//     var css = "";
//     if (url.indexOf('AJX') > -1) {
//       css = await rootBundle.loadString('assets/uniquesoftwares/css/style.css');
//     }
//     return css;
//   }

//   Future saveToAccountList(BuildContext context, List AccountUserList, resJson) async {
//     bool foundUser = false;
//     for (var i = 0; i < AccountUserList.length; i++) {
//       var userID = AccountUserList[i]['userID'];
//       if (userID == resJson['userID']) {
//         foundUser = true;
//         var DID = getId();
//         AccountUserList.forEach((item) {
//           if (item['userID'] == userID) {
//             return item["0"] = resJson["0"];
//           }
//         });
//       }
//     }
//     // if ((!foundUser || AccountUserList.isEmpty)) {
//     //   //print("${resJson['userID']}$foundUser");
//     //   AccountUserList.add(resJson);
//     // }
//     // //print('----Login${jsonEncode(AccountUserList)}');

//     prefs.setString("AccountUser", jsonEncode(AccountUserList));
//   }

//   Future logoutToAccountList(BuildContext context, List AccountUserList, resJson, prUserRemove) async {
//     bool foundUser = false;
//     for (var i = 0; i < AccountUserList.length; i++) {
//       var userID = AccountUserList[i]['userID'];
//       if (userID == resJson['userID']) {
//         foundUser = true;
//         logout(context, AccountUserList[i]['0']['customerDBname'], AccountUserList[i]['0']['login_user'], "AccountRemove");
//         AccountUserList.removeWhere((item) => item['userID'] == userID);
//       }
//     }
//     prefs.setString("AccountUser", jsonEncode(AccountUserList));
//   }

//   // Future<void> verify(BuildContext context, dynamic UserObj) async {
//   //   var deviceId = await getId();
//   //   var userGstin = UserObj["GSTIN"];
//   //   var email = UserObj["emailadd"];
//   //   var mobileNo = UserObj["mobileno_user"];
//   //   var OTP = UserObj["CUOTP"];
//   //   var loginUrl =
//   //       "${urldata.syncDataUrlDomain}/LOGINIOS/appLoginVerification.php?userGstin=$userGstin&email=$email&mobileNo=$mobileNo&OTP=$OTP&DID=$deviceId";
//   //   // //print('----$loginUrl');
//   //   var res = '[]';
//   //   try {
//   //     var url = Uri.parse(loginUrl);
//   //     var response = await http.get(url);
//   //     if (response.statusCode == 200) {
//   //       res = (response.body);
//   //       var AccountUser = prefs.getString("AccountUser");
//   //       AccountUser = AccountUser == null || AccountUser == "" ? "[]" : AccountUser;
//   //       List AccountUserList = jsonDecode(AccountUser);
//   //       if (res != null) {
//   //         var resJson = jsonDecode(res);
//   //         var user = resJson['user'];
//   //         if (user == "valid") {
//   //           var OTP = resJson['OTP'];
//   //           if (OTP == "verify") {
//   //             await saveToAccountList(context, AccountUserList, resJson);
//   //           } else {
//   //             await logoutToAccountList(context, AccountUserList, resJson, true);
//   //           }
//   //         } else {
//   //           resJson["userID"] = UserObj["ID"];
//   //           await logoutToAccountList(context, AccountUserList, resJson, true);
//   //         }
//   //       } else {
//   //         //print("User Not Valid");
//   //       }
//   //     }
//   //   } catch (e) {}
//   // }

//   void gotoExpiredPage(BuildContext context, dynamic CURRENT_USER) {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DemoExpired(UserObj: CURRENT_USER),
//         ));
//   }

//   void gotoIosPermissionDenied(BuildContext context, List CURRENT_USER) {
//     Navigator.of(context).popUntil((route) => route.isFirst);
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => IosDenied(CURRENT_USER: CURRENT_USER),
//         ));
//   }

//   static snakeBar(BuildContext context, msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//     ));
//   }

//   static databaseId(dynamic CURRENT_USER) {
//     var extraPath = CURRENT_USER["extraPathSelected"] != null ? CURRENT_USER["extraPathSelected"] : "";
//     var year = CURRENT_USER["yearSelected"] != null ? CURRENT_USER["yearSelected"] : "";
//     var databaseID = "${CURRENT_USER["customerDBname"]}$extraPath$year";
//     return databaseID;
//   }

//   static saveValToSavedPref(dynamic CURRENT_USER, key, val) {
//     var databaseID = databaseId(CURRENT_USER);
//     prefs.setString("$key$databaseID", val);
//   }

//   static getValFromSavedPref(dynamic CURRENT_USER, key) {
//     var databaseID = databaseId(CURRENT_USER);
//     var val = prefs.getString("$key$databaseID") == null ? "" : prefs.getString("$key$databaseID")!;
//     val = nullC(val);
//     return val;
//   }

//   String getPrivateNetWorkIp(CURRENT_USER) {
//     var databaseID = databaseId(CURRENT_USER);
//     var privateNetworkIp = prefs.getString("privateNetworkIp$databaseID") == null ? "" : prefs.getString("privateNetworkIp$databaseID")!;
//     privateNetworkIp = privateNetworkIp == "" ? CURRENT_USER['privateNetworkIp'] : privateNetworkIp;
//     privateNetworkIp = nullC(privateNetworkIp);
//     return privateNetworkIp;
//   }

//   static String? getUrlPerams(url, key) {
//     String codeParam = "";
//     Uri uri = new Uri.dataFromString(url);
//     Map<String, String> params = uri.queryParameters;
//     codeParam = params[key] ?? "";
//     return codeParam;
//   }

//   static getDateInMiliSec(dt) {
//     //print(dt);
//     var dtime = DateFormat('dd-MM-yyyy hh:mm:ss a').parse(dt);
//     var inMilliseconds = dtime.millisecondsSinceEpoch;
//     return inMilliseconds;
//   }

//   static Future shareOnlyAndroidWhatsApp(path, mobile) async {
//     final arg = {"path": "$path", "mobile": mobile};
//     var name = await AndroidChennal.invokeMethod('share', arg);
//     // myf.showMsg(context, "title", name);
//   }

//   static Future<dynamic> Navi(BuildContext context, StatefulWidget screen) {
//     return Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
//   }

//   static Future<void> showMyDialog(context, title, text) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(text),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
