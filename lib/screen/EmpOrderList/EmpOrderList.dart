import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormSettings/EmpOrderFormSettings.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListCubit.dart';
import 'package:empire_ios/screen/EmpOrderList/cubit/EmpOrderListState.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderList extends StatefulWidget {
  const EmpOrderList({Key? key}) : super(key: key);

  @override
  State<EmpOrderList> createState() => _EmpOrderListState();
}

class _EmpOrderListState extends State<EmpOrderList> {
  late EmpOrderListCubit cubit;

  var ctrlSearch = TextEditingController();

  var ctrlfromDate = TextEditingController();
  var ctrltoDate = TextEditingController();

  var reportView = "all";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderListCubit>(context);
    getData().then((value) {
      cubit.isDisposed = false;
      ctrlSearch.addListener(() {
        if (ctrlSearch.text.isNotEmpty) {
          loadWidgetTable(query: ctrlSearch.text.trim().toUpperCase());
        }
      });
    });
  }

  Future getData() async {
    await SyncLocalFunction.onlyOrderFetch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDisposed = true;
    cubit.EMP_ORDER_LIST.clear();
    cubit.filteredList.clear();
    cubit.rowtable.clear();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
        backgroundColor: jsmColor,
        title: Text("Empire Order List"),
        actions: [
          if (firebaseCurrntUserObj["is_dispatcher"] != true) ...[
            IconButton(
                tooltip: "All Export", onPressed: () => cubit.convertToCsv(exportType: cubit.statusFilter), icon: Icon(Icons.checklist_outlined)),
            TextButton(
              child: Text("Export", style: TextStyle(color: Colors.white)),
              onPressed: () => cubit.convertToCsv(exportType: "confirm"),
            ),
            IconButton(onPressed: () => Myf.Navi(context, EmpOrderFormSettings()), icon: Icon(Icons.settings))
          ],
          IconButton(
              onPressed: () async {
                var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);
                await hiveMainBox.put("${databaseId}EMP_ORDER", "0");
                syncEmpire_OrderSnapShot != null ? syncEmpire_OrderSnapShot.cancel() : null;
                syncEmpire_Order_DeleteSnapShot != null ? syncEmpire_Order_DeleteSnapShot.cancel() : null;
                syncEmpire_Order_ColorSnapShot != null ? syncEmpire_Order_ColorSnapShot.cancel() : null;
                await SyncLocalFunction.onlyOrderFetch();
              },
              icon: Icon(Icons.cloud_sync_rounded)),
          if (loginUserModel.loginUser!.toUpperCase().contains("ADMIN"))
            IconButton(
                onPressed: () {
                  Myf.Navi(context, EmpOrderFormSettings());
                },
                icon: Icon(Icons.settings))
        ],
      ),
      drawer: !kIsWeb ? drawerOrder() : null,
      body: Row(
        children: [
          // !kIsWeb ? SizedBox.shrink() : Flexible(flex: 1, child: drawerOrder()),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.circular(29.5)),
                          child: TextFormField(
                            onChanged: (value) => setState(() {}),
                            controller: ctrlSearch,
                            decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search", border: InputBorder.none),
                          ),
                        ),
                      ),
                      Flexible(flex: 1, child: IconButton(onPressed: () => SyncLocalFunction.onlyOrderFetch(), icon: Icon(Icons.refresh)))
                    ],
                  ),
                  ExpansionTile(
                    title: Row(
                      children: [
                        Text("Filter"),
                        if ("${loginUserModel.loginUser}".contains("ADMIN") || firebaseCurrntUserObj["EMPIRE_ORDER_ADMIN_ACCESS"] == true)
                          Icon(Icons.admin_panel_settings)
                      ],
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Status"),
                          DropdownButton<String>(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            icon: Icon(Icons.rate_review),
                            value: cubit.statusFilter,
                            onChanged: (newValue) {
                              setState(() {
                                cubit.statusFilter = newValue!;
                              });
                              loadWidgetTable();
                            },
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem<String>(
                                value: '',
                                child: Chip(label: Text('ALL')),
                              ),
                              DropdownMenuItem<String>(
                                value: 'confirm',
                                child: Chip(label: Text('confirm')),
                              ),
                              DropdownMenuItem<String>(
                                value: 'pending',
                                child: Chip(label: Text('pending')),
                              ),
                              DropdownMenuItem<String>(
                                value: 'rejected',
                                child: Chip(label: Text('rejected')),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: TextFormField(
                            controller: ctrlfromDate,
                            readOnly: true,
                            onTap: () async {
                              cubit.fromDate = await Myf.selectDate(context);
                              if (cubit.fromDate != null) {
                                ctrlfromDate.text = Myf.dateFormateInDDMMYYYY(cubit.fromDate.toString());
                                loadWidgetTable();
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.date_range),
                              labelText: 'From Date',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                              ),
                            ),
                          )),
                          Flexible(
                              child: TextFormField(
                            readOnly: true,
                            controller: ctrltoDate,
                            onTap: () async {
                              cubit.toDate = await Myf.selectDate(context);
                              if (cubit.toDate != null) {
                                ctrltoDate.text = Myf.dateFormateInDDMMYYYY(cubit.toDate.toString());
                                loadWidgetTable();
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.date_range),
                              labelText: 'To Date',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Set the color of the bottom border
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue), // Set the color of the bottom border when focused
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        BlocBuilder<EmpOrderListCubit, EmpOrderListState>(
                          builder: (context, state) {
                            if (state is EmpOrderListStateLoadOrder) {
                              Widget widget = state.widget;
                              return widget;
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer drawerOrder() {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Container(
          child: Image.asset("assets/img/1024.png"),
        )),
        ListTile(
            onTap: () {
              reportView = "all";
              loadWidgetTable();
            },
            title: Text("Sale Order List")),
        Divider(),
        Divider(),
      ],
    ));
  }

  loadWidgetTable({query}) {
    cubit.loadTable(rpView: reportView, query: query);
  }
}
