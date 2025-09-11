import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  ProductCard({Key? key, required this.UserObj, required this.QulObj}) : super(key: key);
  dynamic UserObj;
  dynamic QulObj;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: jsmColor,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                // height: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titlecard(title: "NAME", key: "label"),
                        titlecard(title: "MAIN SCREEN", key: "MS"),
                        titlecard(title: "FABRICS", key: "BQ"),
                        titlecard(title: "CATEGORY", key: "CT"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RATE1:- ${widget.QulObj["S1"]}/-", style: TextStyle(color: Colors.white)),
                        Text("RATE2:- ${widget.QulObj["S2"]}/-", style: TextStyle(color: Colors.white)),
                        Text("RATE3:- ${widget.QulObj["S3"]}/-", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget titlecard({required title, required key}) {
    return Container(
      width: MediaQuery.of(context).size.width * 59 / 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(child: Text("$title : ")),
          Flexible(
            child: Text(
              "${widget.QulObj[key]}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
