import 'dart:async';
import 'dart:math';

import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormColor/cubit/EmpOrderFormColorCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormColor/cubit/EmpOrderFormColorState.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/EmpOrderFormProduct.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormProductDesign/EmpOrderFormProductDesign.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/inputwidgetlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderFormColor extends StatefulWidget {
  BillDetModel billDetModel;
  EmpOrderFormColor({Key? key, required this.billDetModel}) : super(key: key);

  @override
  State<EmpOrderFormColor> createState() => _EmpOrderFormColorState();
}

class _EmpOrderFormColorState extends State<EmpOrderFormColor> {
  Widget _widget = SizedBox.shrink();
  late EmpOrderFormColorCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderFormColorCubit>(context);
    cubit.billDetModel = widget.billDetModel;
    cubit.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDispose = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Design"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Checkbox(
              value: cubit.boolselectAll,
              onChanged: (value) {
                cubit.boolselectAll = value!;
                cubit.selectAllInList();
                cubit.loadTable();
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<EmpOrderFormColorCubit, EmpOrderFormColorState>(
                builder: (context, state) {
                  if (state is EmpOrderFormColorStateLoadColor) {
                    _widget = state.widget;
                  }
                  return _widget;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.check_circle_outline, color: Colors.white),
                      label: Text("Done", style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () => cubit.doneSave(),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text("Add new Design", style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: () async {
                        if (empOrderSettingModel.colorImageSystemEntry == "image") {
                          await Myf.Navi(
                            context,
                            EmpOrderFormProductDesign(
                              qualModel: QualModel(
                                value: widget.billDetModel.qUAL,
                                label: widget.billDetModel.qUAL,
                              ),
                            ),
                          );
                        } else {
                          GalleryModel galleryModel = GalleryModel(
                            id: DateTime.now().toString(),
                            name: "",
                            type: "text",
                            value: widget.billDetModel.qUAL,
                          );
                          await showModelForEntryColor(galleryModel);
                        }
                        await SyncLocalFunction.syncGallery();
                        cubit.getData();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showModelForEntryColor(GalleryModel galleryModel) async {
    var completer = Completer<void>();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Color"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Color Name"),
                  initialValue: galleryModel.name,
                  onChanged: (value) {
                    galleryModel.name = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                galleryModel.mTime = DateTime.now().millisecondsSinceEpoch.toString();
                await fireBCollection
                    .collection("supuser")
                    .doc(loginUserModel.cLIENTNO)
                    .collection("gallery")
                    .doc(galleryModel.id)
                    .set(galleryModel.toJson());
                completer.complete();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.save, color: Colors.white),
              label: Text("Save", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, color: Colors.white),
              label: Text("Cancel", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
          ],
        );
      },
    );
    return completer.future;
  }
}
