import 'package:flutter/material.dart';

abstract class EmpOrderFormHasteCubitState {}

class EmpOrderFormHasteCubitStateIni extends EmpOrderFormHasteCubitState {}

class EmpOrderFormHasteCubitStateLoading extends EmpOrderFormHasteCubitState {}

class EmpOrderFormHasteCubitStateLoadHate extends EmpOrderFormHasteCubitState {
  Widget widget;
  EmpOrderFormHasteCubitStateLoadHate(this.widget);
}
