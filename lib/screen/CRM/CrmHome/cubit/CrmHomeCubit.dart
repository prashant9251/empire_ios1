import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmHome/cubit/CrmHomeState.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CrmHomeCubit extends Cubit<CrmHomeState> {
  BuildContext context;
  List<CrmFollowUpModel> crmFollowUpModelList = [];
  CrmHomeCubit(this.context) : super(CrmHomeStateIni()) {}

  geData() async {
    crmFollowUpModelList = [];
    var databaseId = Myf.databaseId(GLB_CURRENT_USER);
    LazyBox CRM_FOLLOW_UP_LIST_BOX = await Hive.openLazyBox("${databaseId}CRM_FOLLOW_UP_LIST");
    for (var i = 0; i < CRM_FOLLOW_UP_LIST_BOX.length; i++) {
      dynamic d = await CRM_FOLLOW_UP_LIST_BOX.getAt(i);
      CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(d));
      crmFollowUpModelList.add(crmFollowUpModel);
    }
    // CRM_FOLLOW_UP_LIST_BOX
  }
}
