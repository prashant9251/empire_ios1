// import 'dart:async';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:empire_ios/Models/BillDetModel.dart';
// import 'package:empire_ios/Models/ColorModel.dart';
// import 'package:empire_ios/main.dart';
// import 'package:empire_ios/screen/EMPIRE/Myf.dart';
// import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
// import 'package:empire_ios/screen/EmpOrderFormColor/EmpOrderFormColor.dart';
// import 'package:empire_ios/screen/EmpOrderFormColor/cubit/EmpOrderFormColorCubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EmpOrderFormColorCard extends StatefulWidget {
//   List<ColorModel>? colorList;
//   EmpOrderFormColorCard({Key? key, required this.colorList}) : super(key: key);

//   @override
//   State<EmpOrderFormColorCard> createState() => _EmpOrderFormColorCardState();
// }

// class _EmpOrderFormColorCardState extends State<EmpOrderFormColorCard> {
//   final StreamController<bool> thisScreenChangeStream = StreamController<bool>.broadcast();
//   late EmpOrderFormCubit cubit;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     cubit = BlocProvider.of<EmpOrderFormCubit>(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.colorList = widget.colorList == null ? [] : widget.colorList;
//     return;
//   }

// }
