import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/QualityNew/QualNewFilter.dart';
import 'package:empire_ios/screen/QualityNew/cubit/QualityNewCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

dynamic QualFilterData = {
  "filtered_apply": false,
  "base_quality": "",
  "qualOrderBy": "",
  "qualOrderByOption": "ASC",
  "qualPACK": "",
};

class QualityNew extends StatefulWidget {
  const QualityNew({Key? key}) : super(key: key);

  @override
  State<QualityNew> createState() => _QualityNewState();
}

class _QualityNewState extends State<QualityNew> {
  late QualityNewCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<QualityNewCubit>(context);
    cubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        // iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Quality List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              var shareList = cubit.filteredQualityList.where((element) => element.selected == true).toList();
              if (shareList.isEmpty) {
                GFToast.showToast(
                  "Please select at least one quality to delete",
                  context,
                  toastPosition: GFToastPosition.BOTTOM,
                );
                return;
              }
              List<XFile> shareFiles = [];
              var shareText = "";
              await Future.wait(
                shareList.map((element) async {
                  shareText += "${element.label}\nRate: ₹${element.s1}\nCategory: ${element.category}\nMain screen: ${element.mainScreen}\n\n\n";
                  if (element.imageUrl.toString().contains("upload.wikimedia.org")) {
                    return;
                  }
                  var f = await baseCacheManager.getSingleFile(element.imageUrl!);
                  if (f != null) {
                    shareFiles.add(XFile(f.path));
                  }
                }),
              );
              if (shareFiles.isNotEmpty) {
                SharePlus.instance.share(ShareParams(
                  text: "Sharing Quality: ${shareList.map((e) => e.label).join(", ")}",
                  files: shareFiles,
                ));
              } else {
                Myf.shareText([shareText]); //------share text
              }
            },
          )
        ],
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
                  label: QualFilterData["filtered_apply"] == true ? Text("") : null,
                  child: IconButton(
                      onPressed: () async {
                        showModalBottomSheet(
                            scrollControlDisabledMaxHeightRatio: .9,
                            context: context,
                            builder: (context) => QualFilter(qualList: cubit.qualityList)).then(
                          (value) {
                            if (value == true) {
                              QualFilterData["filtered_apply"] = true;
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
            child: BlocBuilder<QualityNewCubit, QualityNewState>(
              builder: (context, state) {
                if (state is QualityNewLoad) {
                  return state.widget;
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
