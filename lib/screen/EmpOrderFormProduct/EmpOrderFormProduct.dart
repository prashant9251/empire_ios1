import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormProduct/cubit/EmpOrderFormProductCubitState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpOrderFormProduct extends StatefulWidget {
  List<QualModel> productList;
  EmpOrderFormProduct({Key? key, required this.productList}) : super(key: key);

  @override
  State<EmpOrderFormProduct> createState() => _EmpOrderFormProductState();
}

class _EmpOrderFormProductState extends State<EmpOrderFormProduct> {
  Widget gridView = SizedBox.shrink();
  var _isSearching = false;

  var ctrlSearch = TextEditingController();
  late EmpOrderFormProductCubit cubit;

  Widget selectedProductWidget = SizedBox.shrink();
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<EmpOrderFormProductCubit>(context);
    cubit.showinListView = prefs!.getBool("showInListViewInOrderProduct") ?? false;
    cubit.getData(widget.productList);
    ctrlSearch.addListener(() {
      if (ctrlSearch.text.isNotEmpty) {
        cubit.queryData(ctrlSearch.text.trim().toUpperCase(), ctrlSearch: ctrlSearch);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.isDispose = true;
    try {
      cubit.galleryBox.close();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: jsmColor,
          title: _buildTitle(context),
          actions: [
            if (cubit.showinListView)
              IconButton(
                icon: Icon(Icons.grid_view),
                onPressed: () {
                  setState(() {
                    cubit.showinListView = false;
                    prefs!.setBool("showInListViewInOrderProduct", cubit.showinListView);
                    cubit.queryData(ctrlSearch.text.trim().toUpperCase(), ctrlSearch: ctrlSearch);
                  });
                },
              )
            else
              IconButton(
                icon: Icon(Icons.view_list),
                onPressed: () {
                  setState(() {
                    cubit.showinListView = true;
                    prefs!.setBool("showInListViewInOrderProduct", cubit.showinListView);
                    cubit.queryData(ctrlSearch.text.trim().toUpperCase(), ctrlSearch: ctrlSearch);
                  });
                },
              )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchField(),
              BlocBuilder<EmpOrderFormProductCubit, EmpOrderFormProductCubitState>(
                builder: (context, state) {
                  if (state is EmpOrderFormProductCubitStateLoadSelected) {
                    selectedProductWidget = state.widget;
                  }
                  return selectedProductWidget;
                },
              ),
              Expanded(
                child: BlocBuilder<EmpOrderFormProductCubit, EmpOrderFormProductCubitState>(
                  builder: (context, state) {
                    if (state is EmpOrderFormProductCubitStateLoadProduct) {
                      gridView = state.widget;
                    }
                    return gridView;
                  },
                ),
              ),
              if (cubit.returnVal == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: jsmColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: jsmColor.withOpacity(0.4),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                      icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
                      onPressed: () => cubit.done(),
                      label: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 3)
            ],
          ),
        ));
  }

  _buildTitle(BuildContext context) {
    return Row(
      children: [
        // IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios)),
        Text('Product '),
      ],
    );
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
