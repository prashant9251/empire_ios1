import 'dart:async';

import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/HasteModel.dart';
import 'package:empire_ios/Models/HideUnhideModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmAddFollowUp/CrmAddFollowUp.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingCubit.dart';
import 'package:empire_ios/screen/CRM/CrmOutstanding/cubit/CrmOutstandingState.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubitState.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/EmpOrderFormHaste.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/EmpOrderFormParty.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/ShowHideUnhideSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CrmOutstanding extends StatefulWidget {
  const CrmOutstanding({Key? key}) : super(key: key);
  @override
  State<CrmOutstanding> createState() => _CrmOutstandingState();
}

class _CrmOutstandingState extends State<CrmOutstanding> {
  late CrmOutstandingCubit cubit;

  // var ctrlExpansionTileFilter = ExpansionTileController();

  CompmstModel compmstModel = CompmstModel();
  Widget brokerListWidget = SizedBox.shrink();
  Widget brokerPartyListWidget = SizedBox.shrink();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<CrmOutstandingCubit>(context);
    cubit.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isdispose = true;
    cubit.FILTERED_OUTSTANDING = [];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return WillPopScope(
        onWillPop: () async {
          if (cubit.ctrlfromDate.text.isNotEmpty ||
              cubit.ctrltoDate.text.isNotEmpty ||
              cubit.ctrlBrokerName.text.isNotEmpty ||
              cubit.ctrlHaste.text.isNotEmpty ||
              cubit.ctrlSearch.text.isNotEmpty) {
            cubit.ctrlfromDate.clear();
            cubit.ctrltoDate.clear();
            cubit.ctrlHaste.clear();
            cubit.ctrlBrokerName.clear();
            cubit.ctrlSearch.clear();
            cubit.loadBrokerList();
            Myf.toast("Filter cleared", context: context);
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: jsmColor,
              title: Text("${cubit.followUpType.isEmpty ? "All Over Due" : cubit.followUpType}"),
              actions: [
                StreamBuilder(
                  stream: crmOustandingChangeStream.stream,
                  builder: (context, snapshot) {
                    var v = cubit.selectedForShareOutstanding.where((element) {
                      return element.isSelected == true;
                    });
                    return v.length > 0
                        ? Badge(
                            label: Text("${v.length}"),
                            child: IconButton(
                              onPressed: () async {
                                if (v.length == 0) {
                                  Myf.toast("Please select at least one record", context: context);
                                  return;
                                }
                                Myf.showBlurLoading(context);
                                CrmPdfOutstandingClass.createPdf(v.toList(), share: 'enotify', context: context, selectedCno: ctrlCNO.text);
                                Navigator.pop(context);
                                cubit.selectedForShareOutstanding = [];
                                cubit.boolselectAll = false;
                                cubit.selectablebrokerPartyList.map(
                                  (e) {
                                    e.isSelected = false;
                                  },
                                ).toList();
                                crmOustandingChangeStream.sink.add(true);
                              },
                              icon: Icon(Icons.share),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
                StreamBuilder<bool>(
                    stream: crmOustandingChangeStream.stream,
                    builder: (context, snapshot) {
                      return Checkbox(
                        value: cubit.boolselectAll,
                        onChanged: (value) {
                          cubit.boolselectAll = value ?? false;
                          cubit.selectAll();
                        },
                      );
                    }),
                ValueListenableBuilder(
                  valueListenable: cubit.ctrlBrokerName,
                  builder: (context, value, child) {
                    return cubit.ctrlBrokerName.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              if (cubit.FILTERED_OUTSTANDING.length > 0) {
                                Myf.Navi(
                                    context,
                                    CrmAddFollowUp(
                                        outstandingModel: cubit.FILTERED_OUTSTANDING.first, BROKER_FILTERED_OUTSTANDING: cubit.FILTERED_OUTSTANDING));
                              }
                            },
                            icon: Icon(Icons.add_alarm_rounded),
                          )
                        : SizedBox.shrink();
                  },
                ),
                IconButton(
                    onPressed: () {
                      Myf.Navi(context, Showhideunhidesettings(reportName: "CrmOutstandingReport"));
                    },
                    icon: Icon(Icons.settings))
              ],
            ),
            body: ScreenTypeLayout.builder(
              mobile: (BuildContext context) => Row(
                children: [
                  brokerBuilder(context, constraints),
                ],
              ),
              tablet: (BuildContext context) => Row(
                children: [
                  brokerBuilder(context, constraints),
                  brokerPartyBuilder(),
                ],
              ),
              desktop: (BuildContext context) => Row(
                children: [
                  brokerBuilder(context, constraints),
                  brokerPartyBuilder(),
                ],
              ),
              watch: (BuildContext context) => Container(color: Colors.purple),
            )),
      );
    });
  }

  Flexible brokerPartyReportBuilder(BuildContext context, BoxConstraints constraints) {
    return Flexible(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: friendlyScreenWidth(context, constraints),
              child: BlocBuilder<CrmOutstandingCubit, CrmOutstandingState>(
                builder: (context, state) {
                  if (state is CrmOutstandingStateLoadBrokerPartyOutstanding) {
                    return state.widget;
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Flexible brokerPartyBuilder() {
    return Flexible(
      flex: 3,
      child: BlocBuilder<CrmOutstandingCubit, CrmOutstandingState>(
        builder: (context, state) {
          if (state is CrmOutstandingStateLoadBrokerParty) {
            brokerPartyListWidget = state.widget;
            return brokerPartyListWidget;
          }
          return brokerPartyListWidget;
        },
      ),
    );
  }

  Flexible brokerBuilder(BuildContext context, BoxConstraints constraints) {
    return Flexible(
      flex: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Color.fromARGB(255, 225, 222, 222), borderRadius: BorderRadius.circular(29.5)),
            child: TextFormField(
              onChanged: (value) {
                cubit.loadBrokerList();
              },
              controller: cubit.ctrlSearch,
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: "Search",
                border: InputBorder.none,
                suffixIcon: IconButton(
                    onPressed: () {
                      cubit.ctrlSearch.clear();
                      cubit.loadBrokerList();
                    },
                    icon: Icon(Icons.clear)),
              ),
            ),
          ),
          filterTile(context),
          Expanded(
            child: Container(
              width: friendlyScreenWidth(context, constraints),
              child: BlocBuilder<CrmOutstandingCubit, CrmOutstandingState>(
                builder: (context, state) {
                  if (state is CrmOutstandingStateLoadWidget) {
                    brokerListWidget = state.widget;
                    return brokerListWidget;
                  }
                  return brokerListWidget;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget filterTile(BuildContext context) {
    return ListTile(
      // controller: ctrlExpansionTileFilter,
      onTap: () {
        showModalBottomSheet(
            scrollControlDisabledMaxHeightRatio: 0.8,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        backgroundColor: jsmColor,
                        title: Text("Filter"),
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      ...filters(context)
                    ],
                  ),
                ),
              );
            });
      },
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt),
          BlocBuilder<CrmOutstandingCubit, CrmOutstandingState>(
            builder: (context, state) {
              if (state is CrmOutstandingStateLoadLengthParty) {
                return Text(
                  "(${cubit.FILTERED_OUTSTANDING.length})",
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                );
              }
              return Text("(${cubit.FILTERED_OUTSTANDING.length})");
            },
          ),
        ],
      ),
      title: Text("Filter"),
    );
  }

  List<Widget> filters(BuildContext context) {
    final StreamController<bool> changeStream = StreamController<bool>.broadcast();

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: StreamBuilder(
                stream: changeStream.stream,
                builder: (context, asyncSnapshot) {
                  return CheckboxListTile(
                      value: cubit.boolOverDueByMasteDays,
                      onChanged: (value) {
                        cubit.filterDays = 0;
                        cubit.boolOverDueByMasteDays = !cubit.boolOverDueByMasteDays;
                        cubit.loadBrokerList();
                        changeStream.sink.add(true);
                      },
                      title: Text("Over Due By Master Days"));
                }),
          ),
          Flexible(
              child: StreamBuilder(
                  stream: changeStream.stream,
                  builder: (context, asyncSnapshot) {
                    return GestureDetector(
                        onTap: () async {
                          var d = await CrmOutstandingStateSelectDays.selectDays(context);
                          if (d == null) return;
                          cubit.filterDays = d;
                          cubit.boolOverDueByMasteDays = false;
                          cubit.loadBrokerList();
                          changeStream.sink.add(true);
                        },
                        child: Chip(label: Text("Days Filter: ${cubit.filterDays}")));
                  })),
        ],
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
            var model = null;
            model = await EmpOrderFormCubitStateSelectCompany(context).selectCompany();
            if (model is CompmstModel) {
              compmstModel = model;
              if (compmstModel.fIRM == null) return;
              cubit.ctrlFirmName.text = compmstModel.fIRM!;
              ctrlCNO.text = compmstModel.cNO!;
              prefs!.setString("S_FIRM${cubit.databasId}", cubit.ctrlFirmName.text);
              prefs!.setString("S_CNO${cubit.databasId}", compmstModel.cNO!);
            }
          },
          controller: cubit.ctrlFirmName,
          readOnly: true,
          decoration: InputDecoration(label: Text("Company"), hintText: "Company", prefixIcon: Icon(Icons.book)),
        ),
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
          decoration: InputDecoration(
            label: Text("Broker Name"),
            hintText: "Broker Name",
            prefixIcon: Icon(Icons.support_agent),
            suffix: IconButton(
                onPressed: () {
                  cubit.ctrlBrokerName.clear();
                  cubit.loadBrokerList();
                },
                icon: Icon(Icons.clear)),
          ),
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
          decoration: InputDecoration(
            label: Text("Haste Name"),
            hintText: "Haste Name",
            prefixIcon: Icon(Icons.handshake),
            suffix: IconButton(
                onPressed: () {
                  cubit.ctrlBrokerName.clear();
                  cubit.loadBrokerList();
                },
                icon: Icon(Icons.clear)),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => jsmColor)),
              onPressed: () {
                // ctrlExpansionTileFilter.collapse();
                cubit.loadBrokerList();
                Navigator.pop(context);
              },
              icon: Icon(Icons.filter_alt, color: Colors.white),
              label: Text("Apply", style: TextStyle(color: Colors.white))),
          ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => jsmColor)),
              onPressed: () {
                cubit.ctrlBrokerName.clear();
                cubit.ctrlHaste.clear();
                cubit.ctrlfromDate.clear();
                cubit.ctrltoDate.clear();
                ctrlCNO.clear();
                cubit.ctrlFirmName.clear();
                // ctrlExpansionTileFilter.collapse();
                compmstModel.cNO = "";
                prefs!.setString("S_FIRM${cubit.databasId}", cubit.ctrlFirmName.text);
                prefs!.setString("S_CNO${cubit.databasId}", compmstModel.cNO!);
                cubit.loadBrokerList();
                Navigator.pop(context);
              },
              icon: Icon(Icons.clear, color: Colors.white),
              label: Text("Clear", style: TextStyle(color: Colors.white))),
        ],
      )
    ];
  }
}
