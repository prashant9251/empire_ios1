import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:hive/hive.dart';

abstract class OfficeRequestTabsState {}

class OfficeRequestTabsStateLoading extends OfficeRequestTabsState {}

class OfficeRequestTabsStateDataLoaded extends OfficeRequestTabsState {
  final List<OfficeRequestTabModel> req;
  OfficeRequestTabsStateDataLoaded(this.req);
}

class OfficeRequestTabsStateBoxReturn extends OfficeRequestTabsState {
  final Box box;
  OfficeRequestTabsStateBoxReturn(this.box);
}

class OfficeRequestTabsStateError extends OfficeRequestTabsState {
  String error;
  OfficeRequestTabsStateError(this.error);
}
