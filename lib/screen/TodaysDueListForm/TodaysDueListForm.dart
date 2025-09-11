import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubitState.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/EmpOrderFormParty.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueList.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueListCubit.dart';
import 'package:empire_ios/screen/adminPanel/userPermissionOptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:group_radio_button/group_radio_button.dart';

class TodaysDueListForm extends StatefulWidget {
  const TodaysDueListForm({Key? key}) : super(key: key);

  @override
  State<TodaysDueListForm> createState() => _TodaysDueListFormState();
}

class _TodaysDueListFormState extends State<TodaysDueListForm> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrlcRD.text = Myf.getValFromSavedPref(GLB_CURRENT_USER, "outstandingDhara");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: const Text("Today's Due List"),
      ),
      body: Center(
        child: Container(
          width: widthResponsive(context),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RadioListTile<String>(
                        value: "all",
                        groupValue: shoOnlyTodayDue ? "today" : "all",
                        onChanged: (value) {
                          setState(() {
                            shoOnlyTodayDue = value == "today";
                          });
                        },
                        title: Text("Show All Dues"),
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        value: "today",
                        groupValue: shoOnlyTodayDue ? "today" : "all",
                        onChanged: (value) {
                          setState(() {
                            GFToast.showToast("Please enter dhara if not mentioned in your  Master", context,
                                toastPosition: GFToastPosition.BOTTOM,
                                backgroundColor: Colors.blue,
                                trailing: Icon(Icons.info_outline, color: Colors.white));
                            shoOnlyTodayDue = value == "today";
                          });
                        },
                        title: Text("This Week Due"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: ctrlcRD,
                          decoration: InputDecoration(
                            labelText: "Dhara",
                            prefixIcon: Icon(FontAwesomeIcons.calendarDay),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            Myf.saveValToSavedPref(GLB_CURRENT_USER, "outstandingDhara", value);
                            if (value.isEmpty) {
                              Myf.saveValToSavedPref(GLB_CURRENT_USER, "outstandingDhara", "");
                              ctrlToDate.text = "";
                              return;
                            }
                            var days = int.tryParse(value) ?? 0;
                            var now = DateTime.now();
                            var newDate = now.subtract(Duration(days: days));
                            ctrlToDate.text = Myf.dateFormateYYYYMMDD(newDate.toString());
                          },
                        ),
                      ),
                    ),
                    Flexible(
                        child: GFCheckboxListTile(
                            value: initialExpand,
                            onChanged: (value) {
                              setState(() {
                                initialExpand = value;
                              });
                            },
                            titleText: "Initial Expand ",
                            padding: const EdgeInsets.all(0.0),
                            position: GFPosition.end,
                            type: GFCheckboxType.square))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ctrlCompanyName,
                    readOnly: true,
                    onTap: () async {
                      var v = await EmpOrderFormCubitStateSelectCompany(context).selectCompany();
                      if (v != null && v is CompmstModel) {
                        ctrlCompanyName.text = v.fIRM ?? "";
                        ctrlCopanyCno.text = v.cNO ?? "";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Company Name",
                      prefixIcon: Icon(Icons.house),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          ctrlCompanyName.text = "";
                          ctrlCopanyCno.text = "";
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ctrlPartyname,
                    onTap: () async {
                      var v = await Myf.Navi(
                          context, BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "1")));
                      if (v is MasterModel) {
                        ctrlPartyname.text = v.partyname ?? "";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          ctrlPartyname.text = "";
                        },
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: ctrlBrokerName,
                    onTap: () async {
                      var v = await Myf.Navi(
                          context, BlocProvider(create: (context) => EmpOrderFormPartyCubit(context), child: EmpOrderFormParty(atype: "12")));
                      if (v is MasterModel) {
                        ctrlBrokerName.text = v.partyname ?? "";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Broker Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          ctrlBrokerName.text = "";
                        },
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          readOnly: true,
                          controller: ctrlFromDate,
                          onTap: () async {
                            var d = await Myf.selectDate(context);
                            if (d == null) {
                              ctrlFromDate.text = "";
                            }
                            ctrlFromDate.text = Myf.dateFormateYYYYMMDD(d.toString());
                          },
                          decoration: InputDecoration(
                            labelText: "From Date",
                            prefixIcon: Icon(Icons.date_range),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          readOnly: true,
                          controller: ctrlToDate,
                          onTap: () async {
                            var d = await Myf.selectDate(context);
                            if (d == null) {
                              ctrlToDate.text = "";
                            }
                            ctrlToDate.text = Myf.dateFormateYYYYMMDD(d.toString());
                          },
                          decoration: InputDecoration(
                            labelText: "To Date",
                            prefixIcon: Icon(Icons.date_range),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GFButton(
                    fullWidthButton: true,
                    onPressed: () {
                      Myf.Navi(context, BlocProvider(create: (context) => TodaysDueListCubit(context), child: TodaysDueList()));
                    },
                    text: "Generate Report",
                    color: jsmColor,
                    shape: GFButtonShape.standard,
                    icon: Icon(FontAwesomeIcons.rightToBracket, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// BlocProvider(create: (context) => TodaysDueListCubit(context), child: TodaysDueList())