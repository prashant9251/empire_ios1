import 'dart:convert';

import 'package:empire_ios/DesktopVersion/OfficeDeshboard/OfficeDeshboard.dart';
import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/assetsUpdate/addNewAssetsUpdate.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/broadCast/broadCast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../screen/EMPIRE/Tradinghome.dart';

class DesktopHome extends StatefulWidget {
  var UserObj;

  DesktopHome({Key? key, required this.UserObj}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  @override
  void initState() {
    super.initState();

    GLB_CURRENT_USER = widget.UserObj;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Home"),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(Icons.notifications)),
          InDev(
              inDevUser: widget.UserObj["login_user"],
              widget: IconButton(onPressed: () => Myf.Navi(context, AddNewAssetsUpdate(UserObj: widget.UserObj)), icon: Icon(Icons.upload_file))),
          InDev(
              inDevUser: widget.UserObj["login_user"],
              widget: IconButton(onPressed: () => Myf.Navi(context, BroadCast(UserObj: widget.UserObj)), icon: Icon(Icons.broadcast_on_home))),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Welcome to Unique Dashboard",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Center(
            child: Wrap(
              spacing: 30,
              children: [
                // InkWell(
                //   onTap: () => Myf.Navi(context, BlocProvider(create: (context) => EmpOrderListCubit(context), child: EmpOrderList())),
                //   child: Container(
                //     height: 160,
                //     width: 160,
                //     decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.new_label,
                //           size: 80,
                //           color: jsmColor,
                //         ),
                //         Text("Order")
                //       ],
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    assethtmlSubFolder = "uniquesoftwares";
                    Myf.Navi(context, Trading_Home(CURRENT_USER: [widget.UserObj]));
                    //  Myf.Navi(
                    // context,
                    // DeskTopWeb(
                    //     url:
                    //         "${urldata().salesItemWiseReportUrl}?ntab=NTAB&FIX_FIRM=&MCNO=1&http=https://&ServerLocation=uniqsoftwares.com&privateNetworkIp=&login_user=ADMIN%40AASHA%20SILK%20MILLS%2058385&ID=979&LINE1=TKQ1.221220.001&AppLocalStorage=1&IosPlateForm=false&databaseId=NTgzODU=2324&CLDB=NTgzODU=&CLNT=58385&DatabaseSource=NTgzODU=2324&Currentyear=2324&Curentyearforlocalstorage=2324&MTYPE=S1&LFolder=TRADING&pdfBillType=1&&&localTimeInMili=1690654753593&FILE_NAME=CURRENT_YEAR&ACTYPE=TRADING&line_code=&SHOPNAME=AASHA SILK MILLS&upi="));
                  },
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.new_label,
                          size: 80,
                          color: jsmColor,
                        ),
                        Text("DESKTOP VERSION(BETA)")
                      ],
                    ),
                  ),
                ),
                int.parse("${widget.UserObj["uniqOfficeUserAccess"]}") == 0
                    ? SizedBox.shrink()
                    : InkWell(
                        onTap: () => Myf.Navi(context, OfficeDeshBoard(UserObj: widget.UserObj)),
                        child: Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.rectangle_3_offgrid_fill,
                                size: 80,
                                color: jsmColor,
                              ),
                              Text("OFFICE")
                            ],
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  void getData() async {
    var st = prefs!.getString("GLB_CURRENT_USER");
    Map<String, dynamic> GLB_CURRENT_USER = jsonDecode(st ?? "{}");
    loginUserModel = LoginUserModel.fromJson(GLB_CURRENT_USER);
    var databaseId = Myf.databaseId(widget.UserObj);
    mainHiveStreamBox = await Hive.openBox("${databaseId}mainHiveStreamBox");
    // await SyncLocalFunction.startSync(context);
    // SyncLocalFunction.startSync(context);
  }
}
