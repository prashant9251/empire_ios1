import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ProductCardTile/ProductCardTileFirebase.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ViewSingleProduct/ViewSingleProduct.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/cubit/ProductFirebaseListState.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

LazyBox? PRODUCT_IMG_BOX;

class ProductFirebaseListCubit extends Cubit<ProductFirebaseListState> {
  BuildContext context;
  List<dynamic> QUL = [];
  List<ProductModel> filteredproductList = [];
  List<ProductModel> productList = [];
  List<ProductModel> LID_PRODUCT_LIST = [];
  var orderByStockDesc;
  late Box PRODUCT;
  late LazyBox QUAL_PRODUCT_LID;
  List? lid_List_Filter = [];
  bool isDisposed = false;

  ProductFirebaseListCubit(this.context) : super(ProductFirebaseListStateIni()) {
    // hiveMainBox.watch().listen((event) async {
    //   if (!isDisposed) {
    //     await getData();
    //   }
    // });
  }

  getData() async {
    if (!isDisposed) emit(ProductFirebaseListStateLoadProduct(CircularProgressIndicator()));
    var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
    QUL = await Myf.GetFromLocalInList(["${databasId}QUL"]);
    QUAL_PRODUCT_LID = await SyncLocalFunction.openLazyBoxCheck("QUAL_PRODUCT");
    PRODUCT_IMG_BOX = await SyncLocalFunction.openLazyBoxCheck("PRODUCT_IMG_BOX"); // this is for image
    await Future.wait(QUL.map((e) async {
      var id = e["value"].toString().toUpperCase().trim();
      e["LID"] = id.toString();
      await QUAL_PRODUCT_LID.put(e["LID"], e);
    }).toList());
    if (QUL != null) QUL.clear();

    //geting Product

    PRODUCT = await SyncLocalFunction.openBoxCheck("PRODUCT");
    productList = await Future.wait(PRODUCT.values.map((e) async {
      var productModel = ProductModel.fromJson(Myf.convertMapKeysToString(e));
      return productModel;
    }).toList());
    if (PRODUCT != null) PRODUCT.close();

    query("");
  }

  query(String query, {lid_List_Filter}) async {
    this.lid_List_Filter = lid_List_Filter;
    if (query.isNotEmpty) {
      filteredproductList = await productList.where((element) {
        return "${element.name}${element.qualModel!.mainScreen}${element.qualModel!.baseQual}".toUpperCase().contains(query) && element.lID != null;
      }).toList();
    } else {
      filteredproductList = productList.where((element) => element.lID != null).toList();
    }
    if (orderByStockDesc == true) {
      filteredproductList.sort((a, b) {
        final int? ageA = a.qualModel!.finishStock != null && a.qualModel!.finishStock != "" ? int.tryParse(a.qualModel!.finishStock!) : null;
        final int? ageB = b.qualModel!.finishStock != null && b.qualModel!.finishStock != "" ? int.tryParse(b.qualModel!.finishStock!) : null;

        if (ageA == null && ageB == null) {
          return 0; // Both are null, consider them equal.
        } else if (ageA == null) {
          return 1; // Null comes after non-null values.
        } else if (ageB == null) {
          return -1; // Non-null comes before null values.
        }
        return ageB.compareTo(ageA);
      });
    } else if (orderByStockDesc == false) {
      filteredproductList.sort((a, b) {
        final int? ageA = a.qualModel!.finishStock != null && a.qualModel!.finishStock != "" ? int.tryParse(a.qualModel!.finishStock!) : null;
        final int? ageB = b.qualModel!.finishStock != null && b.qualModel!.finishStock != "" ? int.tryParse(b.qualModel!.finishStock!) : null;

        if (ageA == null && ageB == null) {
          return 0; // Both are null, consider them equal.
        } else if (ageA == null) {
          return 1; // Null comes after non-null values.
        } else if (ageB == null) {
          return -1; // Non-null comes before null values.
        }
        return ageA.compareTo(ageB);
      });
    } else {
      filteredproductList.sort((a, b) {
        if (a.name == null && b.name == null) {
          return 0; // Both are null, consider them equal.
        } else if (a.name == null) {
          return 1; // Null comes after non-null values.
        } else if (b.name == null) {
          return -1; // Non-null comes before null values.
        }

        return a.name!.compareTo(b.name!);
      });
    }

    loadProduct();
  }

  void loadProduct() {
    Widget widget = productView();
    if (!isDisposed) emit(ProductFirebaseListStateLoadProduct(widget));
  }

  Widget productView() {
    if (lid_List_Filter != null) {
      if (lid_List_Filter!.length > 0) {
        filteredproductList = filteredproductList.where((element) => lid_List_Filter!.contains(element.lID)).toList();
      }
    }

    var length2 = filteredproductList.length;
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        itemCount: length2 > 200 ? 200 : length2,
        itemBuilder: (context, index) {
          ProductModel productModel = filteredproductList[index];
          return FutureBuilder(
            future: getQualObjProcess(productModel),
            builder: (context, snapshot) {
              return InkWell(
                  onLongPress: () {
                    ProductListClass.showHideShareButtonProcess(product: productModel);
                  },
                  onTap: () {
                    if (tempSelectImglist.length > 0) {
                      ProductListClass.selectit(product: productModel);
                    } else {
                      Myf.Navi(context, ViewSingleProduct(productModel: productModel, UserObj: GLB_CURRENT_USER));
                    }
                  },
                  child: ProductCardTileFirebase(productModel: productModel, UserObj: GLB_CURRENT_USER));
            },
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 5 : 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 2,
        ),
      ),
    );
  }

  Future<List<ProductModel>> getLID_PRODUCT_LIST() async {
    Box LID = await SyncLocalFunction.openBoxCheck("LID");
    LID_PRODUCT_LIST = [];
    await Future.wait(productList.map((e) async {
      if (e.lID != null && LID.isOpen) {
        await LID.put(e.lID, e.toJson());
      }
    }).toList());
    await Future.wait(LID.values.map((e) async {
      ProductModel model = ProductModel.fromJson(Myf.convertMapKeysToString(e));
      model = await getQualObjProcess(model);
      LID_PRODUCT_LIST.add(model);
    }).toList());
    LID.close();
    return LID_PRODUCT_LIST;
  }

  Future getQualObjProcess(ProductModel productModel) async {
    var qualObj = await QUAL_PRODUCT_LID.get(productModel.lID);
    if (qualObj != null) {
      productModel.qualModel = await QualModel.fromJson(Myf.convertMapKeysToString(qualObj));
    }
    return productModel;
  }
}
