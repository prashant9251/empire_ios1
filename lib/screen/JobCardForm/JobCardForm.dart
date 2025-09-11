import 'dart:typed_data';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/JobCardForm/JobCardFormCubit.dart';
import 'package:empire_ios/screen/JobCardForm/JobCardStickerPrintClass.dart';
import 'package:empire_ios/screen/MobileScanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:responsive_builder/responsive_builder.dart';

class JobCardForm extends StatefulWidget {
  const JobCardForm({Key? key}) : super(key: key);

  @override
  State<JobCardForm> createState() => _JobCardFormState();
}

class _JobCardFormState extends State<JobCardForm> {
  late JobCardFormCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<JobCardFormCubit>(context);
    cubit.searchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Job Card Report'),
          backgroundColor: jsmColor,
          actions: [],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop ? 2 : 1,
                  child: TextFormField(
                    controller: cubit.ctrlBarcode,
                    onFieldSubmitted: (value) {
                      cubit.searchData();
                    },
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          cubit.searchData();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop ? 1 : 0,
                  child: GFIconButton(
                    color: jsmColor,
                    icon: Icon(Icons.qr_code_outlined, color: Colors.black),
                    onPressed: () async {
                      String? barcodeScanRes;
                      if (Myf.isAndroid()) {
                        barcodeScanRes = await AndroidChennal.invokeMethod('startScane', []);
                        if (barcodeScanRes == null || barcodeScanRes == "") return;
                        cubit.ctrlBarcode.text = barcodeScanRes;
                        cubit.searchData();
                      } else {
                        barcodeScanRes = await Myf.Navi(context, MobileScannerScreen());
                        GFToast.showToast(
                          "Scanned: ${barcodeScanRes}",
                          context,
                          toastPosition: GFToastPosition.BOTTOM,
                          toastDuration: 1,
                          textStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.black87,
                        );
                        if (barcodeScanRes == null || barcodeScanRes == "") return;
                        cubit.ctrlBarcode.text = barcodeScanRes;
                        cubit.searchData();
                      }
                    },
                    type: GFButtonType.solid,
                  ),
                ),
                Flexible(flex: getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.desktop ? 1 : 0, child: SizedBox(width: 16)),
              ],
            ),
          ),
          BlocBuilder<JobCardFormCubit, JobCardFormState>(
            builder: (context, state) {
              if (state is JobCardFormLoadData) {
                return state.widget;
              }
              return SizedBox.shrink();
            },
          ),
        ]),
      ),
    );
  }
}
