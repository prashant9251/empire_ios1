import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
// import 'package:empire_ios/pdfView/pdfView.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/ProductCardTile/productCardTileFirebaseCarouselSlider.dart';
import 'package:empire_ios/screen/fullScreenImg/fullScreenImg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewSingleProduct extends StatefulWidget {
  ProductModel productModel;
  var UserObj;

  ViewSingleProduct({Key? key, required this.productModel, required this.UserObj}) : super(key: key);

  @override
  State<ViewSingleProduct> createState() => _ViewSingleProductState();
}

class _ViewSingleProductState extends State<ViewSingleProduct> {
  bool loading = true;
  Map<String, dynamic> totalPCSByType = {};
  List imgL = [];
  int activeIndex = 0;
  var ctrlNos = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imgL = [];
    Map<String, dynamic> img = {};
    if (widget.productModel.img != null) {
      Map<String, dynamic>? img = widget.productModel.img;
      img!.forEach((key, value) {
        imgL.add(value);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("View Product"),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       await ProductListClass.shareAllSelectedFile(context, productList: [widget.QUL_OBJ]);

          //       // ShareOption.showModelShare(context, productList: [widget.QUL_OBJ]);
          //     },
          //     icon: Icon(Icons.share))
        ],
      ),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(right: 5, left: 5, top: 5),
                height: 400,
                width: 400,
                color: Color.fromARGB(255, 231, 228, 228),
                child: widget.productModel.img != null
                    ? widget.productModel.img!["0"] != null
                        ? CarouselSlider.builder(
                            disableGesture: true,
                            options: CarouselOptions(
                                scrollPhysics: BouncingScrollPhysics(),
                                height: 400,
                                // autoPlay: true,
                                // autoPlayInterval: const Duration(seconds: 1),
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) => setState(() => activeIndex = index)),
                            itemCount: imgL.length,
                            itemBuilder: (context, index, realindex) {
                              var mimeType = Myf.getMimeType(imgL[index]);
                              return InkWell(
                                onTap: () async {
                                  if (mimeType == "pdf") {
                                    File? f = await baseCacheManager.getSingleFile(imgL[index]);
                                    OpenFilex.open(f.path);
                                  } else {
                                    Myf.Navi(context, fullScreenImg(img_list: imgL));
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  color: Colors.grey,
                                  child: ProductCardTileFirebaseCarouselSlider.view(imgL[index]),
                                ),
                              );
                            },
                          )
                        : Icon(
                            Icons.error_rounded,
                            color: Colors.red,
                          )
                    : SizedBox.shrink(),
              ),
              Positioned(
                bottom: 0,
                child: AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: imgL.length,
                ),
              )
            ],
          ),
          ProductCard(context, productModel: widget.productModel),
        ],
      ),
    );
  }

  Container ProductCard(BuildContext context, {required ProductModel productModel}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: const EdgeInsets.all(8.0),
      child: Card(
        color: jsmColor,
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          // height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  child: InkWell(
                onTap: () {
                  // Myf.Navi(context, TagProductListView(QUL_OBJ: widget.productModel, UserObj: widget.UserObj))
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${productModel.qualModel!.label}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Icon(Icons.ads_click),
                      // ...[Text("Strock"), CircleAvatar(child: Text("100"))]
                    ],
                  ),
                ),
              )),
              Divider(color: Colors.white),
              Chip(backgroundColor: Colors.blue, label: Text("STOCK- ${productModel.qualModel!.finishStock}", style: TextStyle(color: Colors.white))),
              titlecard(title: "NAME", text: "${productModel.name}"),
              Divider(color: Colors.white),
              titlecard(title: "MAIN SCREEN", text: "${productModel.qualModel!.mainScreen}"),
              Divider(color: Colors.white),
              titlecard(title: "FABRICS", text: "${productModel.qualModel!.baseQual}"),
              Divider(color: Colors.white),
              titlecard(title: "CATEGORY", text: "${productModel.qualModel!.category}"),
              Divider(color: Colors.white),
              Chip(label: Text("RATE1:- ${productModel.qualModel!.s1}/-", style: TextStyle(color: Colors.black))),
              Divider(color: Colors.white),
              Chip(label: Text("RATE2:- ${productModel.qualModel!.s2}/-", style: TextStyle(color: Colors.black))),
              Divider(color: Colors.white),
              Chip(label: Text("RATE3:- ${productModel.qualModel!.s3}/-", style: TextStyle(color: Colors.black))),
              Divider(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Row titlecard({required title, required text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "$title : ",
            style: TextStyle(color: Colors.black87),
          ),
        ),
        Flexible(
          child: Text(
            "${text}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget pdfView(String url) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 100,
      ),
      child: Stack(
        children: [
          PDF(
            defaultPage: 0,
            enableSwipe: true,
          ).cachedFromUrl(
            url,
            placeholder: (progress) => Center(child: Text('$progress %')),
            errorWidget: (error) => Center(child: Text(error.toString())),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ElevatedButton(
                onPressed: () async {
                  var fileOld = await baseCacheManager.getSingleFile(url);
                  OpenFilex.open(fileOld.path);
                },
                child: Text("OPEN PDF")),
          )
        ],
      ),
    );
  }
}
