import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/instruction/InstructionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SftNotificationMsg extends StatefulWidget {
  SftNotificationMsg({Key? key, required userObj}) : super(key: key);

  @override
  State<SftNotificationMsg> createState() => _SftNotificationMsgState();
}

class _SftNotificationMsgState extends State<SftNotificationMsg> {
  var loading = true;
  var srIndex = 0;
  late LazyBox broadCastBoxuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox.shrink()
        : StreamBuilder<QuerySnapshot>(
            stream: fireBCollection
                .collection("softwares")
                .doc("$firebaseSoftwaresName")
                .collection("broadcast")
                .where("cTime", isGreaterThanOrEqualTo: loginUserModel.activetiondate)
                .snapshots(),
            builder: (context, snapshot) {
              var snp = snapshot.data != null ? snapshot.data!.docs : [];
              if (snp.length > 0) {
                srIndex = 0;
                return Container(
                  width: screenWidthMobile,
                  child: Column(
                    children: [
                      ...snp.map((e) {
                        srIndex++;
                        final color = srIndex % 2 == 0 ? Colors.yellow : Colors.amber;
                        dynamic d = e.data();
                        InstructionModel instructionModel = InstructionModel.fromJson(Myf.convertMapKeysToString(d));
                        return ValueListenableBuilder(
                          valueListenable: broadCastBoxuser.listenable(),
                          builder: (context, value, child) {
                            return FutureBuilder(
                              future: broadCastBoxuser.get(instructionModel.id),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return msg(instructionModel, color);
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            });
  }

  GestureDetector msg(InstructionModel instructionModel, MaterialColor color) {
    return GestureDetector(
      onTap: () {
        fireBCollection
            .collection("softwares")
            .doc("$firebaseSoftwaresName")
            .collection("broadcastViewBy")
            .doc("viewByUser")
            .collection(loginUserModel.loginUser.toString())
            .doc(instructionModel.id)
            .set({"bId": instructionModel.id, "view": true}).then((value) {
          broadCastBoxuser.put(instructionModel.id, true);
          // setState(() {});
        });
      },
      child: Container(
        height: 20,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidthMobile * .8,
              margin: EdgeInsets.only(left: 5),
              child: Text("${instructionModel.title}"),
            ),
            Icon(Icons.open_in_new),
          ],
        ),
      ),
    );
  }

  void getData() async {
    broadCastBoxuser = await SyncLocalFunction.openLazyBoxCheck("broadCastBoxuser");
    setState(() {
      loading = false;
    });
  }
}
