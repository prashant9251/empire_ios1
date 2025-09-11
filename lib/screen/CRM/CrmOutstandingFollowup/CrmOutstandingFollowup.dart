import 'package:empire_ios/Models/HasteModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingState.dart';
import 'package:empire_ios/screen/CRM/CrmOutstandingFollowup/cubit/CrmOutstandingFollowupCubit.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/EmpOrderFormHaste.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/EmpOrderFormParty.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrmOutstandingFollowup extends StatefulWidget {
  String followUpType;
  CrmOutstandingFollowup({Key? key, required this.followUpType}) : super(key: key);
  @override
  State<CrmOutstandingFollowup> createState() => _CrmOutstandingFollowupState();
}

class _CrmOutstandingFollowupState extends State<CrmOutstandingFollowup> {
  late CrmOutstandingFollowupCubit cubit;

  var ctrlExpansionTileFilter = ExpansionTileController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<CrmOutstandingFollowupCubit>(context);
    cubit.followUpType = widget.followUpType;
    cubit.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.OUTSTANDING = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("${widget.followUpType}"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Color.fromARGB(255, 225, 222, 222), borderRadius: BorderRadius.circular(29.5)),
            child: TextFormField(
              onChanged: (value) {
                cubit.loadPartys();
              },
              controller: cubit.ctrlSearch,
              decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
            ),
          ),
          ExpansionTile(
            controller: ctrlExpansionTileFilter,
            trailing: Icon(Icons.filter_alt),
            title: Text("Filter"),
            children: [
              GestureDetector(
                onTap: () async {
                  var d = await CrmOutstandingStateSelectDays.selectDays(context);
                  if (d == null) return;
                  setState(() {
                    cubit.filterDays = d;
                  });
                  cubit.loadPartys();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Chip(label: Text("Days Filter: ${cubit.filterDays}")),
                    // BlocBuilder<CrmOutstandingFollowupCubit, CrmOutstandingState>(
                    //   builder: (context, state) {
                    //     if (state is CrmOutstandingStateLoadLengthParty) {
                    //       return Text(
                    //         "(${cubit.FILTERED_OUTSTANDING.length})",
                    //         style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                    //       );
                    //     }
                    //     return Text("(${cubit.FILTERED_OUTSTANDING.length})");
                    //   },
                    // )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onTap: () async {
                          cubit.fromDate = await Myf.selectDate(context);
                          if (cubit.fromDate != null) {
                            cubit.ctrlfromDate.text = Myf.dateFormateInDDMMYYYY(cubit.fromDate.toString());
                          }
                        },
                        controller: cubit.ctrlfromDate,
                        readOnly: true,
                        decoration: InputDecoration(label: Text("From Date"), hintText: "From Date", prefixIcon: Icon(Icons.date_range)),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onTap: () async {
                          cubit.toDate = await Myf.selectDate(context);
                          if (cubit.toDate != null) {
                            cubit.ctrltoDate.text = Myf.dateFormateInDDMMYYYY(cubit.toDate.toString());
                          }
                        },
                        controller: cubit.ctrltoDate,
                        readOnly: true,
                        decoration: InputDecoration(label: Text("To Date"), hintText: "To Date", prefixIcon: Icon(Icons.date_range)),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  onTap: () async {
                    var pushScreen = BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "12"));
                    var model = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return pushScreen;
                      },
                    ));
                    if (model == null) return;
                    if (model is MasterModel) {
                      var brokerModel = model;
                      cubit.ctrlBrokerName.text = brokerModel.partyname!;
                    }
                  },
                  controller: cubit.ctrlBrokerName,
                  readOnly: true,
                  decoration: InputDecoration(label: Text("Broker Name"), hintText: "Broker Name", prefixIcon: Icon(Icons.support_agent)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  onTap: () async {
                    var model = await Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(create: (context) => EmpOrderFormHasteCubit(context), child: EmpOrderFormHaste(filterParty: ""));
                      },
                    ));
                    if (model is HasteModel) {
                      var hasteModel = model;
                      cubit.ctrlHaste.text = hasteModel.hS!;
                    }
                  },
                  controller: cubit.ctrlHaste,
                  readOnly: true,
                  decoration: InputDecoration(label: Text("Haste Name"), hintText: "Haste Name", prefixIcon: Icon(Icons.handshake)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => jsmColor)),
                      onPressed: () {
                        ctrlExpansionTileFilter.collapse();
                        cubit.loadPartys();
                      },
                      icon: Icon(Icons.filter_alt, color: Colors.white),
                      label: Text("Apply", style: TextStyle(color: Colors.white))),
                  ElevatedButton.icon(
                      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => jsmColor)),
                      onPressed: () {
                        cubit.ctrlBrokerName.clear();
                        cubit.ctrlHaste.clear();
                        cubit.ctrlfromDate.clear();
                        cubit.ctrltoDate.clear();
                        ctrlExpansionTileFilter.collapse();
                        cubit.loadPartys();
                      },
                      icon: Icon(Icons.clear, color: Colors.white),
                      label: Text("Clear", style: TextStyle(color: Colors.white))),
                ],
              )
            ],
          ),
          Expanded(
            child: BlocBuilder<CrmOutstandingFollowupCubit, CrmOutstandingState>(
              builder: (context, state) {
                if (state is CrmOutstandingStateLoadWidget) {
                  return state.widget;
                }
                return SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
