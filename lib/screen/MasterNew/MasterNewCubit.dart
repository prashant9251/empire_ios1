import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BusinessCard/BusinessCard.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/MasterNew/MasterNew.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MasterNewCubit extends Cubit<MasterNewState> {
  List<MasterModel> masterList = [];
  List<String> cityList = [];

  List<MasterModel> filteredMasterList = [];
  var ctrlSearch = TextEditingController();
  MasterNewCubit() : super(MasterNewInitial());

  Future<void> getData() async {
    emit(MasterNewLoadData(skeletonShowInList()));
    LazyBox<dynamic> lazyBoxMst = await SyncLocalFunction.openLazyBoxCheck("MST");
    for (var i = 0; i < lazyBoxMst.length; i++) {
      var item = await lazyBoxMst.getAt(i);
      if (item != null) {
        try {
          MasterModel masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(item));
          if (masterModel.city != null && !cityList.contains(masterModel.city)) {
            cityList.add(masterModel.city!);
          }
          masterList.add(masterModel);
        } catch (e) {}
      }
    }
    loadData();
  }

  void loadData() async {
    filteredMasterList = masterList;
    await Future.delayed(const Duration(milliseconds: 500));
    if (MasterFilter["ATYPE"] != null && MasterFilter["ATYPE"] != "") {
      filteredMasterList = filteredMasterList.where((element) {
        return element.aTYPE == MasterFilter["ATYPE"];
      }).toList();
    }
    if (MasterFilter["broker"] != null && MasterFilter["broker"] != "") {
      filteredMasterList = filteredMasterList.where((element) {
        return element.broker == MasterFilter["broker"];
      }).toList();
    }
    if (MasterFilter["city"] != null && MasterFilter["city"] != "") {
      filteredMasterList = filteredMasterList.where((element) {
        return element.city == MasterFilter["city"];
      }).toList();
    }
    if (ctrlSearch.text.isNotEmpty) {
      filteredMasterList = filteredMasterList.where((element) {
        return element.partyname?.toLowerCase().contains(ctrlSearch.text.toLowerCase()) ?? false;
      }).toList();
    } else {
      filteredMasterList = filteredMasterList;
    }
    filteredMasterList.sort((a, b) {
      return a.partyname?.toLowerCase().compareTo(b.partyname?.toLowerCase() ?? "") ?? 0;
    });
    Widget widget = getDataMaster();
    emit(MasterNewLoadData(widget));
  }

  Widget getDataMaster() {
    return ListView.builder(
      itemCount: filteredMasterList.length > 500 ? 500 : filteredMasterList.length,
      itemBuilder: (context, index) {
        return BusinessCard(masterModel: filteredMasterList[index]);
      },
    );
  }

  Widget skeletonShowInList() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ShimmerSkelton(height: 100, width: double.infinity);
      },
    );
  }
}

abstract class MasterNewState {}

class MasterNewInitial extends MasterNewState {}

class MasterNewLoadData extends MasterNewState {
  final Widget widget;

  MasterNewLoadData(this.widget);
}
