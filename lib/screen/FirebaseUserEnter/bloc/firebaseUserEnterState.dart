abstract class firebaseUserEnterState {}

class firebaseUserEnterStateIni extends firebaseUserEnterState {}

class firebaseUserEnterStateloading extends firebaseUserEnterState {}

class firebaseUserEnterStateError extends firebaseUserEnterState {
  String error;
  firebaseUserEnterStateError(this.error);
}

class firebaseUserEnterStateLoadComplete extends firebaseUserEnterState {
  dynamic firebaseCurrntUserObj;
  firebaseUserEnterStateLoadComplete(this.firebaseCurrntUserObj);
}
