// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:empire_ios/remark/Remark.dart';
import 'package:empire_ios/screen/AgEmpOrderForm/AgEmpOrderForm.dart';
import 'package:empire_ios/screen/AgEmpOrderList/AgEmpOrderList.dart';
import 'package:empire_ios/screen/AgEmpOrderList/cubit/AgEmpOrderListCubit.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/webviewHeadless.dart';
import 'package:empire_ios/screen/EmpBillPdfView/EmpBillPdfView.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/EmpOrderFormProduct.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubit.dart';
import 'package:empire_ios/screen/EmpOrderList/EmpOrderList.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListCubit.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListHome.dart';
import 'package:empire_ios/screen/GatePass/GatePass.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubit.dart';
import 'package:empire_ios/screen/JobCardPanel/JobCardPanel.dart';
import 'package:empire_ios/screen/MasterNew/MasterNew.dart';
import 'package:empire_ios/screen/MasterNew/MasterNewCubit.dart';
import 'package:empire_ios/screen/OrderPhotoCustomers/OrderPhotoCustomers.dart';
import 'package:empire_ios/screen/OutstandingForm/OutstandingForm.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/ProductFirebaseList.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/cubit/ProductFirebaseListCubit.dart';
import 'package:empire_ios/screen/QualityNew/QualityNew.dart';
import 'package:empire_ios/screen/QualityNew/cubit/QualityNewCubit.dart';
import 'package:empire_ios/screen/SaleDispatch/SaleDispatch.dart';
import 'package:empire_ios/screen/SaleDispatch/SaleDispatchCubit.dart';
import 'package:empire_ios/screen/SaleDispatchList/SaleDispatchList.dart';
import 'package:empire_ios/screen/TaskManager/TaskManager.dart';
import 'package:empire_ios/screen/TaskManager/TaskManagerCubit.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueList.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueListCubit.dart';
import 'package:empire_ios/screen/TodaysDueListForm/TodaysDueListForm.dart';
import 'package:empire_ios/screen/WebViewDataModel.dart';
import 'package:empire_ios/screen/WhatsappManager/WhatsappManagerHome/WhatsappManagerHome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/src/charts/common/callbacks.dart';

import '../../../main.dart';
import '../DesktopVersion/desktopWeb.dart';
import '../screen/EMPIRE/webview.dart';

class MainIcon extends StatefulWidget {
  MainIcon({Key? key, this.mainUrl, required this.imgPath, this.name, required this.CURRENT_USER, this.height, this.ID, this.IconWidget})
      : super(key: key);
  var mainUrl;
  var imgPath;
  var name;
  var height;
  var ID;
  var IconWidget;
  dynamic CURRENT_USER;

  @override
  State<MainIcon> createState() => _MainIconState();
  static Future<void> loadUrlInWebView(BuildContext context, mainUrl, CURRENT_USER) async {
    if (IosPlateForm == true) {
      Myf.Navi(context, WebView(mainUrl: mainUrl, CURRENT_USER: CURRENT_USER));
    } else {
      if (loginUserModel.WebViewType.toString().toLowerCase() == "hybrid") {
        Myf.Navi(context, WebView(mainUrl: mainUrl, CURRENT_USER: CURRENT_USER));
        return;
      }
      //-----android native code
      var UrlLinkUser = await Myf.UrlLinkUser(CURRENT_USER, mainUrl);
      var lastUpdatetime = await Myf.getValFromSavedPref(CURRENT_USER, "lastUpdatetime");
      WebViewDataModel webViewDataModel = WebViewDataModel();
      webViewDataModel.lastUpdatetime = lastUpdatetime;
      webViewDataModel.url = mainUrl;
      webViewDataModel.urlLinkUser = UrlLinkUser;
      webViewDataModel.initialScale = int.parse("${fireUserModel.screenZoom}");
      webViewDataModel.minimumFontSize = 8;
      webViewDataModel.databaseID = Myf.databaseId(CURRENT_USER);
      AndroidChennal.invokeMethod("openUrl", webViewDataModel.toJson());
      //-----android native code
    }
  }

  static bool isPermission(ID) {
    var view = false;
    if (ID != null && ID.toString().isNotEmpty) {
      if (firebaseCurrntUserObj["iconPermissionSet"] != null && firebaseCurrntUserObj["iconPermissionSet"] == true) {
        view = false;
        if (firebaseCurrntUserObj["${ID}"] != null) {
          view = firebaseCurrntUserObj["${ID}"];
        }
      } else {
        view = true;
      }
    }
    return view;
  }
}

class _MainIconState extends State<MainIcon> {
  static const platformChannel = MethodChannel('androidToFlutterChannel');
  var view = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    platformChannel.setMethodCallHandler((call) async {
      if (call.method == 'bulkPdfStartCreateShare') {
        //from android call back
        List<dynamic> urlListgetedForBulkPdf = await jsonDecode(call.arguments);
        pdfFileCreatedForBulkPdf = [];
        Myf.Navi(context, HeadLessWebView(CURRENT_USER: widget.CURRENT_USER, urlListCall: urlListgetedForBulkPdf));
        //from android call back
      } else if (call.method == 'pdfGenerateFromHtml') {
        List<dynamic> arg = await jsonDecode(call.arguments);
        var f = await Myf.createPdfhtml(context, (arg[1]), arg[0], true);
        OpenFilex.open(f!.path);
        // await Share.shareXFiles([await XFile(f!.path)]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    view = MainIcon.isPermission(widget.ID);
    return view
        ? kIsWeb && widget.mainUrl.toString().contains("http")
            ? SizedBox.shrink()
            : InkWell(
                onTap: () async {
                  if (widget.ID == "TASK_CRM") {
                    Myf.Navi(context, BlocProvider(create: (context) => TaskManagerCubit(context), child: TaskManager()));
                    return;
                  } else if ((widget.ID == "QUALITY" || widget.ID == "QUALITY CHART") && fireUserModel.qualReportOldStyle == false) {
                    await Myf.Navi(context, BlocProvider(create: (context) => QualityNewCubit(), child: QualityNew()));
                  } else if ((widget.ID == "ADDRESSBOOK" || widget.ID == "ADDRESS BOOK") && fireUserModel.masterReportOldStyle == false) {
                    await Myf.Navi(
                        context,
                        BlocProvider(
                          create: (context) => MasterNewCubit(),
                          child: MasterNew(),
                        ));
                    return;
                  } else if (widget.ID == "JOB_CARD_REPORT") {
                    await Myf.Navi(context, JobCardPanel());
                    return;
                  } else if (widget.ID == "ORDERPHOTO") {
                    await Myf.Navi(context, OrderPhotoCustomers());
                    return;
                  } else if (widget.ID == "SALE_DISPATCH_SYSTEM") {
                    await Myf.Navi(context, SaleDispatchList());
                    return;
                  } else if (widget.ID == "THIS_WEEK_DUE") {
                    Myf.Navi(context, TodaysDueListForm());
                    return;
                  } else if (widget.ID == "WA") {
                    Myf.Navi(context, WhatsappManagerHome());
                    return;
                  } else if (widget.ID.toString().contains("CRM")) {
                    Myf.Navi(context, CrmHome());
                    return;
                  } else if (widget.ID.toString().contains("PRODUCTGALLERY")) {
                    // Myf.Navi(
                    //     context, BlocProvider(create: (context) => ProductFirebaseListCubit(context), child: ProductFirebaseList(UserObj: CURRENT_USER)));
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) => EmpOrderFormProductCubit(context, returnVal: false),
                                child: EmpOrderFormProduct(productList: productList))));
                    return;
                  } else if (widget.ID.toString().contains("EMPIRE_ORDER_LIST")) {
                    if (loginUserModel.softwareName.toString().contains("AGENCY")) {
                      Myf.Navi(
                          context,
                          BlocProvider(
                            create: (context) => AgEmpOrderListCubit(context),
                            child: AgEmpOrderList(),
                          ));
                    } else {
                      Myf.Navi(context, EmpOrderListHome());
                    }
                    return;
                  } else if (widget.ID.toString().contains("GATEPASS")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => GatePassCubit(context),
                            child: GatePass(),
                          ),
                        ));
                    return;
                  } else if (widget.ID.toString().contains("EMPIRE_ORDER")) {
                    if (loginUserModel.softwareName.toString().contains("AGENCY")) {
                      Myf.Navi(context, AgEmpOrderForm());
                    } else {
                      Myf.Navi(
                          context,
                          BlocProvider(
                            create: (context) => EmpOrderFormCubit(context),
                            child: EmpOrderForm(),
                          ));
                    }
                    return;
                  } else {
                    if (kIsWeb) {
                      var UrlLinkUser = await Myf.UrlLinkUser(widget.CURRENT_USER, widget.mainUrl);
                      var finalUrl = "${widget.mainUrl}$UrlLinkUser";
                      Myf.Navi(context, DeskTopWeb(url: "${finalUrl}", UserObj: widget.CURRENT_USER));
                    } else {
                      await MainIcon.loadUrlInWebView(context, widget.mainUrl, widget.CURRENT_USER);
                    }
                  }
                },
                child: Container(
                  height: 135,
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      widget.IconWidget != null
                          ? widget.IconWidget
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(31, 178, 176, 176),
                                  width: 2,
                                ),
                              ),
                              child: Image(
                                image: AssetImage(widget.imgPath),
                                height: 60,
                                width: widget.height != null ? double.parse("${widget.height}") : 100,
                                color: null,
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.center,
                              ),
                            ),
                      // Divider(),
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
        : SizedBox.shrink();
  }
}

class MainTitle extends StatelessWidget {
  MainTitle({Key? key, this.title}) : super(key: key);
  var title;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [jsmColor, Color.fromARGB(255, 41, 102, 90)],
                ),
                border: Border.all(color: HexColor(ColorHex)),
                borderRadius: BorderRadius.circular(20),
                color: HexColor(ColorHex),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
                child: Text(
                  title,
                  style: const TextStyle(
                    letterSpacing: 5,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
  }
}
