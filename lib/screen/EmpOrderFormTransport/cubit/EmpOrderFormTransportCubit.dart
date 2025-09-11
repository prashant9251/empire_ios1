import 'package:empire_ios/Models/TransportModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/cubit/EmpOrderFormTransportState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmpOrderFormTransportCubit extends Cubit<EmpOrderFormTransportState> {
  BuildContext context;

  Widget widget = SizedBox.shrink();

  List TRANSPORT = [];

  List<TransportModel> transportList = [];

  List<TransportModel> filterList = [];
  EmpOrderFormTransportCubit(this.context) : super(EmpOrderFormTransportStateIni()) {
    getData();
  }

  void getData() async {
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    var CuHiveBox = await Hive.openLazyBox("${databasId}TRANSPORT");
    TRANSPORT = await CuHiveBox.get("${databasId}TRANSPORT", defaultValue: []) as List<dynamic>;
    transportList = await TRANSPORT.map((json) => TransportModel.fromJson(Myf.convertMapKeysToString(json))).toList();
    await CuHiveBox.close();
    queryData("");
  }

  void queryData(String query) async {
    if (query.isNotEmpty) {
      filterList = transportList.where((element) {
        return element.label!.toUpperCase().contains("$query");
      }).toList();
    } else {
      filterList = transportList;
    }
    widget = Expanded(child: listView());
    emit(EmpOrderFormTransportStateLoadTransport(widget));
  }

  Widget listView() {
    return ListView.builder(
      itemCount: filterList.length,
      itemBuilder: (context, index) {
        return card(filterList[index]);
      },
    );
  }

  Card card(TransportModel transportModel) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pop(context, transportModel);
        },
        title: Text(
          "${transportModel.label}",
          style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${transportModel.value}"),
      ),
    );
  }
}
