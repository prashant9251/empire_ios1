import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../../main.dart';
import 'OfficeRequestTabsState.dart';

class OfficeRequestTabsCubits extends Cubit<OfficeRequestTabsState> {
  OfficeRequestTabsCubits() : super(OfficeRequestTabsStateLoading()) {
    getStreamFireStore();
  }
  final Stream<QuerySnapshot<Map<String, dynamic>>> _dataStream = fireBCollection
      .collection("${GLB_CURRENT_USER["collectionName"]}")
      .where("m_time", isGreaterThan: "${GLB_CURRENT_USER["orderLocalSyncTime"]}")
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get dataStream => _dataStream;
  void getStreamFireStore({UserObj}) async {
    try {
      fireBCollection
          .collection("${UserObj["collectionName"]}")
          .where("m_time", isGreaterThan: "${UserObj["orderLocalSyncTime"]}")
          .snapshots()
          .listen((event) async {
        final snpData = event.docs; // Null-safe access to data
        Box box;
        if (Hive.isBoxOpen("${UserObj["collectionName"]}")) {
          box = Hive.box("${UserObj["collectionName"]}");
        } else {
          box = await Hive.openBox("${UserObj["collectionName"]}");
        }
        if (snpData != null && snpData.isNotEmpty) {
          if (snpData.length > 0) {
            await Future.wait(snpData.map((e) async {
              final id = e.id;
              dynamic d = await e.data();
              await box.put(id, d);
            }).toList());
          }
          emit(OfficeRequestTabsStateBoxReturn(box));
        }
      });
      List<OfficeRequestTabModel> req = [];
      emit(OfficeRequestTabsStateDataLoaded(req));
    } catch (e) {
      emit(OfficeRequestTabsStateError(e.toString()));
    }
  }
}
