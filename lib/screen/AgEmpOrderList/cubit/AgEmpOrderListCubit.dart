import 'dart:async';

import 'package:csv/csv.dart';
import 'package:empire_ios/Models/AgEmpOrderModel.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillForCsvModel.dart';
import 'package:empire_ios/Models/BillsDeleteModel.dart';
import 'package:empire_ios/Models/AgEmpOrderModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/AgEmpOrderForm/AgEmpOrderForm.dart';
import 'package:empire_ios/screen/AgEmpOrderList/cubit/AgEmpOrderListState.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/screen/EmpOrderView/EmpOrderView.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

StreamController<bool> tablecheckBoxStream = StreamController<bool>.broadcast();

class AgEmpOrderListCubit extends Cubit<AgEmpOrderListState> {
  DateTime? fromDate;
  DateTime? toDate;
  bool isTableLoad = false;
  bool isDisposed = false;
  BuildContext context;
  var statusList = ["All", "pending", "confirm", "rejected"];

  // Box? EMP_ORDER;

  List<AgEmpOrderModel> EMP_ORDER_LIST = [];
  List<AgEmpOrderModel> filteredList = [];
  List<DataRow> rowtable = [];

  var reportView;

  var statusFilter = "";

  var limitFilter = "50";

  var selectAll = false;
  AgEmpOrderListCubit(this.context) : super(AgEmpOrderListStateIni()) {
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
    // await EMP_ORDER.clear();
    if (EMP_ORDER != null) {
      EMP_ORDER_LIST = [];
      // logger.d(EMP_ORDER.values)
      await Future.wait(EMP_ORDER.values.map((e) async {
        var element = await AgEmpOrderModel.fromJson(Myf.convertMapKeysToString(e));
        // logger.d(element);
        if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true) {
          EMP_ORDER_LIST.add(element);
        } else if (element.cBy == loginUserModel.loginUser) {
          EMP_ORDER_LIST.add(element);
        }
        try {} catch (e) {}
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
        return "${element.VNO}${element.masterDet!.partyname!}${element.acGroupDet!.label!}${element.staff!}${element.transport!}".contains("$query");
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
      // emit(AgEmpOrderListStateLoadOrder(widget));
      // break;
      default:
        await loadTableView();

        isTableLoad = false;
    }
  }

  Future<void> loadTableView() async {
    Widget widget = await getViewTable();
    if (!isDisposed) emit(AgEmpOrderListStateLoadOrder(widget));
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
      return b.VNO.compareTo(a.VNO);
    });
    // ValueListenableBuilder(
    //   valueListenable: EMP_ORDER.listenable(),
    //   builder: (context, value, child) {

    //   },
    // );

    // return PaginationTable(filteredList: filteredList);
    return PaginatedDataTable(
      columnSpacing: 15,
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order List'),
        ],
      ),
      columns: [
        DataColumn(label: Text('VNO')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('CUSTOMER')),
        DataColumn(label: Text('SUPPLIER')),
        DataColumn(label: Text('SUPP.ORD NO')),
        DataColumn(label: Text('CASES')),
        DataColumn(label: Text('PCS')),
        DataColumn(label: Text('UNIT')),
        DataColumn(label: Text('RMK')),
        DataColumn(label: Text('TRANSPORT')),
        DataColumn(label: Text('STAFF')),
        DataColumn(label: Text('')),
        DataColumn(label: Text('')),
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

  void export(String csv) {
    if (kIsWeb) {
      // For web, initiate download in a web-specific way
      AgEmpOrderListStateDownload.downloadCSVWeb(csv, 'Empire Order ${loginUserModel.sHOPNAME!.replaceAll(".", "")}.csv', context);
    } else {
      // For mobile, initiate download in a mobile-specific way
      AgEmpOrderListStateDownload.downloadCSVMobile(csv, 'Empire Order ${loginUserModel.sHOPNAME!.replaceAll(".", "")}.csv');
    }
  }
}

class _YourDataSource extends DataTableSource {
  final List<AgEmpOrderModel> data;
  BuildContext context;
  _YourDataSource(this.data, this.context);

  @override
  DataRow getRow(int index) {
    AgEmpOrderModel billsModel = AgEmpOrderModel.fromJson(data[index].toJson());

    List<String?> parts = data[index].cBy.toString().split('@');
    var colorSTyle = "${billsModel.status}".contains("pending")
        ? Colors.white
        : "${billsModel.status}".contains("rejected")
            ? Colors.red
            : Colors.green;
    return DataRow(color: WidgetStateColor.resolveWith((states) => colorSTyle), cells: [
      DataCell(Text("${billsModel.VNO}")),
      DataCell(Text("${Myf.dateFormate(billsModel.date)}")),
      DataCell(Text("${billsModel.masterDet!.partyname}")),
      DataCell(Text("${billsModel.acGroupDet!.label}")),
      DataCell(Text("${billsModel.suppOrdNo}")),
      DataCell(Text("${billsModel.cases}")),
      DataCell(Text("${billsModel.qty}")),
      DataCell(Text("${billsModel.unit}")),
      DataCell(Text("${billsModel.rmk}")),
      DataCell(Text("${billsModel.transport}")),
      DataCell(Text("${billsModel.staff}")),
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
            CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                color: Colors.white,
                onPressed: () async {
                  // Myf.showBlurLoading(context);
                  // var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context);
                  // Myf.popScreen(context);
                },
                icon: Icon(Icons.print),
              ),
            ),
            if (billsModel.status != "confirm") ...[
              editorderOption(billsModel),
              if (firebaseCurrntUserObj["PERMISSION_DELETE_ORDER"] != false || loginUserModel.loginUser!.contains("ADMIN"))
                deleteBtn(context, billsModel),
            ],
          ],
        ),
      ),
    ]);
  }

  CircleAvatar editorderOption(AgEmpOrderModel billsModel) {
    return CircleAvatar(
        backgroundColor: Colors.deepOrangeAccent,
        child: IconButton(
            color: Colors.white,
            onPressed: () async {
              await Myf.Navi(
                  context,
                  BlocProvider(
                    create: (context) => AgEmpOrderListCubit(context),
                    child: AgEmpOrderForm(agEmpOrderModel: billsModel),
                  ));
              await SyncLocalFunction.onlyOrderFetch();
            },
            icon: Icon(Icons.edit)));
  }

  Widget deleteBtn(BuildContext context, AgEmpOrderModel billsModel) {
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
                title: Text("Confirm Delete Order (${billsModel.VNO})"),
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

  deleteStart(BuildContext context, AgEmpOrderModel billsModel) async {
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
            type: "O1",
            vno: billsModel.VNO.toString(),
            cno: billsModel.CNO,
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

  static Widget statusorderOption(AgEmpOrderModel billsModel, BuildContext context) {
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
