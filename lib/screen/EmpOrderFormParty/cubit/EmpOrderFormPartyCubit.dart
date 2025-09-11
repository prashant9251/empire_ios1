import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/localRequest/getMst.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubitState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmpOrderFormPartyCubit extends Cubit<EmpOrderFormPartyCubitState> {
  BuildContext context;
  List<MasterModel> filterList = [];
  List MST = [];
  var isDisposed = false;
  String Atype = "1";
  Widget widget = SizedBox.shrink();

  LazyBox? CuHiveBox;
  EmpOrderFormPartyCubit(this.context) : super(EmpOrderFormPartyCubitStateIni()) {}
  var iniLoad = true;
  void getData() async {
    if (iniLoad == true) {
      if (!isDisposed) emit(EmpOrderFormPartyCubitStateLoadPraty(Expanded(child: Center(child: CircularProgressIndicator()))));
      iniLoad = false;
    }
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    // Box EMP_MST = await SyncLocalFunction.openBoxCheck("EMP_MST");
    // masterList = EMP_MST.values.map((e) {
    //   return MasterModel.fromJson(Myf.convertMapKeysToString(e));
    // }).toList();
    // await EMP_MST.close();
    if (masterList.length == 0) {
      CuHiveBox = await SyncLocalFunction.openLazyBoxCheck("MST");
      MST = await CuHiveBox!.get("${databasId}MST", defaultValue: []) as List<dynamic>;
      await CuHiveBox!.close();
      masterList = await compute(
        (List<dynamic> list) => list.map((json) => MasterModel.fromJson(Myf.convertMapKeysToString(json))).toList(),
        MST,
      );
      await fireBCollection
          .collection("supuser")
          .doc(loginUserModel.cLIENTNO)
          .collection("EMP_MST")
          .where("eTyp", isEqualTo: "LIVE")
          .get(fireGetOption)
          .then(
        (value) async {
          await Future.wait(value.docs.map((e) async {
            var json = e.data();
            MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(json));
            masterList.add(masterModel);
          }).toList());
        },
      );
    }
    await getMst.start({});
    queryData("");
  }

  closeHive() async {
    if (CuHiveBox != null) {
      CuHiveBox!.close();
    }
  }

  void queryData(String query) async {
    try {
      if (iniLoad == false) {
        if (!isDisposed) emit(EmpOrderFormPartyCubitStateLoadPraty(Expanded(child: Center(child: CircularProgressIndicator()))));
        await Future.delayed(Duration(milliseconds: 250));
      }

      if (query.isNotEmpty) {
        List<String> queryTokens = query.toLowerCase().split(' ');

        filterList = masterList.where((element) {
          List<String> combinedTokens = [
            element.partyname.toString(),
          ].join(' ').toLowerCase().split(' ');

          return queryTokens.every((queryToken) {
            return combinedTokens.any((token) => token.startsWith(queryToken)) && element.aTYPE == Atype;
          });
        }).toList();
      } else {
        filterList = masterList.where((element) => element.aTYPE == Atype).toList();
      }
      widget = Expanded(child: listView());
      if (!isDisposed) emit(EmpOrderFormPartyCubitStateLoadPraty(widget));
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

  Card card(MasterModel masterModel) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context, masterModel);
        },
        title: Text(
          "${masterModel.partyname}",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${masterModel.aD1 ?? ""},${masterModel.aD2 ?? ""},${masterModel.city ?? ""}"),
            Text("${masterModel.gST ?? ""}"),
            Row(
              children: [
                Flexible(child: Text("Agent:", style: TextStyle(fontWeight: FontWeight.bold))),
                Flexible(child: Text("${masterModel.broker ?? ""}")),
              ],
            ),
            if (empOrderSettingModel.sDhara ?? false)
              Row(
                children: [
                  Flexible(child: Text("Dhara:", style: TextStyle(fontWeight: FontWeight.bold))),
                  Flexible(child: Text("${masterModel.dhara ?? ""}")),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
