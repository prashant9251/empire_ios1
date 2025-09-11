import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/AgAcGroupModel.dart';
import 'package:empire_ios/Models/AgEmpOrderModel.dart';
import 'package:empire_ios/Models/AgMasterModel.dart';
import 'package:empire_ios/Models/TransportModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/AgEmpOrderAcGroup/AgEmpOrderAcGroup.dart';
import 'package:empire_ios/screen/AgEmpOrderAcGroup/cubit/AgEmpOrderAcGroupCubit.dart';
import 'package:empire_ios/screen/AgEmpOrderFormParty/AgEmpOrderFormParty.dart';
import 'package:empire_ios/screen/AgEmpOrderFormParty/cubit/AgEmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/EmpOrderFormTransport.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/cubit/EmpOrderFormTransportCubit.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

bool agEditMode = true;

class AgEmpOrderForm extends StatefulWidget {
  var agEmpOrderModel;

  AgEmpOrderForm({Key? key, this.agEmpOrderModel}) : super(key: key);

  @override
  State<AgEmpOrderForm> createState() => _AgEmpOrderFormState();
}

class _AgEmpOrderFormState extends State<AgEmpOrderForm> {
  final StreamController<bool> changeStream = StreamController<bool>.broadcast();
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;
  AgAcGroupModel agAcGroupModel = AgAcGroupModel();
  AgMasterModel CustAgMasterModel = AgMasterModel();
  AgEmpOrderModel agEmpOrderModel = AgEmpOrderModel(VNO: 1, ide: '', qty: 0.0, cases: 0, CNO: "1");
  String? _selectedUnit = "CASES";

  DateTime? orderDate = DateTime.now();

  var ctrlOrderDate = TextEditingController();
  var ctrlTransport = TextEditingController();
  var ctrlOrderStaff = TextEditingController();

  var ctrlOrderSuppOrdno = TextEditingController();

  var ctrlOrderCustomer = TextEditingController();

  var ctrlOrderSuppGroup = TextEditingController();

  var ctrlOrderQty = TextEditingController(text: "0");

  var ctrlOrderRmk = TextEditingController();

  var ctrlOrderCases = TextEditingController(text: "0");

  var databasId = "";
  Uint8List? attachment = null;
  List MST = [];
  var loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderDate = DateTime.now();
    ctrlOrderDate.text = Myf.dateFormate(orderDate.toString());
    if (widget.agEmpOrderModel != null) {
      agEmpOrderModel = widget.agEmpOrderModel;
      CustAgMasterModel = agEmpOrderModel.masterDet!;
      agAcGroupModel = agEmpOrderModel.acGroupDet!;
      _selectedUnit = agEmpOrderModel.unit;

      ctrlOrderDate = TextEditingController(text: Myf.dateFormate(agEmpOrderModel.date));
      ctrlTransport = TextEditingController(text: agEmpOrderModel.transport);
      ctrlOrderStaff = TextEditingController(text: agEmpOrderModel.staff);
      ctrlOrderSuppOrdno = TextEditingController(text: agEmpOrderModel.suppOrdNo);
      ctrlOrderCustomer = TextEditingController(text: agEmpOrderModel.cust);
      ctrlOrderSuppGroup = TextEditingController(text: agEmpOrderModel.supp);
      ctrlOrderQty = TextEditingController(text: agEmpOrderModel.qty.toString());
      ctrlOrderRmk = TextEditingController(text: agEmpOrderModel.rmk);
      ctrlOrderCases = TextEditingController(text: agEmpOrderModel.cases.toString());
    }
    getData();
  }

  getMasterObjByCode(String code) async {
    return MST.where((element) {
      return element["value"] == code;
    }).toList();
  }

  getData() async {
    databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    mediaBox = await SyncLocalFunction.openBoxCheck("media");
    Box? CuHiveBox = await SyncLocalFunction.openBoxCheck("MST");
    MST = await CuHiveBox.get("${databasId}MST", defaultValue: []) as List<dynamic>;
    await CuHiveBox.close();
    basicAuthForLocal = Myf.getBasicAuthForLocal();

    masterList = await Future.wait(MST.map((json) async {
      AgMasterModel agMasterModel = AgMasterModel.fromJson(Myf.convertMapKeysToString(json));
      if (agMasterModel.broker != null && agMasterModel.broker != "") {
        List brokerObj = await getMasterObjByCode(agMasterModel.brokerCode ?? "");
        if (brokerObj.length > 0) {
          agMasterModel.brokerModel = AgMasterModel.fromJson(Myf.convertMapKeysToString(brokerObj[0]));
        }
      }
      return agMasterModel;
    }).toList());
    setState(() {
      loading = false;
    });
    // ctrlAgFirmName.text = prefs!.getString("ctrlFirmName$databasId") ?? "";
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    masterList.clear();
    MST.clear();
    await mediaBox!.close();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("Empire Order Form Ag."),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                    width: friendlyScreenWidth(context, constraints),
                    child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: TextinputField(
                                      title: "Select Order Date",
                                      hint: "Select Order Date",
                                      ctrl: ctrlOrderDate,
                                      prefixIcon: Icon(Icons.date_range),
                                      validator: "Order Date"),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextinputField(
                                      textInputAction: TextInputAction.next,
                                      title: "Purchaser",
                                      hint: "Purchaser",
                                      ctrl: ctrlOrderStaff,
                                      prefixIcon: Icon(Icons.handshake),
                                      validator: "Purchaser"),
                                ),
                                Flexible(
                                  child: TextinputField(
                                    keyboard: TextInputType.number,
                                    readOnly: false,
                                    textInputAction: TextInputAction.next,
                                    title: "Supp.Ord.No.",
                                    hint: "Supp.Ord.No.",
                                    ctrl: ctrlOrderSuppOrdno,
                                    prefixIcon: Icon(Icons.format_list_numbered_sharp),
                                  ),
                                ),
                              ],
                            ),
                            TextinputField(
                                textInputAction: TextInputAction.next,
                                title: "Customer",
                                hint: "Customer",
                                ctrl: ctrlOrderCustomer,
                                prefixIcon: Icon(Icons.business),
                                validator: "Customer"),
                            TextinputField(
                                textInputAction: TextInputAction.next,
                                title: "Supp. Group",
                                hint: "Supp. Group",
                                ctrl: ctrlOrderSuppGroup,
                                prefixIcon: Icon(Icons.assignment_ind_rounded),
                                validator: "Supp. Group"),
                            SizedBox(height: 20),
                            Card(
                              color: jsmColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedUnit,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          isExpanded: true,
                                          items: ["CASES", "PCS", "MTS"].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedUnit = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TextinputField(
                                          textInputAction: TextInputAction.next,
                                          readOnly: false,
                                          title: "Cases",
                                          hint: "Cases",
                                          ctrl: ctrlOrderCases,
                                          prefixIcon: null,
                                          validator: "Cases",
                                          keyboard: TextInputType.number),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: TextinputField(
                                          textInputAction: TextInputAction.next,
                                          readOnly: false,
                                          title: "Pcs/Mts",
                                          hint: "Pcs/Mts",
                                          ctrl: ctrlOrderQty,
                                          prefixIcon: null,
                                          validator: "Pcs/Mts",
                                          keyboard: TextInputType.number),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: TextinputField(
                                    textInputAction: TextInputAction.next,
                                    title: "Transport",
                                    hint: "Transport",
                                    ctrl: ctrlTransport,
                                    readOnly: true,
                                    prefixIcon: Icon(Icons.fire_truck_rounded),
                                  ),
                                ),
                              ],
                            ),
                            TextinputField(
                                readOnly: false, maxLines: 4, title: "Details", hint: "Details", ctrl: ctrlOrderRmk, prefixIcon: Icon(Icons.comment)),
                            //need attackement for image from camera or gallery

                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(jsmColor),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                              ),
                              onPressed: validate,
                              label: Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Attachment"),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Attachment"),
                                              actions: [
                                                ElevatedButton.icon(
                                                    onPressed: () async {
                                                      var i = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
                                                      if (i != null) {
                                                        attachment = await i.readAsBytes();
                                                        setState(() {});
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.camera_alt),
                                                    label: Text("Camera")),
                                                ElevatedButton.icon(
                                                    onPressed: () async {
                                                      var i = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
                                                      if (i != null) {
                                                        attachment = await i.readAsBytes();
                                                        setState(() {});
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.image),
                                                    label: Text("Gallery")),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.add_a_photo)),
                                  IconButton(
                                      onPressed: () async {
                                        attachment = null;
                                        agEmpOrderModel.fileKeyPath = null;
                                        agEmpOrderModel.url = null;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red),
                                ],
                              ),
                              subtitle: Builder(builder: (context) {
                                if (attachment != null) {
                                  return Image.memory(
                                    attachment!,
                                    height: 200,
                                    width: 200,
                                  );
                                } else if (agEmpOrderModel.url != null && agEmpOrderModel.url != "") {
                                  return GestureDetector(
                                    onTap: () {
                                      Myf.Navi(context, fullScreenImg(img_list: [agEmpOrderModel.url]));
                                    },
                                    child: CachedNetworkImage(
                                      height: 200,
                                      width: 200,
                                      imageUrl: agEmpOrderModel.url!,
                                      cacheManager: baseCacheManager,
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                      httpHeaders: {
                                        "Authorization": basicAuthForLocal,
                                      },
                                    ),
                                  );
                                }
                                return Container();
                              }),
                            )
                          ],
                        ))),
              ),
      );
    });
  }

  Container TextinputField(
      {required String title,
      hint,
      ctrl,
      prefixIcon = const Icon(Icons.search),
      pushScreen,
      readOnly = true,
      validator,
      loading = false,
      keyboard = TextInputType.text,
      maxLines = 1,
      textInputAction = TextInputAction.none}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextFormField(
        keyboardType: keyboard,
        validator: (value) {
          if (value!.trim().length == 0) {
            return validator;
          }
          return null;
        },
        enabled: agEditMode,
        textInputAction: textInputAction,
        maxLines: maxLines,
        style: TextStyle(fontWeight: FontWeight.bold, color: jsmColor),
        controller: ctrl,
        readOnly: readOnly,
        onTap: () async {
          if (title.contains("Transport")) {
            var model = await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return BlocProvider(create: (context) => EmpOrderFormTransportCubit(context), child: EmpOrderFormTransport());
              },
            ));
            if (model == null) return;
            if (model is TransportModel) {
              model;
              ctrlTransport.text = model.label!;
            }
          } else if (title.contains("Date")) {
            orderDate = await Myf.selectDate(context);
            if (orderDate != null) {
              ctrlOrderDate.text = Myf.dateFormate(orderDate.toString());
            }
            return;
          } else if (title.contains("Customer")) {
            pushScreen = BlocProvider(
                create: (context) => AgEmpOrderFormPartyCubit(context, staffMobile: loginUserModel.mobilenoUser),
                child: AgEmpOrderFormParty(atype: "1"));
            var model = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return pushScreen;
            }));
            if (model == null) return;
            if (model is AgMasterModel) {
              CustAgMasterModel = model;
              ctrlOrderCustomer.text = model.partyname!;
              // ctrlBrokerName.text = cubit.masterModel.broker!;
              // ctrlStation.text = cubit.masterModel.sT!;
              ctrlTransport.text = model.trspt!;
            }
          } else if (title.contains("Purchaser")) {
            pushScreen = BlocProvider(
                create: (context) => AgEmpOrderFormPartyCubit(context, purchaserMobileNO: loginUserModel.mobilenoUser),
                child: AgEmpOrderFormParty(atype: "17", AppBartitle: "Purchaser"));
            var model = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return pushScreen;
            }));
            if (model == null) return;
            if (model is AgMasterModel) {
              ctrlOrderStaff.text = model.partyname!;
            }
          } else if (title.contains("Supp. Group")) {
            pushScreen = BlocProvider(create: (context) => AgEmpOrderAcGroupCubit(context), child: AgEmpOrderAcGroup(AppBartitle: "Supplier Group"));
            var model = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return pushScreen;
            }));
            if (model == null) return;
            if (model is AgAcGroupModel) {
              agAcGroupModel = model;
              ctrlOrderSuppGroup.text = model.label!;
            }
          } else if (title.toUpperCase().contains("CASES")) {
            ctrlOrderCases.selection = TextSelection(baseOffset: 0, extentOffset: ctrlOrderCases.text.length);
          } else if (title.toUpperCase().contains("PCS")) {
            ctrlOrderQty.selection = TextSelection(baseOffset: 0, extentOffset: ctrlOrderQty.text.length);
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
    if (_formKey.currentState!.validate()) {
      if (CustAgMasterModel.partyname == null || CustAgMasterModel.partyname == "") {
        Myf.snakeBar(context, "*Select Customer");
        return;
      }

      if (agAcGroupModel.label == null || agAcGroupModel.label == "") {
        Myf.snakeBar(context, "*Select Supplier Group");
        return;
      }

      if (!isSaving) {
        isSaving = true;
        save();
      }
    } else {
      Myf.snakeBar(context, "*Fill all details");
    }
  }

  save() async {
    Myf.showBlurLoading(context);

    var orderBreak = false;
    if (widget.agEmpOrderModel == null) {
      agEmpOrderModel.VNO = empOrderSettingModel.IniOrderVno ?? 10001;
      await fireBCollection
          .collection("supuser")
          .doc(GLB_CURRENT_USER["CLIENTNO"])
          .collection("EMPIRE")
          .doc(GLB_CURRENT_USER["yearVal"])
          .collection("EMP_ORDER")
          .orderBy("VNO", descending: true)
          .limit(1)
          .get(fireGetOption)
          .then((value) async {
        var snp = value.docs;
        if (snp.length > 0) {
          await Future.wait(snp.map((e) async {
            dynamic d = e.data();
            AgEmpOrderModel b = AgEmpOrderModel.fromJson(Myf.convertMapKeysToString(d));
            var newVno = b.VNO + 1;
            agEmpOrderModel.VNO = newVno;
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
    if (attachment != null) {
      final StreamController<double> uploadProgress = StreamController<double>.broadcast();
      var error = "";
      //upload image to firebase
      //need to show progress indicator while uploading image to firestorage can you help me with that
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Uploading Image"),
            content: SingleChildScrollView(
              child: StreamBuilder<double>(
                  stream: uploadProgress.stream,
                  builder: (context, snapshot) {
                    var value = snapshot.data ?? 0.0;
                    return ListBody(
                      children: <Widget>[
                        if (error.isNotEmpty) Text("${error}") else Text("Please wait while we upload the image"),
                        LinearProgressIndicator(
                          value: value,
                        ),
                      ],
                    );
                  }),
            ),
          );
        },
      );

      agEmpOrderModel.fileKeyPath = "${loginUserModel.softwareName}/${loginUserModel.cLIENTNO}/${agEmpOrderModel.VNO}.jpeg";
      try {
        // Get reference to the Firebase Storage bucket
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child("${agEmpOrderModel.fileKeyPath}");
        UploadTask uploadTask = ref.putData(attachment!);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          uploadProgress.sink.add(progress);
        }, onError: (e) {
          error = 'Upload error: $e';
          uploadProgress.sink.add(0.0);
        });

        TaskSnapshot snapshot = await uploadTask;
        agEmpOrderModel.url = await snapshot.ref.getDownloadURL();
        Navigator.pop(context);
      } catch (e) {
        error = 'Upload error: $e';
        uploadProgress.sink.add(0.0);
        null;
        return;
      }
    }
    if (agEmpOrderModel.fileKeyPath == null && agEmpOrderModel.url == null) {
      await Myf.deleteMediaFromFireStorage(agEmpOrderModel.fileKeyPath); //deleting media from firestorage
    }

    orderDate = orderDate ?? DateTime.now();
    CustAgMasterModel.brokerModel = AgMasterModel.fromJson(jsonDecode("{}")); //brokerModel details null;

    agEmpOrderModel.masterDet = CustAgMasterModel;
    agEmpOrderModel.acGroupDet = agAcGroupModel;
    agEmpOrderModel.date = orderDate.toString();
    agEmpOrderModel.ide = agEmpOrderModel.ide.isNotEmpty ? agEmpOrderModel.ide : "${agEmpOrderModel.VNO}-${agEmpOrderModel.date}";
    agEmpOrderModel.ordNo = agEmpOrderModel.VNO.toString();
    agEmpOrderModel.close = 'N';
    agEmpOrderModel.unit = _selectedUnit;
    agEmpOrderModel.qty = Myf.convertToDouble(ctrlOrderQty.text);
    agEmpOrderModel.mTime = DateTime.now().toString();
    agEmpOrderModel.staff = ctrlOrderStaff.text;
    agEmpOrderModel.supp = ctrlOrderSuppGroup.text;
    agEmpOrderModel.transport = ctrlTransport.text;
    agEmpOrderModel.suppOrdNo = ctrlOrderSuppOrdno.text;
    agEmpOrderModel.cust = ctrlOrderCustomer.text;
    agEmpOrderModel.rmk = ctrlOrderRmk.text;
    agEmpOrderModel.status = "pending";
    agEmpOrderModel.cases = Myf.toIntVal(ctrlOrderCases.text ?? "0");

    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .doc(agEmpOrderModel.ide)
        .set(agEmpOrderModel.toJson())
        .then((value) {
      isSaving = false;
      Myf.snakeBar(context, "Order Saved");
      Navigator.pop(context);
      Navigator.pop(context);
    });
    if (empOrderSettingModel.askForSharePdfRate ?? true) {
      // await Myf.askForShareOption(context, agEmpOrderModel);
    } else {
      // var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [agEmpOrderModel], context: context);
    }
  }
}
