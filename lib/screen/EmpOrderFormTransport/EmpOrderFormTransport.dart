import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/cubit/EmpOrderFormTransportCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormTransport/cubit/EmpOrderFormTransportState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderFormTransport extends StatefulWidget {
  EmpOrderFormTransport({Key? key}) : super(key: key);

  @override
  State<EmpOrderFormTransport> createState() => _EmpOrderFormTransportState();
}

class _EmpOrderFormTransportState extends State<EmpOrderFormTransport> {
  Widget widgetTransport = SizedBox.shrink();

  bool _isSearching = false;

  var ctrlSearch = TextEditingController();

  late EmpOrderFormTransportCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<EmpOrderFormTransportCubit>(context);
    ctrlSearch.addListener(() {
      cubit.queryData(ctrlSearch.text.trim().toUpperCase());
    });
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
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    icon: Icon(Icons.search))
          ],
        ),
        body: Center(
          child: Container(
            width: friendlyScreenWidth(context, constraints),
            child: Column(
              children: [
                BlocBuilder<EmpOrderFormTransportCubit, EmpOrderFormTransportState>(
                  builder: (context, state) {
                    if (state is EmpOrderFormTransportStateLoadTransport) {
                      widgetTransport = state.widget;
                    }
                    return widgetTransport;
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
    return Text('Select Transport');
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
