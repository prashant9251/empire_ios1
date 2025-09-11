import 'dart:async';

import 'package:empire_ios/Apis/Enotify.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboardClass.dart';
import 'package:empire_ios/Models/WhatsappContactModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListState.dart';
import 'package:empire_ios/screen/TemplateManager/TemplateManager.dart';
import 'package:flutter/material.dart';

class WhatsappManagerHome extends StatefulWidget {
  const WhatsappManagerHome({Key? key}) : super(key: key);

  @override
  State<WhatsappManagerHome> createState() => _WhatsappManagerHomeState();
}

class _WhatsappManagerHomeState extends State<WhatsappManagerHome> {
  var changeStream = StreamController<bool>.broadcast();
  List<WhatsappContactModel> whatsappContactModelList = [];

  var ctrlBodyMsg = TextEditingController(text: "*Update Alert* Please update your Computer Sync Utility to Version *3.11*for proper Syncing ");

  var softwareName = "";

  var paidOnly = false;

  var ctrlImgUrl = TextEditingController(text: "https://uniqsoftwares.com/img/pcutilitySoftwaresUpdate.jpeg");
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("Whatsapp Manager"),
          actions: [
            TextButton(onPressed: () => Myf.Navi(context, TemplateManager()), child: Text("New Templates")),
            TextButton(onPressed: () => exportToCsv(whatsappContactModelList), child: Text("Export Data")),
          ],
        ),
        body: Center(
          child: Container(
            color: Colors.white,
            width: friendlyScreenWidth(context, constraints),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        child: CheckboxListTile(
                      value: paidOnly,
                      onChanged: (value) {
                        paidOnly = value!;
                        setState(() {});
                        changeStream.sink.add(true);
                      },
                      title: Text("Paid only"),
                    )),
                    Flexible(
                      child: Card(
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                          hint: Text("Select Company"),
                          items: ["EMPIRE TRADING", "EMPIRE AGENCY"].map(
                            (e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            },
                          ).toList(),
                          onChanged: (value) async {
                            softwareName = value.toString();
                            await fetchusers(context);
                          },
                        )),
                      ),
                    ),
                    Flexible(
                        child: TextFormField(
                            decoration: InputDecoration(labelText: "Test Mobile No "),
                            onFieldSubmitted: (value) {
                              whatsappContactModelList = whatsappContactModelList.where((element) => element.phone!.contains(value)).toList();
                              changeStream.sink.add(true);
                            })),
                  ],
                ),
                Divider(),
                Expanded(
                  child: StreamBuilder<bool>(
                      stream: changeStream.stream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text("${index + 1}"),
                                ),
                                title: Text("${whatsappContactModelList[index].CompanyName!}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${whatsappContactModelList[index].userName!}"),
                                    Text("91${whatsappContactModelList[index].phone!}"),
                                  ],
                                ),
                                // trailing: Text("${whatsappContactModelList[index].userName!}"),
                                trailing: whatsappContactModelList[index].issent == true ? Icon(Icons.done) : Icon(Icons.send),
                              );
                            },
                            itemCount: whatsappContactModelList.length);
                      }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter Image Url ", border: OutlineInputBorder()),
                  controller: ctrlImgUrl,
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(labelText: "Enter BodyText ", border: OutlineInputBorder()),
                  controller: ctrlBodyMsg,
                ),
                ElevatedButton(
                  onPressed: () {
                    whatsappContactModelList.map((e) {
                      sendMsg(e);
                    }).toList();
                  },
                  child: Text("Send Message"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void sendMsg(WhatsappContactModel whatsappContactModel) async {
    if (ctrlImgUrl.text.isNotEmpty) {
      await EnotifyApis.senFileWithCaption(whatsappContactModel,
          toPhone: "91${whatsappContactModel.phone!}", fileLink: ctrlImgUrl.text, textMsg: ctrlBodyMsg.text);
    } else {
      await EnotifyApis.sendMsg(whatsappContactModel, toPhone: "91${whatsappContactModel.phone!}", textMsg: ctrlBodyMsg.text);
      changeStream.sink.add(true);
    }
    changeStream.sink.add(true);
  }

  Future<void> fetchusers(BuildContext context) async {
    whatsappContactModelList = [];
    Myf.snakeBar(context, "Fetching data ");
    var u = await OfficeDeshboardClass.getData(context, softwareName: softwareName, recorslimit: '10000', PAY: paidOnly ? 'Y' : 'N');
    if (u!.length > 0) {
      await Future.wait(u.map(
        (e) async {
          List users = e["billDetails"];
          await Future.wait(users.map(
            (b) async {
              WhatsappContactModel whatsappContactModel = WhatsappContactModel();
              whatsappContactModel.CompanyName = e['shopName'];
              whatsappContactModel.phone = b['mobileno_user'];
              whatsappContactModel.userName = b['usernm'];
              whatsappContactModel.clnt = e['clnt'];
              whatsappContactModel.PAY = e['PAY'];
              whatsappContactModelList.add(whatsappContactModel);
            },
          ).toList());
        },
      ).toList());
      changeStream.sink.add(true);
    }
  }

  exportToCsv(List<WhatsappContactModel> whatsappContactModelList) async {
    var csv = "Name,mobile,clnt\n";
    whatsappContactModelList.map((e) {
      csv += "${e.userName},91${e.phone},${e.clnt}\n";
    }).toList();
    EmpOrderListStateDownload.downloadCSVWeb(csv, 'Uniq contact ${softwareName}.csv', context, title: "Exported");
    //
  }
}
