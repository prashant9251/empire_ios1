import 'package:csv/csv.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillForCsvModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormSettings/EmpOrderFormSettings.dart';
import 'package:empire_ios/screen/EmpOrderList/EmpOrderList.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListCubit.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListState.dart';
import 'package:empire_ios/screen/EmpOrderListNew/EmpOrderListNew.dart';
import 'package:empire_ios/screen/EmpOrderListPending/EmpOrderListPending.dart';
import 'package:empire_ios/screen/EmpOrderListPending/EmpOrderListPendingCubit.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderListHome extends StatefulWidget {
  const EmpOrderListHome({Key? key}) : super(key: key);

  @override
  State<EmpOrderListHome> createState() => _EmpOrderListHomeState();
}

class _EmpOrderListHomeState extends State<EmpOrderListHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Row(
            children: [
              Text('Order List'),
              if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true)
                Icon(Icons.admin_panel_settings)
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              width: widthResponsive(context),
              child: Column(
                children: [
                  // need search bar

                  TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    dividerColor: Colors.white,
                    tabs: [
                      Tab(text: 'Pending'),
                      Tab(text: 'Confirm'),
                      Tab(text: 'Rejected'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () => Myf.Navi(context, EmpOrderFormSettings()), icon: Icon(Icons.settings)),
            IconButton(
                onPressed: () {
                  convertToCsv();
                },
                icon: Icon(Icons.download)),
          ],
        ),
        body: Center(
          child: Container(
            width: widthResponsive(context),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                BlocProvider(create: (context) => EmpOrderListPendingCubit(context, 'pending'), child: EmpOrderListPending()),
                EmpOrderListNew(status: 'confirm'),
                EmpOrderListNew(status: 'rejected'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  convertToCsv({exportType = 2}) async {
    List<BillsModel> filteredList = [];
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .where("ordCnfB", isEqualTo: 'confirm')
        .where("date", isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 10)).toIso8601String())
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var data = result.data();
        BillsModel billsModel = BillsModel.fromJson(Myf.convertMapKeysToString(data));
        filteredList.add(billsModel);
      });
    });
    await Future.wait(filteredList.map((e) async {
      if (e.status == "confirm") {
        List<BillDetModel>? billDetModel = e.billDetails ?? [];
        var grossamt = 0.0;
        var totPcs = 0.0;
        var totMts = 0.0;
        await Future.wait(billDetModel.map((d) async {
          var aMT2 = Myf.convertToDouble(d.pCS!) * Myf.convertToDouble(Myf.getPackingRate(d).toString());
          totPcs += Myf.convertToDouble(d.pCS);
          totMts += Myf.convertToDouble(d.mTR);
          grossamt += aMT2;
          d.aMT = aMT2.toString();
        }));
        e.grossAmt = grossamt.toString();
        e.totPcs = totPcs.toString();
        e.totMts = totMts.toString();
      }
      return e;
    }).toList());

    List<Map<String, dynamic>> jsonForCsv = []; //this is csv
    if (exportType == '') {
      jsonForCsv = await jsonPartyOrder(filteredList, exportType);
    } else {
      jsonForCsv = [];
      await Future.wait(filteredList.map((e) async {
        if (e.status == "confirm") {
          Map<String, dynamic> map = e.toJson();
          List<BillDetModel>? billDetModel = e.billDetails ?? [];
          var sr = 0;
          await Future.wait(billDetModel.map((d) async {
            sr++;
            if (empOrderSettingModel.colorExportInCsv ?? false) {
              var colorDetails = d.colorDetails;
              if (colorDetails != null) {
                await Future.wait(colorDetails.map((c) async {
                  var cBy = e.cBy.toString().split("@");
                  var mtr = Myf.convertToDouble(d.cUT) * Myf.convertToDouble(c.clQty);
                  BillForCsvModel billForCsvModel = csvCard(e, d, mtr, sr, cBy);
                  billForCsvModel.qUAL = c.clName;
                  billForCsvModel.pCS = c.clQty;
                  jsonForCsv.add(billForCsvModel.toJson());
                }).toList());
              }
            } else {
              var cBy = e.cBy.toString().split("@");
              var mtr = Myf.convertToDouble(d.cUT) * Myf.convertToDouble(d.pCS);
              BillForCsvModel billForCsvModel = csvCard(e, d, mtr, sr, cBy);
              jsonForCsv.add(billForCsvModel.toJson());
            }
          }).toList());
        }
      }).toList());
    }

    jsonForCsv.sort((a, b) {
      // Compare by company no
      int companyComparison = int.parse(a['CNO']).compareTo(int.parse(b['CNO']));

      // If company no is the same, compare by voucher no
      if (companyComparison == 0) {
        int voucherComparison = int.parse(a['VNO']).compareTo(int.parse(b['VNO']));

        // If voucher no is the same, compare by srno
        if (voucherComparison == 0) {
          return int.parse(a['SRNO']).compareTo(int.parse(b['SRNO']));
        }

        return voucherComparison;
      }

      return companyComparison;
    });

    if (jsonForCsv.length == 0) {
      Myf.snakeBar(context, "Please confirm order status");
      return;
    }
    final List<List<dynamic>> csvData = [];
    //headerAdd
    final List<String> headers = jsonForCsv[0].keys.toList();
    csvData.add(headers);
    logger.d(jsonForCsv.first);
    jsonForCsv.forEach((map) {
      final List<dynamic> row = map.values.toList();
      csvData.add(row);
    });
    final String csv = const ListToCsvConverter().convert(csvData);
    export(csv);
  }

  void export(String csv) {
    if (kIsWeb) {
      // For web, initiate download in a web-specific way
      EmpOrderListStateDownload.downloadCSVWeb(csv, 'Empire Order ${loginUserModel.sHOPNAME!.replaceAll(".", "")}.csv', context);
    } else {
      // For mobile, initiate download in a mobile-specific way
      EmpOrderListStateDownload.downloadCSVMobile(csv, 'Empire Order ${loginUserModel.sHOPNAME!.replaceAll(".", "")}.csv');
    }
  }

  BillForCsvModel csvCard(BillsModel e, BillDetModel d, double mtr, int sr, List<String> cBy) {
    BillForCsvModel billForCsvModel = BillForCsvModel(
      cNO: e.cNO,
      tYPE: e.tYPE.toString().replaceAll("00", ""),
      vNO: e.vNO.toString(),
      bCODE: e.bcode,
      bILL: e.bill,
      cODE: e.masterDet!.value,
      dATE: Myf.dateFormateInDDMMYYYY(e.date),
      hASTE: e.haste,
      sTATION: e.st,
      tRANSPORT: e.trnsp,
      qUAL: d.qUAL,
      cUT: d.cUT,
      aMT: d.aMT,
      mTR: mtr.toString(),
      pACK: d.packing,
      pCS: d.pCS,
      rATE: Myf.getPackingRate(d).toString(),
      sRNO: sr.toString(),
      uNIT: d.uNIT,
      vATRATE: d.vatRate,
      SETS: d.sets,
      PCS_IN_SETS: d.pcsInSets,
      cATEGORY: d.category,
      dETAILS: d.rmk,
      aLTQUAL: d.mainScreen,
      TOTPCS: e.totPcs,
      TOTMTS: e.totMts,
      CREATEDBY: cBy.first,
      COMPANY_GSTIN: e.compmstDet!.cOMPANYGSTIN ?? "",
      GROSS_AMT: e.grossAmt,
      RMK: e.rmk,
      GSTIN: e.masterDet!.gST,
      STATECODE: getStateCode(e),
    );
    return billForCsvModel;
  }

  String? getStateCode(BillsModel e) {
    var stateCode = e.stateCode;
    if (e.stateCode == null || e.stateCode == "") {
      try {
        stateCode = (e.masterDet!.gST!.substring(0, 2));
      } catch (e) {}
    }
    var formattedNumber = '${stateCode!.length == 1 ? '0' : ''}$stateCode';
    return stateCode;
  }

  jsonPartyOrder(List<BillsModel> filteredList, exportType) async {
    List<Map<String, dynamic>> jsonForCsv = [];
    await Future.wait(filteredList.map((e) async {
      Map<String, dynamic> obj = {};
      obj["CNO"] = e.cNO.toString();
      obj["TYPE"] = e.tYPE.toString();
      obj["VNO"] = e.vNO.toString();
      obj["DATE"] = Myf.dateFormate(e.date.toString());
      obj["BILL"] = (e.bill.toString());
      obj["PARTY"] = e.masterDet!.partyname.toString();
      obj["BROKER"] = e.bcode.toString();
      obj["HASTE"] = e.haste.toString();
      obj["BOOKING"] = e.st.toString();
      obj["TRANSPORT"] = e.trnsp.toString();
      obj["TOTAL_PCS"] = e.totPcs.toString();
      obj["TOTAL_MTS"] = e.totMts.toString();
      obj["GROSS_AMT"] = e.grossAmt.toString();
      obj["STATUS"] = e.status.toString();
      if (exportType != '') {
        if (e.status == exportType) {
          jsonForCsv.add(obj);
        }
      } else {
        jsonForCsv.add(obj);
      }
    }).toList());
    final List<List<dynamic>> csvData = [];
    //headerAdd
    if (jsonForCsv.length > 0) {
      final List<String> headers = jsonForCsv[0].keys.toList();
      csvData.add(headers);
      await Future.wait(jsonForCsv.map((e) async {
        final List<dynamic> row = e.values.toList();
        csvData.add(row);
      }).toList());
    }

    return jsonForCsv;
  }
}
