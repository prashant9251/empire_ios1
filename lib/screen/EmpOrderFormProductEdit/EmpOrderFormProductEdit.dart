import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/PackingStyleModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormSettings/EmpOrderFormSettings.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EmpOrderFormProductEdit extends StatefulWidget {
  BillDetModel billDetModel;
  EmpOrderFormProductEdit({Key? key, required this.billDetModel}) : super(key: key);

  @override
  State<EmpOrderFormProductEdit> createState() => _EmpOrderFormProductEditState();
}

class _EmpOrderFormProductEditState extends State<EmpOrderFormProductEdit> {
  var formKey = GlobalKey<FormState>();
  late BillDetModel billDetModel;
  StreamController<bool> changeQtyStream = StreamController<bool>.broadcast();
  StreamController<bool> changeMtrStream = StreamController<bool>.broadcast();
  StreamController<bool> changerateStream = StreamController<bool>.broadcast();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billDetModel = BillDetModel.fromJson(Myf.convertMapKeysToString(widget.billDetModel.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text(
          "${billDetModel.qUAL ?? ""}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Myf.Navi(context, EmpOrderFormSettings());
              setState(() {});
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: widthResponsive(context),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 5),
                  if (billDetModel.imageUrl != null)
                    GestureDetector(
                      onTap: () => Myf.Navi(context, fullScreenImg(img_list: ["${billDetModel.imageUrl}"])),
                      child: Container(
                        height: 200,
                        // width: screenWidthMobile * .3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade100, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            height: 200,
                            // width: screenWidthMobile * .3,
                            key: UniqueKey(),
                            imageUrl: "${billDetModel.imageUrl}",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ShimmerSkelton(
                              height: 200,
                              width: 200,
                            ),
                            httpHeaders: {
                              "Authorization": basicAuthForLocal,
                            },
                            errorWidget: (context, url, error) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text(
                                    "Not Available",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  Divider(height: 10),
                  ListTile(
                    title: Text("Product Name"),
                    subtitle: Text(
                      "${billDetModel.qUAL ?? ""}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      if (empOrderSettingModel.setsSystemOn ?? true)
                        if (empOrderSettingModel.frmItmShowSets ?? true)
                          Flexible(
                            child: sets(context),
                          ),
                      if (empOrderSettingModel.setsSystemOn ?? true)
                        if (empOrderSettingModel.frmItmPcsInSets ?? true)
                          Flexible(
                            child: pcsInSets(context),
                          ),
                      Flexible(
                        child: qty(context),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (empOrderSettingModel.frmItmCut ?? true)
                        Flexible(
                          child: cut(context),
                        ),
                      if (empOrderSettingModel.frmItmMtr ?? true)
                        Flexible(
                          child: mtr(context),
                        ),
                      if (empOrderSettingModel.frmItmRate ?? true)
                        Flexible(
                          child: rate(context),
                        ),
                    ],
                  ),
                  if (empOrderSettingModel.frmItmPacking ?? true) packing(context),
                  if (empOrderSettingModel.frmItmDno ?? true)
                    buildTextFormField(
                      context,
                      maxLines: 2,
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Dno",
                      controller: TextEditingController(text: billDetModel.dno),
                      onChanged: (value) {
                        billDetModel.dno = value.toUpperCase().trim();
                      },
                    ),
                  if (empOrderSettingModel.frmItmRmk ?? true)
                    buildTextFormField(
                      context,
                      maxLines: 2,
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Remark",
                      controller: TextEditingController(text: billDetModel.rmk),
                      onChanged: (value) {
                        billDetModel.rmk = value.toUpperCase().trim();
                      },
                    ),
                  Container(
                    width: 300,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: jsmColor),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          widget.billDetModel = billDetModel;
                          Navigator.pop(context, widget.billDetModel);
                        }
                      },
                      label: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(Icons.save, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rate(BuildContext context) {
    return StreamBuilder<bool>(
        stream: changerateStream.stream,
        builder: (context, snapshot) {
          var ctrl = TextEditingController(text: Myf.getPackingRate(billDetModel).toString());
          return buildTextFormField(
            context,
            labelStyle: TextStyle(color: Colors.black),
            labelText: "Rate",
            controller: ctrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              billDetModel.rATE = value;
              billDetModel.rateEnteredManual = true;
            },
            onTap: () {
              ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Rate";
              } else if (Myf.convertToDouble(value) <= 0) {
                return "Rate";
              }
              return null;
            },
          );
        });
  }

  Widget mtr(BuildContext context) {
    return StreamBuilder<bool>(
        stream: changeMtrStream.stream,
        builder: (context, snapshot) {
          double cut = Myf.convertToDouble(billDetModel.cUT);
          var qty = Myf.convertToDouble(billDetModel.pCS);
          double mtr = (qty * cut);
          billDetModel.mTR = mtr.toString();
          var ctrl = TextEditingController(text: billDetModel.mTR);
          return buildTextFormField(
            context,
            labelStyle: TextStyle(color: Colors.black),
            labelText: "Mtr",
            controller: ctrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onTap: () {
              ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
            },
            onChanged: (value) {
              billDetModel.mTR = value;
            },
          );
        });
  }

  Widget cut(BuildContext context) {
    var ctrl = TextEditingController(text: billDetModel.cUT);
    return buildTextFormField(
      context,
      labelStyle: TextStyle(color: Colors.black),
      labelText: "Cut",
      controller: ctrl,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onTap: () {
        ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
      },
      onChanged: (value) {
        billDetModel.cUT = value;
        changeMtrStream.sink.add(true);
      },
    );
  }

  Widget packing(BuildContext context) {
    var ctrl = TextEditingController(text: billDetModel.packing);
    return buildTextFormField(
      context,
      labelStyle: TextStyle(color: Colors.black),
      labelText: "Packing",
      controller: ctrl,
      readOnly: true,
      textInputAction: TextInputAction.next,
      onTap: () async {
        var model = await EmpOrderFormCubit.selectPacking(context);
        if (model != null && model is PackingStyleModel) {
          billDetModel.packing = model.packingStyle;
          ctrl.text = model.packingStyle!;
          packingStyleModel = model;
          billDetModel.rateEnteredManual = false;
          EmpOrderFormCubit.packingRateAddCheck(billDetModel, context);
          changerateStream.sink.add(true);
          setState(() {});
        }
      },
    );
  }

  Widget qty(BuildContext context) {
    return StreamBuilder<bool>(
        stream: changeQtyStream.stream,
        builder: (context, snapshot) {
          if (empOrderSettingModel.setsSystemOn == true && billDetModel.pcSManualEntered == false) {
            var sets = Myf.convertToDouble(billDetModel.sets);
            var pcsInSets = Myf.convertToDouble(billDetModel.pcsInSets);
            var qty = sets * pcsInSets;
            billDetModel.pCS = qty.toString();
          }
          var ctrl = TextEditingController(text: billDetModel.pCS);
          return buildTextFormField(
            context,
            labelStyle: TextStyle(color: Colors.black),
            labelText: "Qty",
            controller: ctrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              billDetModel.pCS = value;
              billDetModel.pcSManualEntered = true;
              changeMtrStream.sink.add(true);
            },
            onTap: () {
              ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "Qty";
              } else if (Myf.convertToDouble(value) <= 0) {
                return "Qty";
              }
              return null;
            },
          );
        });
  }

  Widget pcsInSets(BuildContext context) {
    var ctrl = TextEditingController(text: billDetModel.pcsInSets);

    return buildTextFormField(
      context,
      labelStyle: TextStyle(color: Colors.black),
      labelText: "Pcs in sets",
      controller: ctrl,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onTap: () {
        ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
      },
      onChanged: (value) {
        billDetModel.pcsInSets = value;
        billDetModel.pcSManualEntered = false;
        changeQtyStream.sink.add(true);
        changeMtrStream.sink.add(true);
      },
    );
  }

  Widget sets(BuildContext context) {
    var ctrl = TextEditingController(text: billDetModel.sets);
    return buildTextFormField(
      context,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      controller: ctrl,
      labelStyle: TextStyle(color: Colors.black),
      labelText: "sets",
      onTap: () {
        ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
      },
      onChanged: (value) {
        billDetModel.sets = value;
        billDetModel.pcSManualEntered = false;
        iniSets = billDetModel.sets.toString();
        changeQtyStream.sink.add(true);
        changeMtrStream.sink.add(true);
      },
    );
  }
}
