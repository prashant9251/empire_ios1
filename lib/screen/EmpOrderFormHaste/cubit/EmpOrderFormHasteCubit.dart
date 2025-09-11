import 'package:empire_ios/Models/HasteModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubitState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmpOrderFormHasteCubit extends Cubit<EmpOrderFormHasteCubitState> {
  var filterParty = "";
  BuildContext context;
  List HASTE = [];
  List<HasteModel> hasteList = [];
  List<HasteModel> filterList = [];
  Widget widget = SizedBox.shrink();

  Box? CuHiveBox;
  EmpOrderFormHasteCubit(this.context) : super(EmpOrderFormHasteCubitStateIni()) {}

  void getData() async {
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    if (hasteList.length == 0) {
      CuHiveBox = await Hive.openBox("${databasId}HASTE");

      HASTE = await CuHiveBox!.get("${databasId}HASTE", defaultValue: []) as List<dynamic>;
      CuHiveBox!.close();
      hasteList = await HASTE.map((json) => HasteModel.fromJson(Myf.convertMapKeysToString(json))).toList();
      queryData("");
    }
  }

  void queryData(String query) async {
    if (query.isNotEmpty) {
      filterList = hasteList.where((element) {
        return element.hS!.toUpperCase().contains("$query");
      }).toList();
    } else {
      if (filterParty.isNotEmpty) {
        filterList = hasteList.where((element) {
          return element.aD == filterParty;
        }).toList();
      } else {
        filterList = hasteList;
      }
    }
    widget = Expanded(child: listView());
    emit(EmpOrderFormHasteCubitStateLoadHate(widget));
  }

  Widget listView() {
    filterList.sort(
      (a, b) {
        return (a.hS!).compareTo((b.hS!));
      },
    );
    if (filterList.length == 0) {
      return Center(child: Text("Haste not found  \n$filterParty"));
    }
    return ListView.builder(
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        return card(filterList[index]);
      },
    );
  }

  Card card(HasteModel hasteModel) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context, hasteModel);
        },
        title: Text(
          "${hasteModel.hS}",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("City:${hasteModel.sT}", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
