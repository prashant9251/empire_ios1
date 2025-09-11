// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/NotificationService/FirebaseApi.dart';
import 'package:empire_ios/screen/DailySaleGraph/DailySaleGraph.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/Tradinghome.dart';
import 'package:empire_ios/screen/EMPIRE/homedrawer.dart';
import 'package:empire_ios/screen/EMPIRE/urlData.dart';
import 'package:empire_ios/screen/EMPIRE/urlDataAg.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqOfficeSupport.dart';
import 'package:empire_ios/widget/mainScreenIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:ndialog/ndialog.dart';

import '../../SyncData.dart';
import '../../main.dart';
import '../expiries/expCalculation.dart';
import '../instruction/homeInstruction.dart';
import 'extraComanIcon.dart';

class Agency_Home extends StatefulWidget {
  Agency_Home({Key? key, required this.CURRENT_USER}) : super(key: key);
  List CURRENT_USER;
  @override
  _Agency_HomeState createState() => _Agency_HomeState();
}

class _Agency_HomeState extends State<Agency_Home> {
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
    //----yearGet--set

    //----extraPathObj--set
    if (widget.CURRENT_USER[0]['extraPathLIST'] != null && widget.CURRENT_USER[0]['extraPathLIST'] != "") {
      extraPathObj = jsonDecode(widget.CURRENT_USER[0]['extraPathLIST']);
    }
    //----extraPathObj--set
    year = yearVal.replaceAll("-", "");
    await setYear(yearVal);

    // syncReady = true;
    syncReadyStream.sink.add(true);

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

    // Myf.checkFornotification(context, widget.CURRENT_USER[0]);
  }

  @override
  Widget build(BuildContext context) {
    loginUserModel = LoginUserModel.fromJson(widget.CURRENT_USER[0]);
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
        //   child: Remark(
        //     UserObj: widget.CURRENT_USER[0],
        //   ),
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
              child: Text(
                "SYNC",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          backgroundColor: HexColor(ColorHex),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SftExpStatusMsg(userObj: widget.CURRENT_USER[0]),
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
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StreamBuilder<String>(
                        stream: lastUpdateDateControl.stream,
                        builder: (context, snapshot) {
                          var lastUpdatetime = Myf.getValFromSavedPref(widget.CURRENT_USER[0], "lastUpdatetime");
                          return Text("Last Sync${lastUpdatetime.toString()}");
                        },
                      ),
                      // Text('Last Sync : ${lastUpdatetime.text}'),
                    ],
                  ),
                ),
                uniqOfficeSupport(UserObj: widget.CURRENT_USER[0]),
                HomeScreenInstruction(UserObj: widget.CURRENT_USER[0]),
                DailySaleGraph(UserObj: widget.CURRENT_USER[0]),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Wrap(
                            children: [
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MainTitle(
                    title: "Unique",
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.square_stack_3d_down_right_fill,
                                  color: jsmColor,
                                  size: 60,
                                ),
                                ID: "GSTIN SEARCH",
                                imgPath: "assets/img/gstin.png",
                                mainUrl: urldata().gstinSearchUrl,
                                name: "GSTIN SEARCH",
                                CURRENT_USER: widget.CURRENT_USER[0],
                                height: 80,
                              ),
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.book_fill,
                                  size: 60,
                                  color: Color(0xFF031c72),
                                ),
                                ID: "PAYMENT ENTRY",
                                imgPath: "assets/img/paymententry.png",
                                mainUrl: urldataAG().BankEntryReportUrl,
                                name: "PAYMENT ENTRY",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                              MainIcon(
                                IconWidget: Icon(
                                  Icons.assessment,
                                  size: 60,
                                  color: Color(0xFF69302b),
                                ),
                                ID: "LEDGER",
                                imgPath: "assets/img/ledger.png",
                                mainUrl: urldataAG().LedgerReportUrl,
                                name: "LEDGER",
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
                                mainUrl: urldataAG().chartUrl,
                                name: "ANALYTICS",
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
                                mainUrl: urldataAG().PcOrderUrl,
                                name: "ORDER",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                              InDev(
                                  inDevUser: widget.CURRENT_USER[0]["login_user"],
                                  widget: MainIcon(
                                    IconWidget: Icon(
                                      CupertinoIcons.photo_on_rectangle,
                                      size: 60,
                                      color: Colors.pink.shade900,
                                    ),
                                    ID: "ORDERPHOTO",
                                    imgPath: "assets/img/ledger.png",
                                    mainUrl: urldataAG().PcOrderUrl,
                                    name: "ORDER PHOTO",
                                    CURRENT_USER: widget.CURRENT_USER[0],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MainIcon(
                              IconWidget: Icon(
                                Icons.find_in_page,
                                size: 60,
                                color: Color(0xFF3f4eb2),
                              ),
                              ID: "FIND BILL",
                              imgPath: "assets/img/findbill.png",
                              mainUrl: urldataAG().findBill,
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
                              mainUrl: urldataAG().SaleReportUrl,
                              name: "SALE",
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
                              mainUrl: urldataAG().OutstandingReportUrl,
                              name: "OUTSTANDING",
                              CURRENT_USER: widget.CURRENT_USER[0],
                            ),
                            MainIcon(
                              IconWidget: Icon(
                                Icons.picture_as_pdf,
                                size: 60,
                                color: Colors.blue[900],
                              ),
                              ID: "BULK PDF BILL",
                              imgPath: "assets/img/bulkpdf.png",
                              mainUrl: urldataAG().BulkPdfBill,
                              name: "BULK PDF BILL",
                              CURRENT_USER: widget.CURRENT_USER[0],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MainTitle(
                    title: "Commission",
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
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.purchased,
                                  color: Colors.black,
                                  size: 60,
                                ),
                                ID: "COMMISSION REPORT",
                                imgPath: "assets/img/purchase.png",
                                mainUrl: urldataAG().commReportUrl,
                                name: "Commission/DD report",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.doc_text_viewfinder,
                                  color: Colors.black,
                                  size: 60,
                                ),
                                ID: "PURCHASE OUTSTANDING",
                                imgPath: "assets/img/purchaseoutstanding2.png",
                                mainUrl: urldataAG().purchaseOutstandingReportUrl,
                                name: "PURCHASE OUTSTANDING",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.rectangle_stack_person_crop_fill,
                                  color: Color(0xff737373),
                                  size: 50,
                                ),
                                ID: "ADDRESS BOOK",
                                imgPath: "assets/img/addressbook.png",
                                mainUrl: urldataAG().AddressReportUrl,
                                name: "ADDRESS BOOK",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.group,
                                  color: Color(0xff737373),
                                  size: 50,
                                ),
                                ID: "ACGROUP BOOK",
                                imgPath: "assets/img/accountno.png",
                                mainUrl: urldataAG().acgroupReportUrl,
                                name: "ACGROUP BOOK",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                              MainIcon(
                                IconWidget: Icon(
                                  CupertinoIcons.table_badge_more_fill,
                                  color: Colors.black,
                                  size: 50,
                                ),
                                ID: "QUALITY CHART",
                                imgPath: "assets/img/quality.png",
                                mainUrl: urldataAG().QualReportUrl,
                                name: "QUALITY CHART",
                                CURRENT_USER: widget.CURRENT_USER[0],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ExtraComanIcon(UserObj: widget.CURRENT_USER[0])
              ],
            ),
          ),
        ),
      ),
    );
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
    // HiveBox = await Myf.openHiveBox(databaseId);
    var lastUpdatetime = await Myf.getValFromSavedPref(widget.CURRENT_USER[0], "lastUpdatetime");
    widget.CURRENT_USER[0]["last_update_time_for_show"] = lastUpdatetime;
    lastUpdateDateControl.sink.add(lastUpdatetime);
    // setState(() {});
    yearValStream.sink.add(yearVal);
    GLB_CURRENT_USER = widget.CURRENT_USER[0];

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
