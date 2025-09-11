import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/localRequest/getQual.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubitState.dart';
import 'package:empire_ios/screen/EmpOrderFormProductDesign/EmpOrderFormProductDesign.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EmpOrderFormProductCubit extends Cubit<EmpOrderFormProductCubitState> {
  bool showinListView = false;
  BuildContext context;
  List<QualModel> productList = [];
  List Qual = [];

  List<QualModel> filterList = [];
  late Box galleryBox;
  Widget widget = SizedBox.shrink();
  var ctrlSearch = TextEditingController();
  var isDispose = false;
  bool returnVal = true;
  EmpOrderFormProductCubit(this.context, {this.returnVal = true}) : super(EmpOrderFormProductCubitStateIni()) {
    // getData();
  }
  clear() {
    ctrlSearch.clear();
  }

  void getData(productList) async {
    if (!isDispose) emit(EmpOrderFormProductCubitStateLoadProduct(Center(child: showinListView == true ? listShimer() : gridShimer())));
    if (productList.length == 0) {
      var databasId = await Myf.databaseIdCurrent(GLB_CURRENT_USER);
      var CuHiveBox = await Hive.openLazyBox("${databasId}QUL");
      var Qual = await CuHiveBox.get("${databasId}QUL", defaultValue: []) as List<dynamic>;
      productList = await Qual.map((json) => QualModel.fromJson(Myf.convertMapKeysToString(json))).toList();
      await CuHiveBox.close();
    }
    this.productList = productList;
    // sync gallery
    await SyncLocalFunction.syncGallery();
    galleryBox = await SyncLocalFunction.openBoxCheck("gallery");
    // LazyBox PRODUCT = await SyncLocalFunction.openLazyBoxCheck("PRODUCT");
    // this.productList = await Future.wait(this.productList.map((e) async {
    //   // var id = e.value.toString().toUpperCase();
    //   // dynamic d = await PRODUCT.get(id);
    //   // if (d != null) {
    //   //   ProductModel productModel = ProductModel.fromJson(Myf.convertMapKeysToString(d));
    //   //   e.imageUrl = productModel.img!["0"].toString();
    //   // }
    //   return e;
    // }).toList());
    // await PRODUCT.close();
    await getQual.start({});
    this.productList = await this.productList.where((e) => e.iB == "N").toList();
    queryData("");
  }

  GridView gridShimer() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: getValueForScreenType(context: context, mobile: 2, desktop: 7, tablet: 5)),
        itemCount: getValueForScreenType(context: context, mobile: 10, desktop: 30, tablet: 20),
        itemBuilder: (context, index) {
          return Padding(padding: const EdgeInsets.all(8.0), child: ShimmerSkelton(width: 100, height: 100));
        });
  }

  ListView listShimer() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: ShimmerSkelton(width: 40, height: 40),
          ),
          title: ShimmerSkelton(width: 100, height: 10),
          subtitle: ShimmerSkelton(width: 150, height: 10),
        );
      },
    );
  }

  void queryData(query, {ctrlSearch}) async {
    if (ctrlSearch != null) {
      this.ctrlSearch = ctrlSearch;
    }
    if (query.isNotEmpty) {
      filterList = productList.where((element) {
        return element.label!.toUpperCase().contains("$query");
      }).toList();
    } else {
      filterList = productList;
    }
    widget = showinListView ? listView() : gridView();
    if (!isDispose) emit(EmpOrderFormProductCubitStateLoadProduct(widget));
  }

  Widget listView() {
    var length = filterList.length;
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: length,
      itemBuilder: (context, index) {
        return StreamBuilder(
            stream: somthingHaschange.stream,
            builder: (context, asyncSnapshot) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: FutureBuilder(
                      future: getGalleyImage(filterList[index]),
                      builder: (context, snapshot) {
                        List<dynamic> d = snapshot.data as List<dynamic>? ?? [];
                        List<GalleryModel> galleryModelList = d.map((e) => GalleryModel.fromJson(Myf.convertMapKeysToString(e))).toList();
                        if (galleryModelList.length > 0) {
                          filterList[index].imageUrl = galleryModelList[0].url;
                        }
                        return CachedNetworkImage(
                          imageUrl: "${filterList[index].imageUrl ?? ""}",
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ShimmerSkelton(width: 40, height: 40),
                          errorWidget: (context, url, error) =>
                              empOrderSettingModel.colorImageSystemEntry == "image" ? Icon(Icons.error) : Icon(Icons.image_not_supported),
                          httpHeaders: {
                            "Authorization": basicAuthForLocal,
                          },
                        );
                      }),
                ),
                title: Text("${filterList[index].label}"),
                subtitle: Text(
                    "RATE:${filterList[index].s1} | CATEGORY :${filterList[index].category} | ${filterList[index].finishStock != null && filterList[index].finishStock != "" ? "| STOCK :${filterList[index].finishStock}" : ""}"),
                isThreeLine: true,
                trailing: filterList[index].selected ? Icon(Icons.check_box_outlined, color: Colors.blue) : null,
                onTap: () async {
                  if (returnVal == true) {
                    selectIt(filterList[index]);
                  } else {
                    await Myf.Navi(context, EmpOrderFormProductDesign(qualModel: filterList[index]));
                    queryData("");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImg(qualModel.imageUrl)));
                  }
                },
              );
            });
      },
    );
  }

  Widget gridView() {
    var length = filterList.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: getValueForScreenType(context: context, mobile: 2, desktop: 7, tablet: 4), // Two items in each row
          ),
          itemCount: length > 500 ? 500 : length,
          itemBuilder: (context, index) {
            return productCard(filterList[index]);
          },
        );
      },
    );
  }

  Widget productCard(QualModel qualModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth; // Calculate item width
        final itemHeight = constraints.maxHeight;
        return StreamBuilder(
            stream: somthingHaschange.stream,
            builder: (context, snapshot) {
              String i = Myf.qualImgLink(qualModel);
              if (i.isNotEmpty) {
                qualModel.imageUrl = i;
              }
              return GestureDetector(
                onTap: () async {
                  if (returnVal == true) {
                    selectIt(qualModel);
                  } else {
                    await Myf.Navi(context, EmpOrderFormProductDesign(qualModel: qualModel));
                    queryData("");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImg(qualModel.imageUrl)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: FutureBuilder(
                        future: getGalleyImage(qualModel),
                        builder: (context, snapshot) {
                          List<dynamic> d = snapshot.data as List<dynamic>? ?? [];
                          List<GalleryModel> galleryModelList = d.map((e) => GalleryModel.fromJson(Myf.convertMapKeysToString(e))).toList();
                          if (galleryModelList.length > 0) {
                            qualModel.imageUrl = galleryModelList[0].url;
                          }
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: "${qualModel.imageUrl ?? ""}",
                                  height: itemHeight,
                                  width: itemWidth,
                                  key: UniqueKey(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => ShimmerSkelton(width: itemWidth, height: itemHeight),
                                  errorWidget: (context, url, error) =>
                                      empOrderSettingModel.colorImageSystemEntry == "image" ? Icon(Icons.error) : Icon(Icons.image_not_supported),
                                  httpHeaders: {
                                    "Authorization": basicAuthForLocal,
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: itemWidth,
                                  // height: itemHeight * .50,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${qualModel.label}",
                                            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text("${"RATE:${qualModel.s1}"}", style: TextStyle(fontSize: 12.0, color: Colors.white)),
                                        Text("${"CATEGORY :${qualModel.category}"}", style: TextStyle(fontSize: 10.0, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              qualModel.selected ? Positioned(child: Icon(Icons.check_box_outlined, color: Colors.black)) : SizedBox.shrink(),
                              qualModel.finishStock != null && qualModel.finishStock != ""
                                  ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: CircleAvatar(radius: 25, child: Text("${qualModel.finishStock}", style: TextStyle(fontSize: 13))))
                                  : SizedBox.shrink(),
                              if (galleryModelList.length > 0)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      '${galleryModelList.length}',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                  ),
                ),
              );
            });
      },
    );
  }

  Future<List<dynamic>> getGalleyImage(QualModel qualModel) async {
    return await Future.value(galleryBox.values.where((element) => element["value"] == qualModel.value).toList());
  }

  void selectIt(QualModel qualModel) {
    final isAlreadySelected = qualModel.selected;
    if (isAlreadySelected) {
      qualModel.selected = false;
    } else {
      qualModel.selected = true;
    }
    somthingHaschange.sink.add(true);
    showSelected();
  }

  void showSelected() async {
    Widget widget = selectedWidget();
    if (!isDispose) emit(EmpOrderFormProductCubitStateLoadSelected(widget));
    await Future.delayed(Duration(milliseconds: 500));
    clear();
  }

  Widget selectedWidget() {
    var selectedList = productList.where((element) => element.selected == true).toList();
    return selectedList.length == 0
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: selectedList.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final qualModel = selectedList[idx];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: "${qualModel.imageUrl}",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          httpHeaders: {"Authorization": basicAuthForLocal},
                          placeholder: (context, url) => ShimmerSkelton(width: 70, height: 70),
                          errorWidget: (context, url, error) => empOrderSettingModel.colorImageSystemEntry == "image"
                              ? Icon(Icons.error, size: 32, color: Colors.redAccent)
                              : Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "${qualModel.label}",
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => selectIt(qualModel),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, size: 14, color: Colors.redAccent),
                          ),
                        ),
                      ),
                      if (qualModel.finishStock != null && qualModel.finishStock != "")
                        Positioned(
                          top: 2,
                          left: 2,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              "${qualModel.finishStock}",
                              style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          );
  }

  done() {
    var r_list = productList.where((element) => element.selected == true).toList();
    Navigator.pop(context, r_list);
  }
}
