import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/auth.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/adminPanel/userPermissionOptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> settingsMap = {};

dynamic currentUserObjForPermission;

class UserPermissionAdmin extends StatefulWidget {
  UserPermissionAdmin({Key? key, required this.UserObj}) : super(key: key);
  dynamic UserObj;
  @override
  State<UserPermissionAdmin> createState() => _UserPermissionAdminState();
}

class _UserPermissionAdminState extends State<UserPermissionAdmin> {
  var ctrlName = TextEditingController();
  dynamic userD = {};
  bool _switchValue = true;

  var UPIPAYMENTPAGE = false;

  var ctrlFixFirm = TextEditingController();

  var ctrlMcnoFirm = TextEditingController();

  var ctrlTypeId = TextEditingController();

  initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await fireBCollection
        .collection("supuser")
        .doc(widget.UserObj["clnt"])
        .collection("user")
        .where("userID", isEqualTo: widget.UserObj["usernm"])
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        var d = value.docs[0].data();

        ctrlFixFirm.text = d["FIX_FIRM"] == null ? "" : d["FIX_FIRM"];
        ctrlMcnoFirm.text = d["MCNO"] == null ? "" : d["MCNO"];
        ctrlTypeId.text = d["MTYPE"] == null ? "" : d["MTYPE"];
        userD = d;
        setState(() {});
      } else {
        widget.UserObj["user"] = widget.UserObj["usernm"];
        widget.UserObj["CLIENTNO"] = widget.UserObj["clnt"];
        firebaseAuthfunction.createUserInFirebase(widget.UserObj);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUserObjForPermission = widget.UserObj;
    String software_name = widget.UserObj['software_name'];
    bool isTrading = software_name.contains("TRADING") ? true : false;
    bool isAgency = software_name.contains("AGENCY") ? true : false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("USER PERMISSION"),
        actions: [
          TextButton.icon(
            onPressed: () async {
              Myf.showBlurLoading(context);
              await fireBCollection
                  .collection("supuser")
                  .doc(widget.UserObj["clnt"])
                  .collection("user")
                  .doc(widget.UserObj["usernm"])
                  .update(userD)
                  .then((value) {});
              Myf.snakeBar(context, "Permissions Saved");
              Navigator.pop(context);
              Navigator.pop(context);
            },
            icon: Icon(Icons.save, color: Colors.white),
            label: Text("Save", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [jsmColor.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("USER : "),
                  Text("${widget.UserObj["usernm"]}"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "FIRM FIX FOR THIS USER",
                            style: TextStyle(color: Colors.blue),
                          ),
                          Container(
                            width: 120,
                            child: TextFormField(
                              controller: ctrlFixFirm,
                              onEditingComplete: () async {
                                Myf.showBlurLoading(context);
                                await fireBCollection
                                    .collection("supuser")
                                    .doc(widget.UserObj["clnt"])
                                    .collection("user")
                                    .doc(widget.UserObj["usernm"])
                                    .update({
                                  "FIX_FIRM": ctrlFixFirm.text,
                                }).then((value) {});
                                Myf.snakeBar(context, "Saved");
                                Navigator.pop(context);
                              },
                              onChanged: (value) {
                                // userEmail = value;
                              },
                              decoration: InputDecoration(
                                hintText: "COMPNAY ID",
                                label: Text("COMPNAY ID"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("PARTICULAR ICON PERMISSION"),
                        ),
                        CupertinoSwitch(
                          activeTrackColor: jsmColor,
                          value: "${userD["iconPermissionSet"]}".contains("true") ? true : false,
                          onChanged: (value) {
                            userD["iconPermissionSet"] = value;

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Text(
                      "ICON LIST",
                      style: TextStyle(fontSize: 30, color: jsmColor, fontWeight: FontWeight.bold),
                    ),
                    if ("${userD["iconPermissionSet"]}".contains("true") ? true : false) ...[
                      switchTileCard("Last_30_Days_Daily_Sales Chart", "Last_30_Days_Daily_Sales", userD),
                      if (loginUserModel.taskCrmManager == "1") switchTileCard("TASK_CRM", "TASK_CRM", userD),
                      if (loginUserModel.photoGallerySystem == "1") switchTileCard("PRODUCT GALLERY", "PRODUCTGALLERY", userD),
                      if (loginUserModel.gatePassSystem == "1") isTrading ? switchTileCard("GATEPASS", "GATEPASS", userD) : SizedBox.shrink(),
                      if (loginUserModel.crmSystem == "1") isTrading ? switchTileCard("CRM", "CRM", userD) : SizedBox.shrink(),
                      if (loginUserModel.saleDispatchSystem == "1") ...[
                        isTrading ? switchTileCard("SALE_DISPATCH_SYSTEM", "SALE_DISPATCH_SYSTEM", userD) : SizedBox.shrink(),
                      ],
                      if (loginUserModel.oRDERFORMENABLE == "1") ...[
                        Divider(),
                        Text("Order Permission", style: TextStyle(color: jsmColor, fontWeight: FontWeight.bold)),
                        isTrading ? switchTileCard("EMPIRE_ORDER_ADMIN_ACCESS", "EMPIRE_ORDER_ADMIN_ACCESS", userD) : SizedBox.shrink(),
                        isTrading ? switchTileCard("EMPIRE_ORDER", "EMPIRE_ORDER", userD) : SizedBox.shrink(),
                        isTrading ? switchTileCard("EMPIRE_ORDER_LIST", "EMPIRE_ORDER_LIST", userD) : SizedBox.shrink(),
                        isTrading ? switchTileCard("PERMISSION_DELETE_ORDER", "PERMISSION_DELETE_ORDER", userD) : SizedBox.shrink(),
                        Divider(),
                      ],
                      if (loginUserModel.jobCardReportPermission == "1") ...[
                        isTrading ? switchTileCard("JOB_CARD_REPORT", "JOB_CARD_REPORT", userD) : SizedBox.shrink(),
                      ],

                      isTrading ? switchTileCard("SALES_COMMISSION_REPORT", "SALESCOMMISSIONREPORT", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("THIS_WEEK_DUE", "THIS_WEEK_DUE", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("SALES ORDER", "PC_ORDER", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("TDS", "TDS", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("GSTIN SEARCH", "GSTINSEARCH", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("ACCOUNT NO", "ACCOUNTNO", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("BANK BOOK", "PAYMENTENTRY", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("LEDGER", "LEDGER", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("ANALYTICS", "ANALYTICS", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("ITEMANALYTICS", "ITEMANALYTICS", userD) : SizedBox.shrink(),

                      isTrading ? switchTileCard("FIND BILL", "FINDBILL", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("SALE", "SALE", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("OUTSTANDING", "OUTSTANDING", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("LR", "LR", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("BULK PDF BILL", "BULKPDFBILL", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("ITEM WISE SALE", "ITEMWISESALE", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("RETURN GOODS", "RETURNGOODS", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("PURCHASE", "PURCHASE", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("PURCHASE OUTSTANDING", "PURCHASEOUTSTANDING", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("MILL STOCK", "MILLSTOCK", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("STOCK IN HOUSE", "STOCKINHOUSE", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("JOB WORK", "JOBWORK", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("ADDRESS BOOK", "ADDRESSBOOK", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("QUALITY", "QUALITY", userD) : SizedBox.shrink(),
                      isTrading ? switchTileCard("TRANSPORT", "TRANSPORT", userD) : SizedBox.shrink(),

                      //----AGENCY SATRT FROM HERE
                      isAgency ? switchTileCard("GSTIN SEARCH", "GSTIN SEARCH", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("PAYMENT ENTRY", "PAYMENT ENTRY", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("LEDGER", "LEDGER", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("ORDERPHOTO", "ORDERPHOTO", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("FIND BILL", "FIND BILL", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("SALE", "SALE", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("OUTSTANDING", "OUTSTANDING", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("BULK PDF BILL", "BULK PDF BILL", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("COMMISSION REPORT", "COMMISSION REPORT", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("PURCHASE OUTSTANDING", "PURCHASE OUTSTANDING", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("ADDRESS BOOK", "ADDRESS BOOK", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("QUALITY CHART", "QUALITY CHART", userD) : SizedBox.shrink(),
                      isAgency ? switchTileCard("ACGROUP BOOK", "ACGROUP BOOK", userD) : SizedBox.shrink(),
                    ],
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SwitchListTile switchTileCard(title, ID, d) {
    return SwitchListTile(
      activeColor: jsmColor,
      title: Text(title),
      value: d[ID] == true,
      onChanged: (value) {
        setState(() {
          d[ID] = value;
        });
      },
    );
  }

  // Widget options(title, var trueFalse, String ID) {
  //   var trueFalseValue = trueFalse.contains("true") ? true : false;
  //   return boolparticularIconPermission
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text("$title"),
  //             ),
  //             CupertinoSwitch(
  //               value: trueFalseValue,
  //               onChanged: (value) {
  //                 setState(() {
  //                   trueFalseValue = value;
  //                   updatePermission(ID, trueFalseValue);
  //                 });
  //               },
  //             ),
  //           ],
  //         )
  //       : SizedBox.shrink();
  // }
}
