// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeClientRequestOpen.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboardClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

import '../OfficeRequestList/OfficeRequestEndDrawer.dart';

class OfficeSearchList extends StatefulWidget {
  var UserObj;

  OfficeSearchList({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<OfficeSearchList> createState() => _OfficeSearchListState();
}

class _OfficeSearchListState extends State<OfficeSearchList> {
  final StreamController<bool> refreshScreen = StreamController<bool>.broadcast();
  var ctrlSearch = TextEditingController();
  List? userData = [];
  dynamic EndDrawerObj;

  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      endDrawer: OfficeRequestEndDrawer(drawerObj: EndDrawerObj),
      body: StreamBuilder<bool>(
          stream: refreshScreen.stream,
          builder: (context, snapshot) {
            return loading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator(), Text("please wait")],
                    ),
                  )
                : ListView(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(29.5)),
                              child: TextFormField(
                                autofocus: true,
                                onChanged: (value) => setState(() {}),
                                onFieldSubmitted: (value) => getData(),
                                controller: ctrlSearch,
                                decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
                              ),
                            ),
                          ),
                          Flexible(child: FloatingActionButton.extended(onPressed: () => getData(), label: Text("Search")))
                        ],
                      ),
                      ...userData!.map((e) {
                        var admin_mobile = e["admin_mobile"];
                        var admin_email = e["admin_email"];
                        List billDetails = e["billDetails"];
                        var colorStyle = OfficeDeshboardClass.colorOnPayType(e);
                        return Card(
                          color: colorStyle,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(width: 200, child: Text("${e["shopName"]}")),
                                    IconButton(
                                        onPressed: () => Myf.Navi(
                                            context,
                                            OfficeClientRequestOpen(
                                              obj: e,
                                              UserObj: widget.UserObj,
                                            )),
                                        icon: Icon(Icons.open_in_browser))
                                  ],
                                ),
                                richText(context, "CLNT", "${e["clnt"]}"),
                                richText(context, "SOFTWARE", "${e["software_name"]}"),
                              ],
                            ),
                            initiallyExpanded: false,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text('Name')),
                                      DataColumn(label: Text('Mobile No')),
                                      DataColumn(label: Text('Email')),
                                    ],
                                    rows: billDetails.map((item) {
                                      var userIsadmin = false;
                                      if (item['mobileno_user'] == admin_mobile && item['emailadd'] == admin_email) {
                                        userIsadmin = true;
                                      }
                                      return DataRow(
                                        color: MaterialStateColor.resolveWith((states) => userIsadmin ? Colors.grey : Colors.white),
                                        cells: [
                                          DataCell(Text(item['usernm'])),
                                          DataCell(Text(item['mobileno_user'])),
                                          DataCell(Text(item['emailadd'])),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList()
                    ],
                  );
          }),
    );
  }

  RichText richText(BuildContext context, title, text) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: '$text',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  void getData() async {
    loading = true;
    refreshScreen.sink.add(true);
    userData = await OfficeDeshboardClass.getData(context, term: ctrlSearch.text);
    loading = false;
    refreshScreen.sink.add(true);
  }
}
