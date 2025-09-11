import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:empire_ios/Models/BlsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EMPIRE/webview.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubit.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitState.dart';
import 'package:empire_ios/screen/GatePassDateTab/GatePassDateTab.dart';
import 'package:empire_ios/screen/GatePassReport/GatePassReport.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:ndialog/ndialog.dart';
import 'package:responsive_builder/responsive_builder.dart';

BlsModel blsGatePassModel = BlsModel();

class GatePass extends StatefulWidget {
  const GatePass({Key? key}) : super(key: key);

  @override
  State<GatePass> createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  late GatePassCubit cubit;
  final player = AudioPlayer();
  Widget gatePassCubitSreeenLoad = SizedBox.shrink();
  Widget gatePassCubitLoadBill = SizedBox.shrink();
  var firebasecollection = fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("SETTINGS").doc("EMP_ORDER");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<GatePassCubit>(context);
    fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("SETTINGS").doc("EMP_GATEPASS").snapshots().listen((event) {
      if (event.exists) {
        dynamic snp = event.data();
        cubit.selectPerson = snp["selectPerson"];
      }
    });
    // cubit.startScane();
    // cubit.startScane();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try {
      cubit.ctrlScanner.stop();
      cubit.ctrlScanner.dispose();
    } catch (e) {}
    cubit.isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Gate Pass"),
        actions: [
          IconButton(
            onPressed: () => settingsOpen(),
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => cubit.scaneSecondQr(),
            icon: Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () => cubit.SelectMukadimUser(),
            icon: Icon(Icons.group_add_outlined),
          ),
          IconButton(
            onPressed: () => Myf.Navi(context, GatePassDateTab()),
            icon: Icon(Icons.inventory_outlined),
          ),
        ],
      ),
      body: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          readOnly: true,
                          onTap: () async {
                            var mukadam = await cubit.SelectMukadimUser();
                            if (mukadam == null) return;
                            cubit.ctrlMukadam.text = mukadam;
                            cubit.ctrlFocuseNode.requestFocus();
                          },
                          controller: cubit.ctrlMukadam,
                          decoration: InputDecoration(
                            hintText: "Mukadam",
                            labelText: "Mukadam",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          focusNode: cubit.ctrlFocuseNode,
                          onFieldSubmitted: (value) async {
                            print("onSubmitted-${value}");
                            cubit.clickByScanner = false;
                            await cubit.splitBarCode(value);
                            cubit.ctrlBarcodeInput.clear();
                          },
                          onChanged: (value) {
                            // print("onChanged-${value}");
                          },
                          controller: cubit.ctrlBarcodeInput,
                          decoration: InputDecoration(
                            hintText: "Enter Barcode",
                            labelText: "Barcode",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<GatePassCubit, GatePassCubitState>(
                    builder: (context, state) {
                      if (state is GatePassCubitSreeenLoad) {
                        gatePassCubitSreeenLoad = state.widget;
                      }
                      return gatePassCubitSreeenLoad;
                    },
                  ),
                ),
              ],
            ),
          ),
          if (getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop)
            Flexible(
              flex: 3,
              child: ScreenTypeLayout.builder(
                mobile: (BuildContext context) => SizedBox.shrink(),
                tablet: (BuildContext context) => SizedBox.shrink(),
                desktop: (BuildContext context) => billView(),
              ),
            )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: kIsWeb
          ? SizedBox.shrink()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                  heroTag: "scaneTypebtn1",
                  onPressed: () => {
                    cubit.clickByScanner = true,
                    cubit.scanQRForAndroid(),
                  },
                  label: Text("Scanner1"),
                ),
                FloatingActionButton.extended(
                  heroTag: "scaneTypebtn2",
                  onPressed: () => {
                    cubit.clickByScanner = true,
                    cubit.scaneSecondQr(),
                  },
                  label: Text("Scanner2"),
                ),
                FloatingActionButton.extended(
                  heroTag: "scaneTypebtn3",
                  onPressed: () => {
                    cubit.clickByScanner = true,
                    cubit.scaneSecondQr3(),
                  },
                  label: Text("Scanner3"),
                ),
              ],
            ),
    );
  }

  Widget billView() {
    return BlocBuilder<GatePassCubit, GatePassCubitState>(
      builder: (context, state) {
        if (state is GatePassCubitLoadBill) {
          gatePassCubitLoadBill = state.widget;
        }
        return gatePassCubitLoadBill;
      },
    );
  }

  void settingsOpen() async {
    ipController.text = await Myf.getPrivateNetWorkIp(GLB_CURRENT_USER);
    var ctrlLFolder = TextEditingController(text: firebaseCurrntSupUserObj["Lfolder"]);
    // setState(() {});
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: const Text("Please Enter Private Network IP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: ipController,
            validator: (value) {
              if (value!.isEmpty) {
                return "ip Cannot be empty";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Enter Your Private Network Ip ",
              labelText: "Private Network IP ",
            ),
          ),
          TextFormField(
            readOnly: true,
            enabled: false,
            controller: ctrlLFolder,
            validator: (value) {
              if (value!.isEmpty) {
                return "ip Cannot be empty";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Enter Your Lfolder",
              labelText: "Lfolder ",
            ),
          ),
          GFCheckboxListTile(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            value: empOrderSettingModel.gatePassPrintDirect ?? false,
            onChanged: (value) async {
              empOrderSettingModel.gatePassPrintDirect = value;
              await firebasecollection.set(empOrderSettingModel.toJson()).then((value) {
                Navigator.pop(context);
              });
            },
            titleText: "Direct Print For Desktop",
            type: GFCheckboxType.square,
            size: 20,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Myf.checkHostStatus();
            },
            child: Text("Connection Status")),
        TextButton(
            onPressed: () async {
              Myf.saveValToSavedPref(GLB_CURRENT_USER, "privateNetworkIp", ipController.text);

              Navigator.pop(context);
            },
            child: const Text('SAVE')),
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
      ],
    ).show(context);
  }
}
