import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpBillPdfView/EmpBillPdfView.dart';
import 'package:empire_ios/screen/GatePass/GatePass.dart';
import 'package:empire_ios/screen/GatePass/GatePassModel.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitState.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitStateGpUpdateRequest%20.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitStateSearchRequest.dart';
import 'package:empire_ios/screen/GatePass/mobile.dart';
import 'package:empire_ios/screen/GatePass/scanner_error_widget.dart';
import 'package:empire_ios/screen/MobileScanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GatePassCubit extends Cubit<GatePassCubitState> {
  var isDisposed = false;
  var selectPerson = false;
  StreamSubscription<DocumentSnapshot>? snapshotSubscription;
  final player = AudioPlayer();
  var gpRequested = false;
  var searchRequested = false;
  BuildContext context;
  Map<String, dynamic> reQobj = {};
  GatePassModel? gatePassModel;
  var flashOn = false;
  var reqBarcode = "";

  var barcode = "";
  var ctrlScanner = MobileScannerController();

  var ctrlBarcodeInput = TextEditingController();
  var ctrlMukadam = TextEditingController(text: "");
  var ctrlFocuseNode = FocusNode();
  var clickByScanner = false;
  GatePassCubit(this.context) : super(GatePassCubitStateIni()) {
    // scanQRForAndroid();
    fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("GATEPASS_REPORT")
        .where("DATE", isLessThan: DateTime.now().subtract(Duration(days: 7)).toString())
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("SETTINGS").doc("EMP_GATEPASS").snapshots().listen((value) {
      if (value.exists) {
        dynamic snp = value.data();
        selectPerson = snp["selectPerson"];
      }
    });
    iniScreen();
  }

  Future<void> scanQRForAndroid() async {
    iniScreen();
    this.barcode = "";
    String barcodeScanRes;
    if (Myf.isAndroid()) {
      barcodeScanRes = await AndroidChennal.invokeMethod('startScane', []);
      // barcodeScanRes = await Myf.Navi(context, EmpOrderproductScanner());
      if (barcodeScanRes == null || barcodeScanRes == "") return;
    } else {
      barcodeScanRes = await BarCodeScaneGoogleMlKit.startScane() ?? "";
      if (barcodeScanRes == null || barcodeScanRes == "") return;
    }
    barcodeScanRes = barcodeScanRes.trim();
    splitBarCode(barcodeScanRes);
  }

  scaneSecondQr() async {
    iniScreen();
    String barcodeScanRes = await BarCodeScaneGoogleMlKit.startScane() ?? "";
    if (barcodeScanRes == null || barcodeScanRes == "") return;
    barcodeScanRes = barcodeScanRes.trim();
    splitBarCode(barcodeScanRes);
  }

  scaneSecondQr3() async {
    iniScreen();
    var barcodeScanRes = await Myf.Navi(context, MobileScannerScreen());
    GFToast.showToast(
      "Scanned: ${barcodeScanRes}",
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 1,
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.black87,
    );
    if (barcodeScanRes == null || barcodeScanRes == "") return;
    splitBarCode(barcodeScanRes!, bySplit: true);
  }

  // startScane({flashOn = false}) async {
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.first;
  //   StatefulWidget app = Mobile(camera: firstCamera);
  //   var barcodeResult = await Myf.Navi(context, app);
  // }
  void iniScreen() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      Myf.snakeBar(context, "Camera permission is required to scan.");
      return;
    }
    if (!isDisposed) emit(GatePassCubitSreeenLoad(Center(child: Text("Start Scane", style: textstyle()))));
  }

  splitBarCode(String barcode, {bySplit = true}) async {
    List<String> splitStrings = barcode.split('-');
    reqBarcode = barcode.toString();
    reQobj = {};
    var sr = 0;
    if (bySplit) {
      await Future.wait(splitStrings.map((e) async {
        sr++;
        if (sr == 1) {
          reQobj["CNO"] = e;
        } else if (sr == 2) {
          reQobj["TYPE"] = e;
        } else if (sr == 3) {
          reQobj["VNO"] = e;
        } else if (sr == 4) {
          reQobj["DATE"] = GatePassCubitStateSearchRequest.convertToFormattedDate(e);
        }
      }).toList());
      var CNO = Myf.convertToDouble(reQobj["CNO"]);
      if (CNO > 0 && reQobj["DATE"] != "" && reQobj["DATE"] != null) {
        emit(GatePassCubitLoadBill(SizedBox.shrink()));
        emit(GatePassCubitSreeenLoad(SizedBox.shrink()));
        SearchApi(reQobj, barcode);
        // ctrlScanner.stop();
        // ctrlScanner.stop();
      } else {
        // emit(GatePassCubitStateUserDateBasConnIssue("${barcode} invalid barcode"));
      }
    } else {
      reQobj["barcode"] = barcode;
      SearchApi(reQobj, barcode);
    }
  }

// old api-----
  void SearchApi(Map<String, dynamic> reQobj, barcode) async {
    if (searchRequested) return;
    searchRequested = true;
    if (!isDisposed) emit(GatePassCubitSreeenLoad(Text("Searching...", style: textstyle())));
    gatePassModel = await GatePassCubitStateSearchRequest.serachRequest(reQobj);
    if (clickByScanner == false) ctrlFocuseNode.requestFocus();
    if (gatePassModel == null) {
      player.play(AssetSource("img/error.mp3"));
      if (!isDisposed) emit(GatePassCubitSreeenLoad(Text("somthing went wrong #1", style: textstyle())));
      searchRequested = false;
    } else {
      if (gatePassModel!.error != null) {
        player.play(AssetSource("img/error.mp3"));
        if (!isDisposed) emit(GatePassCubitSreeenLoad((Text("${gatePassModel!.error ?? ""}\n $barcode", style: textstyle()))));
      } else {
        if (gatePassModel!.userStatus == "invalid") {
          if (!isDisposed) {
            player.play(AssetSource("img/error.mp3"));
            emit(GatePassCubitSreeenLoad(
                Center(child: Column(children: [Icon(Icons.error, size: 70, color: Colors.red), Text("Invalid User", style: textstyle())]))));
          }
        } else {
          if (gatePassModel!.dbStatus == "CONNECTED") {
            if (getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop) {
              if (empOrderSettingModel.gatePassPrintDirect ?? true)
                emit(GatePassCubitLoadBill(EmpBillPdfView(directPrint: false, blsModel: blsGatePassModel)));
              await Future.delayed(Duration(seconds: 1));
            }
            await showDetail(gatePassModel);
          } else {
            if (!isDisposed) {
              player.play(AssetSource("img/error.mp3"));

              emit(GatePassCubitSreeenLoad(Center(
                  child: Column(children: [
                Icon(Icons.error, size: 70, color: Colors.red),
                Text("${gatePassModel!.dbStatus}", style: TextStyle(fontSize: 30))
              ]))));
            }
          }
        }
      }
      searchRequested = false;
      if (getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop) {
        if ((gatePassModel!.gpdate == null || gatePassModel!.gpdate == "") && gatePassModel!.billNo != null && gatePassModel!.billNo != "") {
          await gpUpdate();
        }
      }
    }
    if (clickByScanner == false) ctrlFocuseNode.requestFocus();
  }

  TextStyle textstyle() => TextStyle(fontSize: 20, color: jsmColor);

  // void SearchApiFire(Map<String, dynamic> reQobj) async {
  //   if (searchRequested) return;
  //   searchRequested = true;
  //   emit(GatePassCubitStateStartLoading("Request Sending"));
  //   var reqSend = await GatePassCubitStateSearchRequest.serachRequest2(reQobj);
  //   if (reqSend == false) {
  //     emit(GatePassCubitStateNotFound("somthing went wrong #1"));
  //     searchRequested = false;
  //   } else {
  //     emit(GatePassCubitStateStartLoading("Request Sent waiting for response"));
  //     getResponse();
  //     searchRequested = false;
  //   }
  // }

  showDetail(GatePassModel? gatePassModel) async {
    var msg = "";
    if (gatePassModel!.fetchStatus != "success") {
      if (!isDisposed) {
        player.play(AssetSource("img/error.mp3"));
        emit(GatePassCubitSreeenLoad(Text('${gatePassModel.fetchStatus ?? "${reqBarcode}\n No Data Found"}\n $barcode', style: textstyle())));
      }
      return;
    }
    if (gatePassModel.updateGp == "success") {
      msg = "Gp Date successfully saved ";
      // if (getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.desktop)
      //   Myf.showMsg(context, "Alert", "$msg \n${Myf.dateFormate(gatePassModel.gpdate)}", titleColor: Colors.green);
    }

    bool boolGpExist = gatePassModel.gpdate != null && gatePassModel.gpdate != "" ? true : false;
    if (boolGpExist && gatePassModel.gpdate != null && gatePassModel.gpdate != "" && gatePassModel.updateGp != "success") {
      msg = "Gp Date already Generated ";
      // if (getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.desktop)
      //   Myf.showMsg(context, "Alert", "$msg \n${Myf.dateFormate(gatePassModel.gpdate)}", titleColor: Colors.red);
    }
    player.play(AssetSource("img/search.mp3"));

    Widget widget = SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: boolGpExist ? jsmColor : Colors.red,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "${gatePassModel.fIRM}",
                      style: TextStyle(
                        color: jsmColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Bill No:")),
                          Flexible(
                            child: Chip(
                              label: Text(
                                "${gatePassModel.billNo}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    rowtitleText("Date:", "${Myf.dateFormateInDDMMYYYY(gatePassModel.dATE)}"),
                    rowtitleText("Party Name:", "${gatePassModel.party}"),
                    rowtitleText("City:", "${gatePassModel.city}"),
                    rowtitleText("Haste:", "${gatePassModel.haste}"),
                    rowtitleText("Transport:", "${gatePassModel.transport}"),
                    rowtitleText("Station:", "${gatePassModel.station}"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Total Qty:")),
                          Flexible(
                            child: CircleAvatar(
                              child: Text(
                                "${gatePassModel.totalPcs}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text("Bill Amount:")),
                          Flexible(
                            child: Text(
                              "${gatePassModel.billAmt}/-",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                    boolGpExist && gatePassModel.gpdate != null && gatePassModel.gpdate != ""
                        ? Text(
                            "$msg",
                            style: TextStyle(
                              fontSize: 20,
                              color: gatePassModel.updateGp == "success" ? Colors.green : Colors.red,
                            ),
                          )
                        : SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: gatePassModel.gpdate != null && gatePassModel.gpdate != ""
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text("${Myf.dateFormate(gatePassModel.gpdate)}"))
                              : FloatingActionButton.extended(
                                  backgroundColor: Colors.green,
                                  heroTag: "confirmBtnGatepass",
                                  onPressed: () => gpUpdate(),
                                  label: Text("CONFIRM"),
                                ),
                        ),
                        Flexible(
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.amber,
                            heroTag: "PrintBtnGatepass",
                            onPressed: () {
                              Myf.Navi(context, EmpBillPdfView(directPrint: false, blsModel: blsGatePassModel));
                            },
                            label: Text("Print"),
                          ),
                        ),
                        Flexible(
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.blueAccent,
                            heroTag: "closeBtnGatepass",
                            onPressed: () => Navigator.pop(context),
                            label: Text("Close"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "BarCode: ${reqBarcode}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
    if (!isDisposed) emit(GatePassCubitSreeenLoad(widget));
  }

  Widget rowtitleText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text("$title")),
          Flexible(
              child: Text(
            "$value",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          )),
        ],
      ),
    );
  }

  //  old gpupdate api ----------
  gpUpdate() async {
    if (searchRequested) return;
    searchRequested = true;
    if (selectPerson == true && ctrlMukadam.text.isEmpty) {
      Myf.snakeBar(context, "please select Mukadam");
      searchRequested = false;
      return;
    }
    reQobj["mukadam"] = ctrlMukadam.text;
    gatePassModel = await GatePassCubitStateGpUpdateRequest.gpUpdate(reQobj);
    gpRequested = true;
    if (gatePassModel == null) {
      if (!isDisposed) emit(GatePassCubitSreeenLoad(Text("somthing went wrong #2", style: textstyle())));
      searchRequested = false;
    } else {
      if (getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop) {
        if (empOrderSettingModel.gatePassPrintDirect ?? true)
          emit(GatePassCubitLoadBill(EmpBillPdfView(directPrint: true, blsModel: blsGatePassModel)));
        await Future.delayed(Duration(seconds: 1));
      } else {
        // if (empOrderSettingModel.gatePassPrintDirect ?? false) {
        //   Myf.Navi(context, EmpBillPdfView(directPrint: true, blsModel: blsGatePassModel));
        // }
      }
      fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("GATEPASS_REPORT").add(gatePassModel!.toJson());
      showDetail(gatePassModel);
      searchRequested = false;
    }
    if (clickByScanner == false) ctrlFocuseNode.requestFocus();
  }

  SelectMukadimUser() async {
    final Completer<String> _Completer = Completer<String>();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      "SELECT PERSON",
                      style: TextStyle(fontSize: 25, color: jsmColor),
                    ),
                  ),
                  Flexible(child: IconButton(onPressed: () => addMukadimUser(), icon: Icon(Icons.add))),
                  Flexible(
                      child: SwitchListTile(
                    onChanged: (value) {
                      fireBCollection
                          .collection("supuser")
                          .doc(GLB_CURRENT_USER["CLIENTNO"])
                          .collection("SETTINGS")
                          .doc("EMP_GATEPASS")
                          .set({"ID": "EMP_GATEPASS", "selectPerson": value});
                      Myf.popScreen(context);
                      SelectMukadimUser();
                    },
                    value: selectPerson,
                  ))
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: fireBCollection
                    .collection("supuser")
                    .doc(GLB_CURRENT_USER["CLIENTNO"])
                    .collection("EMP_USER")
                    .where("type", isEqualTo: "mukadam")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var snp = snapshot.data!.docs;
                  if (snp.length == 0) {
                    return Center(child: Text("No data found"));
                  }
                  return Column(
                    children: [
                      ...snp
                          .map((e) => Card(
                                color: jsmColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    onTap: () {
                                      _Completer.complete(e.id);
                                      Navigator.pop(context, e.id);
                                    },
                                    title: Text(
                                      e.id,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    leading: Icon(Icons.ads_click),
                                  ),
                                ),
                              ))
                          .toList()
                    ],
                  );
                },
              )
            ],
          ),
        );
      },
    );
    return _Completer.future;
  }

  addMukadimUser() async {
    final Completer _Completer = Completer();
    var ctrlPersonName = TextEditingController();
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
              Row(
                children: [
                  Text(
                    "New Person",
                    style: TextStyle(fontSize: 25, color: jsmColor),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              TextFormField(
                controller: ctrlPersonName,
                decoration: InputDecoration(label: Text("PERSON")),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                  onPressed: () async {
                    var person = ctrlPersonName.text.toUpperCase().trim();
                    if (person.isNotEmpty) {
                      await fireBCollection
                          .collection("supuser")
                          .doc(GLB_CURRENT_USER["CLIENTNO"])
                          .collection("EMP_USER")
                          .doc(person)
                          .set({"ID": person, "name": person, "type": "mukadam"});
                    }
                    Myf.popScreen(context);
                  },
                  icon: Icon(Icons.save),
                  label: Text("Save"))
            ],
          ),
        );
      },
    );
    return _Completer.future;
  }
}
