import 'package:empire_ios/Models/ProductModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ndialog/ndialog.dart';

class ShareOption {
  static showModelShare(context, {required List<ProductModel> productList}) {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => makeDismissible(
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return shareOptionMenu(scrollController: scrollController, productList: productList);
              },
            ),
            context: context));
  }

  static makeDismissible({required Widget child, required BuildContext context}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
  }

  static deleteOptioMulti(context, List<ProductModel> tempSelectImglist) async {
    var yesNo = await Myf.yesNoShowDialod(context, title: "Alert", msg: "Are you sure you want to delete selected product");
    if (!yesNo) return;
    Myf.showLoading(context, "Please wait");
    await Future.wait(tempSelectImglist.map((e) async {
      await ProductListClass.deleteFInalProcess(GLB_CURRENT_USER, e);
      hiveMainBox.put("PRODUCT", "value");
    }).toList());
    Navigator.pop(context);
  }
}

class shareOptionMenu extends StatefulWidget {
  shareOptionMenu({Key? key, required this.scrollController, required this.productList}) : super(key: key);
  ScrollController scrollController;
  List<ProductModel> productList;
  @override
  State<shareOptionMenu> createState() => _shareOptionMenuState();
}

class _shareOptionMenuState extends State<shareOptionMenu> {
  var fromRateCtrl = TextEditingController(text: "0");
  var toRateCtrl = TextEditingController(text: "10000");
  double progressimg = 0;
  var ctrlMuRateOnShare = TextEditingController(text: "0");
  var boolviewDno = false;
  var boolviewPrice = false;
  var boolviewMainScreenName = false;
  var boolviewFabricsName = false;

  var selectedValue = "S1";
  @override
  void initState() {
    super.initState();
    boolviewDno = shareSettingObj["v_name"] ?? false;
    boolviewPrice = shareSettingObj["v_rate"] ?? false;
    boolviewMainScreenName = shareSettingObj["v_mainscreen"] ?? false;
    boolviewFabricsName = shareSettingObj["v_fabrics"] ?? false;
    selectedValue = shareSettingObj["v_rateType"] ?? "S1";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                children: [
                  Text(
                    "Share",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: jsmColor),
                  ),
                  Divider(
                    height: 20, // The divider's height extent.
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text("Share  settings ?"),
                    children: [
                      ListTile(
                        title: Text("With Name?"),
                        trailing: Switch(
                          value: boolviewDno,
                          onChanged: (value) {
                            shareSettingObj["v_name"] = value;
                            setState(() {
                              boolviewDno = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("With Rate?"),
                        subtitle: DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              shareSettingObj["v_rateType"] = selectedValue;
                            });
                          },
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'S1',
                              child: Text('RATE1'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'S2',
                              child: Text('RATE2'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'S3',
                              child: Text('RATE3'),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: boolviewPrice,
                          onChanged: (value) {
                            shareSettingObj["v_rate"] = value;
                            setState(() {
                              boolviewPrice = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("With Main Screen Name ?"),
                        trailing: Switch(
                          value: boolviewMainScreenName,
                          onChanged: (value) {
                            shareSettingObj["v_mainscreen"] = value;
                            setState(() {
                              boolviewMainScreenName = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text("With Fabric Name ?"),
                        trailing: Switch(
                          value: boolviewFabricsName,
                          onChanged: (value) {
                            shareSettingObj["v_fabrics"] = value;
                            setState(() {
                              boolviewFabricsName = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  // Row(children: [Icon(Icons.check_box_outlined), Text("Remember This?")])
                ],
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ProductListClass.shareAllSelectedFile(context, productList: widget.productList);
                  },
                  icon: const Icon(Icons.share_outlined),
                  label: const Text("Share"),
                ))
          ],
        ),
      ),
    );
  }
}
