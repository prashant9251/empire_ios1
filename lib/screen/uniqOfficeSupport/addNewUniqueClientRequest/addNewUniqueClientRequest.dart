// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboard.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboardClass.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeRequestList/OfficeRequestTabs/model/OfficeRequestTabModel.dart';
import 'package:empire_ios/Models/ResponseSuggetionsModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/Product/AddNewproduct/inputwidgetlist.dart';
import 'package:empire_ios/screen/uniqOfficeSupport/uniqOfficeClass.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class AddNewUniqueClientRequest extends StatefulWidget {
  var userDataObj;

  var UserObj;

  AddNewUniqueClientRequest({Key? key, required this.userDataObj, required this.UserObj}) : super(key: key);

  @override
  State<AddNewUniqueClientRequest> createState() => _AddNewUniqueClientRequestState();
}

class _AddNewUniqueClientRequestState extends State<AddNewUniqueClientRequest> {
  final _formKey = GlobalKey<FormState>();
  var ctrlName = TextEditingController();
  var ctrlDateTime = TextEditingController();
  var ctrlReqTypeSelected = TextEditingController();
  var ctrlMobile = TextEditingController();
  var ctrlClnt = TextEditingController();
  var ctrlReferedBy = TextEditingController();
  var ctrlRmk = TextEditingController();
  var ctrlResponse = TextEditingController();
  var ctrlSolution = TextEditingController();
  var ctrlShopName = TextEditingController();
  String responseOptions = "";
  List<dynamic> userList = [];

  List<ResponseSuggetionsModel> responnsSuggetionList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlName.text = widget.userDataObj["req_usernm"] ?? "";
    ctrlMobile.text = widget.userDataObj["req_mobileno_user"] ?? "";
    ctrlClnt.text = widget.userDataObj["clnt"] ?? "";
    ctrlShopName.text = widget.userDataObj["shopName"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    userList = widget.userDataObj["billDetails"] ?? [];
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenWidth = ScreenWidth(context);
        if (constraints.maxWidth < 600) {
          screenWidth = ScreenWidth(context);
        } else if (constraints.maxWidth < 1200) {
          screenWidth = ScreenWidth(context);
        } else {
          screenWidth = ScreenWidth(context) * .6;
        }
        var sr = 0;
        var srResponse = 0;
        return Scaffold(
          appBar: AppBar(backgroundColor: jsmColor, title: Text("Add New Request"), actions: []),
          body: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: screenWidth,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Card(
                          child: DropdownButton(
                              value: ctrlReqTypeSelected.text,
                              hint: Text("Select Req Type"),
                              items: followUpTypes
                                  .map((e) => DropdownMenuItem(
                                        child: Text("${sr++}-${e}"),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (var val) {
                                // setYear(val);
                                ctrlReqTypeSelected.text = val.toString();
                                responnsSuggetionList = responseSuggetions.where(
                                  (element) {
                                    return element.issueType == ctrlReqTypeSelected.text;
                                  },
                                ).toList();
                                setState(() {});
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child:
                              inputBoxClassWidget.InputField(ctrl: ctrlShopName, hint: "Shop Name", label: "Shop Name", validator: "Enter Shop Name"),
                        ),
                        Flexible(
                          child: inputBoxClassWidget.InputField(
                              prefix: IconButton(
                                  onPressed: () async {
                                    var v = await UniqOfficeClass.selectMobileNo(context, userList);
                                    if (v == null) return;
                                    ctrlMobile.text = v["mobileno_user"];
                                    ctrlName.text = v["usernm"];
                                  },
                                  icon: Icon(Icons.find_in_page)),
                              ctrl: ctrlMobile,
                              hint: "Mobile",
                              label: "Mobile",
                              validator: "Enter Mobile",
                              TextInputTypeKeyBord: TextInputType.number),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: inputBoxClassWidget.InputField(
                              ctrl: ctrlClnt,
                              hint: "Client No",
                              label: "Client No",
                              validator: "Enter Client No",
                              TextInputTypeKeyBord: TextInputType.number),
                        ),
                        Flexible(
                          child: inputBoxClassWidget.InputField(
                              ctrl: ctrlName, hint: "Contact persion Name", label: "Contact persion Name", validator: "Enter Contact persion Name"),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: SearchField(
                                suggestions: (() {
                                  final filtered = responseSuggetions.where((element) => element.issueType == ctrlReqTypeSelected.text).toList();
                                  filtered.sort((a, b) => a.desc!.compareTo(b.desc!));
                                  return filtered.map((e) => SearchFieldListItem<Object?>(e.desc!, item: e.desc, value: e.desc)).toList();
                                })(),
                                controller: ctrlResponse,
                                textInputAction: TextInputAction.next,
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return "Please enter Response";
                                  }
                                  return null;
                                },
                                searchInputDecoration: SearchInputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Response",
                                ),
                                onSuggestionTap: (v) {
                                  ctrlResponse.text = v.value as String;
                                }),
                          ),
                          Flexible(
                              child: IconButton(
                                  onPressed: () async {
                                    var v = await OfficeDeshboardClass.getResposeSelection(
                                        context, ResponseSuggetionsModel(issueType: ctrlReqTypeSelected.text));
                                    if (v is ResponseSuggetionsModel) {
                                      ctrlResponse.text = v.desc!;
                                      ctrlSolution.text = v.solution!;
                                    }
                                  },
                                  icon: Icon(Icons.add)))
                        ],
                      ),
                    ),
                    inputBoxClassWidget.InputField(ctrl: ctrlSolution, hint: "Solution", label: "Solution", maxLine: 5),
                    Row(
                      children: [
                        Flexible(
                          child: inputBoxClassWidget.InputField(ctrl: ctrlReferedBy, hint: "Reference by", label: "Reference by"),
                        ),
                        Flexible(
                          child: inputBoxClassWidget.InputField(ctrl: ctrlRmk, hint: "Remark", label: "Remark"),
                        )
                      ],
                    ),
                    FloatingActionButton.extended(
                        backgroundColor: jsmColor,
                        onPressed: () => validate(),
                        label: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      save();
    }
  }

  void save() async {
    if (ctrlReqTypeSelected.text.isEmpty) {
      Myf.showMsg(context, "Alert", "Please select request type");
      return;
    }
    Myf.showBlurLoading(context);
    OfficeRequestTabModel officeRequestTabModel = OfficeRequestTabModel();
    DateTime now = DateTime.now();
    String formattedDate = "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}T"
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";
    officeRequestTabModel.fname = ctrlName.text;
    officeRequestTabModel.shopName = ctrlShopName.text;
    officeRequestTabModel.dATE = formattedDate;
    officeRequestTabModel.tdATE = DateTime.now().toString();
    officeRequestTabModel.iD = now.toString();
    officeRequestTabModel.reqType = ctrlReqTypeSelected.text;
    officeRequestTabModel.mobileNo = ctrlMobile.text;
    officeRequestTabModel.user = widget.UserObj["login_user"];
    officeRequestTabModel.cLNT = ctrlClnt.text;
    officeRequestTabModel.refName = ctrlReferedBy.text;
    officeRequestTabModel.remark = ctrlRmk.text;
    officeRequestTabModel.response = ctrlResponse.text;
    officeRequestTabModel.solution = ctrlSolution.text;
    officeRequestTabModel.status = false;
    officeRequestTabModel.tktStatus = "open";
    officeRequestTabModel.mTime = DateTime.now().millisecondsSinceEpoch.toString();

    await fireBCollection.collection("UserResponseReq").doc(officeRequestTabModel.iD).set(officeRequestTabModel.toJson()).then((value) {
      Navigator.pop(context);
    });
    Navigator.pop(context);
  }
}
