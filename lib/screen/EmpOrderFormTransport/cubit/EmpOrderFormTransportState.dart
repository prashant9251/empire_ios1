import 'package:flutter/material.dart';

abstract class EmpOrderFormTransportState {}

class EmpOrderFormTransportStateIni extends EmpOrderFormTransportState {}

class EmpOrderFormTransportStateLoading extends EmpOrderFormTransportState {}

class EmpOrderFormTransportStateLoadTransport extends EmpOrderFormTransportState {
  Widget widget;

  EmpOrderFormTransportStateLoadTransport(this.widget);
}
