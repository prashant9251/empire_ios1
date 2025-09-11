import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:empire_ios/Apis/printerApis.dart';
import 'package:empire_ios/Models/BillDispatchModel.dart';
import 'package:empire_ios/Models/BlsModel.dart';
import 'package:empire_ios/Models/DetModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GatePass/GatePass.dart';
import 'package:empire_ios/screen/GatePass/cubit/GatePassCubitStateSearchRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SaleDispatchCubit extends Cubit<SaleDispatchState> {
  final player = AudioPlayer();

  BillDispatchModel? billDispatchModel = BillDispatchModel();

  List<QualModel> qualList = [];
  String reqBarcode = "";
  var ctrlreqBarcode = TextEditingController();
  Map<String, dynamic> reQobj = {};

  BuildContext context;

  bool isDisposed = false;

  var ctrlQualBarcode = TextEditingController();
  var qualFocusNode = FocusNode();
  SaleDispatchCubit(this.context, {this.billDispatchModel}) : super(SaleDispatchInitial()) {
    print("SaleDispatchCubit");
    getData();
  }

  getData() async {
    loadBilldetails();
  }

  loadBilldetails() async {
    Widget widget = billdetailsWidget();
    emit(SaleDispatchLoadBill(widget));
    await Future.delayed(Duration(seconds: 1), () {
      qualFocusNode.requestFocus();
    });
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
        // emit(GatePassCubitLoadBill(SizedBox.shrink()));
        // emit(GatePassCubitSreeenLoad(SizedBox.shrink()));
        SearchApi(reQobj, barcode);
      } else {
        // emit(GatePassCubitStateUserDateBasConnIssue("${barcode} invalid barcode"));
      }
    } else {
      reQobj["barcode"] = barcode;
      SearchApi(reQobj, barcode);
    }
  }

  void SearchApi(Map<String, dynamic> reQobj, barcode) async {
    var checkBillExistRes = await checkBillExist(reQobj);
    if (checkBillExistRes == true) {
      showSimpleNotification(Text("Bill Already Dispatched"), background: Colors.red);
      return;
    }
    blsGatePassModel = BlsModel();
    if (!isDisposed) emit(SaleDispatchLoadBill(Center(child: Text("Searching..."))));
    await GatePassCubitStateSearchRequest.serachRequest(reQobj);
    if (blsGatePassModel.code != null && blsGatePassModel.code!.isNotEmpty) {
      List<BlsBillDetails> blsBillDetails = blsGatePassModel.billdetails ?? [];
      if (blsBillDetails.length > 0) {
        blsBillDetails.forEach((bills) {
          billDispatchModel = BillDispatchModel(
            cBy: loginUserModel.loginUser,
            CNO: bills.cno,
            TYPE: bills.type,
            VNO: bills.vno,
            masterModel: blsGatePassModel.masterModel,
            bill: bills.bill,
            bcode: bills.bcode,
            date: bills.date,
            billDispatchDetails: bills.detBillDetails ?? [],
          );
        });
        loadBilldetails();
      }
    }
  }

  Widget billdetailsWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: jsmColor,
            elevation: 10,
            child: ListTile(
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bill No ${billDispatchModel!.bill ?? ""}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "#${Myf.dateFormateInDDMMYYYY(billDispatchModel!.date) ?? ""}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${billDispatchModel!.masterModel!.partyname ?? ""}",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${billDispatchModel!.masterModel!.aD1 ?? ""},${billDispatchModel!.masterModel!.aD2 ?? ""},${billDispatchModel!.masterModel!.city ?? ""}",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text("GSTIN: ${billDispatchModel!.masterModel!.gST ?? ""}", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: jsmColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Verify products", style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold)),
                  )),
                  Flexible(
                      child: TextFormField(
                    focusNode: qualFocusNode,
                    onFieldSubmitted: (value) {
                      checkBarcodeInBill(value);
                    },
                    controller: ctrlQualBarcode,
                    decoration: InputDecoration(
                      labelText: "Product Barcode",
                      border: OutlineInputBorder(),
                    ),
                  )),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () async {
                          String barcodeScanRes = await BarCodeScaneGoogleMlKit.startScane() ?? "";
                          if (barcodeScanRes == null || barcodeScanRes == "") return;
                          barcodeScanRes = barcodeScanRes.trim();
                          Myf.snakeBar(context, "Scanned barcode: $barcodeScanRes");
                          checkBarcodeInBill(barcodeScanRes);
                        },
                        icon: Icon(Icons.qr_code_2),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.symmetric(inside: BorderSide(width: 1, color: Colors.black)),
                  // columnSpacing: getValueForScreenType(context: context, mobile: 10, tablet: 20, desktop: 30),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Product', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                    DataColumn(numeric: true, label: Text(' PCS ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                    DataColumn(
                        numeric: true, label: Text(' PCS PER SET ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                    DataColumn(numeric: true, label: Text('Verified', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                    DataColumn(numeric: true, label: Text('Pending', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))),
                  ],
                  rows: <DataRow>[
                    ...billDispatchModel!.billDispatchDetails!.map((e) {
                      var verified = Myf.convertToDouble(e.tallyPcs) == Myf.convertToDouble(e.pcs) && Myf.convertToDouble(e.tallyPcs) > 0;
                      return DataRow(
                        color: WidgetStateProperty.all(verified ? Colors.green : Colors.red.shade200),
                        cells: <DataCell>[
                          DataCell(Checkbox(
                              value:
                                  Myf.convertToDouble(e.tallyPcs) == Myf.convertToDouble(e.pcs) && Myf.convertToDouble(e.tallyPcs) > 0 ? true : false,
                              onChanged: (value) {},
                              activeColor: jsmColor)),
                          DataCell(Text(e.qual ?? "")),
                          DataCell(AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                Myf.convertToDouble(e.pcs).toString(),
                                key: ValueKey<double>(Myf.convertToDouble(e.pcs)),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          DataCell(Text(e.pcsParSet ?? "")),
                          DataCell(AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                Myf.convertToDouble(e.tallyPcs).toString(),
                                key: ValueKey<double>(Myf.convertToDouble(e.tallyPcs)),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          DataCell(AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                Myf.convertToDouble(e.tallyPendingPcs).toInt().toString(),
                                key: ValueKey<int>(Myf.convertToDouble(e.tallyPendingPcs).toInt()),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ))),
                        ],
                      );
                    })

                    // Add more DataRow here if needed
                  ],
                ),
              ),
            ],
          ),
        ),
        // check if all is verified then show of bottom

        // billDispatchModel!.billDispatchDetails!
        //             .where((element) => Myf.convertToDouble(element.tallyPcs) != Myf.convertToDouble(element.pcs))
        //             .length ==
        //         0
        //     ? Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 16.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             ElevatedButton(
        //               onPressed: () async {},
        //               style: ElevatedButton.styleFrom(backgroundColor: jsmColor),
        //               child: const Text("Save", style: TextStyle(color: Colors.white)),
        //             ),
        //           ],
        //         ),
        //       )
        //     : SizedBox.shrink(),
      ],
    );
  }

  void checkBarcodeInBill(String barcodeScanRes) async {
    var itemFound = false;
    billDispatchModel!.billDispatchDetails!.forEach((element) {
      if (element.itsr == barcodeScanRes) {
        player.play(AssetSource("img/search.mp3"));
        itemFound = true;
        var tallyPcs = Myf.convertToDouble(element.tallyPcs) + Myf.convertToDouble(element.pcsParSet);
        if (tallyPcs <= Myf.convertToDouble(element.pcs)) {
          element.tallyPcs = tallyPcs.toString();
        } else {
          showSimpleNotification(Text("Already Verified"), background: Colors.red);
        }
      }
    });
    if (itemFound == false) {
      showSimpleNotification(Text("Item not found in bill"), background: Colors.red);
    }
    await loadBilldetails();
    ctrlQualBarcode.clear();
    qualFocusNode.requestFocus();
    if (billDispatchModel!.billDispatchDetails!
            .where((element) => Myf.convertToDouble(element.tallyPcs) != Myf.convertToDouble(element.pcs))
            .length ==
        0) {
      await save();
      Uint8List? bytes = await stickerPrint(billDispatchModel);
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes!);
      Navigator.pop(context);
    }
  }

  save() async {
    billDispatchModel!.cBy = loginUserModel.loginUser;
    billDispatchModel!.cTime = DateTime.now().toString();
    var id = "${billDispatchModel!.CNO}_${billDispatchModel!.TYPE}_${billDispatchModel!.VNO}";
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_SALE_DISPATCH")
        .doc(id)
        .set(billDispatchModel!.toJson())
        .then(
          (value) {},
        );
  }

  checkBillExist(reqObj) async {
    var id = "${reqObj["CNO"]}_${reqObj["TYPE"]}_${reqObj["VNO"]}".toUpperCase();
    logger.d("id: $id");
    var doc = await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_SALE_DISPATCH")
        .doc(id)
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }
}

abstract class SaleDispatchState {}

class SaleDispatchInitial extends SaleDispatchState {}

class SaleDispatchLoadBill extends SaleDispatchState {
  Widget widget;
  SaleDispatchLoadBill(this.widget);
}
