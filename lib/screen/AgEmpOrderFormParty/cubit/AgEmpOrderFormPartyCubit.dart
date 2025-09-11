import 'package:empire_ios/Models/AgMasterModel.dart';
import 'package:empire_ios/localRequest/getMst.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/AgEmpOrderFormParty/cubit/AgEmpOrderFormPartyState.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

List<AgMasterModel> masterList = [];

class AgEmpOrderFormPartyCubit extends Cubit<AgEmpOrderFormPartyCubitState> {
  BuildContext context;
  List<AgMasterModel> filterList = [];
  List MST = [];

  String Atype = "1";
  Widget widget = SizedBox.shrink();

  Box? CuHiveBox;

  var purchaserMobileNO;

  var staffMobile;
  AgEmpOrderFormPartyCubit(this.context, {this.purchaserMobileNO, this.staffMobile}) : super(AgEmpOrderFormPartyCubitStateIni()) {}

  void getData() async {
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    // Box EMP_MST = await SyncLocalFunction.openBoxCheck("EMP_MST");
    // masterList = EMP_MST.values.map((e) {
    //   return AgMasterModel.fromJson(Myf.convertMapKeysToString(e));
    // }).toList();
    // await EMP_MST.close();
    // if (masterList.length == 0) {}
    queryData("");
  }

  closeHive() async {
    if (CuHiveBox != null) {
      CuHiveBox!.close();
    }
  }

  void queryData(String query) async {
    try {
      emit(AgEmpOrderFormPartyCubitStateLoadPraty(Expanded(child: Center(child: CircularProgressIndicator()))));
      await Future.delayed(Duration(milliseconds: 250));

      if (query.isNotEmpty) {
        filterList = masterList.where((element) {
          return element.label!.toUpperCase().contains("$query") && element.atype == Atype;
        }).toList();
      } else {
        filterList = masterList.where((element) => element.atype == Atype).toList();
      }
      if (purchaserMobileNO != null && !loginUserModel.loginUser.toString().toUpperCase().contains("ADMIN")) {
        filterList = filterList.where((element) {
          return "${element.wm}${element.wm2}${element.wm3}${element.wm4}".contains(purchaserMobileNO);
        }).toList();
      }
      if (staffMobile != null && !loginUserModel.loginUser.toString().toUpperCase().contains("ADMIN")) {
        filterList = filterList.where((element) {
          return "${element.brokerModel!.wm}${element.brokerModel!.wm2}${element.brokerModel!.wm3}${element.brokerModel!.wm4}".contains(staffMobile);
        }).toList();
      }
      widget = Expanded(child: listView());
      emit(AgEmpOrderFormPartyCubitStateLoadPraty(widget));
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

  Card card(AgMasterModel agMasterModel) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context, agMasterModel);
        },
        title: Text(
          "${agMasterModel.partyname}",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Address:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${agMasterModel.ad1},${agMasterModel.ad2},${agMasterModel.city}"),
            Text("${agMasterModel.gst}"),
          ],
        ),
      ),
    );
  }
}
