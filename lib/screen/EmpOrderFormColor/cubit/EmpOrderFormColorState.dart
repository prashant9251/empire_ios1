import 'dart:async';

import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class EmpOrderFormColorState {}

class EmpOrderFormColorStateIni extends EmpOrderFormColorState {}

class EmpOrderFormColorStateLoading extends EmpOrderFormColorState {}

class EmpOrderFormColorStateLoadColor extends EmpOrderFormColorState {
  Widget widget;
  EmpOrderFormColorStateLoadColor(this.widget);
}

class EmpOrderFormColorStateAddColor extends EmpOrderFormColorState {
  BuildContext context;
  EmpOrderFormColorStateAddColor(this.context);
  addColor(BillDetModel billDetModel) async {
    final Completer<ColorModel?> _companyCompleter = Completer<ColorModel?>();
    ColorModel colorModel = ColorModel();
    var ctrlName = TextEditingController();
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      context: this.context,
      builder: (context) {
        return Container(
          height: ScreenHeight(context) * .5,
          margin: EdgeInsets.only(top: 5, left: 10),
          child: ListView(
            children: [
              Text(
                "Add Color",
                style: TextStyle(fontSize: 25, color: jsmColor),
              ),
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: ctrlName,
                  onChanged: (value) {},
                  textInputAction: TextInputAction.none,
                  decoration: InputDecoration(
                    labelText: 'Color Name',
                    hintText: 'Color Name',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    colorModel.clName = ctrlName.text.trim().toUpperCase();
                    colorModel.category = billDetModel.category == null || billDetModel.category == "" ? billDetModel.qUAL : billDetModel.category;
                    fireBCollection
                        .collection("supuser")
                        .doc(GLB_CURRENT_USER["CLIENTNO"])
                        .collection("EMP_COLOR")
                        .doc(colorModel.clName)
                        .set(colorModel.toJson());
                    _companyCompleter.complete(colorModel);
                    Navigator.pop(context, colorModel);
                  },
                  icon: Icon(Icons.save),
                  label: Text("Save"))
            ],
          ),
        );
      },
    );
    return _companyCompleter.future;
  }
}
