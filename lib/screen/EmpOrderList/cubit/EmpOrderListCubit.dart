import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillForCsvModel.dart';
import 'package:empire_ios/Models/BillsDeleteModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderList/EmpOrderPaginationList.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListState.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/screen/EmpOrderView/EmpOrderView.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

StreamController<bool> tablecheckBoxStream = StreamController<bool>.broadcast();

class EmpOrderListCubit extends Cubit<EmpOrderListState> {
  DateTime? fromDate;
  DateTime? toDate;
  bool isTableLoad = false;
  bool isDisposed = false;
  BuildContext context;
  var statusList = ["All", "pending", "confirm", "rejected"];

  // Box? EMP_ORDER;
  List<BillsModel> EMP_ORDER_LIST = [];
  List<BillsModel> filteredList = [];
  List<DataRow> rowtable = [];

  var reportView;

  var statusFilter = "";

  var limitFilter = "50";

  var selectAll = false;
  EmpOrderListCubit(this.context) : super(EmpOrderListStateIni()) {
    getData();
    hiveMainBox.watch().listen((event) async {
      if (!isDisposed && !isTableLoad) {
        isTableLoad = true;
        await getData();
      }
    });
  }

  getData() async {
    Box EMP_ORDER = await SyncLocalFunction.openBoxCheckByYearWise("EMP_ORDER");
    if (EMP_ORDER != null) {
      EMP_ORDER_LIST = [];
      await Future.wait(EMP_ORDER.values.map((e) async {
        dynamic d = await e;
        dynamic v = await Myf.convertMapKeysToString(d);
        var element = await BillsModel.fromJson(v);
        if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true) {
          EMP_ORDER_LIST.add(element);
        } else if (firebaseCurrntSupUserObj["is_dispatcher"] == true) {
          if (element.status == "confirm") {
            EMP_ORDER_LIST.add(element);
          }
        } else if (element.cBy == loginUserModel.loginUser) {
          EMP_ORDER_LIST.add(element);
        }
      }).toList());
      EMP_ORDER.close();
      filteredList = [];
      loadTable();
    }
  }

  void loadTable({var query, var rpView}) async {
    this.reportView = rpView;
    filteredList = await [...EMP_ORDER_LIST];
    if (query != null && query != "") {
      filteredList = await filteredList.where((element) {
        return "${element.vNO}${element.pcode ?? ""}${element.bcode ?? ""}${element.haste ?? ""}${element.trnsp ?? ""}${element.st ?? ""}"
            .contains("$query");
      }).toList();
    }
    if (fromDate != null) {
      filteredList = filteredList.where((e) {
        var billdate = DateTime.tryParse(e.date!);
        var dateOnly = billdate?.toLocal().toLocal().toLocal();
        if (dateOnly != null) {
          dateOnly = DateTime(dateOnly.year, dateOnly.month, dateOnly.day);
        }
        return e.date != null && dateOnly!.isAfter(fromDate!) || dateOnly!.isAtSameMomentAs(fromDate!);
      }).toList();
    }

    if (toDate != null) {
      filteredList = filteredList.where((e) {
        var billdate = DateTime.tryParse(e.date!);
        var dateOnly = billdate?.toLocal().toLocal().toLocal();
        if (dateOnly != null) {
          dateOnly = DateTime(dateOnly.year, dateOnly.month, dateOnly.day);
        }
        return e.date != null && dateOnly!.isBefore(toDate!) || dateOnly!.isAtSameMomentAs(toDate!);
      }).toList();
    }
    if (statusFilter.isNotEmpty && !statusFilter.contains("All")) {
      filteredList = await filteredList.where((element) {
        return "${element.status}" == statusFilter;
      }).toList();
    }
    switch (reportView) {
      case "list":
      // Widget widget = Expanded(child: await getViewOrderList());
      // emit(EmpOrderListStateLoadOrder(widget));
      // break;
      default:
        if (!isDisposed) await loadTableView();

        isTableLoad = false;
    }
  }

  Future<void> loadTableView() async {
    Widget widget = await getViewTable();
    if (!isDisposed) emit(EmpOrderListStateLoadOrder(widget));
  }

  getViewTable() async {
    filteredList.sort((a, b) {
      var dateA = DateTime.tryParse(a.date ?? "");
      var dateB = DateTime.tryParse(b.date ?? "");
      if (dateA == null || dateB == null) {
        return 0;
      }
      int dateComparison = dateB.compareTo(dateA);
      if (dateComparison != 0) {
        return dateComparison;
      }
      return b.vNO.compareTo(a.vNO);
    });
    // ValueListenableBuilder(
    //   valueListenable: EMP_ORDER.listenable(),
    //   builder: (context, value, child) {

    //   },
    // );

    // return PaginationTable(filteredList: filteredList);
    return PaginatedDataTable(
      // dataRowMaxHeight: 200,

      columnSpacing: 15,
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order List'),
          IconButton(
            onPressed: () async {
              var pdfSelectedList = filteredList.where((e) => e.selected == true).toList();
              if (pdfSelectedList.length > 0) {
                Myf.showBlurLoading(context);

                var f = await EmpOrderPrintClass.savePdfOpen(OrderList: pdfSelectedList, context: context);
                Myf.popScreen(context);
              } else {
                Myf.snakeBar(context, "please Select Order");
              }
            },
            icon: Icon(Icons.picture_as_pdf),
            color: Colors.red,
          )
        ],
      ),
      columns: [
        DataColumn(
            label: Checkbox(
          onChanged: (value) async {
            selectAll = !selectAll;
            filteredList = await Future.wait(filteredList.map((e) async {
              e.selected = selectAll;
              return e;
            }).toList());
            loadTableView();
          },
          value: selectAll,
        )),
        DataColumn(label: Text('VNO')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Party Name')),
        DataColumn(label: Text('CITY')),
        DataColumn(label: Text('FIRM')),
        DataColumn(label: Text('Broker')),
        DataColumn(label: Text('Haste')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Actions')),
        DataColumn(label: Text('Created By')),
      ],
      source: _YourDataSource(filteredList, context),
      rowsPerPage: 100, // Set your desired number of rows per page
    );
  }

  Row subDetaisl(title, text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(child: Text("$title:")),
        Flexible(child: Text("${text}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
      ],
    );
  }

  convertToCsv({exportType = 2}) async {
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
      jsonForCsv = await jsonPartyOrder(exportType);
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

  jsonPartyOrder(exportType) async {
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

class _YourDataSource extends DataTableSource {
  final List<BillsModel> data;
  BuildContext context;
  _YourDataSource(this.data, this.context);

  @override
  DataRow getRow(int index) {
    final billsModel = BillsModel.fromJson(data[index].toJson());

    var createdBY = "";

    List<String?> parts = data[index].cBy.toString().split('@');
    createdBY = parts[0] ?? "";
    var colorSTyle = "${billsModel.status}".contains("pending")
        ? Colors.white
        : "${billsModel.status}".contains("rejected")
            ? Colors.red
            : Colors.green;
    return DataRow(
        onLongPress: () async {
          var yesNO = await Myf.yesNoShowDialod(context, title: "Alert", msg: "Do you want Open Again this Order?");
          if (yesNO) {
            billsModel.mTime = DateTime.now().toString();
            billsModel.status = "pending";
            await fireBCollection
                .collection("supuser")
                .doc(loginUserModel.cLIENTNO)
                .collection("EMPIRE")
                .doc(GLB_CURRENT_USER["yearVal"])
                .collection("EMP_ORDER")
                .doc(billsModel.ide)
                .update(billsModel.toJson());
            await SyncLocalFunction.onlyOrderFetch();
            await SyncLocalFunction.onlyOrderFetch();
          }
        },
        color: WidgetStateColor.resolveWith((states) => colorSTyle),
        cells: [
          DataCell(StreamBuilder<bool>(
              stream: tablecheckBoxStream.stream,
              builder: (context, snapshot) {
                return Checkbox(
                  onChanged: (value) {
                    data[index].selected = !data[index].selected!;
                    tablecheckBoxStream.sink.add(true);
                  },
                  value: data[index].selected,
                );
              })),
          DataCell(Text("${billsModel.vNO}")),
          DataCell(Text("${Myf.dateFormate(billsModel.date)}")),
          DataCell(Text("${billsModel.masterDet!.partyname}")),
          DataCell(Text("${billsModel.masterDet!.city}")),
          DataCell(Text("${billsModel.compmstDet!.sHORTNAME}")),
          DataCell(Text("${billsModel.bcode}")),
          DataCell(Text("${billsModel.haste}")),
          DataCell(Column(
            children: [
              if (firebaseCurrntUserObj["is_dispatcher"] != true)
                if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true)
                  statusorderOption(billsModel, context),
            ],
          )),
          DataCell(
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: [
                viewOrderWithPhoto(billsModel),
                if (firebaseCurrntUserObj["is_dispatcher"] != true) ...[
                  shareIcon(billsModel),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        Myf.showBlurLoading(context);
                        var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context);
                        Myf.popScreen(context);
                      },
                      icon: Icon(Icons.print),
                    ),
                  ),
                  SyncStatusTime(billsModel),
                  if (billsModel.status != "confirm") ...[
                    editorderOption(billsModel),
                    if (firebaseCurrntUserObj["PERMISSION_DELETE_ORDER"] != false || loginUserModel.loginUser!.contains("ADMIN"))
                      deleteBtn(context, billsModel),
                  ],
                ],
              ],
            ),
          ),
          DataCell(Text("${createdBY}")),
        ]);
  }

  CircleAvatar editorderOption(BillsModel billsModel) {
    return CircleAvatar(
        backgroundColor: Colors.deepOrangeAccent,
        child: IconButton(
            color: Colors.white,
            onPressed: () async {
              await Myf.Navi(
                  context,
                  BlocProvider(
                    create: (context) => EmpOrderFormCubit(context),
                    child: EmpOrderForm(billsModel: billsModel),
                  ));
              await SyncLocalFunction.onlyOrderFetch();
            },
            icon: Icon(Icons.edit)));
  }

  Widget SyncStatusTime(BillsModel billsModel) {
    return billsModel.empSyncTime != null && billsModel.empSyncTime != ""
        ? CircleAvatar(
            backgroundColor: Colors.green,
            child: IconButton(
                tooltip: "Sync time ${Myf.dateFormate(billsModel.empSyncTime)}",
                color: Colors.white,
                onPressed: () async {
                  // var f = await EmpOrderPrintClass.savePdfOpen(ORDER: billsModel, context: context);
                },
                icon: Icon(Icons.done)))
        : SizedBox.shrink();
  }

  viewOrderWithPhoto(BillsModel billsModel) {
    return CircleAvatar(
      backgroundColor: Colors.blueGrey,
      child: IconButton(
        onPressed: () => Myf.Navi(context, EmpOrderView(billsModel: billsModel)),
        icon: Icon(Icons.photo_library_outlined),
        color: Colors.white,
      ),
    );
  }

  Widget shareIcon(BillsModel billsModel) {
    return CircleAvatar(
        backgroundColor: Colors.green,
        child: IconButton(
            color: Colors.white,
            onPressed: () async {
              Myf.showBlurLoading(context);

              var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context, pdfOprate: "share");
              Myf.popScreen(context);
            },
            icon: Icon(Icons.share)));
  }

  Widget deleteBtn(BuildContext context, BillsModel billsModel) {
    return CircleAvatar(
      backgroundColor: Colors.red,
      child: IconButton(
        icon: Icon(Icons.delete),
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Delete Order(${billsModel.compmstDet!.sHORTNAME}-${billsModel.vNO})"),
                content: Text("Are you sure you want to delete this Order?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await deleteStart(context, billsModel);
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  deleteStart(BuildContext context, BillsModel billsModel) async {
    Myf.showBlurLoading(context);
    await fireBCollection
        .collection("supuser")
        .doc(loginUserModel.cLIENTNO)
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .doc(billsModel.ide)
        .get(fireGetOption)
        .then((value) async {
      if (value.exists) {
        var snp = value.data();
        BillsDeleteModel billsDeleteModel = BillsDeleteModel(
            ide: "${billsModel.ide}",
            type: billsModel.tYPE,
            vno: billsModel.vNO.toString(),
            cno: billsModel.cNO,
            dBy: loginUserModel.loginUser,
            dTime: DateTime.now().toString());
        await fireBCollection
            .collection("supuser")
            .doc(loginUserModel.cLIENTNO)
            .collection("EMPIRE")
            .doc(GLB_CURRENT_USER["yearVal"])
            .collection("EMP_ORDER_DELETED")
            .doc("${billsDeleteModel.ide}-${DateTime.now().toString()}")
            .set(billsDeleteModel.toJson())
            .then((value) async {
          await fireBCollection
              .collection("supuser")
              .doc(loginUserModel.cLIENTNO)
              .collection("EMPIRE")
              .doc(GLB_CURRENT_USER["yearVal"])
              .collection("EMP_ORDER")
              .doc("${billsModel.ide}")
              .delete()
              .then((value) async {
            await SyncLocalFunction.onlyOrderFetch();
            Navigator.pop(context);
            Navigator.pop(context);
            Myf.showMyDialog(context, "DELETED", "successfully");
          }).onError((error, stackTrace) {
            Myf.snakeBar(context, "$error");
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
      }
    });
  }

  static Widget statusorderOption(BillsModel billsModel, BuildContext context) {
    return DropdownButton(
        value: billsModel.status,
        items: ["pending", "confirm", "rejected"]
            .map((e) => DropdownMenuItem(
                  child: Chip(
                      backgroundColor: "${billsModel.status}".contains("pending")
                          ? Colors.blue
                          : "${billsModel.status}".contains("rejected")
                              ? Colors.red
                              : Colors.green,
                      label: Text(e)),
                  value: e,
                ))
            .toList(),
        onChanged: "${billsModel.status}".contains("confirm")
            ? null
            : (var val) async {
                Myf.showBlurLoading(context);
                billsModel.status = "${val}";
                billsModel.mTime = DateTime.now().toString();
                await fireBCollection
                    .collection("supuser")
                    .doc(loginUserModel.cLIENTNO)
                    .collection("EMPIRE")
                    .doc(GLB_CURRENT_USER["yearVal"])
                    .collection("EMP_ORDER")
                    .doc(billsModel.ide)
                    .update(billsModel.toJson());
                await SyncLocalFunction.onlyOrderFetch();
                Navigator.pop(context);
              });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
