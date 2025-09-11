import 'package:empire_ios/InDev.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderAddMaster/EmpOrderAddMaster.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormParty/cubit/EmpOrderFormPartyCubitState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmpOrderFormParty extends StatefulWidget {
  var atype;
  String? AppBartitle = "";
  EmpOrderFormParty({Key? key, this.atype, this.AppBartitle = "Customer"}) : super(key: key);

  @override
  State<EmpOrderFormParty> createState() => _EmpOrderFormPartyState();
}

class _EmpOrderFormPartyState extends State<EmpOrderFormParty> {
  Widget widgetParty = SizedBox.shrink();

  bool _isSearching = false;

  var ctrlSearch = TextEditingController();

  late EmpOrderFormPartyCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cubit = BlocProvider.of<EmpOrderFormPartyCubit>(context);
    cubit.Atype = widget.atype;
    getData().then((value) {
      cubit.getData();
    });
  }

  Future getData() async {
    // await SyncLocalFunction.onlyEMP_MSTFetch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: _buildTitle(context),
          actions: [
            InDev(
              inDevUser: loginUserModel.loginUser,
              widget: IconButton(
                icon: Icon(Icons.person_add),
                tooltip: 'Add New Account',
                onPressed: () async {
                  var v = await showModalBottomSheet(
                    scrollControlDisabledMaxHeightRatio: .9,
                    context: context,
                    builder: (context) {
                      MasterModel masterModel = MasterModel(aTYPE: cubit.Atype);
                      return EmpOrderAddMaster(masterModel: masterModel);
                    },
                  );
                  if (v is MasterModel) {
                    masterList.add(v);
                    ctrlSearch.text = v.partyname ?? "";
                    cubit.queryData(ctrlSearch.text.trim().toUpperCase());
                  }
                },
              ),
            )
          ],
        ),
        body: Center(
          child: Container(
            width: friendlyScreenWidth(context, constraints),
            child: Column(
              children: [
                _buildSearchField(),
                BlocBuilder<EmpOrderFormPartyCubit, EmpOrderFormPartyCubitState>(
                  builder: (context, state) {
                    if (state is EmpOrderFormPartyCubitStateLoadPraty) {
                      widgetParty = state.widget;
                    }
                    return widgetParty;
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildTitle(BuildContext context) {
    return Text('Select ${widget.AppBartitle}');
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Flexible(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: ctrlSearch,
                autofocus: true,
                onChanged: (value) {
                  cubit.queryData(value.trim().toUpperCase());
                },
                decoration: const InputDecoration(
                  hintText: 'Search ...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
