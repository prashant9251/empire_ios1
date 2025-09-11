import 'package:audioplayers/audioplayers.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/BarCodeScaneGoogleMlKit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/GatePass/GatePass.dart';
import 'package:empire_ios/screen/SaleDispatch/SaleDispatchCubit.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SaleDispatch extends StatefulWidget {
  const SaleDispatch({Key? key}) : super(key: key);

  @override
  State<SaleDispatch> createState() => _SaleDispatchState();
}

class _SaleDispatchState extends State<SaleDispatch> {
  late SaleDispatchCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cubit = BlocProvider.of<SaleDispatchCubit>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: const Text("Sale Dispatch"),
        actions: [
          IconButton(
            onPressed: () async {
              Myf.checkHostStatus();
            },
            icon: Icon(Icons.wifi),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: widthResponsive(context),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 7,
                    child: TextFormField(
                      autofocus: true,
                      onTap: () {
                        cubit.ctrlreqBarcode.clear();
                        cubit.reqBarcode = "";
                        cubit.splitBarCode("", bySplit: true);
                      },
                      onFieldSubmitted: (value) {
                        cubit.reqBarcode = value;
                        cubit.splitBarCode(value, bySplit: true);
                      },
                      controller: cubit.ctrlreqBarcode,
                      decoration: const InputDecoration(
                        labelText: "Bill Barcode",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  if (getDeviceType(MediaQuery.of(context).size) != DeviceScreenType.desktop)
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        onPressed: () async {
                          String barcodeScanRes = await BarCodeScaneGoogleMlKit.startScane() ?? "";
                          if (barcodeScanRes == null || barcodeScanRes == "") return;
                          cubit.player.play(AssetSource("img/search.mp3"));
                          barcodeScanRes = barcodeScanRes.trim();
                          cubit.reqBarcode = barcodeScanRes;
                          cubit.splitBarCode(barcodeScanRes, bySplit: true);
                        },
                        icon: Icon(Icons.qr_code_2),
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<SaleDispatchCubit, SaleDispatchState>(builder: (context, state) {
              if (state is SaleDispatchLoadBill) {
                return state.widget;
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
