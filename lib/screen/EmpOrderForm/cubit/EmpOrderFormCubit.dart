import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/Models/EmpOrderSettingModel.dart';
import 'package:empire_ios/Models/ImageModel.dart';
import 'package:empire_ios/Models/PackingStyleModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/localRequest/getQual.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderproductScanner.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubitState.dart';
import 'package:empire_ios/screen/EmpOrderFormColor/EmpOrderFormColor.dart';
import 'package:empire_ios/screen/EmpOrderFormColor/cubit/EmpOrderFormColorCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/EmpOrderFormProduct.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormProductEdit/EmpOrderFormProductEdit.dart';
import 'package:empire_ios/screen/MobileScanner.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:hive/hive.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../Models/MasterModel.dart';

var iniSets = "1";
List<MasterModel> masterList = [];
List<QualModel> productList = [];
var rateSelected = "S1";
List<PackingStyleModel> packingStyleList = [];

PackingStyleModel packingStyleModel = PackingStyleModel();
double finaltotalPcs = 0.0;
double finaltotalMtr = 0.0;

class EmpOrderFormCubit extends Cubit<EmpOrderFormCubitState> {
  final ScrollController verticalScrollController = ScrollController();
  var qtyProductDetailsStream = StreamController<bool>.broadcast();
  var sr = 0;
  var ctrlOrderPacking = TextEditingController();
  late MasterModel masterModel = MasterModel();
  final formKeyProduct = GlobalKey<FormState>();
  BuildContext context;
  List<BillDetModel> billDetailslist = [];
  String? barcodeScanRes = "";
  final StreamController<bool> totalChangeStream = StreamController<bool>.broadcast();

  var focusNodeBarcode = FocusNode();
  EmpOrderFormCubit(this.context) : super(EmpOrderFormCubitStateIni()) {
    //getData();
  }

  getData() async {
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    var CuHiveBox = await Hive.openLazyBox("${databasId}QUL");
    var Qual = await CuHiveBox.get("${databasId}QUL", defaultValue: []) as List<dynamic>;
    productList = await Qual.map((json) => QualModel.fromJson(Myf.convertMapKeysToString(json))).toList();
    await CuHiveBox.close();

    List PACKINGSTYLE = [];
    Box packingBox = await Hive.openBox("${databasId}PACKINGSTYLE");
    PACKINGSTYLE = await packingBox.get("${databasId}PACKINGSTYLE", defaultValue: []) as List<dynamic>;
    packingStyleList = await Future.wait(PACKINGSTYLE.map((json) async => PackingStyleModel.fromJson(Myf.convertMapKeysToString(json))).toList());
    PACKINGSTYLE.clear();
    await packingBox.close();
    await getQual.start({});
  }

  startScane() async {
    // Request camera permission before scanning

    var status = await Permission.camera.request();
    if (!status.isGranted) {
      Myf.snakeBar(context, "Camera permission is required to scan.");
      return;
    }
    if (Myf.isAndroid()) {
      barcodeScanRes = await AndroidChennal.invokeMethod('startScane', []);
      // barcodeScanRes = await Myf.Navi(context, EmpOrderproductScanner());
      if (barcodeScanRes == null || barcodeScanRes == "") return;
      this.barcodeScanRes = barcodeScanRes;
      loadResult(barcodeScanRes);
    } else {
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
      this.barcodeScanRes = barcodeScanRes;
      loadResult(barcodeScanRes);
    }
  }

  loadResult(barcodeScanRes) async {
    if (barcodeScanRes == null || barcodeScanRes == "") return;
    barcodeScanRes = barcodeScanRes!.trim();
    List<QualModel> list = await productList.where((element) {
      if (element.itemSrNo == barcodeScanRes) {
        element.selected = true;
        return true;
      }
      return false;
    }).toList();
    selectProduct(list);
  }

  void selectProductStart() async {
    productList = await productList.where((e) {
      e.selected = false;
      return true;
    }).toList();

    List<QualModel>? list = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BlocProvider(create: (context) => EmpOrderFormProductCubit(context), child: EmpOrderFormProduct(productList: productList))));
    if (list == null) return;
    selectProduct(list);
  }

  void selectProduct(List<QualModel> list) async {
    //---select packing before selected product load
    if (empOrderSettingModel.showPackingSelectionAtBottom != true) {
      if (packingStyleModel.packingStyle == null) {
        await selectPacking(context);
      }
    }

    //--loading product selected

    await Future.wait(list.map((qualModel) async {
      if (qualModel.selected == true) {
        String i = Myf.qualImgLink(qualModel);
        if (i.isNotEmpty) {
          qualModel.imageUrl = i;
        }
        sr++;
        var rate = selectRate(qualModel);
        var pcs = "1";
        if (empOrderSettingModel.setsSystemOn == true) {
          var sets = Myf.convertToDouble(iniSets);
          var pcsInSets = Myf.convertToDouble(qualModel.pcsPerSet == "" || qualModel.pcsPerSet == null ? "1" : qualModel.pcsPerSet);
          pcs = (sets * pcsInSets).toString();
        }
        BillDetModel billDetModel = BillDetModel(
          rateEnteredManual: false,
          sR: sr.toString(),
          qUAL: qualModel.value,
          imageUrl: qualModel.imageUrl,
          pCS: pcs,
          rATE: selectRate(qualModel),
          uNIT: "PCS",
          mTR: "0",
          aMT: "0",
          rmk: "",
          packing: packingStyleModel.packingStyle ?? qualModel.packing,
          iniPacking: qualModel.packing,
          category: qualModel.category,
          cUT: qualModel.cut,
          vatRate: qualModel.vatRate,
          sets: iniSets,
          pcsInSets: qualModel.pcsPerSet == "" || qualModel.pcsPerSet == null ? "1" : qualModel.pcsPerSet,
          mainScreen: qualModel.mainScreen,
        );
        //packing rate adding
        packingRateAddCheck(billDetModel, context);

        //packing rate adding
        billDetailslist.add(billDetModel);
        return true;
      }

      return false;
    }).toList());
    loadProductDetails();
  }

  static Future<PackingStyleModel> selectPacking(context) async {
    var model = await EmpOrderFormCubitStateSelectPacking(context).selectPacking();
    if (model is PackingStyleModel) {
      packingStyleModel = model;
    }
    return packingStyleModel;
  }

  String? selectRate(QualModel qualModel) {
    switch (rateSelected) {
      case "S1":
        return qualModel.s1;
      case "S2":
        return qualModel.s2;
      case "S3":
        return qualModel.s3;
      default:
    }
    return qualModel.s1;
  }

  loadEditBillDetails(List<BillDetModel> list) {
    this.billDetailslist = list;
    loadProductDetails();
  }

  void loadProductDetails() {
    billDetailslist.sort(
      (a, b) {
        return int.parse(a.sR!).compareTo(int.parse(b.sR!));
      },
    );
    if (billDetailslist.length > 0) {
      sr = int.parse(billDetailslist.last.sR!);
    }
    Widget widget = billDetails();
    emit(EmpOrderFormCubitStateLoadProduct(widget));
  }

  Widget billDetails() {
    billDetailslist.sort((a, b) {
      return int.parse(a.sR!).compareTo(int.parse(b.sR!));
    });
    finaltotalPcs = 0.0;
    finaltotalMtr = 0.0;
    return Form(
        key: formKeyProduct,
        child: billDetailslist.length == 0
            ? SizedBox.shrink()
            : ExpansionTile(
                minTileHeight: 50,
                initiallyExpanded: true,
                title: Text("ITEMS (${billDetailslist.length})"),
                children: [
                  ...billDetailslist.map((billDetModel) => productCard(billDetModel)).toList(),
                  StreamBuilder(
                      stream: totalChangeStream.stream,
                      builder: (context, asyncSnapshot) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: screenWidthMobile,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Pcs : ${finaltotalPcs.toInt()}"),
                              Text("Total Mtr : ${finaltotalMtr.toStringAsFixed(2)}"),
                              Text("Product Count : ${billDetailslist.length}"),
                            ],
                          ),
                        );
                      })
                ],
              ));
  }

  Card productCard(BillDetModel billDetModel) {
    List<ColorModel>? colorList = billDetModel.colorDetails ?? [];
    return Card(
      // color: Color.fromARGB(255, 233, 187, 167),
      elevation: 20,
      shadowColor: Colors.black,
      child: Container(
        width: screenWidthMobile,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: jsmColor,
              ),
              child: Row(
                children: [
                  // Flexible(child: Text("$sr", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: GestureDetector(
                        onTap: () => Myf.Navi(context, fullScreenImg(img_list: ["${billDetModel.imageUrl}"])),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: "${billDetModel.imageUrl}",
                              height: 60,
                              width: screenWidthMobile * .15,
                              fit: BoxFit.cover,
                              httpHeaders: {
                                "Authorization": basicAuthForLocal,
                              },
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              placeholder: (context, url) => ShimmerSkelton(width: screenWidthMobile * .15, height: 60),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7, // You can adjust the flex value as needed
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<QualModel>(
                            future: gerQualModel(billDetModel),
                            builder: (context, snapshot) {
                              QualModel itemQualModel = snapshot.data ?? QualModel();
                              Widget stockText = SizedBox.shrink();
                              if (itemQualModel.finishStock != null && itemQualModel.finishStock != '') {
                                stockText = Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox.shrink(),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(text: "Stock:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                        TextSpan(text: "${itemQualModel.finishStock}", style: TextStyle(color: Colors.black))
                                      ]),
                                    ),
                                  ],
                                );
                              }
                              return Expanded(
                                child: ListTile(
                                  minTileHeight: 50,
                                  title: Text(
                                    "${billDetModel.qUAL}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: stockText,
                                ),
                              );
                            }),
                        Flexible(
                          child: OverflowBar(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (EmpOrderForm.editMode) {
                                    askForCopyQtyToAll(billDetModel);
                                  } else {
                                    Myf.snakeBar(context, "please enable edit mode");
                                  }
                                }, // Replace with your onPressed logic
                                icon: Icon(Icons.copy),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (EmpOrderForm.editMode) {
                                    billDetailslist.remove(billDetModel);
                                    loadProductDetails();
                                  } else {
                                    Myf.snakeBar(context, "please enable edit mode");
                                  }
                                }, // Replace with your onPressed logic
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            StreamBuilder<bool>(
                stream: qtyProductDetailsStream.stream,
                builder: (context, snapshot) {
                  return qtyProductDetails(billDetModel);
                }),
            if (empOrderSettingModel.colorSystemOn ?? true) ...[
              Divider(),
              ...colorList
                  .map(
                    (billDetModel) => colorDetails(billDetModel, colorList),
                  )
                  .toList(),
              TextButton(
                  onPressed: () async {
                    if (!EmpOrderForm.editMode) {
                      Myf.snakeBar(context, "please enable edit mode");
                      return;
                    }
                    List<ColorModel>? l = await Myf.Navi(
                        context,
                        BlocProvider(
                          create: (context) => EmpOrderFormColorCubit(context),
                          child: EmpOrderFormColor(billDetModel: billDetModel),
                        ));
                    if (l == null) return;
                    billDetModel.colorDetails = l.where((element) => element.selected == true).toList();
                    loadProductDetails();
                  },
                  child: Text("Add Design"))
            ],
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget qtyProductDetails(BillDetModel billDetModel) {
    var ctrlTotalQty = TextEditingController(text: billDetModel.pCS);
    var ctrlTotalMtr = TextEditingController(text: billDetModel.mTR);
    var ctrlPacking = TextEditingController(text: billDetModel.packing);
    if (ctrlOrderPacking.text.isNotEmpty) {
      ctrlPacking.text = ctrlOrderPacking.text;
      billDetModel.packing = ctrlPacking.text;
    }
    if (billDetModel.rateEnteredManual == false) {
      packingRateAddCheck(billDetModel, context);
    }
    var ctrlRate = TextEditingController(text: Myf.getPackingRate(billDetModel).toString());
    if (empOrderSettingModel.setsSystemOn == true && billDetModel.pcSManualEntered == false) {
      var sets = Myf.convertToDouble(billDetModel.sets);
      var pcsInSets = Myf.convertToDouble(billDetModel.pcsInSets);
      var qty = sets * pcsInSets;
      billDetModel.pCS = qty.toString();
    }
    List<ColorModel>? colorList = billDetModel.colorDetails ?? [];
    if (colorList.length > 0) {
      var qty = 0.0;
      colorList.where((e) {
        var i = Myf.convertToDouble(e.clQty);
        qty += i;
        return true;
      }).toList();
      billDetModel.pCS = qty.toString();
    }
    double cut = Myf.convertToDouble(billDetModel.cUT);
    var qty = Myf.convertToDouble(billDetModel.pCS);
    double mtr = (qty * cut);
    billDetModel.mTR = mtr.toString();
    ctrlTotalMtr.text = billDetModel.mTR.toString();
    finaltotalPcs += qty;
    finaltotalMtr += mtr;
    totalChangeStream.sink.add(true);
    var textInputType = TextInputType.numberWithOptions(decimal: true);
    ctrlTotalQty.text = qty.toInt().toString();
    var responsiveInputWidth = getValueForScreenType(
      context: context,
      mobile: screenWidthMobile * .2,
      tablet: screenWidthMobile * .1,
      desktop: screenWidthMobile * .05,
    );
    return ListTile(
      minVerticalPadding: 1,
      // leading: Container(width: screenWidthMobile * .15, child: Transform.scale(scale: .75, child: Text(""))),
      title: Wrap(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (empOrderSettingModel.setsSystemOn ?? true)
            if (empOrderSettingModel.frmItmShowSets ?? true)
              Container(
                width: responsiveInputWidth,
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  // controller: ctrlSets,
                  initialValue: billDetModel.sets,
                  enabled: EmpOrderForm.editMode,
                  readOnly: colorList.length > 0 ? true : false,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  keyboardType: textInputType,
                  onChanged: (value) {
                    billDetModel.sets = value;
                    iniSets = billDetModel.sets.toString();
                    billDetModel.pcSManualEntered = false;
                    loadProductDetails();
                  },
                  decoration: InputDecoration(
                    labelText: 'Sets',
                    hintText: 'Sets',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                    ),
                  ),
                ),
              ),
          if (empOrderSettingModel.setsSystemOn ?? true)
            if (empOrderSettingModel.frmItmPcsInSets ?? true)
              Container(
                width: responsiveInputWidth,
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: TextFormField(
                  initialValue: billDetModel.pcsInSets,
                  enabled: EmpOrderForm.editMode,
                  readOnly: colorList.length > 0 ? true : false,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  keyboardType: textInputType,
                  onChanged: (value) {
                    billDetModel.pcsInSets = value;
                    billDetModel.pcSManualEntered = false;
                    loadProductDetails();
                  },
                  decoration: InputDecoration(
                    labelText: 'Pcs in Sets',
                    hintText: 'Pcs in Sets',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                    ),
                  ),
                ),
              ),
          Container(
            width: responsiveInputWidth,
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TextFormField(
              enabled: EmpOrderForm.editMode,
              validator: (empOrderSettingModel.validatRate ?? true)
                  ? (value) {
                      {
                        if (value!.isEmpty) {
                          return "Qty";
                        } else if (Myf.convertToDouble(value) <= 0) {
                          return "Qty";
                        }
                      }
                      return null;
                    }
                  : null,
              controller: ctrlTotalQty,
              readOnly: colorList.length > 0 ? true : false,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              keyboardType: textInputType,
              onFieldSubmitted: (value) {
                billDetModel.pCS = value;
                billDetModel.pcSManualEntered = true;
                loadProductDetails();
              },
              onChanged: (value) {
                billDetModel.pCS = value;
                billDetModel.pcSManualEntered = true;
              },
              onTap: () {
                ctrlTotalQty.selection = TextSelection(baseOffset: 0, extentOffset: ctrlTotalQty.text.length);
                var colorDetails = billDetModel.colorDetails ?? [];
                if (colorDetails.length > 0) {
                  askForInputSetToSet(billDetModel);
                }
              },
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Quantity',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                ),
              ),
            ),
          ),
          if (empOrderSettingModel.frmItmPacking ?? true)
            Container(
              width: responsiveInputWidth,
              // width: width,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                readOnly: true,
                enabled: EmpOrderForm.editMode,
                onTap: () async {
                  var model = await selectPacking(context);
                  if (model is PackingStyleModel) {
                    billDetModel.packing = model.packingStyle;
                    ctrlPacking.text = model.packingStyle!;
                    packingStyleModel = model;
                    billDetModel.rateEnteredManual = false;
                    ctrlOrderPacking.text = "";
                    loadProductDetails();
                  }
                },
                controller: ctrlPacking,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Packing',
                  hintText: 'Packing',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
          if (empOrderSettingModel.frmItmCut ?? true)
            Container(
              width: responsiveInputWidth,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                textAlign: TextAlign.center,
                enabled: EmpOrderForm.editMode,
                onChanged: (value) {
                  billDetModel.cUT = value;
                  loadProductDetails();
                },
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: textInputType,
                initialValue: billDetModel.cUT,
                decoration: InputDecoration(
                  labelText: 'Cut',
                  hintText: 'Cut',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
          if (empOrderSettingModel.frmItmMtr ?? true)
            Container(
              width: responsiveInputWidth,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                controller: ctrlTotalMtr,
                enabled: EmpOrderForm.editMode,
                onChanged: (value) {
                  billDetModel.mTR = value;
                },
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: textInputType,
                decoration: InputDecoration(
                  labelText: 'Mtr',
                  hintText: 'Mtr',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
          if (empOrderSettingModel.frmItmRate ?? true)
            Container(
              width: responsiveInputWidth,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                enabled: EmpOrderForm.editMode,
                onChanged: (value) {
                  billDetModel.rATE = value;
                  // ctrlRate.text = value;
                  billDetModel.packingRate = "0";
                  billDetModel.rateEnteredManual = true;
                },
                onTap: () {
                  ctrlRate.selection = TextSelection(baseOffset: 0, extentOffset: ctrlRate.text.length);
                },
                validator: (empOrderSettingModel.validatRate ?? true)
                    ? (value) {
                        if (value!.isEmpty) {
                          return "Rate";
                        } else if (Myf.convertToDouble(value) <= 0) {
                          return "Rate";
                        }
                        return null;
                      }
                    : null,
                controller: ctrlRate,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: textInputType,
                decoration: InputDecoration(
                  labelText: 'Rate',
                  hintText: 'Rate',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
          if (empOrderSettingModel.frmItmRmk ?? true)
            Container(
              width: responsiveInputWidth,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                enabled: EmpOrderForm.editMode,
                readOnly: true,
                onTap: () async {
                  var v = await Myf.showEntryDialog(context, billDetModel.rmk, "Rmk");
                  if (v != null) {
                    billDetModel.rmk = v;
                    loadProductDetails();
                  }
                },
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: TextInputType.text,
                controller: TextEditingController(text: billDetModel.rmk),
                decoration: InputDecoration(
                  labelText: 'Rmk',
                  hintText: 'Rmk',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
          if (empOrderSettingModel.frmItmDno ?? false)
            Container(
              width: responsiveInputWidth,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                enabled: EmpOrderForm.editMode,
                onChanged: (value) {
                  billDetModel.dno = value;
                },
                readOnly: true,
                onTap: () async {
                  // showDnoDialog(billDetModel); for entry dno
                  var v = await Myf.showEntryDialog(context, billDetModel.dno, "Dno");
                  if (v != null) {
                    billDetModel.dno = v;
                    loadProductDetails();
                  }
                },
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                keyboardType: TextInputType.text,
                controller: TextEditingController(text: billDetModel.dno),
                // initialValue: billDetModel.dno,
                decoration: InputDecoration(
                  labelText: 'Dno',
                  hintText: 'Dno',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static packingRateAddCheck(BillDetModel billDetModel, context) {
    var packingRate = 0.0;
    var p_rate = getIniPackingRate(billDetModel, packingStyleList);
    if (empOrderSettingModel.packingRateAddInProductRate == true) {
      if (packingStyleList.length > 0) {
        (packingStyleList.where((e) {
          if (e.packingStyle == billDetModel.packing && p_rate == 0) {
            packingRate = Myf.convertToDouble(e.packingAdd);
            return true;
          } else {
            return false;
          }
        }).toList());
      } else {
        Myf.snakeBar(context, "Packing style not found");
      }
    }
    billDetModel.packingRate = packingRate.toString();
  }

  static getIniPackingRate(BillDetModel billDetModel, List<PackingStyleModel> packingStyleList) {
    var p_rate = 0.0;
    packingStyleList.where((e) {
      if (billDetModel.iniPacking == e.packingStyle) {
        p_rate = Myf.convertToDouble(e.packingAdd ?? "0.0");
      }
      return true;
    }).toList();
    return p_rate;
  }

  Widget colorDetails(ColorModel colorModel, List<ColorModel>? colorDetails) {
    var ctrlColorQty = TextEditingController(text: colorModel.clQty);
    // ctrlColorQty.selection = TextSelection(baseOffset: 0, extentOffset: ctrlColorQty.text.length);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              width: 48,
              height: 48,
              child: Myf.showImg(ImageModel(
                url: colorModel.url,
                type: "url",
              )),
            ),
          ),
          SizedBox(width: 12),
          // Name
          Expanded(
            flex: 2,
            child: Text(
              "${Myf.getSubstring(colorModel.clName ?? '', length: 14)}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10),
          // Qty Input
          Container(
            width: 70,
            child: TextFormField(
              controller: ctrlColorQty,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                colorModel.clQty = value;
                qtyProductDetailsStream.sink.add(true);
              },
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                labelText: "Qty",
                labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                ),
                isDense: true,
              ),
            ),
          ),
          SizedBox(width: 8),
          // Remove Button
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.redAccent, size: 22),
            splashRadius: 20,
            tooltip: "Remove",
            onPressed: () {
              colorDetails!.remove(colorModel);
              loadProductDetails();
            },
          ),
        ],
      ),
    );
  }

  void askForInputSetToSet(BillDetModel billDetModel) {
    var iniVal = billDetModel.colorDetails!.first.clQty ?? "0";
    var ctrlSetToSet = TextEditingController(text: "$iniVal");
    ctrlSetToSet.selection = TextSelection(baseOffset: 0, extentOffset: iniVal.length);
    NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        controller: ctrlSetToSet,
        decoration: InputDecoration(label: Text("Set to Set Qty")),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            if (ctrlSetToSet.text.isEmpty) return;
            await Future.wait(billDetModel.colorDetails!.map((e) async {
              e.clQty = ctrlSetToSet.text;
            }).toList());
            loadProductDetails();
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ).show(context);
  }

  Future<QualModel> gerQualModel(BillDetModel billDetModel) async {
    QualModel qualModel = QualModel();
    try {
      qualModel = productList.firstWhere((e) => e.value == billDetModel.qUAL);
    } catch (e) {}
    return qualModel;
  }

  void scrollToBottom() {
    final maxScrollExtent = verticalScrollController.position.maxScrollExtent;

    verticalScrollController.animateTo(
      maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  MasterModel getBrokerDetails(code) {
    List<MasterModel> b = masterList.where((e) {
      if (e.value == code) {
        return true;
      }
      return false;
    }).toList();
    if (b.length > 0) {
      return b.first;
    } else {
      return MasterModel();
    }
  }

  void askForCopyQtyToAll(BillDetModel billDetModel) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Copy to All"),
              content: Text("Do you want to copy this to all items?"),
              actions: [
                GFButton(
                    onPressed: () {
                      if (billDetModel.pCS!.isEmpty) {
                        Myf.snakeBar(context, "Please enter quantity");
                        return;
                      }
                      var qty = Myf.convertToDouble(billDetModel.pCS);
                      billDetailslist.forEach((element) {
                        element.pCS = qty.toString();
                        element.pcSManualEntered = true;
                      });
                      loadProductDetails();
                      Navigator.of(context).pop();
                    },
                    text: "Copy Qty"),
                // GFButton(
                //     onPressed: () {
                //       if (billDetModel.sets!.isEmpty) {
                //         Myf.snakeBar(context, "Please enter sets");
                //         return;
                //       }
                //       var sets = Myf.convertToDouble(billDetModel.sets);
                //       print(sets);
                //       billDetailslist.forEach((element) {
                //         element.sets = sets.toString();
                //         var pcsInSets = Myf.convertToDouble(element.pcsInSets);
                //         element.pCS = (sets * pcsInSets).toString();
                //         element.pcSManualEntered = true;
                //       });
                //       loadProductDetails();
                //       Navigator.of(context).pop();
                //     },
                //     text: "Copy Sets"),
              ],
            ));
  }
}
