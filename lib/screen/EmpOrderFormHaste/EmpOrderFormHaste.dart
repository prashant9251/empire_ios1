import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormHaste/cubit/EmpOrderFormHasteCubitState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderFormHaste extends StatefulWidget {
  var filterParty;

  EmpOrderFormHaste({Key? key, required this.filterParty}) : super(key: key);

  @override
  State<EmpOrderFormHaste> createState() => _EmpOrderFormHasteState();
}

class _EmpOrderFormHasteState extends State<EmpOrderFormHaste> {
  late EmpOrderFormHasteCubit cubit;
  Widget _widget = SizedBox.shrink();

  var ctrlSearch = TextEditingController();
  bool _isSearching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderFormHasteCubit>(context);
    cubit.filterParty = widget.filterParty ?? "";
    cubit.getData();
    ctrlSearch.addListener(() {
      if (ctrlSearch.text.isNotEmpty) {
        cubit.queryData(ctrlSearch.text.trim().toUpperCase());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: [
          _isSearching
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  icon: Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<EmpOrderFormHasteCubit, EmpOrderFormHasteCubitState>(
            builder: (context, state) {
              if (state is EmpOrderFormHasteCubitStateLoadHate) {
                _widget = state.widget;
              }
              return _widget;
            },
          )
        ],
      ),
    );
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

  _buildTitle(BuildContext context) {
    return Text('Select Haste');
  }
}
