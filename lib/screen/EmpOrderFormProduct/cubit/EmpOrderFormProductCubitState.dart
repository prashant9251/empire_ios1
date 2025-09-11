import 'package:flutter/material.dart';

abstract class EmpOrderFormProductCubitState {}

class EmpOrderFormProductCubitStateIni extends EmpOrderFormProductCubitState {}

class EmpOrderFormProductCubitStateLoadProduct extends EmpOrderFormProductCubitState {
  Widget widget;
  EmpOrderFormProductCubitStateLoadProduct(this.widget);
}

class EmpOrderFormProductCubitStateLoadSelected extends EmpOrderFormProductCubitState {
  Widget widget;
  EmpOrderFormProductCubitStateLoadSelected(this.widget);
}
