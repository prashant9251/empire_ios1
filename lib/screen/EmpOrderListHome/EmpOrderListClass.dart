import 'package:empire_ios/Models/BillsDeleteModel.dart';
import 'package:empire_ios/Models/BillsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/EmpOrderForm.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderPrintClass/EmpOrderPrintClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Emporderlistclass {
  Card EmpOrderListCard(BuildContext context, BillsModel billsModel) {
    return Card(
      child: ListTile(
        onLongPress: () async {
          askForEnableOrdeAgain(context, billsModel);
        },
        trailing: (billsModel.status != "confirm") ? Emporderlistclass().editorderOption(context, billsModel) : SizedBox.shrink(),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    "${billsModel.bill!.padLeft(5, '0')} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 6,
                child: Text(
                  " ${billsModel.pcode!} ${billsModel.masterDet!.city}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: jsmColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${Myf.dateFormate(billsModel.date)}",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              directShareIcon(context, billsModel),
              prindPdfBtn(context, billsModel),
              if (firebaseCurrntUserObj["PERMISSION_DELETE_ORDER"] != false || loginUserModel.loginUser!.contains("ADMIN"))
                deleteBtn(context, billsModel),
              shareIcon(context, billsModel),
              if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true)
                statusorderOption(billsModel, context)
              else
                Chip(label: Text("${billsModel.status}")),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "created by ",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            "${billsModel.cBy}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }

  Future<dynamic> askForEnableOrdeAgain(BuildContext context, BillsModel billsModel) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Do you want Open Again this Order?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
              ),
              onPressed: () => makeDulicateThisOrder(context, billsModel),
              child: Text("Duplicate Order"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                billsModel.mTime = DateTime.now().toString();
                billsModel.status = "pending";
                await fireBCollection
                    .collection("supuser")
                    .doc(loginUserModel.cLIENTNO)
                    .collection("EMPIRE")
                    .doc(GLB_CURRENT_USER["yearVal"])
                    .collection("EMP_ORDER")
                    .doc(billsModel.ide)
                    .update(billsModel.toJson())
                    .then(
                  (value) {
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
              child: Text("Yes"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  CircleAvatar editorderOption(context, BillsModel billsModel) {
    return CircleAvatar(
        backgroundColor: Colors.grey.shade700,
        child: IconButton(
            color: Colors.white,
            onPressed: () async {
              await Myf.Navi(
                  context,
                  BlocProvider(
                    create: (context) => EmpOrderFormCubit(context),
                    child: EmpOrderForm(billsModel: billsModel),
                  ));
            },
            icon: Icon(Icons.edit)));
  }

  Widget prindPdfBtn(BuildContext context, BillsModel billsModel) {
    return CircleAvatar(
      backgroundColor: Colors.black54,
      child: IconButton(
        color: Colors.white,
        onPressed: () async {
          Myf.showBlurLoading(context);
          var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context, pdfOprate: "open");
          Myf.popScreen(context);
        },
        icon: Icon(Icons.print),
      ),
    );
  }

  Widget shareIcon(context, BillsModel billsModel) {
    return CircleAvatar(
        backgroundColor: Colors.green,
        child: IconButton(
            color: Colors.white,
            onPressed: () async {
              Myf.showBlurLoading(context);

              var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context, pdfOprate: "share");
              Myf.popScreen(context);
            },
            icon: Icon(Icons.share)));
  }

  Widget deleteBtn(BuildContext context, BillsModel billsModel) {
    return CircleAvatar(
      backgroundColor: Colors.red,
      child: IconButton(
        icon: Icon(Icons.delete),
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Delete Order(${billsModel.compmstDet!.sHORTNAME}-${billsModel.vNO})"),
                content: Text("Are you sure you want to delete this Order?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await deleteStart(context, billsModel);
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  deleteStart(BuildContext context, BillsModel billsModel) async {
    Myf.showBlurLoading(context);
    await fireBCollection
        .collection("supuser")
        .doc(loginUserModel.cLIENTNO)
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .doc(billsModel.ide)
        .get(fireGetOption)
        .then((value) async {
      if (value.exists) {
        var snp = value.data();
        BillsDeleteModel billsDeleteModel = BillsDeleteModel(
            ide: "${billsModel.ide}",
            type: billsModel.tYPE,
            vno: billsModel.vNO.toString(),
            cno: billsModel.cNO,
            dBy: loginUserModel.loginUser,
            dTime: DateTime.now().toString());
        await fireBCollection
            .collection("supuser")
            .doc(loginUserModel.cLIENTNO)
            .collection("EMPIRE")
            .doc(GLB_CURRENT_USER["yearVal"])
            .collection("EMP_ORDER_DELETED")
            .doc("${billsDeleteModel.ide}-${DateTime.now().toString()}")
            .set(billsDeleteModel.toJson())
            .then((value) async {
          await fireBCollection
              .collection("supuser")
              .doc(loginUserModel.cLIENTNO)
              .collection("EMPIRE")
              .doc(GLB_CURRENT_USER["yearVal"])
              .collection("EMP_ORDER")
              .doc("${billsModel.ide}")
              .delete()
              .then((value) async {
            Navigator.pop(context);
            Navigator.pop(context);
            Myf.showMyDialog(context, "DELETED", "successfully");
          }).onError((error, stackTrace) {
            Myf.snakeBar(context, "$error");
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
      }
    });
  }

  Widget statusorderOption(BillsModel billsModel, BuildContext context) {
    return DropdownButton(
        value: billsModel.status,
        items: ["pending", "confirm", "rejected"]
            .map((e) => DropdownMenuItem(
                  child: Chip(
                      backgroundColor: "${billsModel.status}".contains("pending")
                          ? Colors.blue
                          : "${billsModel.status}".contains("rejected")
                              ? Colors.red
                              : Colors.green,
                      label: Text(e)),
                  value: e,
                ))
            .toList(),
        onChanged: "${billsModel.status}".contains("confirm")
            ? null
            : (var val) async {
                Myf.showBlurLoading(context);
                billsModel.status = "${val}";
                billsModel.mTime = DateTime.now().toString();
                await fireBCollection
                    .collection("supuser")
                    .doc(loginUserModel.cLIENTNO)
                    .collection("EMPIRE")
                    .doc(GLB_CURRENT_USER["yearVal"])
                    .collection("EMP_ORDER")
                    .doc(billsModel.ide)
                    .update(billsModel.toJson());
                try {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                } catch (e) {}
              });
  }

  directShareIcon(BuildContext context, BillsModel billsModel) {
    return CircleAvatar(
      backgroundColor: Colors.white54,
      child: IconButton(
          onPressed: () async {
            var f = await EmpOrderPrintClass.savePdfOpen(OrderList: [billsModel], context: context, pdfOprate: "enotify");
          },
          icon: Icon(
            Icons.send,
            color: Colors.black54,
          )),
    );
  }

  void makeDulicateThisOrder(BuildContext context, BillsModel billsModel) async {
    Myf.showBlurLoading(context);
    var orderBreak = false;
    billsModel.vNO = empOrderSettingModel.IniOrderVno ?? 10001;
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .where("CNO", isEqualTo: billsModel.cNO)
        .where("TYPE", isEqualTo: billsModel.tYPE)
        .orderBy("VNO", descending: true)
        .limit(1)
        .get(fireGetOption)
        .then((value) async {
      var snp = value.docs;
      if (snp.length > 0) {
        await Future.wait(snp.map((e) async {
          dynamic d = e.data();
          BillsModel b = BillsModel.fromJson(Myf.convertMapKeysToString(d));
          var newVno = b.vNO + 1;
          billsModel.vNO = newVno;
        }).toList());
      }
    }, onError: (error) {
      Myf.snakeBar(context, error.toString());
      orderBreak = true;
    }).onError((error, stackTrace) {
      orderBreak = true;
      Myf.snakeBar(context, error.toString());
    });
    billsModel.ide = "${billsModel.cNO}-${billsModel.tYPE}-${billsModel.vNO}-${billsModel.date}";
    billsModel.cTime = DateTime.now().toString();
    billsModel.mTime = DateTime.now().toString();
    billsModel.bill = billsModel.vNO.toString();
    billsModel.date = DateTime.now().toString();
    if (orderBreak) {
      Navigator.pop(context);
      return;
    }
    await fireBCollection
        .collection("supuser")
        .doc(GLB_CURRENT_USER["CLIENTNO"])
        .collection("EMPIRE")
        .doc(GLB_CURRENT_USER["yearVal"])
        .collection("EMP_ORDER")
        .doc(billsModel.ide)
        .set(billsModel.toJson())
        .then((value) {
      Myf.popScreen(context);
      Myf.popScreen(context);
      Myf.snakeBar(context, "Order Duplicated Successfully");
    }).onError((error, stackTrace) {
      Myf.popScreen(context);
      Myf.snakeBar(context, error.toString());
    });
  }
}
