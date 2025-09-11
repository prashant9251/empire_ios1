// ignore_for_file: must_be_immutable

import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/AddNewproduct.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFilter/ProductFilter.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/cubit/ProductFirebaseListCubit.dart';
import 'package:empire_ios/screen/ProductManagement/Product/ProductFirebaseList/cubit/ProductFirebaseListState.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/shareOption.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFirebaseList extends StatefulWidget {
  var UserObj;

  ProductFirebaseList({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<ProductFirebaseList> createState() => _ProductFirebaseListState();
}

class _ProductFirebaseListState extends State<ProductFirebaseList> {
  List<dynamic> QUL_LIST = [];
  List<dynamic> QUL_LIST_MAIN = [];
  List<ProductModel> LID_PRODUCT_LIST = [];
  var loading = true;
  var searchCtrl = TextEditingController();
  var searchMainCtrl = TextEditingController();
  var searchFabrics = TextEditingController();
  var ctrlSearch = TextEditingController();
  late ProductFirebaseListCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ProductFirebaseListCubit>(context);
    if (mounted) {
      getData().then((value) {
        if (mounted) {
          cubit.isDisposed = false;
          loading = false;
          setState(() {});
          cubit.getData();
        }
      });
    }
    ctrlSearch.addListener(() {
      if (ctrlSearch.text.isNotEmpty) {
        cubit.query(ctrlSearch.text.trim().toUpperCase());
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    cubit.productList.clear();
    cubit.LID_PRODUCT_LIST.clear();
    cubit.filteredproductList.clear();
    cubit.QUL = [];
    cubit.isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("Product"),
          actions: [
            IconButton(
                onPressed: () async {
                  Myf.showBlurLoading(context);
                  fireBCollection.collection("supuser").doc(widget.UserObj["CLIENTNO"]).collection("PRODUCT").get().then((value) async {
                    var snp = value.docs;
                    await Future.wait(snp.map((e) async {
                      dynamic d = e.data();
                      ProductModel model = ProductModel.fromJson(Myf.convertMapKeysToString(d));
                      model.lID = model.name;
                      model.time = DateTime.now().toString();
                      fireBCollection
                          .collection("supuser")
                          .doc(widget.UserObj["CLIENTNO"])
                          .collection("PRODUCT")
                          .doc(model.iD)
                          .update(model.toJson());
                    }).toList());
                  });
                  await Myf.productSyncLocal(context, UserObj: widget.UserObj);
                  cubit.getData();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.sync)),
            StreamBuilder(
              stream: shareButtonBool.stream,
              builder: (context, snapshot) {
                var boolShowShare = snapshot.data.toString().contains("true");
                return boolShowShare
                    ? badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -1, end: -1),
                        showBadge: true,
                        ignorePointer: false,
                        onTap: () {},
                        badgeContent: Text("${tempSelectImglist.length}"),
                        badgeAnimation: badges.BadgeAnimation.scale(
                          animationDuration: Duration(seconds: 1),
                          colorChangeAnimationDuration: Duration(seconds: 1),
                          loopAnimation: false,
                          curve: Curves.fastOutSlowIn,
                          colorChangeAnimationCurve: Curves.easeInCubic,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () => ShareOption.deleteOptioMulti(context, tempSelectImglist),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            ElevatedButton.icon(
                                label: Text("Share"),
                                onPressed: () async {
                                  ShareOption.showModelShare(context, productList: tempSelectImglist);
                                  // await ProductListClass.shareAllSelectedFile(context, productList: tempSelectImglist);
                                },
                                icon: Icon(Icons.share)),
                          ],
                        ),
                      )
                    //
                    : SizedBox.shrink();
              },
            ),
            IconButton(
                onPressed: () async {
                  LID_PRODUCT_LIST = await cubit.getLID_PRODUCT_LIST();
                  List? lid_List_Filter = await Myf.Navi(context, ProductFilter(UserObj: widget.UserObj, LID_LIST: LID_PRODUCT_LIST));
                  if (lid_List_Filter == null) return;
                  cubit.query("", lid_List_Filter: lid_List_Filter);
                },
                icon: Icon(Icons.filter_alt)),
            IconButton(
                onPressed: () async {
                  cubit.orderByStockDesc = cubit.orderByStockDesc == false ? true : false;
                  await cubit.query(ctrlSearch.text.trim().toUpperCase());
                  setState(() {});
                },
                icon: cubit.orderByStockDesc == true ? Icon(Icons.arrow_downward) : Icon(Icons.arrow_upward))
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (tempSelectImglist.length > 0) {
              tempSelectImglist = [];
              shareImgObjList.sink.add(tempSelectImglist);
              shareButtonBool.sink.add(false);
              return false;
            }
            return true;
          },
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(29.5)),
                  child: TextFormField(
                    onChanged: (value) => setState(() {}),
                    controller: ctrlSearch,
                    decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
                  ),
                ),
                BlocBuilder<ProductFirebaseListCubit, ProductFirebaseListState>(
                  builder: (context, state) {
                    if (state is ProductFirebaseListStateLoadProduct) {
                      return state.widget;
                    }
                    return SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Myf.Navi(context, AddNewproduct(QUL_OBJ: {}, UserObj: widget.UserObj));
              await Myf.productSyncLocal(context, UserObj: widget.UserObj);
              await cubit.getData();
            },
            label: Text("Add New Product")),
      ),
    );
  }

  Future getData() async {
    await Myf.productSyncLocal(context, UserObj: widget.UserObj);
  }
}
