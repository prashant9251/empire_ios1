import 'dart:math';

import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class EmpOrderCheckForDoubleClass {
  static Future<List<BillsModel>> checkForDouble(BillsModel billsModel) async {
    List<BillDetModel> orderProductList = await billsModel.billDetails ?? [];
    if (orderProductList.length == 0) {
      return [];
    }
    var productLength = orderProductList.length;

    int startIndex = 0;
    int limitIndex = empOrderSettingModel.pdfProductViewLimit ?? 15; // Assuming productLimit is defined
    var lastIndex = empOrderSettingModel.pdfProductViewLimit ?? 15;
    double devide = productLength / limitIndex;
    int loop = (devide.ceil());
    List<BillsModel> mainList = [];
    var billSr = 0;
    for (int k = 0; k < loop; k++) {
      billSr++;
      if (k != 0) {
        startIndex += limitIndex;
        lastIndex += limitIndex;
      }
      BillsModel billModelSub = await BillsModel.fromJson(await billsModel.toJson());
      billModelSub.billSr = billSr;
      List<BillDetModel> orderProductListSub = [];
      for (int l = startIndex; l < lastIndex; l++) {
        try {
          orderProductListSub.add(orderProductList[l]);
        } catch (e) {}
      }
      //print(orderProductListSub);
      billModelSub.billDetails = orderProductListSub;
      mainList.add(billModelSub);
    }
    //print(mainList.length);

    return mainList;
  }
}
