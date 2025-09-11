import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/AgEmpOrderFormParty/cubit/AgEmpOrderFormPartyCubit.dart';
import 'package:empire_ios/screen/AgEmpOrderFormParty/cubit/AgEmpOrderFormPartyState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgEmpOrderFormParty extends StatefulWidget {
  var atype;
  String? AppBartitle = "";
  AgEmpOrderFormParty({Key? key, this.atype, this.AppBartitle = "Customer"}) : super(key: key);

  @override
  State<AgEmpOrderFormParty> createState() => _AgEmpOrderFormPartyState();
}

class _AgEmpOrderFormPartyState extends State<AgEmpOrderFormParty> {
  Widget widgetParty = SizedBox.shrink();

  bool _isSearching = false;

  var ctrlSearch = TextEditingController();

  late AgEmpOrderFormPartyCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cubit = BlocProvider.of<AgEmpOrderFormPartyCubit>(context);
    cubit.Atype = widget.atype;
    getData().then((value) {
      cubit.getData();
      ctrlSearch.addListener(() {
        if (ctrlSearch.text.isNotEmpty) {
          cubit.queryData(ctrlSearch.text.trim().toUpperCase());
        }
      });
    });
  }

  Future getData() async {
    // await SyncLocalFunction.onlyEMP_MSTFetch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: [
            _isSearching
                ? SizedBox.shrink()
                : Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          icon: Icon(Icons.search)),
                      // IconButton(
                      //     onPressed: () async {
                      //       var databaseId = Myf.databaseId(GLB_CURRENT_USER);
                      //       await hiveMainBox.put("${databaseId}EMP_MST", 0);
                      //       getData();
                      //     },
                      //     icon: Icon(Icons.sync)),
                    ],
                  )
          ],
        ),
        body: Center(
          child: Container(
            width: friendlyScreenWidth(context, constraints),
            child: Column(
              children: [
                BlocBuilder<AgEmpOrderFormPartyCubit, AgEmpOrderFormPartyCubitState>(
                  builder: (context, state) {
                    if (state is AgEmpOrderFormPartyCubitStateLoadPraty) {
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
    return Row(
      children: [
        Flexible(
          flex: 7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextField(
              controller: ctrlSearch,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search ...',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }
}
