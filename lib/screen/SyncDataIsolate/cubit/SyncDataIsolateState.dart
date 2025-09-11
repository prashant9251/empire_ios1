abstract class SyncDataIsolateState {}

class SyncDataIsolateStateIni extends SyncDataIsolateState {}

class SyncDataIsolateStateLoading extends SyncDataIsolateState {}

class SyncDataIsolateStateDownloadProgressUpdate extends SyncDataIsolateState {
  double progress;
  double savingProgress;
  String msg;
  Map map;
  SyncDataIsolateStateDownloadProgressUpdate(this.progress, this.savingProgress, this.msg, this.map);
}

class SyncDataIsolateStateError extends SyncDataIsolateState {
  String error;
  SyncDataIsolateStateError(this.error);
}
