import 'package:flutter/material.dart';

abstract class CrmHomeState {}

class CrmHomeStateIni extends CrmHomeState {}

class CrmHomeStateLoadFollowUpCountWidget extends CrmHomeState {
  Widget widget;
  CrmHomeStateLoadFollowUpCountWidget(this.widget);
}
