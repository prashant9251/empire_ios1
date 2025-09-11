// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/NotificationService/FirebaseApi.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/screen/DailySaleGraph/DailySaleGraph.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/extraComanIcon.dart';
import 'package:empire_ios/screen/EMPIRE/homedrawer.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/instruction/homeInstruction.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqOfficeSupport.dart';
import 'package:empire_ios/widget/mainScreenIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:ndialog/ndialog.dart';

import '../../SyncData.dart';
import '../../main.dart';
import '../expiries/expCalculation.dart';

class Trading_Home extends ConsumerStatefulWidget {
  Trading_Home({Key? key, required this.CURRENT_USER}) : super(key: key);
  List CURRENT_USER;
  @override
  ConsumerState<Trading_Home> createState() => _Trading_HomeState();
}

class _Trading_HomeState extends ConsumerState<Trading_Home> {
  var databaseId = "";

  var BRANDNAME = "UNIQUE";
  var privateNetworkIp = "";
  var privateNetWorkSync = "";
  var yearVal = urldata.yearVal;
  var year = "";
  var lastUpdatetime = "";

  StreamController<bool> syncReadyStream = StreamController<bool>.broadcast();

  get onChanged => null;
  Map<String, dynamic> extraPathObj = {};
  var extraPathSelected = TextEditingController(text: "");
  StreamController<String> yearValStream = StreamController<String>.broadcast();

  Future<void> getData() async {
    GLB_CURRENT_USER = widget.CURRENT_USER[0];
    //----yearGet--set
    currentYears = urldata.defultYears;
    currentYears = firebaseCurrntSupUserObj['year'] ?? jsonDecode(widget.CURRENT_USER[0]['year']);
    yearVal = (currentYears[0]);
    Myf.checkForRating(context);

    databaseId = await Myf.databaseId(widget.CURRENT_USER[0]);

    //----expiry check
    Map<String, dynamic> expiryObj = await ExpCalculate.expiryStatusForDesktop(widget.CURRENT_USER[0]);
    if (expiryObj["expiry"].toString().contains("Y")) {
      Myf.gotoExpiredPage(context, widget.CURRENT_USER);
    }
    //----ios permission check
    var iosPermission = widget.CURRENT_USER[0]['iosPermission'];
    if (IosPlateForm == true) {
      if (!iosPermission.toString().contains("1")) {
        Myf.gotoIosPermissionDenied(context, widget.CURRENT_USER);
      }
    }

    //----extraPathObj--set
    if (widget.CURRENT_USER[0]['extraPathLIST'] != null && widget.CURRENT_USER[0]['extraPathLIST'] != "") {
      extraPathObj = jsonDecode(widget.CURRENT_USER[0]['extraPathLIST']);
    }
    //----extraPathObj--set
    year = yearVal.replaceAll("-", "");
    await setYear(yearVal);

    // syncReady = true;
    syncReadyStream.sink.add(true);

    // SyncLocalFunction.startSync(context);
    await Myf.getsettings();
    prefs!.setString("GLB_CURRENT_USER", jsonEncode(GLB_CURRENT_USER));
  }

  @override
  void initState() {
    super.initState();

    mycomputerSyncAccess = true;
    loginUserModel = LoginUserModel.fromJson(widget.CURRENT_USER[0]);
    getData();
    Myf.verify(context, widget.CURRENT_USER[0]);
    ExpCalculate.checkExp(widget.CURRENT_USER[0]);
    FirebaseApi().subscribeToTopic(loginUserModel.softwareName.toString().replaceAll(" ", "_"));
    FirebaseApi().subscribeToTopic(loginUserModel.cLIENTNO);
    FirebaseApi().saveTokenToFirebase(loginUserModel);
    basicAuthForLocal = Myf.getBasicAuthForLocal();
    // Myf.checkFornotification(context, widget.CURRENT_USER[0]);
  }

  @override
  Widget build(BuildContext context) {
    GLB_CURRENT_USER = widget.CURRENT_USER[0];
    loginUserModel = LoginUserModel.fromJson(widget.CURRENT_USER[0]);
    print(loginUserModel);
    // var fireUser = ref.watch(userCollectionProvider(widget.CURRENT_USER[0]));
    return LayoutBuilder(builder: (context, constraints) {
      return PopScope(
        onPopInvoked: (didPop) {
          hiveBoxOpenedMap.entries.map((e) async {
            try {
              var b = await Hive.openLazyBox(e.value);
              await b.compact();
              await b.close();
            } catch (e) {}
          }).toList();
          // return didPop;
        },
        child: Scaffold(
          drawer: HomeDrawer(UserObj: widget.CURRENT_USER[0]),
          // endDrawer: Drawer(
          //   child: Remark(UserObj: widget.CURRENT_USER[0]),
          // ),
          appBar: AppBar(
            title: Row(children: [
              Flexible(
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: BackButtonIcon()),
              ),
              Flexible(child: Text(widget.CURRENT_USER[0]["SHOPNAME"].toString().toUpperCase()))
            ]),
            actions: [
              StreamBuilder<String>(
                  stream: yearValStream.stream,
                  builder: (context, snapshot) {
                    return DropdownButton(
                        value: yearVal,
                        hint: Text(yearVal),
                        items: currentYears
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (var val) {
                          if (backgroundSyncInProcess) {
                            Myf.showSnakeBarOnTop("$backgroundSyncInProcessForCompanyYear Syncing in process please wait");
                          } else {
                            backgroundSyncInProcessForCompanyYear = "";
                            setYear(val);
                            syncReadyStream.sink.add(true);
                          }
                        });
                  }),
              TextButton(
                onPressed: () {
                  if (backgroundSyncInProcess) {
                    Myf.showSnakeBarOnTop("$backgroundSyncInProcessForCompanyYear Syncing in process please wait");
                  } else {
                    backgroundSyncInProcessForCompanyYear = "";
                    showSyncDialog(context, widget.CURRENT_USER[0], privateNetWorkSync);
                  }
                },
                child: Text("SYNC", style: TextStyle(color: Colors.white)),
              ),
            ],
            backgroundColor: HexColor(ColorHex),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SftExpStatusMsg(userObj: widget.CURRENT_USER[0]),
                  // SftNotificationMsg(userObj: widget.CURRENT_USER[0]),
                  StreamBuilder<bool>(
                      stream: syncReadyStream.stream,
                      builder: (context, snapshot) {
                        var snp = snapshot.data ?? false;
                        if (snp) {
                          return SyncdataFetch(CURRENT_USER: widget.CURRENT_USER[0]);
                          // return backgroundSyncInProcess ? SizedBox.shrink() : SyncdataFetch(CURRENT_USER: widget.CURRENT_USER[0]);
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                  StreamBuilder(
                      stream: lastUpdateDateControl.stream,
                      builder: (context, snapshot) {
                        var lastUpdatetime = Myf.getValFromSavedPref(widget.CURRENT_USER[0], "lastUpdatetime");
                        return Column(
                          children: [
                            Container(
                              width: screenWidthMobile,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (lastUpdatetime.toString().isEmpty)
                                    Text(
                                      "->ऊपर दिए गए SYNC बटन पे click करें->Server पे click करें",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  else
                                    Text("Last Sync${lastUpdatetime.toString()}")

                                  // Text('Last Sync : ${lastUpdatetime.text}'),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  uniqOfficeSupport(UserObj: widget.CURRENT_USER[0]),
                  HomeScreenInstruction(UserObj: widget.CURRENT_USER[0]),
                  DailySaleGraph(UserObj: widget.CURRENT_USER[0]),
                  ...[
                    if (loginUserModel.gatePassSystem == "1" ||
                        loginUserModel.oRDERFORMENABLE == "1" ||
                        loginUserModel.crmSystem == "1" ||
                        loginUserModel.photoGallerySystem == "1")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainTitle(
                          title: "Empire Options",
                        ),
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,

                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (loginUserModel.gatePassSystem == "1")
                              MainIcon(
                                ID: "GATEPASS",
                                IconWidget: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 60,
                                  color: jsmColor,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "GATE PASS",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.oRDERFORMENABLE == "1")
                              MainIcon(
                                ID: "EMPIRE_ORDER",
                                IconWidget: Icon(
                                  CupertinoIcons.doc_on_clipboard,
                                  size: 60,
                                  color: jsmColor,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "EMPIRE ORDER",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.oRDERFORMENABLE == "1")
                              MainIcon(
                                ID: "EMPIRE_ORDER_LIST",
                                IconWidget: Icon(
                                  CupertinoIcons.list_bullet_below_rectangle,
                                  size: 60,
                                  color: jsmColor,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "EMPIRE ORDER\nLIST",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.crmSystem == "1")
                              MainIcon(
                                ID: "CRM",
                                IconWidget: Icon(
                                  Icons.dashboard_customize_rounded,
                                  size: 60,
                                  color: jsmColor,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "CRM",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.taskCrmManager == "1")
                              MainIcon(
                                ID: "TASK_CRM",
                                IconWidget: Icon(
                                  Icons.dashboard_outlined,
                                  size: 60,
                                  color: jsmColor,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "TASK CRM",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.saleDispatchSystem == "1")
                              MainIcon(
                                ID: "SALE_DISPATCH_SYSTEM",
                                IconWidget: Icon(
                                  Icons.book,
                                  size: 60,
                                  color: Colors.black,
                                ),
                                imgPath: "assets/img/accountno.png",
                                mainUrl: '',
                                name: "SALE DISPATCH",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            if (loginUserModel.photoGallerySystem == "1")
                              MainIcon(
                                ID: "PRODUCTGALLERY",
                                IconWidget: Icon(
                                  CupertinoIcons.photo_on_rectangle,
                                  size: 60,
                                  color: Color(0xffa3155e),
                                ),
                                imgPath: "assets/img/productmanagement.png",
                                mainUrl: '',
                                name: "PHOTO\nGALLERY",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            InDev(
                              inDevUser: widget.CURRENT_USER[0]["login_user"],
                              widget: MainIcon(
                                ID: "WA",
                                IconWidget: Icon(
                                  Icons.share,
                                  size: 60,
                                  color: Color(0xffa3155e),
                                ),
                                imgPath: "assets/img/productmanagement.png",
                                mainUrl: '',
                                name: "WA",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            ),
                            if (loginUserModel.jobCardReportPermission == "1")
                              MainIcon(
                                ID: "JOB_CARD_REPORT",
                                IconWidget: Icon(
                                  Icons.chalet_outlined,
                                  size: 60,
                                  color: Color(0xffa3155e),
                                ),
                                imgPath: "assets/img/productmanagement.png",
                                mainUrl: '',
                                name: "JOB CARD REPORT",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MainTitle(
                      title: "Unique",
                    ),
                  ),
                  if (loginUserModel.premiumType == "1") ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  MainIcon(
                                    ID: "THIS_WEEK_DUE",
                                    IconWidget: Icon(
                                      Icons.today,
                                      size: 60,
                                      color: Color.fromARGB(255, 19, 90, 156),
                                    ),
                                    imgPath: "assets/img/productmanagement.png",
                                    mainUrl: '',
                                    name: "THIS WEEK DUE",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    ID: "ACCOUNTNO",
                                    IconWidget: Icon(
                                      Icons.account_balance_sharp,
                                      size: 60,
                                      color: jsmColor,
                                    ),
                                    imgPath: "assets/img/accountno.png",
                                    mainUrl: urldata().AccountNoUrl,
                                    name: "MY BANK\nACCOUNT NO",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    IconWidget: Icon(
                                      CupertinoIcons.book_fill,
                                      size: 60,
                                      color: Color(0xFF031c72),
                                    ),
                                    ID: "PAYMENTENTRY",
                                    imgPath: "assets/img/paymententry.png",
                                    mainUrl: urldata().BankEntryReportUrl,
                                    name: "PAYMENT ENTRY",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    ID: "LEDGER",
                                    IconWidget: Icon(
                                      Icons.assessment,
                                      size: 60,
                                      color: Color(0xFF69302b),
                                    ),
                                    imgPath: "assets/img/ledger.png",
                                    mainUrl: urldata().LedgerReportUrl,
                                    name: "LEDGER\nREPORT",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    IconWidget: Icon(
                                      Icons.inventory_outlined,
                                      size: 60,
                                      color: jsmColor,
                                    ),
                                    ID: "PC_ORDER",
                                    imgPath: "assets/img/ledger.png",
                                    mainUrl: urldata().PcOrderUrl,
                                    name: "SALES \nORDER",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    IconWidget: Icon(
                                      CupertinoIcons.chart_pie_fill,
                                      size: 60,
                                      color: jsmColor,
                                    ),
                                    ID: "ANALYTICS",
                                    imgPath: "assets/img/ledger.png",
                                    mainUrl: urldata().chartUrl,
                                    name: "ANALYTICS",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                  MainIcon(
                                    IconWidget: Icon(
                                      CupertinoIcons.chart_bar,
                                      size: 60,
                                      color: jsmColor,
                                    ),
                                    ID: "ITEMANALYTICS",
                                    imgPath: "assets/img/ledger.png",
                                    mainUrl: urldata().chartProductUrl,
                                    name: "ITEM\nANALYTICS",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainTitle(
                            title: "Sale",
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,

                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MainIcon(
                                      IconWidget: Icon(
                                        Icons.find_in_page,
                                        size: 60,
                                        color: Color(0xFF3f4eb2),
                                      ),
                                      ID: "FINDBILL",
                                      imgPath: "assets/img/findbill.png",
                                      mainUrl: urldata().findBill,
                                      name: "FIND BILL",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        Icons.library_books_outlined,
                                        size: 60,
                                        color: Color(0xFF691415),
                                      ),
                                      ID: "SALE",
                                      imgPath: "assets/img/sale.png",
                                      mainUrl: urldata().SaleReportUrl,
                                      name: "SALE\nREPORT",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        CupertinoIcons.square_list_fill,
                                        size: 60,
                                        color: Colors.black,
                                      ),
                                      ID: "OUTSTANDING",
                                      imgPath: "assets/img/outstanding.png",
                                      mainUrl: urldata().OutstandingReportUrl,
                                      name: "SALE\nOUTSTANDING",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        CupertinoIcons.list_number,
                                        size: 60,
                                        color: jsmColor,
                                      ),
                                      ID: "LR",
                                      imgPath: "assets/img/lr.png",
                                      mainUrl: urldata().lrPending,
                                      name: "LR PENDING",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        Icons.picture_as_pdf,
                                        size: 60,
                                        color: Colors.blue[900],
                                      ),
                                      ID: "BULKPDFBILL",
                                      imgPath: "assets/img/bulkpdf.png",
                                      mainUrl: urldata().BulkPdfBill,
                                      name: "BULK PDF BILL",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        CupertinoIcons.list_bullet_below_rectangle,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                      ID: "ITEMWISESALE",
                                      imgPath: "assets/img/saleItemwise.png",
                                      mainUrl: urldata().salesItemWiseReportUrl,
                                      name: "ITEM WISE SALE",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Icon(
                                        CupertinoIcons.doc_on_clipboard_fill,
                                        size: 60,
                                        color: Colors.blue.shade900,
                                      ),
                                      ID: "SALESCOMMISSIONREPORT",
                                      imgPath: "assets/img/rg.png",
                                      mainUrl: urldata().salesCommReport,
                                      name: "SALES\nCOMMISSION",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                    MainIcon(
                                      IconWidget: Text(
                                        "G",
                                        style: TextStyle(fontSize: 40, color: jsmColor, fontWeight: FontWeight.bold),
                                      ),
                                      ID: "RETURNGOODS",
                                      imgPath: "assets/img/rg.png",
                                      mainUrl: urldata().goodsReturnReportUrl,
                                      name: "RETURN GOODS",
                                      CURRENT_USER: widget.CURRENT_USER[0],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainTitle(
                            title: "Purchase",
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,

                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.purchased_circle_fill,
                                          color: Colors.black,
                                          size: 60,
                                        ),
                                        ID: "PURCHASE",
                                        imgPath: "assets/img/purchase.png",
                                        mainUrl: urldata().purchaseUrl,
                                        name: "PURCHASE",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.doc_text_viewfinder,
                                          color: Colors.black,
                                          size: 60,
                                        ),
                                        ID: "PURCHASEOUTSTANDING",
                                        imgPath: "assets/img/purchaseoutstanding2.png",
                                        mainUrl: urldata().purchaseOutstandingReportUrl,
                                        name: "PURCHASE\nOUTSTANDING",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: MainTitle(
                    //         title: "Order",
                    //       ),
                    //     ),
                    //     SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             width: MediaQuery.of(context).size.width,
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 MainIcon(
                    //                   IconWidget: Icon(
                    //                     Icons.edit_document,
                    //                     color: Color(0xFF777368),
                    //                     size: 60,
                    //                   ),
                    //                   ID: "ORDERFORM",
                    //                   imgPath: "assets/img/neworder.png",
                    //                   mainUrl: urldata().OrderFormReportUrl,
                    //                   name: "NEW ORDER",
                    //                   CURRENT_USER: widget.CURRENT_USER[0],
                    //                 ),
                    //                 MainIcon(
                    //                   IconWidget: Icon(
                    //                     Icons.newspaper_outlined,
                    //                     color: jsmColor,
                    //                     size: 60,
                    //                   ),
                    //                   ID: "ORDERLIST",
                    //                   imgPath: "assets/img/orderlist.png",
                    //                   mainUrl: urldata().OrderListReportUrl,
                    //                   name: "ORDER LIST",
                    //                   CURRENT_USER: widget.CURRENT_USER[0],
                    //                 ),
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainTitle(
                            title: "Stock",
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,

                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MainIcon(
                                        IconWidget: Icon(
                                          Icons.factory,
                                          color: Color(0xFF5e7aed),
                                          size: 60,
                                        ),
                                        ID: "MILLSTOCK",
                                        imgPath: "assets/img/millstock.png",
                                        mainUrl: urldata().MillStockReportUrl,
                                        name: "MILL STOCK",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          Icons.library_books_outlined,
                                          color: Color(0xff721119),
                                          size: 60,
                                        ),
                                        ID: "STOCKINHOUSE",
                                        imgPath: "assets/img/stockinhouse.png",
                                        mainUrl: urldata().StockInHouse,
                                        name: "STOCK IN HOUSE",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.news_solid,
                                          color: Color(0xff3a575e),
                                          size: 60,
                                        ),
                                        ID: "JOBWORK",
                                        imgPath: "assets/img/jobwork.png",
                                        mainUrl: urldata().JobworkReportUrl,
                                        name: "JOBWORK",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainTitle(
                            title: "Extras",
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,

                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.rectangle_stack_person_crop_fill,
                                          color: Color(0xff737373),
                                          size: 60,
                                        ),
                                        ID: "ADDRESSBOOK",
                                        imgPath: "assets/img/addressbook.png",
                                        mainUrl: urldata().AddressReportUrl,
                                        name: "ADDRESS BOOK",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.table_badge_more_fill,
                                          color: Colors.black,
                                          size: 60,
                                        ),
                                        ID: "QUALITY",
                                        imgPath: "assets/img/quality.png",
                                        mainUrl: urldata().QualReportUrl,
                                        name: "QUALITY",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          FontAwesomeIcons.truck,
                                          color: jsmColor,
                                          size: 60,
                                        ),
                                        ID: "TRANSPORT",
                                        imgPath: "assets/img/transport.png",
                                        mainUrl: urldata().transportReportUrl,
                                        name: "TRANSPORT",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.today,
                                          color: Colors.blue[900],
                                          size: 60,
                                        ),
                                        ID: "TDS",
                                        imgPath: "assets/img/tds.png",
                                        mainUrl: urldata().tdsReportUrl,
                                        name: "TDS",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                        height: 80,
                                      ),
                                      MainIcon(
                                        IconWidget: Icon(
                                          CupertinoIcons.square_stack_3d_down_right_fill,
                                          color: jsmColor,
                                          size: 60,
                                        ),
                                        ID: "GSTINSEARCH",
                                        imgPath: "assets/img/gstin.png",
                                        mainUrl: urldata().gstinSearchUrl,
                                        name: "GSTIN SEARCH",
                                        CURRENT_USER: widget.CURRENT_USER[0],
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  ExtraComanIcon(UserObj: widget.CURRENT_USER[0]),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<String> setYear(var val) async {
    // setState(() {
    year = val.replaceAll("-", "");
    prefs!.setString("year", year);
    prefs!.setString("yearVal", val);
    yearVal = val;
    // });
    widget.CURRENT_USER[0]["yearSelected"] = year;
    widget.CURRENT_USER[0]["yearVal"] = yearVal;
    widget.CURRENT_USER[0]["privateNetWorkSync"] = privateNetWorkSync;
    widget.CURRENT_USER[0]["extraPathSelected"] = extraPathSelected.text;
    widget.CURRENT_USER[0]["Curentyearforlocalstorage"] = currentYears[0].toString().replaceAll("-", "");
    widget.CURRENT_USER[0]["FILE_NAME"] = Myf.getFileNameYear(yearVal: yearVal, currentYears: currentYears);
    databaseId = await Myf.databaseId(widget.CURRENT_USER[0]);
    //HiveBox = await Myf.openHiveBox(databaseId);
    var lastUpdatetime = await Myf.getValFromSavedPref(widget.CURRENT_USER[0], "lastUpdatetime");
    widget.CURRENT_USER[0]["last_update_time_for_show"] = lastUpdatetime;
    lastUpdateDateControl.sink.add(lastUpdatetime);
    // setState(() {});
    yearValStream.sink.add(yearVal);
    GLB_CURRENT_USER = widget.CURRENT_USER[0];
    autoSync = Myf.autoSyncIs();

    if ((lastUpdatetime == null || lastUpdatetime == "") && backgroundSyncInProcess == false && autoSync == true) {
      await Myf.startServerSync(context, UserObj: widget.CURRENT_USER[0]);
    } else if (backgroundSyncInProcess == false && autoSync == true) {
      String FILE_NAME = widget.CURRENT_USER[0]["FILE_NAME"];
      if (FILE_NAME.contains("LAST_YEAR")) {
        var onlineTimeInMili = Myf.getOnlineTimeInMili(widget.CURRENT_USER[0]);
        var localTimeInMili = Myf.getValFromSavedPref(widget.CURRENT_USER[0], "localTimeInMili");
        localTimeInMili = localTimeInMili == null || localTimeInMili == "" ? "0" : localTimeInMili;
        var miliLastUpdateTimeOnline = int.parse("$onlineTimeInMili");
        var mililastUpdatetimeLocal = int.parse("$localTimeInMili");
        if (miliLastUpdateTimeOnline > mililastUpdatetimeLocal) {
          await Myf.startServerSync(context, UserObj: widget.CURRENT_USER[0]);
        }
      }
    }
    ipController.text = Myf.getPrivateNetWorkIp(widget.CURRENT_USER[0]) ?? "";
    return "";
  }
}

Future<String> showSyncDialog(BuildContext context, CURRENT_USER, privateNetWorkSync) async {
  ipController.text = await Myf.getPrivateNetWorkIp(CURRENT_USER) ?? "";
  // setState(() {});
  await NAlertDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    title: const Text("Please Enter Private Network IP"),
    content: TextFormField(
      controller: ipController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Gstin Cannot be empty";
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Enter Your Private Network Ip ",
        labelText: "Private Network IP ",
      ),
    ),
    actions: <Widget>[
      TextButton(
          onPressed: () {
            showModalBottomSheet(
                scrollControlDisabledMaxHeightRatio: .6,
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      if (firebaseCurrntSupUserObj["pcUtility"]["privateNetworkIp"] != null &&
                          firebaseCurrntSupUserObj["pcUtility"]["privateNetworkIp"].toString().isNotEmpty)
                        Card(
                          color: Colors.blue.shade50,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(Icons.wifi, color: Colors.blue.shade700),
                            ),
                            title: Text("Wifi/LAN Local IP", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${firebaseCurrntSupUserObj["pcUtility"]["privateNetworkIp"] ?? ""}"),
                            onTap: () async {
                              ipController.text = "${firebaseCurrntSupUserObj["pcUtility"]["privateNetworkIp"] ?? ""}";
                              await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                              Navigator.pop(context);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.wifi_tethering, color: Colors.blue.shade700),
                              tooltip: "Check Connection",
                              onPressed: () async {
                                ipController.text = CURRENT_USER["privateNetworkIp"];
                                await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                                Myf.toast("ip Saved", context: context);
                                await checkConnectionStatus(context);
                              },
                            ),
                          ),
                        ),
                      if (firebaseCurrntSupUserObj["pcUtility"]["publicNetworkIp"] != null &&
                          firebaseCurrntSupUserObj["pcUtility"]["publicNetworkIp"].toString().isNotEmpty)
                        Card(
                          color: Colors.green.shade50,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Icon(Icons.public, color: Colors.green.shade700),
                            ),
                            title: Text("Static Connection", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${firebaseCurrntSupUserObj["pcUtility"]["publicNetworkIp"]}"),
                            onTap: () {
                              ipController.text = firebaseCurrntSupUserObj["pcUtility"]["publicNetworkIp"];
                              Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                              Navigator.pop(context);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.wifi_tethering, color: Colors.green.shade700),
                              tooltip: "Check Connection",
                              onPressed: () async {
                                ipController.text = firebaseCurrntSupUserObj["pcUtility"]["publicNetworkIp"];
                                await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                                Myf.toast("ip Saved", context: context);
                                await checkConnectionStatus(context);
                              },
                            ),
                          ),
                        ),
                      if (firebaseCurrntSupUserObj["pcUtility"]["ngDomain"] != null &&
                          firebaseCurrntSupUserObj["pcUtility"]["ngDomain"].toString().isNotEmpty)
                        Card(
                          color: Colors.purple.shade50,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple.shade100,
                              child: Icon(Icons.cloud, color: Colors.purple.shade700),
                            ),
                            title: Text("Domain Connection", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("${firebaseCurrntSupUserObj["pcUtility"]["ngDomain"]}"),
                            onTap: () {
                              ipController.text = firebaseCurrntSupUserObj["pcUtility"]["ngDomain"];
                              Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                              Navigator.pop(context);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.wifi_tethering, color: Colors.purple.shade700),
                              tooltip: "Check Connection",
                              onPressed: () async {
                                ipController.text = firebaseCurrntSupUserObj["pcUtility"]["ngDomain"];
                                await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
                                Myf.toast("ip Saved", context: context);
                                await checkConnectionStatus(context);
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                });
            // setState(() {
            // });
          },
          child: const Text('Auto Detect Ip')),
      TextButton(
          onPressed: () async {
            await Myf.startServerSync(context, UserObj: CURRENT_USER);
            await Myf.popScreen(context);
          },
          child: const Text('Server')),
      TextButton(
          onPressed: () async {
            await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
            Myf.toast("ip Saved", context: context);
            await Myf.popScreen(context);
          },
          onLongPress: () async {
            await Myf.saveValToSavedPref(CURRENT_USER, "privateNetworkIp", ipController.text);
            Myf.toast("ip Saved", context: context);
            Myf.launchurl(Uri.parse("http://${ipController.text}"));
          },
          child: const Text('Save')),
    ],
  ).show(context);
  return privateNetWorkSync;
}

Future<void> checkConnectionStatus(BuildContext context) async {
  var isConnectionOk = await Myf.connectionCheckPrivateNetwork();
  if (isConnectionOk == true) {
    Navigator.pop(context);
    Myf.toast("Connection Successful", context: context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Connection Status"),
        content: Text("Connection is OK!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  } else {
    Myf.toast("Connection Failed", context: context);
  }
}
