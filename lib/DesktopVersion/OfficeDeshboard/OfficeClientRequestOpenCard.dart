// ignore_for_file: must_be_immutable

import 'package:bubble/bubble.dart';
import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboard.dart';
import 'package:empire_ios/Models/ResponseSuggetionsModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import '../../main.dart';
import 'OfficeDeshboardClass.dart';

class OfficeClientRequestOpenCard extends StatefulWidget {
  var d;

  var UserObj;

  OfficeClientRequestOpenCard({Key? key, this.d, required this.UserObj}) : super(key: key);

  @override
  State<OfficeClientRequestOpenCard> createState() => _OfficeClientRequestOpenCardState();
}

class _OfficeClientRequestOpenCardState extends State<OfficeClientRequestOpenCard> {
  final _formKey = GlobalKey<FormState>();
  var ctrlReqType = TextEditingController();
  var ctrlComment = TextEditingController();

  var reqStatus;

  DateTime? followUpDate;

  var ctrlFollowUpDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List rplys = widget.d["rplys"] ?? [];
    String resolveDate = widget.d["resolveDate"] ?? "";
    var colorStyle = OfficeDeshboardClass.colorOnReqType(widget.d["reqType"]);
    try {
      followUpDate = DateTime.tryParse(widget.d["flwDate"]);
    } catch (e) {}
    ctrlFollowUpDate.text = Myf.dateFormateInDDMMYYYY(widget.d["flwDate"] ?? "");

    return Form(
      key: _formKey,
      child: Card(
        child: ExpansionTile(
          initiallyExpanded: resolveDate.isEmpty ? true : false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("${(widget.d["ID"])}", style: TextStyle(color: jsmColor))),
                  Flexible(child: Text("${widget.d["resolveDate"] ?? ""}")),
                ],
              ),
              GestureDetector(
                  onTap: () async {
                    var v = await Myf.showEntryDialog(context, widget.d["CLNT"], "CLNT");
                    if (v != null) {
                      widget.d["CLNT"] = v;
                      fireBCollection.collection("UserResponseReq").doc(widget.d["ID"]).update({"CLNT": v});
                    }
                  },
                  child: Text("${(widget.d["CLNT"])}", style: TextStyle(color: jsmColor))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: SelectableText("${(widget.d["response"])}", style: TextStyle(color: jsmColor))),
                  Flexible(
                    child: Chip(
                      label: Text("${widget.d["reqType"]}"),
                      backgroundColor: colorStyle,
                    ),
                  ),
                ],
              ),
              GestureDetector(onTap: () => Myf.dialNo([widget.d["MobileNo"]], context), child: Chip(label: Text("${(widget.d["MobileNo"])}")))
            ],
          ),
          children: [
            ListTile(
              title: Column(
                children: [
                  Container(
                    width: 400,
                    child: Bubble(
                      margin: BubbleEdges.only(top: 10),
                      alignment: Alignment.topLeft,
                      nip: BubbleNip.leftBottom,
                      color: jsmColor,
                      child: Column(
                        children: [
                          SelectableText(
                            "${(widget.d["response"])}",
                            style: TextStyle(color: Colors.white),
                          ),
                          if (widget.d["solution"] != null)
                            SelectableText(
                              "Solution: ${(widget.d["solution"])}",
                              style: TextStyle(color: Colors.white),
                            ),
                          if (widget.d["refName"] != null)
                            Text(
                              "Ref by: ${(widget.d["refName"] ?? "")}",
                              style: TextStyle(color: Colors.white),
                            ),
                          if (widget.d["remark"] != null)
                            SelectableText(
                              "${(widget.d["remark"])}",
                              style: TextStyle(color: Colors.white),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  '${Myf.dateFormate(widget.d["ID"])}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 8),
                                ),
                              ),
                              Flexible(child: Icon(Icons.watch_later_outlined, size: 10))
                            ],
                          ),
                          Text(
                            'By: ${widget.d["user"] ?? ""}',
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  ...rplys.map((e) {
                    var type = e["type"] ?? "";
                    if (type != "" && type != "cmt") {
                      return Container(
                        child: Bubble(
                          margin: BubbleEdges.only(top: 10),
                          alignment: Alignment.center,
                          nip: BubbleNip.no,
                          color: Color.fromRGBO(212, 234, 244, 1.0),
                          child: Text('${e["type"]} From ${e["from"]} To ${e["ans"]} By ${e["user"]}',
                              textAlign: TextAlign.center, style: TextStyle(fontSize: 10.0)),
                        ),
                      );
                    } else {
                      return Container(
                        width: 400,
                        child: Bubble(
                          margin: BubbleEdges.only(top: 10),
                          alignment: Alignment.topRight,
                          nip: BubbleNip.rightBottom,
                          color: Color.fromRGBO(225, 255, 199, 1.0),
                          child: Column(
                            children: [
                              SelectableText('${e["ans"]}', textAlign: TextAlign.right),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${Myf.dateFormate(e["time"])}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  Flexible(child: Icon(Icons.done, size: 10))
                                ],
                              ),
                              Text(
                                'By: ${e["user"] ?? ""}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }).toList(),
                  SizedBox(height: 5),
                ],
              ),
              subtitle: resolveDate != ""
                  ? Container(
                      child: Text("Ticket closed"),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: IconButton(
                                    onPressed: () async {
                                      var v = await OfficeDeshboardClass.getResposeSelection(
                                          context, ResponseSuggetionsModel(issueType: widget.d["reqType"], id: DateTime.now().toString()));
                                      if (v is ResponseSuggetionsModel) {
                                        ctrlComment.text = v.desc!;
                                      }
                                    },
                                    icon: Icon(Icons.add))),
                            Flexible(
                              flex: 5,
                              child: SearchField(
                                  suggestions: (() {
                                    final filtered = responseSuggetions.where((element) => element.issueType == widget.d["reqType"]).toList();
                                    filtered.sort((a, b) => a.desc!.compareTo(b.desc!));
                                    return filtered.map((e) => SearchFieldListItem<Object?>(e.desc!, item: e.desc, value: e.desc)).toList();
                                  })(),
                                  controller: ctrlComment,
                                  textInputAction: TextInputAction.next,
                                  validator: (p0) {
                                    if (p0 == null || p0.isEmpty) {
                                      return "Please enter comment";
                                    }
                                    return null;
                                  },
                                  searchInputDecoration: SearchInputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Comment",
                                  ),
                                  onSuggestionTap: (v) {
                                    ctrlComment.text = v.value as String;
                                  }),
                            ),
                            Flexible(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        save(widget.d);
                                      }
                                    },
                                    child: Text("Save"))),
                            Flexible(
                                child: TextFormField(
                              controller: ctrlFollowUpDate,
                              onTap: () async {
                                followUpDate = await Myf.selectDate(context);
                                if (followUpDate == null) return;

                                ctrlFollowUpDate.text = Myf.dateFormateInDDMMYYYY(followUpDate.toString());
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                label: Text("Follow update"),
                              ),
                            ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(onPressed: () => askForClose(), icon: Icon(Icons.done_all), label: Text("Ticket close")),
                            DropdownButton(
                                value: ctrlReqType.text,
                                hint: Text("Select Req Type"),
                                items: followUpTypes
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (var val) {
                                  // setYear(val);
                                  ctrlReqType.text = val.toString();
                                  changeReqType(widget.d);
                                })
                          ],
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  void save(d) async {
    List rplys = d["rplys"] ?? [];
    Map<String, dynamic> obj = {};
    obj["ans"] = ctrlComment.text.trim();
    obj["time"] = DateTime.now().toString();
    obj["user"] = widget.UserObj["login_user"];
    obj["type"] = "cmt";
    rplys.add(obj);
    d["rplys"] = rplys;
    d["flwDate"] = Myf.dateFormateYYYYMMDD(followUpDate.toString(), formate: "yyyy-MM-dd");
    d["m_time"] = DateTime.now().millisecondsSinceEpoch.toString();
    fireBCollection.collection("UserResponseReq").doc(d["ID"]).update(d);
    ctrlComment.clear();

    // // ----time update ;
    // fireBCollection.collection("UserResponseReq").get().then((value) {
    //   var snp = value.docs;
    //   snp.map((e) async {
    //     dynamic d = e.data();
    //     if (d["m_time"] == null) {
    //       logger.d(d, snp.length);
    //       d["m_time"] = d["m_time"] ?? "000";
    //       await fireBCollection.collection("UserResponseReq").doc(e["ID"]).update({"m_time": d["m_time"]});
    //     }
    //   }).toList();
    // });
  }

  changeReqType(d, {status}) async {
    List rplys = d["rplys"] ?? [];
    Map<String, dynamic> obj = {};
    obj["from"] = d["reqType"];
    obj["ans"] = status != null && status != "" ? status : ctrlReqType.text.trim();
    d["reqType"] = ctrlReqType.text.isEmpty ? widget.d["reqType"] : ctrlReqType.text.trim();
    obj["time"] = DateTime.now().toString();
    obj["user"] = widget.UserObj["login_user"];
    obj["type"] = "REQ TYPE CHANGED";
    rplys.add(obj);
    d["m_time"] = DateTime.now().millisecondsSinceEpoch.toString();
    d["rplys"] = rplys;
    fireBCollection.collection("UserResponseReq").doc(widget.d["ID"]).update(d);
    ctrlComment.clear();
  }

  askForClose() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text("Are you sure you want to Ticket Close"),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await changeReqType(widget.d, status: "TICKET CLOSE");
                  await fireBCollection
                      .collection("UserResponseReq")
                      .doc(widget.d["ID"])
                      .update({"resolveDate": DateTime.now().toString(), "tktStatus": "close"});
                },
                child: Text("YES")),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("CANCEL")),
          ],
        );
      },
    );
  }
}
