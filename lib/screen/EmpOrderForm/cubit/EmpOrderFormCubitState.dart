import 'dart:async';

import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/PackingStyleModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../EmpOrderForm.dart';

abstract class EmpOrderFormCubitState {}

class EmpOrderFormCubitStateIni extends EmpOrderFormCubitState {}

class EmpOrderFormCubitStateLoading extends EmpOrderFormCubitState {}

class EmpOrderFormCubitStateError extends EmpOrderFormCubitState {
  String error;
  EmpOrderFormCubitStateError(this.error);
}

class EmpOrderFormCubitStateInput extends EmpOrderFormCubitState {}

class EmpOrderFormCubitStateLoadProduct extends EmpOrderFormCubitState {
  Widget widget;
  EmpOrderFormCubitStateLoadProduct(this.widget);
}

class EmpOrderFormCubitStateColorLoad extends EmpOrderFormCubitState {
  Widget widget;
  EmpOrderFormCubitStateColorLoad(this.widget);
}

class EmpOrderFormCubitStateSelectCompany extends EmpOrderFormCubitState {
  BuildContext context;
  List COMPMST = [];
  List<CompmstModel> companyList = [];

  EmpOrderFormCubitStateSelectCompany(this.context);
  selectCompanyByFirmName() async {
    CompmstModel compmstModel = CompmstModel();
    await getData();
    if (ctrlFirmName.text.isNotEmpty) {
      await Future.wait(companyList.map((e) async {
        if (e.fIRM == ctrlFirmName.text) {
          compmstModel = e;
        }
      }).toList());
    }
    return compmstModel;
  }

  selectCompany() async {
    await getData();
    final Completer<CompmstModel?> _companyCompleter = Completer<CompmstModel?>();

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: this.context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Text(
                "SELECT COMPANY",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              Divider(),
              SizedBox(height: 10),
              ...companyList
                  .map((companyModel) => ListTile(
                        onTap: () async {
                          _companyCompleter.complete(companyModel);
                          Navigator.pop(context, companyModel);
                        },
                        leading: CircleAvatar(
                          child: Text("${companyModel.cNO}"),
                        ),
                        title: Text("${companyModel.fIRM}"),
                        trailing: Icon(Icons.ads_click),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
    return _companyCompleter.future;
  }

  Future<void> getData() async {
    LazyBox CuHiveBox = await SyncLocalFunction.openLazyBoxCheck("COMPMST");
    try {
      var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
      if (!CuHiveBox.isOpen) {
        CuHiveBox = await SyncLocalFunction.openLazyBoxCheck("COMPMST");
      }
      COMPMST = await CuHiveBox.get("${databasId}COMPMST", defaultValue: []) as List<dynamic>;
      companyList = await COMPMST.map((json) => CompmstModel.fromJson(Myf.convertMapKeysToString(json))).toList();
      if (CuHiveBox.isOpen) {
        CuHiveBox.close();
      }
    } catch (e) {
      print("Error: $e");
      SyncLocalFunction.closeOpenBox("COMPMST");
    }
  }
}

class EmpOrderFormCubitStateSelectPacking extends EmpOrderFormCubitState {
  BuildContext context;
  EmpOrderFormCubitStateSelectPacking(this.context);

  selectPacking() async {
    final Completer<PackingStyleModel?> _companyCompleter = Completer<PackingStyleModel?>();
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: this.context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Text(
                "SELECT PACKING",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              Divider(),
              SizedBox(height: 10),
              ...packingStyleList
                  .map((packingStyleModel) => ListTile(
                        onTap: () async {
                          _companyCompleter.complete(packingStyleModel);
                          Navigator.pop(context, packingStyleModel);
                        },
                        title: Text("${packingStyleModel.packingStyle}"),
                        subtitle: Text("Packing charges: ${packingStyleModel.packingAdd}/-"),
                        trailing: Icon(Icons.ads_click),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
    return _companyCompleter.future;
  }
}
