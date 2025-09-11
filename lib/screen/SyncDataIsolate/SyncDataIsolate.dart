import 'dart:async';

import 'package:empire_ios/Models/LoginUserModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/SyncDataIsolate/cubit/SyncDataIsolateCubit.dart';
import 'package:empire_ios/screen/SyncDataIsolate/cubit/SyncDataIsolateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncDataIsolate extends StatefulWidget {
  dynamic UserObj;
  var boolShowDetails;
  SyncDataIsolate({Key? key, required this.UserObj, this.boolShowDetails}) : super(key: key);

  @override
  State<SyncDataIsolate> createState() => _SyncDataIsolateState();
}

class _SyncDataIsolateState extends State<SyncDataIsolate> {
  late SyncDataIsolateCubit cubit;
  final StreamController<double> progressbarDownload = StreamController<double>.broadcast();
  final StreamController<double> progressFileStatus = StreamController<double>.broadcast();

  int sr = 0;
  @override
  void initState() {
    loginUserModel = LoginUserModel.fromJson(widget.UserObj);
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<SyncDataIsolateCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.boolShowDetails != null && widget.boolShowDetails == true
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: jsmColor,
              actions: [
                IconButton(
                    onPressed: () => {
                          // cubit.download(),
                        },
                    icon: Icon(Icons.download))
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<SyncDataIsolateCubit, SyncDataIsolateState>(
                builder: (context, state) {
                  var progress = 1.0;
                  var savingProgress = 1.0;
                  var msg = "";
                  Map map = {};
                  List savedList = [];
                  var timeForUpdateInMili = "";
                  if (state is SyncDataIsolateStateDownloadProgressUpdate) {
                    progress = state.progress;
                    savingProgress = state.savingProgress / 100;
                    msg = state.msg;
                    map = state.map;
                    savedList = map["savedList"] ?? [];
                    timeForUpdateInMili = map["timeForUpdateInMili"] ?? "0";
                  }
                  sr = 0;
                  return Column(
                    children: [
                      ...progressBar(progress, savingProgress, msg),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: savedList.length,
                            itemBuilder: (context, index) {
                              int size = savedList[index]["size"];
                              bool save = savedList[index]["save"];
                              sr += 1;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text(" $sr:  ${savedList[index]["key"]}")),
                                  size > 0 ? Icon(Icons.done) : Icon(Icons.close, color: Colors.red),
                                ],
                              );
                            }),
                      ),
                      savingProgress == 1
                          ? Container(
                              color: jsmColor,
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Last sync Date "),
                                  Chip(label: Text("${Myf.datetimeFormateFromMilli(timeForUpdateInMili)}")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"))
                                ],
                              ),
                            )
                          : SizedBox.square(),
                      Divider()
                    ],
                  );
                },
              ),
            ),
          )
        : BlocBuilder<SyncDataIsolateCubit, SyncDataIsolateState>(
            builder: (context, state) {
              var progress = 1.0;
              var savingProgress = 1.0;
              var msg = "";
              Map map = {};
              List savedList = [];
              var timeForUpdateInMili = "";
              if (state is SyncDataIsolateStateDownloadProgressUpdate) {
                progress = state.progress;
                savingProgress = state.savingProgress / 100;
                msg = state.msg;
                map = state.map;
                savedList = map["savedList"] ?? [];
                timeForUpdateInMili = map["timeForUpdateInMili"] ?? "0";
              }
              sr = 0;
              return Column(
                children: [
                  ...progressBar(progress, savingProgress, msg),
                ],
              );
            },
          );
  }

  List progressBar(progress, savingProgress, msg) {
    return [
      LinearProgressIndicator(value: progress, color: jsmColor),
      SizedBox(height: 3),
      LinearProgressIndicator(
        value: savingProgress,
        color: jsmColor,
      ),
      Text("${msg}"),
    ];
  }
}
