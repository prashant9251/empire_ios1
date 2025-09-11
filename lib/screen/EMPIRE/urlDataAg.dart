// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';

class urldataAG {
  String UserAgent =
      "Mozilla/5.0 (Linux; Android 9; Redmi 6 Pro Build/PKQ1.180917.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/89.0.4389.105 Mobile Safari/537.36";
  static String syncDataUrlDomain = "https://aashaimpex.com";
  final String Domainurl = "android_asset";
  // static String mainurl = kIsWeb
  //     ? "https://uniqsoftwares.com/app/v1"
  //     : IosPlateForm
  //         ? 'file://${myUniqueApp.path}'
  //         : "http://localhost:$serverPort/assets";
  static String mainurl = Myf.mainUrl(); // "http://localhost:$serverPort/assets";

  static var ios_assets_path = firebaseCurrntSupUserObj["ios_assets_path"] ?? "";
  static var android_assets_path = firebaseCurrntSupUserObj["android_assets_path"] ?? "";
  // static String mainurl = kIsWeb
  //     ? "https://uniqsoftwares.com/app/v1"
  //     : IosPlateForm
  //         ? 'file://${myUniqueApp.path}'
  //         : android_assets_path != null && android_assets_path != ""
  //             ? android_assets_path
  //             : "http://localhost:$serverPort/assets"; //"file:///android_asset/flutter_assets/assets" this only for temp next year all user allow on this
// file:///android_asset/flutter_assets/assets
  final String subfolder1 = "/agency";
  final String subuser = "/SUBUSER";
  final String sfolder = "/AC19";
  final String last = "/AC19";
  static String yearVal = "22-23";
  static List defultYears = [yearVal];
  static String yearArrayUrl = "https://aashaimpex.com/LOGINIOS/year.json";
  var loginUrl = "https://aashaimpex.com/LOGINIOS/appLoginVerification.php";
  var loginGstVerificationUrl = "https://aashaimpex.com/LOGINIOS/appGstLoginVerification.php";
  final String gotoSettings = "https://aashaimpex.com/LOGINIOS/settingSelection.php?";

  final String purchaseUrl = "$mainurl/agency/PURCHASE_FRMReport.html?ntab=NTAB&";
  final String syncUrl = "$mainurl/agency/jsonSyncToIndexeddb.html?ntab=NTAB";
  final String SaleReportUrl = "$mainurl/agency/ALLSALE_FRMReport.html?ntab=NTAB";
  final String LedgerReportUrl = "$mainurl/agency/LEDGER_FRMReport.html?ntab=NTAB";
  var OutstandingReportUrl = "$mainurl/agency/OUTSTANDING_FRMReport.html?ntab=NTAB";
  var AccountNoUrl = "$mainurl/agency/COMPMST_FRMReport.html?ntab=NTAB";
  var UpiPaymentPageUrl = "$mainurl/agency/upi.html?ntab=NTAB";
  var gstinSearchUrl = "$mainurl/agency/gstin_search.html?ntab=NTAB";
  var purchaseOutstandingReportUrl = "$mainurl/agency/PURCHASEOUTSTANDING_FRMReport.html?ntab=NTAB";
  var commReportUrl = "$mainurl/agency/COMM_FRMReport.html?ntab=NTAB";
  var AllReportReportUrl = "$mainurl/agency/ALLREPORT_FRMReport.html?ntab=NTAB";
  var BankEntryReportUrl = "$mainurl/agency/bankPassBook_FRMReport.html?ntab=NTAB";
  var findBill = "$mainurl/agency/findBill.html?";
  var lrPending = "$mainurl/agency/PENDINGLR_FRMReport.html?ntab=NTAB";
  var MillStockReportUrl = "$mainurl/agency/millstock_FRMReport.html?ntab=NTAB";
  var StockInHouse = "$mainurl/agency/PCSSTOCK_FRMReport.html?ntab=NTAB";
  var JobworkReportUrl = "$mainurl/agency/JOBWORK_FRMReport.html?ntab=NTAB";
  var AddressReportUrl = "$mainurl/agency/master.html?ntab=NTAB";
  var acgroupReportUrl = "$mainurl/agency/acgroup.html?ntab=NTAB";
  var BulkPdfBill = "$mainurl/agency/bulkPdfBill.html?ntab=NTAB";
  var QualReportUrl = "$mainurl/agency/QualChart.html?ntab=NTAB";
  var OrderFormReportUrl = "$mainurl/agency/orderForm.html?ntab=NTAB";
  var OrderListReportUrl = "$mainurl/agency/orderFormList_FRM.html?ntab=NTAB";
  var chartUrl = "$mainurl/agency/chart.html?ntab=NTAB";
  var PcOrderUrl = "$mainurl/agency/PCORDER_FRMReport.html?ntab=NTAB";

  static var headLessSync = "$mainurl/agency/headlessSync.html?ntab=NTAB";
}
