import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:empire_ios/Models/BillsDeleteModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListClass.dart';
import 'package:empire_ios/screen/EmpOrderListHome/EmpOrderListHome.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderListNew extends StatefulWidget {
  String status;
  EmpOrderListNew({Key? key, required this.status}) : super(key: key);

  @override
  State<EmpOrderListNew> createState() => _EmpOrderListNewState();
}

class _EmpOrderListNewState extends State<EmpOrderListNew> {
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
        .collection("EMP_ORDER")
        .where("ordCnfB", isEqualTo: widget.status)
        .where("cBy", isEqualTo: "${loginUserModel.loginUser}")
        .orderBy("date", descending: true)
        .limit(_documentLimit);
    if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true) {
      query = fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMPIRE")
          .doc(GLB_CURRENT_USER["yearVal"])
          .collection("EMP_ORDER")
          .where("ordCnfB", isEqualTo: widget.status)
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
    return Column(
      children: [
        // buildTextFormField(
        //   context,
        //   hintText: 'Search',
        //   controller: ctrlEmpOrderSearch,
        //   onFieldSubmitted: (val) {
        //     _fetchOrders();
        //   },
        //   prefix: Icon(Icons.search),
        //   suffix: IconButton(
        //     onPressed: () {
        //       _fetchOrders();
        //     },
        //     icon: Icon(Icons.reset_tv_rounded),
        //   ),
        // ),
        Expanded(
          child: _orders.isEmpty
              ? Center(child: Text('No data found'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _orders.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _orders.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    dynamic order = _orders[index].data();
                    BillsModel billsModel = BillsModel.fromJson(Myf.convertMapKeysToString(order));
                    return Emporderlistclass().EmpOrderListCard(context, billsModel);
                  },
                ),
        ),
      ],
    );
  }
}
