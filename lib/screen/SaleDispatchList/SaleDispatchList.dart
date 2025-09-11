import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:empire_ios/Models/BillsDeleteModel.dart';
import 'package:empire_ios/Models/BillDispatchModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListClass.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListHome.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/screen/SaleDispatch/SaleDispatch.dart';
import 'package:empire_ios/screen/SaleDispatch/SaleDispatchCubit.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaleDispatchList extends StatefulWidget {
  SaleDispatchList({
    Key? key,
  }) : super(key: key);

  @override
  State<SaleDispatchList> createState() => _SaleDispatchListState();
}

class _SaleDispatchListState extends State<SaleDispatchList> {
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _orders = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _documentLimit = 15;
  DocumentSnapshot? _lastDocument;
  var ctrlEmpOrderSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchOrders();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });
    Query query = fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_SALE_DISPATCH")
        .orderBy("date", descending: true)
        .limit(_documentLimit);
    if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true) {
      query = fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMPIRE")
          .doc(GLB_CURRENT_USER["yearVal"])
          .collection("EMP_SALE_DISPATCH")
          .orderBy("date", descending: true)
          .limit(_documentLimit);
    }

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _orders.addAll(querySnapshot.docs);
    }

    setState(() {
      _isLoading = false;
      _hasMore = querySnapshot.docs.length == _documentLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: jsmColor, title: Text('Sale Dispatch List'), actions: []),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: jsmColor)),
          width: widthResponsive(context),
          child: Column(
            children: [
              Expanded(
                child: _orders.isEmpty
                    ? Center(child: Text('No data found'))
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(color: Colors.black),
                        controller: _scrollController,
                        itemCount: _orders.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _orders.length) {
                            return Center(child: CircularProgressIndicator());
                          }
                          dynamic order = _orders[index].data();
                          BillDispatchModel billDispatchModel = BillDispatchModel.fromJson(Myf.convertMapKeysToString(order));
                          return ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => SaleDispatchCubit(context, billDispatchModel: billDispatchModel),
                                          child: SaleDispatch(),
                                        )),
                              );
                              _hasMore = true;
                              _isLoading = false;
                              _fetchOrders();
                            },
                            leading: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text("${billDispatchModel.VNO.toString().padLeft(5, '0')}"),
                            ),
                            title: Row(
                              children: [
                                Text("${billDispatchModel.masterModel!.partyname}", style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${Myf.dateFormateInDDMMYYYY(billDispatchModel.date)}"),
                                Text(
                                    "By:${Myf.getUserNameString(billDispatchModel.cBy ?? "")}  at ${Myf.dateFormateYYYYMMDD(billDispatchModel.cTime, formate: "dd-MM-yyyy hh:mm a")}"),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => SaleDispatchCubit(context, billDispatchModel: BillDispatchModel()),
                      child: SaleDispatch(),
                    )),
          );
          _hasMore = true;
          _isLoading = false;
          _fetchOrders();
        },
        child: Icon(Icons.add),
        backgroundColor: jsmColor,
      ),
    );
  }
}
