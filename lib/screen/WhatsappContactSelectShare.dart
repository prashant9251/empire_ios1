import 'dart:async';

import 'package:empire_ios/Models/WhatsappSendToModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/WhatsappSendTaskListPdf/WhatsappSendTaskListPdf.dart';
import 'package:flutter/material.dart';

class WhatsappContactSelectShareScreen extends StatefulWidget {
  List<WhatsappSendToModel> whatsappSendToModelList;
  var shareBy;
  WhatsappContactSelectShareScreen({Key? key, required this.whatsappSendToModelList, this.shareBy}) : super(key: key);

  @override
  State<WhatsappContactSelectShareScreen> createState() => _WhatsappContactSelectShareScreenState();
}

class _WhatsappContactSelectShareScreenState extends State<WhatsappContactSelectShareScreen> {
  var changeStream = StreamController<bool>.broadcast();
  var moSelected = true;
  var brokerSelected = true;
  var ph1Selected = true;
  var ph2Selected = true;
  var fx2Selected = true;
  @override
  Widget build(BuildContext context) {
    if (loginUserModel.enotifyInstance == null || loginUserModel.enotifyInstance == "") {
      return Scaffold(
        appBar: AppBar(
          title: Text("Select Contact"),
        ),
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Please contact to Unique softwraes call support for this feature"),
                ],
              ),
            )),
            Row(
              children: [
                Flexible(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                    icon: Icon(Icons.call, color: Colors.white),
                    label: const Text('Call', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Myf.dialNo(["${firebSoftwraesInfo["contactNo"]}"], context);
                    },
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Select Contact"),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            // height: 200,
            width: widthResponsive(context),
            child: Column(
              children: [
                SizedBox(height: 10),
                StreamBuilder<bool>(
                    stream: changeStream.stream,
                    builder: (context, snapshot) {
                      return Container(
                        color: jsmColor,
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                Container(
                                    width: 120,
                                    child: CheckboxListTile(
                                      value: moSelected,
                                      onChanged: (value) {
                                        moSelected = value!;
                                        widget.whatsappSendToModelList.forEach((element) {
                                          element.contactList!.forEach((element) {
                                            if (element.noType == "MO") element.selected = value;
                                          });
                                        });
                                        changeStream.sink.add(true);
                                      },
                                      title: Text(
                                        "MO.",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )),
                                Container(
                                    width: 120,
                                    child: CheckboxListTile(
                                      value: ph1Selected,
                                      onChanged: (value) {
                                        ph1Selected = value!;
                                        widget.whatsappSendToModelList.forEach((element) {
                                          element.contactList!.forEach((element) {
                                            if (element.noType == "PH1") element.selected = value;
                                          });
                                        });
                                        changeStream.sink.add(true);
                                      },
                                      title: Text(
                                        "PH1",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )),
                                Container(
                                    width: 120,
                                    child: CheckboxListTile(
                                      value: ph2Selected,
                                      onChanged: (value) {
                                        ph2Selected = value!;
                                        widget.whatsappSendToModelList.forEach((element) {
                                          element.contactList!.forEach((element) {
                                            if (element.noType == "PH2") element.selected = value;
                                          });
                                        });
                                        changeStream.sink.add(true);
                                      },
                                      title: Text(
                                        "PH2",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )),
                                Container(
                                    width: 120,
                                    child: CheckboxListTile(
                                      value: fx2Selected,
                                      onChanged: (value) {
                                        fx2Selected = value!;
                                        widget.whatsappSendToModelList.forEach((element) {
                                          element.contactList!.forEach((element) {
                                            if (element.noType == "FX1") element.selected = value;
                                          });
                                        });
                                        changeStream.sink.add(true);
                                      },
                                      title: Text(
                                        "FX1",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )),
                                Container(
                                  width: 120,
                                  child: CheckboxListTile(
                                    value: brokerSelected,
                                    onChanged: (value) {
                                      brokerSelected = value!;
                                      widget.whatsappSendToModelList.forEach((element) {
                                        element.contactList!.forEach((element) {
                                          if (element.uType == "Broker") element.selected = value;
                                        });
                                      });
                                      changeStream.sink.add(true);
                                    },
                                    title: Text(
                                      "Broker",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                Expanded(
                    child: StreamBuilder<bool>(
                        stream: changeStream.stream,
                        builder: (context, snapshot) {
                          return ListView.builder(
                              itemCount: widget.whatsappSendToModelList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Card(
                                    elevation: 20,
                                    child: ListTile(
                                      title: Text("${widget.whatsappSendToModelList[index].pname}"),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ...widget.whatsappSendToModelList[index].contactList!.map((e) {
                                            return CheckboxListTile(
                                              title: Text("${e.uType ?? ""}-${e.phone}"),
                                              value: e.selected ?? true,
                                              onChanged: (value) {
                                                // print(value);
                                                e.selected = value;
                                                changeStream.sink.add(true);
                                              },
                                            );
                                          }).toList()
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        })),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                      onPressed: () async {
                        var selectedList = widget.whatsappSendToModelList.map((e) {
                          e.contactList = e.contactList!.where((element) => element.selected == true).toList();
                          return e;
                        }).toList();
                        selectedList = selectedList.where((element) => element.contactList!.length > 0).toList();
                        await Myf.Navi(context,
                            WhatsappSendTaskListPdf(UserObj: GLB_CURRENT_USER, whatsappSendToModelList: selectedList, shareBy: widget.shareBy));
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Send Now",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
