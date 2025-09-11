import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/Models/EmpOrderSettingModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/ProductJsonList/ProductListClass.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class EmpOrderFormSettings extends StatefulWidget {
  const EmpOrderFormSettings({Key? key}) : super(key: key);

  @override
  State<EmpOrderFormSettings> createState() => _EmpOrderFormSettingsState();
}

class _EmpOrderFormSettingsState extends State<EmpOrderFormSettings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireBCollection.collection("supuser").doc(GLB_CURRENT_USER["CLIENTNO"]).collection("SETTINGS").doc("EMP_ORDER").get().then((value) {
      empOrderSettingModel = EmpOrderSettingModel.fromJson(value.data()!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Order Settings"),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.save),
            label: Text("Save"),
            onPressed: () async {
              Myf.showBlurLoading(context);
              await fireBCollection
                  .collection("supuser")
                  .doc(GLB_CURRENT_USER["CLIENTNO"])
                  .collection("SETTINGS")
                  .doc("EMP_ORDER")
                  .set(empOrderSettingModel.toJson());
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Order sets system"),
            subtitle: Text(""),
            value: empOrderSettingModel.setsSystemOn ?? false,
            onChanged: (value) async {
              empOrderSettingModel.setsSystemOn = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Color system"),
            subtitle: Text("Show Color system on product add"),
            value: empOrderSettingModel.colorSystemOn ?? false,
            onChanged: (value) async {
              empOrderSettingModel.colorSystemOn = value;
              setState(() {});
            },
          ),
          if (empOrderSettingModel.colorSystemOn == true) ...[
            ListTile(
              title: Text("Color Add System Type"),
              subtitle: Text("Select how to choose color: image or Text"),
              trailing: DropdownButton<String>(
                value: empOrderSettingModel.colorImageSystemEntry ?? 'image',
                items: [
                  DropdownMenuItem(
                    value: 'image',
                    child: Text('Image'),
                  ),
                  DropdownMenuItem(
                    value: 'Text',
                    child: Text('Text'),
                  ),
                ],
                onChanged: (value) {
                  empOrderSettingModel.colorImageSystemEntry = value;
                  setState(() {});
                },
              ),
            ),
          ],
          SwitchListTile(
            title: Text("Show Rate Selection "),
            subtitle: Text("Show rate Selection OnEntry FormOrder"),
            value: empOrderSettingModel.showRateSelectionOnEntryFormOrder ?? false,
            onChanged: (value) async {
              empOrderSettingModel.showRateSelectionOnEntryFormOrder = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Show Date "),
            subtitle: Text("Show Date OnEntry FormOrder"),
            value: empOrderSettingModel.showFrmDate ?? false,
            onChanged: (value) async {
              empOrderSettingModel.showFrmDate = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Show Packing selection at bottom"),
            subtitle: Text("Show Packing selection at bottom"),
            value: empOrderSettingModel.showPackingSelectionAtBottom ?? false,
            onChanged: (value) async {
              empOrderSettingModel.showPackingSelectionAtBottom = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Packing rate add in Product rate"),
            subtitle: Text("Packing rate add in Product rate"),
            value: empOrderSettingModel.packingRateAddInProductRate ?? false,
            onChanged: (value) async {
              empOrderSettingModel.packingRateAddInProductRate = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Validate PCS & Rate (Not allow 0 or empty)"),
            // subtitle: Text("Validate PCS & Rate  (Not allow 0 or empty)"),
            value: empOrderSettingModel.validatRate ?? false,
            onChanged: (value) async {
              empOrderSettingModel.validatRate = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Show Dhara"),
            // subtitle: Text("Show Dhara"),
            value: empOrderSettingModel.sDhara ?? false,
            onChanged: (value) async {
              empOrderSettingModel.sDhara = value;
              setState(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text("PRODUCT DETAILS FORM VIEW SETTINGS"),
              children: [
                SwitchListTile(
                  title: Text("show sets"),
                  subtitle: Text("show sets"),
                  value: empOrderSettingModel.frmItmShowSets ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmShowSets = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show PcsInSets"),
                  subtitle: Text("show PcsInSets"),
                  value: empOrderSettingModel.frmItmPcsInSets ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmPcsInSets = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Packing"),
                  subtitle: Text("show Packing"),
                  value: empOrderSettingModel.frmItmPacking ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmPacking = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Cut"),
                  subtitle: Text("show Cut"),
                  value: empOrderSettingModel.frmItmCut ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmCut = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Mtr"),
                  subtitle: Text("show Mtr"),
                  value: empOrderSettingModel.frmItmMtr ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmMtr = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Rate"),
                  subtitle: Text("show Rate"),
                  value: empOrderSettingModel.frmItmRate ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmRate = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Design"),
                  subtitle: Text("show Design"),
                  value: empOrderSettingModel.frmItmDno ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmDno = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Rmk"),
                  subtitle: Text("show Rmk"),
                  value: empOrderSettingModel.frmItmRmk ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.frmItmRmk = value;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text("Pdf Settings"),
              children: [
                SwitchListTile(
                  title: Text("show Category"),
                  subtitle: Text("show Category"),
                  value: empOrderSettingModel.pdfItmcategory ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmcategory = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Design"),
                  subtitle: Text("show Design"),
                  value: empOrderSettingModel.pdfItmDno ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmDno = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Sets"),
                  subtitle: Text("show Sets"),
                  value: empOrderSettingModel.pdfItmSets ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmSets = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Packing"),
                  subtitle: Text("show Packing"),
                  value: empOrderSettingModel.pdfItmPacking ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmPacking = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Cut"),
                  subtitle: Text("show Cut"),
                  value: empOrderSettingModel.pdfItmCut ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmCut = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Rate"),
                  subtitle: Text("show Rate"),
                  value: empOrderSettingModel.pdfItmRate ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmRate = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Rmk"),
                  subtitle: Text("show Rmk"),
                  value: empOrderSettingModel.pdfItmRmk ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmRmk = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Amt"),
                  subtitle: Text("show Amt"),
                  value: empOrderSettingModel.pdfItmAmt ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfItmAmt = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("show Packing at bottom"),
                  subtitle: Text("show Packing at bottom"),
                  value: empOrderSettingModel.pdfPackingAtBottom ?? false,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfPackingAtBottom = value;
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("showHeader Details In Pdf"),
                  subtitle: Text("showHeader Details In Pdf"),
                  value: empOrderSettingModel.pdfHeaderDetails ?? true,
                  onChanged: (value) async {
                    empOrderSettingModel.pdfHeaderDetails = value;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text("Ask for PdfShare"),
            subtitle: Text("Ask for PdfShare"),
            value: empOrderSettingModel.askForSharePdfRate ?? true,
            onChanged: (value) async {
              empOrderSettingModel.askForSharePdfRate = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Photo link by local Network"),
            subtitle: Text("Photo link by local Network"),
            value: empOrderSettingModel.photoOnWifi ?? true,
            onChanged: (value) async {
              empOrderSettingModel.photoOnWifi = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Auto confirm on Order on create "),
            subtitle: Text("Auto confirm on Order on create "),
            value: empOrderSettingModel.autoConfimOrder ?? false,
            onChanged: (value) async {
              empOrderSettingModel.autoConfimOrder = value;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text("Show Image In Order Pdf"),
            subtitle: Text("Show Image In Order Pdf"),
            value: empOrderSettingModel.showImgInOrder ?? false,
            onChanged: (value) async {
              empOrderSettingModel.showImgInOrder = value;
              setState(() {});
            },
          ),
          ListTile(
            leading: empOrderSettingModel.urlPdfBackground != null
                ? CachedNetworkImage(
                    imageUrl: empOrderSettingModel.urlPdfBackground!,
                    height: 50,
                    width: 50,
                    httpHeaders: {
                      "Authorization": basicAuthForLocal,
                    },
                  )
                : SizedBox.shrink(),
            title: Text("Pdf Logo"),
            subtitle: IconButton(
                onPressed: () async {
                  empOrderSettingModel.urlPdfBackground = null;
                  setState(() {});
                },
                icon: Icon(Icons.delete)),
            trailing: IconButton(
                onPressed: () async {
                  XFile? f = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (f == null) return;
                  var url = await ProductListClass.UploadFilePublic(
                      path: f.path, name: "${GLB_CURRENT_USER["CLIENTNO"]}_urlPdfBackground", UserObj: GLB_CURRENT_USER, mimetype: "png");
                  empOrderSettingModel.urlPdfBackground = url;
                  setState(() {});
                },
                icon: Icon(Icons.attach_file_outlined)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    // validator: (value) {
                    //   if (Myf.toIntVal(value ?? "0") > 5) {
                    //     return "Value should be less than 5";
                    //   }
                    //   return null;
                    // },
                    initialValue: (empOrderSettingModel.pdfProductViewLimit ?? "").toString(),
                    onFieldSubmitted: (value) async {
                      empOrderSettingModel.pdfProductViewLimit = Myf.convertToDouble(value).toInt();
                    },
                    decoration: InputDecoration(label: Text("PDF PRODUCT VIEW LIMIT(>5)")),
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    initialValue: (empOrderSettingModel.pcReqTimeOut ?? "").toString(),
                    onFieldSubmitted: (value) async {
                      empOrderSettingModel.pcReqTimeOut = Myf.convertToDouble(value).toInt();
                    },
                    decoration: InputDecoration(label: Text("PC REQ TIMEOUT(Sec)")),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: (empOrderSettingModel.fixorderRmk ?? "").toString(),
              onFieldSubmitted: (value) async {
                empOrderSettingModel.fixorderRmk = value;
              },
              decoration: InputDecoration(label: Text("Fix Order Remark")),
            ),
          ),
          SizedBox(height: 80)
        ],
      ),
    );
  }
}
