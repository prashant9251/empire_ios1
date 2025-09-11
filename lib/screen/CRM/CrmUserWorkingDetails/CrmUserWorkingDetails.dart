import 'package:bubble/bubble.dart';
import 'package:empire_ios/Models/OutstandingModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmHome/CrmHome.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/CRM/CrmPartyOutstanding/CrmPartyOutstanding.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:flutter/material.dart';

class CrmUserWorkingDetails extends StatefulWidget {
  List<CrmFollowUpModel>? crmFollowUpList;
  CrmUserWorkingDetails({Key? key, required this.crmFollowUpList}) : super(key: key);

  @override
  State<CrmUserWorkingDetails> createState() => _CrmUserWorkingDetailsState();
}

class _CrmUserWorkingDetailsState extends State<CrmUserWorkingDetails> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: Text("${Myf.getUserNameString(widget.crmFollowUpList!.first.user!)}"),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: friendlyScreenWidth(context, constraints),
              padding: const EdgeInsets.all(12),
              child: ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemCount: widget.crmFollowUpList!.length,
                itemBuilder: (context, idx) {
                  final e = widget.crmFollowUpList![idx];
                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      subtitle: Row(
                        children: [
                          Chip(
                            label: Text(
                              "${e.followUpType}",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: Colors.blue.shade100,
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            tooltip: "View Outstanding",
                            onPressed: () async {
                              try {
                                OutstandingModel outstandingModel = await CRM_OUTSTANDING_LIST.firstWhere((i) => i.code == e.partyCode);
                                Myf.Navi(context, CrmPartyOutstanding(outstandingModel: outstandingModel));
                              } catch (e) {}
                            },
                            icon: Icon(Icons.open_in_new_rounded, color: Colors.blue),
                          ),
                        ],
                      ),
                      initiallyExpanded: true,
                      title: Row(
                        children: [
                          Icon(Icons.business, color: Colors.black),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "${e.partyCode}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        ...e.CrmFollowRespList!.map(
                          (resp) {
                            return Align(
                              alignment: resp.type == "in" ? Alignment.centerLeft : Alignment.centerRight,
                              child: Container(
                                width: friendlyScreenWidth(context, constraints) * 0.85,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  nip: resp.type == "in" ? BubbleNip.leftTop : BubbleNip.rightTop,
                                  color: bubbleColor(resp),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${resp.resp}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${Myf.dateFormate(resp.time)}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          Text(
                                            'By: ${Myf.getUserNameString(resp.user.toString())}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Color bubbleColor(CrmFollowRespModel element) {
    switch (element.type) {
      case "in":
        return jsmColor;
      case "out":
        return Color.fromRGBO(225, 255, 199, 1.0);
      case "change":
        return Color.fromRGBO(225, 255, 199, 1.0);
      case "tktClose":
        return Color.fromRGBO(212, 234, 244, 1.0);
      case "followUpchange":
        return Color.fromRGBO(76, 174, 220, 1);
      default:
    }
    return Color.fromRGBO(225, 255, 199, 1.0);
  }
}
