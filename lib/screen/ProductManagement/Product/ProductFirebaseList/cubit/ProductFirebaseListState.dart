import 'package:flutter/material.dart';

abstract class ProductFirebaseListState {}

class ProductFirebaseListStateIni extends ProductFirebaseListState {}

class ProductFirebaseListStateLoading extends ProductFirebaseListState {}

class ProductFirebaseListStateLoadProduct extends ProductFirebaseListState {
  Widget widget;
  ProductFirebaseListStateLoadProduct(this.widget);
}
