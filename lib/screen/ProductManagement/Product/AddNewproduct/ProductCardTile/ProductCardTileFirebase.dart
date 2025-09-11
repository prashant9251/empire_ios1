// ignore_for_file: must_be_immutable

import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ProductCardTile/productCardTileFirebaseCarouselSlider.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/shareOption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCardTileFirebase extends StatelessWidget {
  var UserObj;
  ProductModel productModel;
  ProductCardTileFirebase({Key? key, required this.productModel, required this.UserObj}) : super(key: key);
  int activeIndex = 0;

  List imgL = [];

  @override
  Widget build(BuildContext context) {
    imgL = [];
    Map<String, dynamic> img = {};
    if (productModel.img != null) {
      Map<String, dynamic>? img = productModel.img;
      img!.forEach((key, value) {
        imgL.add(value);
      });
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      color: Colors.white,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;
        double parentheight = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: parentheight,
              width: parentWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: productModel.img != null
                  ? productModel.img!["0"] != null
                      ? ProductCardTileFirebaseCarouselSlider(
                          imgL: imgL,
                          imgwidth: parentWidth,
                        )
                      : Icon(
                          Icons.error_rounded,
                          color: Colors.red,
                        )
                  : SizedBox.shrink(),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: parentWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${productModel.name}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Rate: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "${productModel.qualModel!.s1}/-",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            // Myf.Navi(context, TagProductListView(QUL_OBJ: widget.productModel, UserObj: widget.UserObj));
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.tag,
                                size: 12,
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  "${productModel.qualModel!.label}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ))),
            productModel.qualModel!.finishStock != null && productModel.qualModel!.finishStock != ""
                ? Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${productModel.qualModel!.finishStock}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
                : SizedBox.shrink(),
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                    onPressed: () async {
                      ProductListClass.deleteImg(context: context, QUL_OBJ: productModel, UserObj: UserObj);
                    },
                    icon: CircleAvatar(backgroundColor: Color.fromARGB(255, 231, 228, 228), child: Icon(Icons.delete, color: Colors.red)))),
            Positioned(
                top: 10,
                right: 50,
                child: IconButton(
                    onPressed: () async {
                      await ProductListClass.selectit(product: productModel);
                      ShareOption.showModelShare(context, productList: tempSelectImglist);
                    },
                    icon: CircleAvatar(backgroundColor: Color.fromARGB(255, 231, 228, 228), child: Icon(Icons.share, color: Colors.blue)))),
            StreamBuilder<List<ProductModel>>(
                stream: shareImgObjList.stream,
                builder: (context, snapshot) {
                  List<ProductModel> l = snapshot.data ?? [];
                  if (l.length > 0) {
                    bool select = false;
                    l.map((e) {
                      if (e.iD == productModel.iD) {
                        select = true;
                      }
                    }).toList();
                    return select
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            top: 0,
                            left: 0,
                            child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Color.fromARGB(255, 231, 228, 228).withOpacity(.6),
                                child: Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.blue,
                                  size: 50,
                                )))
                        : SizedBox.shrink();
                  } else {
                    return SizedBox.shrink();
                  }
                })
          ],
        );
      }),
    );
  }
}
