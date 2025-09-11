import 'package:empire_ios/Models/AgAcGroupModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/localRequest/getMst.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

List<AgAcGroupModel> acGroupList = [];

class AgEmpOrderAcGroupCubit extends Cubit<AgEmpOrderAcGroupCubitState> {
  BuildContext context;
  List<AgAcGroupModel> filterList = [];
  List ACGROUP = [];

  Widget widget = SizedBox.shrink();

  Box? CuHiveBox;
  AgEmpOrderAcGroupCubit(this.context) : super(AgEmpOrderAcGroupCubitStateIni()) {}

  void getData() async {
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    if (acGroupList.length == 0) {
      CuHiveBox = await Hive.openBox("${databasId}ACGROUP");
      ACGROUP = await CuHiveBox!.get("${databasId}ACGROUP", defaultValue: []) as List<dynamic>;
      await CuHiveBox!.close();
      acGroupList = await ACGROUP.map((json) => AgAcGroupModel.fromJson(Myf.convertMapKeysToString(json))).toList();
    }
    queryData("");
  }

  closeHive() async {
    if (CuHiveBox != null) {
      CuHiveBox!.close();
    }
  }

  void queryData(String query) async {
    try {
      emit(AgEmpOrderAcGroupCubitStateLoadPraty(Expanded(child: Center(child: CircularProgressIndicator()))));
      await Future.delayed(Duration(milliseconds: 250));

      if (query.isNotEmpty) {
        filterList = acGroupList.where((element) {
          return element.label!.toUpperCase().contains("$query");
        }).toList();
      } else {
        filterList = acGroupList;
      }
      widget = Expanded(child: listView());
      emit(AgEmpOrderAcGroupCubitStateLoadPraty(widget));
    } catch (e) {}
  }

  Widget listView() {
    var length = filterList.length;
    if (length > 0) {
      return ListView.builder(
        itemCount: length > 500 ? 500 : length,
        itemBuilder: (context, index) {
          return card(filterList[index]);
        },
      );
    } else {
      return Center(child: Text("No Data Found"));
    }
  }

  Card card(AgAcGroupModel acGroupModel) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context, acGroupModel);
        },
        title: Text(
          "${acGroupModel.label}",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}

abstract class AgEmpOrderAcGroupCubitState {}

class AgEmpOrderAcGroupCubitStateIni extends AgEmpOrderAcGroupCubitState {}

class AgEmpOrderAcGroupCubitStateLoadPraty extends AgEmpOrderAcGroupCubitState {
  Widget widget;
  AgEmpOrderAcGroupCubitStateLoadPraty(this.widget);
}
