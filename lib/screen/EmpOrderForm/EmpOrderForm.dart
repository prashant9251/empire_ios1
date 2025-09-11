import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/HasteModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/PackingStyleModel.dart';
import 'package:empire_ios/Models/StateCode.dart';
import 'package:empire_ios/Models/TransportModel.dart';
import 'package:empire_ios/localRequest/getMst.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubitState.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/EmpOrderFormHaste.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/EmpOrderFormParty.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormSettings/EmpOrderFormSettings.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/EmpOrderFormTransport.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/cubit/EmpOrderFormTransportCubit.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

var ctrlFirmName = TextEditingController();

class EmpOrderForm extends StatefulWidget {
  var billsModel;

  static bool editMode = true;
  EmpOrderForm({Key? key, this.billsModel}) : super(key: key);

  @override
  State<EmpOrderForm> createState() => _EmpOrderFormState();
}

class _EmpOrderFormState extends State<EmpOrderForm> {
  final formKey = GlobalKey<FormState>();
  var ctrlMasterName = TextEditingController();
  var ctrlBrokerName = TextEditingController();
  var ctrlStation = TextEditingController();
  var ctrlTransport = TextEditingController();
  var ctrlHaste = TextEditingController();
  late CompmstModel compmstModel = CompmstModel();
  var ctrlOrderDate = TextEditingController();
  DateTime? orderDate = DateTime.now();
  late HasteModel hasteModel = HasteModel();
  late MasterModel brokerModel = MasterModel();
  late BillsModel billsModel = BillsModel(vNO: 1, tYPE: "O100", ide: "", cNO: "");
  late EmpOrderFormCubit cubit;
  var ctrlOrderRemark = TextEditingController();
  var ctrlOrderGivenBy = TextEditingController();
  var ctrlStateCode = TextEditingController();
  var ctrlProductBarcode = TextEditingController();
  var databasId = "";

  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderFormCubit>(context);
    getData().then((value) {
      orderDate = DateTime.now();
      ctrlOrderDate.text = Myf.dateFormate(orderDate.toString());
      if (widget.billsModel != null) {
        EmpOrderForm.editMode = false;
        billsModel = BillsModel.fromJson(widget.billsModel.toJson());
        cubit.masterModel = billsModel.masterDet!;
        ctrlFirmName.text = billsModel.compmstDet!.fIRM!;
        ctrlMasterName.text = billsModel.pcode ?? "";
        ctrlBrokerName.text = billsModel.bcode!;
        ctrlStation.text = billsModel.st!;
        ctrlTransport.text = billsModel.trnsp!;
        ctrlHaste.text = billsModel.haste!;
        ctrlOrderRemark.text = billsModel.rmk!;
        ctrlOrderGivenBy.text = billsModel.orderGivenBy!;
        ctrlStateCode.text = billsModel.stateCode!;
        compmstModel = billsModel.compmstDet!;
        ctrlOrderDate.text = billsModel.date!;
        cubit.ctrlOrderPacking.text = billsModel.pack!;
        orderDate = DateTime.tryParse(ctrlOrderDate.text);
        cubit.loadEditBillDetails(billsModel.billDetails!);
      } else {
        selectCompany();
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future getData() async {
    // Myf.checkForSyncMini(context);
    EmpOrderForm.editMode = true;
    databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    ctrlFirmName.text = prefs!.getString("ctrlFirmName$databasId") ?? "";
    rateSelected = shareSettingObj["v_rateType"] ?? "S1";
    await cubit.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    masterList.clear();
    productList.clear();
    packingStyleList.clear();
    packingStyleModel = PackingStyleModel();
    cubit.verticalScrollController.dispose();
    Myf.enableFirebasePersistence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Empire Order Form"),
        actions: [
          EmpOrderForm.editMode
              ? Center(child: Text("Edit mode"))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      EmpOrderForm.editMode = true;
                      cubit.loadEditBillDetails(billsModel.billDetails!);
                    });
                  },
                  icon: Icon(Icons.edit)),
          IconButton(onPressed: () => Myf.Navi(context, EmpOrderFormSettings()), icon: Icon(Icons.settings))
        ],
      ),
      body: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Center(child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: friendlyScreenWidth(context, constraints),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    if (empOrderSettingModel.showFrmDate ?? true)
                      TextinputField(
                          title: "Select Order Date",
                          hint: "Select Order Date",
                          ctrl: ctrlOrderDate,
                          prefixIcon: Icon(Icons.date_range),
                          validator: "Order Date"),
                    TextinputField(
                        title: "Select Company",
                        hint: "Select Company",
                        ctrl: ctrlFirmName,
                        prefixIcon: Icon(Icons.add_business_rounded),
                        validator: "Select Company"),
                    Row(
                      children: [
                        Flexible(
                            child: TextinputField(
                                title: "Select Customer", hint: "Select Customer", ctrl: ctrlMasterName, validator: "Select Customer")),
                        Flexible(
                          child: TextinputField(
                              title: "State Code ",
                              hint: "State Code ",
                              ctrl: ctrlStateCode,
                              validator: "Select State Code",
                              prefixIcon: Icon(Icons.star_rate)),
                        ),
                      ],
                    ),
                    TextinputField(
                        title: "Select broker", hint: "Select broker", ctrl: ctrlBrokerName, prefixIcon: Icon(Icons.assignment_ind_rounded)),
                    Row(
                      children: [
                        Flexible(
                          child: TextinputField(
                            title: "Select Haste",
                            hint: "Select Haste",
                            ctrl: ctrlHaste,
                            prefixIcon: Icon(Icons.handshake),
                          ),
                        ),
                        empOrderSettingModel.showRateSelectionOnEntryFormOrder == true
                            ? Flexible(
                                child: Container(
                                  color: Colors.white,
                                  width: screenWidthMobile * .4,
                                  child: DropdownButton<String>(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                    icon: Icon(Icons.rate_review),
                                    value: rateSelected,
                                    onChanged: (newValue) {
                                      setState(() {
                                        rateSelected = newValue!;
                                        shareSettingObj["v_rateType"] = rateSelected;
                                      });
                                    },
                                    items: <DropdownMenuItem<String>>[
                                      DropdownMenuItem<String>(
                                        value: 'S1',
                                        child: Chip(label: Text('RATE1')),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'S2',
                                        child: Chip(label: Text('RATE2')),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'S3',
                                        child: Chip(label: Text('RATE3')),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: TextinputField(
                                title: "Station", hint: "Station", ctrl: ctrlStation, prefixIcon: Icon(Icons.location_on), readOnly: false)),
                        Flexible(
                            child: TextinputField(
                                title: "Transport",
                                hint: "Transport",
                                ctrl: ctrlTransport,
                                prefixIcon: Icon(Icons.fire_truck),
                                pushScreen: BlocProvider(create: (context) => EmpOrderFormTransportCubit(context), child: EmpOrderFormTransport()))),
                      ],
                    ),
                    SizedBox(height: 10),

                    BlocBuilder<EmpOrderFormCubit, EmpOrderFormCubitState>(
                      builder: (context, state) {
                        if (state is EmpOrderFormCubitStateLoadProduct) {
                          Widget widget = state.widget;
                          return widget;
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: FloatingActionButton.extended(
                                heroTag: "productaddtabtoEmpireOrder",
                                onPressed: () async {
                                  Myf.askForCameraPermission();
                                  if (EmpOrderForm.editMode) {
                                    cubit.selectProductStart();
                                  } else {
                                    Myf.snakeBar(context, "please enable edit mode");
                                  }
                                },
                                label: Text("Add product"))),
                        Flexible(
                            fit: FlexFit.loose,
                            child: IconButton(
                                onPressed: () {
                                  if (EmpOrderForm.editMode) {
                                    cubit.startScane();
                                  } else {
                                    Myf.snakeBar(context, "please enable edit mode");
                                  }
                                },
                                icon: Icon(Icons.qr_code_scanner))),
                        Flexible(
                            fit: FlexFit.loose,
                            child: TextFormField(
                                controller: ctrlProductBarcode,
                                focusNode: cubit.focusNodeBarcode,
                                onFieldSubmitted: (value) async {
                                  cubit.barcodeScanRes = value;
                                  await cubit.loadResult(cubit.barcodeScanRes);
                                  cubit.barcodeScanRes = "";
                                  ctrlProductBarcode.clear();
                                  cubit.focusNodeBarcode.requestFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: "Product Barcode",
                                  hintText: "Barcode",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                                  ),
                                ))),
                      ],
                    ),
                    SizedBox(height: 10),
                    // EmpOrderFormProductCard(billDetailslist: billDetailslist),
                    SizedBox(height: 50),
                    if (empOrderSettingModel.showPackingSelectionAtBottom == true)
                      TextinputField(
                        title: "Packing",
                        hint: "Packing",
                        ctrl: cubit.ctrlOrderPacking,
                        readOnly: true,
                        prefixIcon: Icon(Icons.card_giftcard_outlined),
                      ),
                    TextinputField(
                      title: "Order Remark",
                      hint: "Order Remark",
                      ctrl: ctrlOrderRemark,
                      readOnly: false,
                      prefixIcon: Icon(Icons.comment),
                    ),
                    TextinputField(
                      title: "Order Given By",
                      hint: "Order Given By",
                      ctrl: ctrlOrderGivenBy,
                      readOnly: false,
                      prefixIcon: Icon(Icons.account_box_rounded),
                    ),
                    SizedBox(height: 50),
                    FloatingActionButton.extended(
                        heroTag: "saveOrderBtn",
                        onPressed: () {
                          validate();
                        },
                        label: Text("Save"))
                  ],
                ),
              ),
            );
          },
        )),
      ),
    );
  }

  Container TextinputField(
      {required String title, hint, ctrl, prefixIcon = const Icon(Icons.search), pushScreen, readOnly = true, validator, loading = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextFormField(
        validator: (value) {
          if (value!.trim().length == 0) {
            return validator;
          }
          return null;
        },
        enabled: EmpOrderForm.editMode,
        style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor),
        controller: ctrl,
        readOnly: readOnly,
        textInputAction: TextInputAction.none,
        onTap: () async {
          if (title.contains("Packing")) {
            packingStyleModel = await EmpOrderFormCubit.selectPacking(context);
            if (packingStyleModel == null) return;
            cubit.ctrlOrderPacking.text = packingStyleModel.packingStyle!;
            cubit.loadProductDetails();
            return;
          } else if (title.contains("Date")) {
            orderDate = await Myf.selectDate(context);
            if (orderDate != null) {
              ctrlOrderDate.text = Myf.dateFormate(orderDate.toString());
            }
            return;
          } else if (title.contains("State") && ctrlStateCode.text.isEmpty) {
            var c = await selectStateCode(context);
            if (c == null) return;
            ctrlStateCode.text = c.key;
            return;
          } else if (title.contains("Company")) {
            ctrlFirmName.text = "";
            selectCompany();
            return;
          } else if (title.contains("Haste")) {
            var model = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                    create: (context) {
                      return EmpOrderFormHasteCubit(context);
                    },
                    child: EmpOrderFormHaste(filterParty: ctrlMasterName.text));
              },
            ));
            if (model is HasteModel) {
              hasteModel = model;
              ctrlHaste.text = hasteModel.hS!;
              ctrlStation.text = hasteModel.sT!;
              ctrlTransport.text = hasteModel.tR!;
            }
            return;
          } else if (title.contains("Customer")) {
            pushScreen = BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "1"));
            var model = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return pushScreen;
              },
            ));
            if (model == null) return;
            if (model is MasterModel) {
              cubit.masterModel = model;
              ctrlMasterName.text = cubit.masterModel.partyname ?? "";
              ctrlBrokerName.text = cubit.masterModel.broker ?? "";
              billsModel.brokerDet = cubit.getBrokerDetails(cubit.masterModel.broker!);
              ctrlStation.text = cubit.masterModel.sT ?? "";
              ctrlTransport.text = cubit.masterModel.tRSPT ?? "";
              try {
                ctrlStateCode.text = cubit.masterModel.gST!.substring(0, 2);
              } catch (e) {}
              // rateSelected = cubit.masterModel.cUSTTYPE;
              switch (cubit.masterModel.cUSTTYPE) {
                case "1":
                  rateSelected = "S1";
                  break;
                case "2":
                  rateSelected = "S2";
                  break;
                case "3":
                  rateSelected = "S3";
                  break;
                default:
              }
              setState(() {});
            }
          } else if (title.contains("broker")) {
            pushScreen = BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "12"));
            var model = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return pushScreen;
              },
            ));
            if (model == null) return;
            if (model is MasterModel) {
              brokerModel = model;
              billsModel.brokerDet = brokerModel;
              ctrlBrokerName.text = brokerModel.partyname!;
            }
          } else if (title.contains("Transport")) {
            var model = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return pushScreen;
              },
            ));
            if (model == null) return;
            if (model is TransportModel) {
              model;
              ctrlTransport.text = model.label!;
            }
          }
        },
        decoration: InputDecoration(
          prefixIcon: loading ? Transform.scale(scale: .75, child: CircularProgressIndicator(color: Colors.black)) : prefixIcon,
          labelText: '$title',
          hintText: '${hint ?? ""}',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
          ),
        ),
      ),
    );
  }

  validate() async {
    if (formKey.currentState!.validate() &&
        cubit.formKeyProduct.currentState!.validate() &&
        ctrlMasterName.text.isNotEmpty &&
        ctrlStateCode.text.isNotEmpty &&
        cubit.masterModel.partyname != null &&
        compmstModel.fIRM != null &&
        compmstModel.fIRM != "") {
      if (cubit.billDetailslist.length == 0) {
        showSimpleNotification(Text("Please Add at least 1 product"), background: Colors.red);
      } else {
        if (!isSaving) {
          isSaving = true;
          save();
        }
      }
    } else {
      Myf.snakeBar(context, "*Fill all details");
    }
  }

  save() async {
    Myf.disableFirebasePersistence();
    Myf.showBlurLoading(context);
    var orderBreak = false;
    if (widget.billsModel == null) {
      billsModel.vNO = empOrderSettingModel.IniOrderVno ?? 10001;
      billsModel.cNO = compmstModel.cNO!;
      await fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMPIRE")
          .doc(GLB_CURRENT_USER["yearVal"])
          .collection("EMP_ORDER")
          .where("CNO", isEqualTo: billsModel.cNO)
          .where("TYPE", isEqualTo: billsModel.tYPE)
          .orderBy("VNO", descending: true)
          .limit(1)
          .get(GetOptions(source: Source.server))
          .then((value) async {
        var snp = value.docs;
        if (value.metadata.isFromCache) {
          orderBreak = true;
          Myf.snakeBar(context, "No internet connection. Please try again later.");
          return;
        } else if (snp.length > 0) {
          await Future.wait(snp.map((e) async {
            dynamic d = e.data();
            BillsModel b = BillsModel.fromJson(Myf.convertMapKeysToString(d));
            var newVno = b.vNO + 1;
            billsModel.vNO = newVno;
          }).toList());
        }
      }, onError: (error) {
        Myf.snakeBar(context, error.toString());
        orderBreak = true;
      }).onError((error, stackTrace) {
        orderBreak = true;
        Myf.snakeBar(context, error.toString());
      });
    }
    if (orderBreak) {
      isSaving = false;
      Navigator.pop(context);
      return;
    }
    orderDate = orderDate ?? DateTime.now();
    billsModel.totPcs = finaltotalPcs.toString();
    billsModel.totMts = finaltotalMtr.toString();
    billsModel.pack = cubit.ctrlOrderPacking.text;
    billsModel.date = orderDate.toString();
    billsModel.bill = billsModel.vNO.toString();
    billsModel.compmstDet = compmstModel;
    billsModel.masterDet = cubit.masterModel;
    billsModel.pcode = cubit.masterModel.value;
    billsModel.bcode = ctrlBrokerName.text.trim().toUpperCase();
    billsModel.haste = ctrlHaste.text.trim().toUpperCase();
    billsModel.st = ctrlStation.text.trim();
    billsModel.trnsp = ctrlTransport.text.trim();
    billsModel.billDetails = cubit.billDetailslist;
    billsModel.cBy = GLB_CURRENT_USER["login_user"];
    billsModel.cTime = DateTime.now().toString();
    billsModel.mTime = DateTime.now().toString();
    billsModel.rmk = ctrlOrderRemark.text.trim().toUpperCase();
    billsModel.orderGivenBy = ctrlOrderGivenBy.text.trim().toUpperCase();
    billsModel.stateCode = ctrlStateCode.text.trim().toUpperCase();
    print(empOrderSettingModel.autoConfimOrder);
    billsModel.status = empOrderSettingModel.autoConfimOrder == true ? "confirm" : "pending";
    billsModel.ide = billsModel.ide.isNotEmpty ? billsModel.ide : "${billsModel.cNO}-${billsModel.tYPE}-${billsModel.vNO}-${billsModel.date}";
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .doc(billsModel.ide)
        .set(billsModel.toJson())
        .then((value) {
      isSaving = false;
    });

    if (empOrderSettingModel.askForSharePdfRate ?? true) {
      await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context, pdfOprate: "enotify");
    } else {
      await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context);
    }
    if (context != null) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void selectCompany() async {
    var model = null;
    if (ctrlFirmName.text.isNotEmpty) {
      model = await EmpOrderFormCubitStateSelectCompany(context).selectCompanyByFirmName();
    } else {
      model = await EmpOrderFormCubitStateSelectCompany(context).selectCompany();
    }
    if (model is CompmstModel) {
      compmstModel = model;
      if (compmstModel.fIRM == null) return;
      ctrlFirmName.text = compmstModel.fIRM!;
      prefs!.setString("ctrlFirmName$databasId", ctrlFirmName.text);
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Confirmation'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  // checkForSync() async {
  //   var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);
  //   var localSyncTimeEMP_MST = hiveMainBox.get("${databaseId}EMP_MST") ?? "0";
  //   var dt = await DateTime.now();
  //   syncEmpire_OrderSnapShot = fireBCollection
  //       .collection("supuser")
  //       .doc(GLB_CURRENT_USER["CLIENTNO"])
  //       .collection("EMP_MST")
  //       .where("time", isGreaterThan: localSyncTimeEMP_MST)
  //       .get()
  //       .then((event) async {
  //     var snp = event.docs;
  //     if (snp.length > 0) {
  //       Box EMP_MST = await SyncLocalFunction.openBoxCheck("EMP_MST");
  //       if (localSyncTimeEMP_MST == "0") {
  //         await EMP_MST.clear();
  //         await hiveMainBox.put("${databaseId}EMP_MST", dt.toString());
  //       }
  //       await Future.wait(snp.map((e) async {
  //         var id = e.id;
  //         dynamic d = e.data();
  //         await EMP_MST.put(id, d);
  //       }).toList());
  //       await EMP_MST.close();
  //       hiveMainBox.put("${databaseId}EMP_MST", dt.toString());
  //     }
  //   });

  //   var localSyncTimeEMP_HASTE = hiveMainBox.get("${databaseId}EMP_HASTE") ?? "0";
  //   dt = await DateTime.now();
  //   syncEmpire_OrderSnapShot = fireBCollection
  //       .collection("supuser")
  //       .doc(GLB_CURRENT_USER["CLIENTNO"])
  //       .collection("EMP_HASTE")
  //       .where("time", isGreaterThan: localSyncTimeEMP_HASTE)
  //       .get()
  //       .then((event) async {
  //     var snp = event.docs;
  //     if (snp.length > 0) {
  //       Box EMP_HASTE = await SyncLocalFunction.openBoxCheck("EMP_HASTE");
  //       if (localSyncTimeEMP_HASTE == "0") {
  //         await EMP_HASTE.clear();
  //         await hiveMainBox.put("${databaseId}EMP_HASTE", dt.toString());
  //       }
  //       await Future.wait(snp.map((e) async {
  //         var id = e.id;
  //         dynamic d = e.data();
  //         await EMP_HASTE.put(id, d);
  //       }).toList());
  //       await EMP_HASTE.close();
  //       hiveMainBox.put("${databaseId}EMP_HASTE", dt.toString());
  //     }
  //   });
  // }
}
