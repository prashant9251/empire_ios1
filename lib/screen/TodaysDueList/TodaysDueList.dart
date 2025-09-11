import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/CRM/CrmPdfOutstandingClass.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/TodaysDueList/TodaysDueListCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:ndialog/ndialog.dart';

class TodaysDueList extends StatefulWidget {
  const TodaysDueList({Key? key}) : super(key: key);

  @override
  State<TodaysDueList> createState() => _TodaysDueListState();
}

class _TodaysDueListState extends State<TodaysDueList> {
  late TodaysDueListCubit cubit;
  initState() {
    super.initState();
    cubit = BlocProvider.of<TodaysDueListCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Today's Due List"),
        actions: [],
      ),
      body: Center(
        child: Container(
          width: widthResponsive(context),
          alignment: Alignment.topCenter,
          child: Form(
            key: cubit.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          cubit.loadData();
                        },
                        title: Text("Show All Over Dues"),
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
                          cubit.loadData();
                        },
                        title: Text("This Week Due"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: ctrlcRD,
                          decoration: InputDecoration(
                            labelText: "Dhara",
                            prefixIcon: Icon(Icons.data_array_sharp),
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
                            cubit.loadData();
                          },
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: StreamBuilder<bool>(
                            stream: cubit.changeStream.stream,
                            builder: (context, snapshot) {
                              return Row(
                                children: [
                                  Flexible(
                                    child: GFCheckbox(
                                      value: cubit.selectedOutstanding.length == cubit.FILTERED_OUTSTANDING.length,
                                      onChanged: (value) {
                                        cubit.selectAll(value);
                                        cubit.changeStream.add(value);
                                      },
                                      type: GFCheckboxType.square,
                                      inactiveIcon: null,
                                      activeBgColor: Colors.blue,
                                    ),
                                  ),
                                  Flexible(
                                    child: cubit.selectedOutstanding.length > 0
                                        ? CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                              icon: Icon(Icons.send),
                                              onPressed: () {
                                                if (cubit.selectedOutstanding.length > 0) {
                                                  CrmPdfOutstandingClass.createPdf(cubit.selectedOutstanding,
                                                      share: "enotify", context: context, selectedCno: ctrlCopanyCno.text);
                                                }
                                              },
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                  Flexible(
                                    child: cubit.selectedOutstanding.length > 0
                                        ? Badge(
                                            label: Text("${cubit.selectedOutstanding.length}"),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              child: IconButton(
                                                icon: Icon(Icons.share),
                                                onPressed: () {
                                                  if (cubit.selectedOutstanding.length > 0) {
                                                    CrmPdfOutstandingClass.createPdf(cubit.selectedOutstanding,
                                                        share: true, context: context, selectedCno: ctrlCopanyCno.text);
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                ],
                              );
                            })),
                  ],
                ),
                BlocBuilder<TodaysDueListCubit, TodaysDueListState>(
                  builder: (context, state) {
                    if (state is TodaysDueListLoadWidget) {
                      return state.widget;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
