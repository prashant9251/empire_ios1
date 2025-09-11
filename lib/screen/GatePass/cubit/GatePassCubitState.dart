import 'package:flutter/material.dart';

abstract class GatePassCubitState {}

class GatePassCubitStateIni extends GatePassCubitState {}

class GatePassCubitSreeenLoad extends GatePassCubitState {
  Widget widget;
  GatePassCubitSreeenLoad(this.widget);
}

class GatePassCubitLoadBill extends GatePassCubitState {
  Widget widget;
  GatePassCubitLoadBill(this.widget);
}
