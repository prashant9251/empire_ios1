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
import 'package:empire_ios/screen/EmpOrderListPending/EmpOrderListPendingCubit.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderListPending extends StatefulWidget {
  EmpOrderListPending({Key? key}) : super(key: key);

  @override
  State<EmpOrderListPending> createState() => _EmpOrderListPendingState();
}

class _EmpOrderListPendingState extends State<EmpOrderListPending> {
  late EmpOrderListPendingCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderListPendingCubit>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.ctrlEmpOrderSearch.dispose();
    cubit.isDisposed = true;
    // cubit.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextFormField(
          context,
          hintText: 'Search',
          controller: cubit.ctrlEmpOrderSearch,
          onFieldSubmitted: (val) {
            cubit.loadData();
          },
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              cubit.ctrlEmpOrderSearch.clear();
              cubit.loadData();
            },
            icon: Icon(Icons.reset_tv_rounded),
          ),
        ),
        Expanded(
          child: BlocBuilder<EmpOrderListPendingCubit, EmpOrderListPendingCubitState>(builder: (context, state) {
            if (state is EmpOrderListPendingStateLoadOrder) {
              return cubit.OrderList();
            }
            return SizedBox.shrink();
          }),
        ),
      ],
    );
  }
}
