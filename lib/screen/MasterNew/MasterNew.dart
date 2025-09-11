import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/MasterNew/MasterNewCubit.dart';
import 'package:empire_ios/screen/MasterNewFilter/MasterNewFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

dynamic MasterFilter = {
  "ATYPE": "",
  "filtered_apply": false,
};

class MasterNew extends StatefulWidget {
  const MasterNew({Key? key}) : super(key: key);

  @override
  State<MasterNew> createState() => _MasterNewState();
}

class _MasterNewState extends State<MasterNew> {
  late MasterNewCubit cubit;
  initState() {
    super.initState();
    cubit = BlocProvider.of<MasterNewCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADDRESS BOOK", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: jsmColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: cubit.ctrlSearch,
                    decoration: InputDecoration(
                      // labelText: 'Search',
                      hintText: 'Type to search...',
                      prefixIcon: Icon(Icons.search, color: jsmColor),
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    ),
                    style: TextStyle(fontSize: 16.0),
                    onChanged: (value) {
                      cubit.loadData();
                    },
                  ),
                ),
                Badge(
                  label: MasterFilter["filtered_apply"] == true ? Text("") : null,
                  child: IconButton(
                      onPressed: () async {
                        showModalBottomSheet(
                            scrollControlDisabledMaxHeightRatio: .9,
                            context: context,
                            builder: (context) => MasterNewFilter(masterList: cubit.masterList, cityList: cubit.cityList)).then(
                          (value) {
                            if (value == true) {
                              MasterFilter["filtered_apply"] = true;
                              cubit.loadData();
                              setState(() {});
                            }
                          },
                        );
                      },
                      icon: Icon(Icons.filter_list, color: jsmColor)),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MasterNewCubit, MasterNewState>(builder: (context, state) {
              if (state is MasterNewLoadData) {
                return state.widget;
              }
              return Container();
            }),
          ),
        ],
      ),
    );
  }
}
