import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderListPendingCubit extends Cubit<EmpOrderListPendingCubitState> {
  var isDisposed = false;
  BuildContext context;
  var ctrlEmpOrderSearch = TextEditingController();

  final ScrollController scrollController = ScrollController();
  List<BillsModel> billsModelList = [];
  List<BillsModel> filterBillsModelList = [];
  var status;
  EmpOrderListPendingCubit(this.context, this.status) : super(EmpOrderListPendingInitial()) {
    getData(context);
  }

  void getData(BuildContext context) async {
    if (!isDisposed) emit(EmpOrderListPendingStateLoadOrder(widget: Center(child: CircularProgressIndicator())));
    await Future.delayed(Duration(milliseconds: 100));
    var orderBy = fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .where("ordCnfB", isEqualTo: status)
        .where("cBy", isEqualTo: "${loginUserModel.loginUser}");
    if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true) {
      orderBy = fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMPIRE")
          .doc(GLB_CURRENT_USER["yearVal"])
          .collection("EMP_ORDER")
          .where("ordCnfB", isEqualTo: status);
    }
    orderBy.snapshots().listen((event) {
      billsModelList.clear();
      event.docs.forEach((element) {
        BillsModel billsModel = BillsModel.fromJson(Myf.convertMapKeysToString(element.data()));
        billsModelList.add(billsModel);
      });
      billsModelList = billsModelList;
      billsModelList.sort((a, b) => b.date!.compareTo(a.date!));
      loadData();
    });
  }

  void loadData() {
    var qry = ctrlEmpOrderSearch.text.toUpperCase();
    if (qry.isNotEmpty) {
      filterBillsModelList = billsModelList.where((element) {
        return "${element.vNO}${element.masterDet!.partyname}${element.masterDet!.city}".toUpperCase().contains("$qry");
      }).toList();
    } else {
      filterBillsModelList = billsModelList;
    }
    Widget widget = OrderList();
    if (!isDisposed) emit(EmpOrderListPendingStateLoadOrder(widget: widget));
  }

  Widget OrderList() {
    if (filterBillsModelList.isEmpty) {
      return Center(
        child: Text("No Data Found"),
      );
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: filterBillsModelList.length,
      itemBuilder: (context, index) {
        BillsModel billsModel = filterBillsModelList[index];
        return Emporderlistclass().EmpOrderListCard(context, billsModel);
      },
    );
  }
}

abstract class EmpOrderListPendingCubitState {}

class EmpOrderListPendingInitial extends EmpOrderListPendingCubitState {}

class EmpOrderListPendingStateLoadOrder extends EmpOrderListPendingCubitState {
  Widget widget;
  EmpOrderListPendingStateLoadOrder({required this.widget});
}
