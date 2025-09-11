// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/foundation.dart';

class urldata {
  // String UserAgent =
  //     "Mozilla/5.0 (Linux; Android 9; Redmi 6 Pro Build/PKQ1.180917.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/89.0.4389.105 Mobile Safari/537.36";

  String UserAgent =
      "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/119.0.6045.109 Mobile/15E148 Safari/604.1";

  static String syncDataUrlDomain = Myf.domainVerifyApi(); //"https://aashaimpex.com";
  final String Domainurl = "android_asset";

  // static String mainurl = kIsWeb
  //     ? "https://uniqsoftwares.com/app/v1"
  //     : IosPlateForm
  //         ? 'file://${myUniqueApp.path}'
  //         : "http://localhost:$serverPort/assets";
  static var ios_assets_path = firebaseCurrntSupUserObj["ios_assets_path"] ?? "";
  static var android_assets_path = firebaseCurrntSupUserObj["android_assets_path"] ?? "";
  // static String mainurl = kIsWeb
  //     ? "https://uniqsoftwares.com/app/v1"
  //     : IosPlateForm
  //         ? 'file://${myUniqueApp.path}'
  //         : android_assets_path != null && android_assets_path != ""
  //             ? android_assets_path
  //             : "http://localhost:$serverPort/assets"; //"file:///android_asset/flutter_assets/assets" this only for temp next year all user allow on this
  //file:///android_asset/flutter_assets/assets
  // static String mainurl = kIsWeb ? "https://uniqsoftwares.com/app/v1" : ;
  static String mainurl = Myf.mainUrl(); // "http://localhost:$serverPort/assets";

  final String subfolder1 = "/uniquesoftwares";
  final String subuser = "/SUBUSER";
  final String sfolder = "/AC19";
  final String last = "/AC19";
  static String yearVal = "25-26";
  static List defultYears = [yearVal];
  static String yearArrayUrl = "${syncDataUrlDomain}/LOGINIOS/year.json";
  var loginUrl = "${syncDataUrlDomain}/LOGINIOS/appLoginVerification.php";
  static var adminUserListUrl = "${syncDataUrlDomain}/LOGINIOS/adminUserListUrl.php";
  var loginGstVerificationUrl = "${syncDataUrlDomain}/LOGINIOS/appGstLoginVerification.php";
  final String gotoSettings = "${syncDataUrlDomain}/LOGINIOS/settingSelection.php?";
  final String newUserCreateUrlSettings = "${syncDataUrlDomain}/LOGINIOS/newUserByAuth.php?";
  static String deleteUserUrl = "${syncDataUrlDomain}/LOGINIOS/deleteUserFunction.php?";
  final String NewUserCreateApi = "${syncDataUrlDomain}/LOGINIOS/newUserByAuthUserCreate.php?";

  final String purchaseUrl = "$mainurl/uniquesoftwares/PURCHASE_FRMReport.html?ntab=NTAB&";
  final String syncUrl = "$mainurl/uniquesoftwares/jsonSyncToIndexeddb.html?ntab=NTAB";
  final String SaleReportUrl = "$mainurl/uniquesoftwares/ALLSALE_FRMReport.html?ntab=NTAB";
  final String LedgerReportUrl = "$mainurl/uniquesoftwares/LEDGER_FRMReport.html?ntab=NTAB";
  final String PcOrderUrl = "$mainurl/uniquesoftwares/PCORDER_FRMReport.html?ntab=NTAB";
  final String abcAnaliticsUrl = "$mainurl/uniquesoftwares/ABC_ANALITICS_AJXREPORT.html?ntab=NTAB&hideAbleTr=true";
  var OutstandingReportUrl = "$mainurl/uniquesoftwares/OUTSTANDING_FRMReport.html?ntab=NTAB&FORM_TYPE=SALEOUTSTANDING";
  var AccountNoUrl = "$mainurl/uniquesoftwares/COMPMST_FRMReport.html?ntab=NTAB";
  var chartUrl = "$mainurl/uniquesoftwares/chart.html?ntab=NTAB";
  var chartProductUrl = "$mainurl/uniquesoftwares/SaleItemchart.html?ntab=NTAB";
  var headleassWebStringUrl = "$mainurl/uniquesoftwares/headlessSyncWeb.html?ntab=NTAB";

  var UpiPaymentPageUrl = "$mainurl/uniquesoftwares/upi.html?ntab=NTAB";
  var gstinSearchUrl = "$mainurl/uniquesoftwares/gstin_search.html?ntab=NTAB";
  var purchaseOutstandingReportUrl = "$mainurl/uniquesoftwares/OUTSTANDING_FRMReport.html?ntab=NTAB&FORM_TYPE=PURCHASEOUTSTANDING";
  var tdsReportUrl = "$mainurl/uniquesoftwares/TDS_FRMReport.html?ntab=NTAB";
  var AllReportReportUrl = "$mainurl/uniquesoftwares/ALLREPORT_FRMReport.html?ntab=NTAB";
  var BankEntryReportUrl = "$mainurl/uniquesoftwares/bankPassBook_FRMReport.html?ntab=NTAB";
  var findBill = "$mainurl/uniquesoftwares/Billpdf.html?PDFBILLTYPE=findBill";
  var lrPending = "$mainurl/uniquesoftwares/PENDINGLR_FRMReport.html?ntab=NTAB";
  var MillStockReportUrl = "$mainurl/uniquesoftwares/millstock_FRMReport.html?ntab=NTAB";
  var StockInHouse = "$mainurl/uniquesoftwares/PCSSTOCK_FRMReport.html?ntab=NTAB";
  var JobworkReportUrl = "$mainurl/uniquesoftwares/JOBWORK_FRMReport.html?ntab=NTAB";
  var AddressReportUrl = "$mainurl/uniquesoftwares/master.html?ntab=NTAB";
  var BulkPdfBill = "$mainurl/uniquesoftwares/bulkPdfBill.html?ntab=NTAB";
  var QualReportUrl = "$mainurl/uniquesoftwares/QualChart.html?ntab=NTAB";
  var imageManagementUrl = "$mainurl/imagemanagement.html?ntab=NTAB";

  var transportReportUrl = "$mainurl/uniquesoftwares/transport.html?ntab=NTAB";
  var OrderFormReportUrl = "$mainurl/uniquesoftwares/orderForm.html?ntab=NTAB";
  var OrderListReportUrl = "$mainurl/uniquesoftwares/orderFormList_FRM.html?ntab=NTAB";
  var salesItemWiseReportUrl = "$mainurl/uniquesoftwares/ALLSALE_FRMReport.html?ntab=NTAB&itemWiseSaleForm=true";
  var goodsReturnReportUrl = "$mainurl/uniquesoftwares/ALLSALE_FRMReport.html?ntab=NTAB&TypeSearch=P3";
  var salesCommReport = "$mainurl/uniquesoftwares/SALES_COMM_FRMReport.html?ntab=NTAB&TypeSearch=P3";

  static var headLessSync = "$mainurl/uniquesoftwares/headlessSync.html?ntab=NTAB";
}
