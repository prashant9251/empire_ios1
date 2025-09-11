import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/orderForm/createPdfOrderFormClass.dart';
import 'package:flutter/material.dart';

class CreateOrderFormHtmlToPdf extends StatefulWidget {
  var Orderobject;

  CreateOrderFormHtmlToPdf({Key? key, required UserObj, required this.Orderobject}) : super(key: key);

  @override
  State<CreateOrderFormHtmlToPdf> createState() => _CreateOrderFormHtmlToPdfState();
}

class _CreateOrderFormHtmlToPdfState extends State<CreateOrderFormHtmlToPdf> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PdfApi.createPdfAndView(ORDER: widget.Orderobject, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Order Form"),
      ),
    );
  }
}
