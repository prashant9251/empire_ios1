import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/JobCardPanel/JobCardPanel.dart';
import 'package:empire_ios/screen/MasterNew/MasterNew.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:searchfield/searchfield.dart';

class MasterNewFilter extends StatefulWidget {
  final List<MasterModel> masterList;
  final List<String> cityList;
  const MasterNewFilter({Key? key, required this.masterList, required this.cityList}) : super(key: key);

  @override
  State<MasterNewFilter> createState() => _MasterNewFilterState();
}

class _MasterNewFilterState extends State<MasterNewFilter> {
  List<MasterModel> brokerList = [];
  var loading = true;
  List<dynamic> Atypes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  dispose() {
    super.dispose();
  }

  void getData() async {
    LazyBox<dynamic> lazyBoxAtypes = await SyncLocalFunction.openLazyBoxCheck("ATYPE");
    var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);

    var Atypes = await lazyBoxAtypes.get("${databaseId}ATYPE");
    if (Atypes is List) {
      this.Atypes = Atypes;
    } else {
      Atypes = [];
    }
    brokerList = widget.masterList.where((e) => e.aTYPE == "12").toList();
    lazyBoxAtypes.close();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: jsmColor,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Divider(),
                      ListTile(
                        title: Text("ATypes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: DropdownButton<String>(
                          value: MasterFilter["ATYPE"] == "" ? null : MasterFilter["ATYPE"],
                          hint: Text("Select AType"),
                          items: [
                            DropdownMenuItem<String>(
                              value: "",
                              child: Text(""),
                            ),
                            ...Atypes.map((dynamic value) => DropdownMenuItem<String>(
                                  value: value["ATYPE"],
                                  child: Text("${value["ATYPE"]} - ${value["NAME"]}", style: TextStyle(fontSize: 16)),
                                ))
                          ],
                          onChanged: (String? newValue) {
                            MasterFilter["ATYPE"] = newValue ?? "";
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchField(
                                suggestions: brokerList
                                    .map((e) => SearchFieldListItem<Object?>(
                                          e.partyname ?? '',
                                          item: e,
                                          value: e.value,
                                        ))
                                    .toList(),
                                controller: TextEditingController(text: MasterFilter["broker"] ?? ''),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter BrokerName";
                                  }
                                  return null;
                                },
                                searchInputDecoration: SearchInputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "BrokerName",
                                ),
                                onSuggestionTap: (v) {
                                  MasterFilter["broker"] = v.searchKey;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  MasterFilter["broker"] = '';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SearchField(
                                suggestions: widget.cityList
                                    .map((city) => SearchFieldListItem<String>(
                                          city,
                                          item: city,
                                          value: city,
                                        ))
                                    .toList(),
                                controller: TextEditingController(text: MasterFilter["city"] ?? ''),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter City";
                                  }
                                  return null;
                                },
                                searchInputDecoration: SearchInputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "City",
                                ),
                                onSuggestionTap: (v) {
                                  MasterFilter["city"] = v.searchKey;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  MasterFilter["city"] = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  GFButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      text: "Apply Filters",
                      color: jsmColor,
                      shape: GFButtonShape.standard,
                      size: GFSize.LARGE),
                ],
              ),
            ),
    );
  }
}
