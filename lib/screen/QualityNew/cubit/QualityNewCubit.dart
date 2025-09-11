import 'dart:async';
import 'dart:io';

import 'package:empire_ios/Models/ImageModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ImageViewer/ImageViewer.dart';
import 'package:empire_ios/screen/QualityNew/QualityNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

class QualityNewCubit extends Cubit<QualityNewState> {
  var cardStreamChange = StreamController<bool>.broadcast();
  List<QualModel> qualityList = [];
  List<QualModel> filteredQualityList = [];

  var ctrlSearch = TextEditingController();
  QualityNewCubit() : super(QualityNewInitial());

  void getData() async {
    LazyBox<dynamic> lazyBoxQual = await SyncLocalFunction.openLazyBoxCheck("QUL");
    var databaseId = Myf.databaseIdCurrent(GLB_CURRENT_USER);
    var qul = await lazyBoxQual.get("${databaseId}QUL");
    for (var i = 0; i < qul.length; i++) {
      var item = qul[i];
      if (item != null) {
        try {
          QualModel qualModel = QualModel.fromJson(Myf.convertMapKeysToString(item));
          qualityList.add(qualModel);
        } catch (e) {
          // Handle parsing error
        }
      }
    }
    lazyBoxQual.close();
    loadData();
  }

  void loadData() async {
    filteredQualityList = qualityList;

    if (QualFilterData["base_quality"] != null && QualFilterData["base_quality"] != "") {
      filteredQualityList = qualityList.where((e) => e.toString().toUpperCase().trim() == QualFilterData["base_quality"]).toList();
    }
    if (QualFilterData["qualOrderBy"] != null && QualFilterData["qualOrderBy"] != "") {
      filteredQualityList.sort((a, b) {
        var aJson = Myf.convertMapKeysToString(a.toJson());
        var bJson = Myf.convertMapKeysToString(b.toJson());
        if (QualFilterData["qualOrderByOption"] == "ASC") {
          return aJson[QualFilterData["qualOrderBy"]].compareTo(bJson[QualFilterData["qualOrderBy"]]);
        } else {
          return bJson[QualFilterData["qualOrderBy"]].compareTo(aJson[QualFilterData["qualOrderBy"]]);
        }
      });
    }
    if (QualFilterData["qualPACK"] != null && QualFilterData["qualPACK"] != "") {
      filteredQualityList = filteredQualityList.where((e) => e.packing == QualFilterData["qualPACK"]).toList();
    }
    if (QualFilterData["qualType"] != null && QualFilterData["qualType"] != "") {
      filteredQualityList = filteredQualityList.where((e) => e.qT == QualFilterData["qualType"]).toList();
    }
    if (ctrlSearch.text.isNotEmpty) {
      filteredQualityList = filteredQualityList.where((item) {
        return item.label!.toLowerCase().contains(ctrlSearch.text.toLowerCase());
      }).toList();
    } else {
      filteredQualityList = filteredQualityList;
    }
    Widget widget = getListQual(filteredQualityList);
    emit(QualityNewLoad(widget));
  }

  Widget getListQual(List<QualModel> filteredQualityList) {
    return ListView.builder(
      itemCount: filteredQualityList.length,
      itemBuilder: (context, index) {
        final item = filteredQualityList[index];
        return QualityNewTile(item);
      },
    );
  }

  StreamBuilder<bool> QualityNewTile(QualModel qualModel) {
    String i = Myf.qualImgLink(qualModel);
    if (i.isNotEmpty) {
      qualModel.imageUrl = i;
    }
    return StreamBuilder(
        stream: cardStreamChange.stream,
        builder: (context, asyncSnapshot) {
          return GestureDetector(
            onTap: () {
              qualModel.selected = !qualModel.selected;
              cardStreamChange.add(true);
            },
            onLongPress: () {
              qualModel.selected = true;
              cardStreamChange.add(true);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: qualModel.selected ? Colors.blue[50] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: qualModel.selected ? Border.all(color: Colors.blueAccent, width: 2) : Border.all(color: Colors.transparent),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Myf.Navi(context, ImageViewer([qualModel.imageUrl!], iniIndex: 0));
                      },
                      child: Hero(
                        tag: qualModel.value ?? UniqueKey(),
                        child: Container(
                          width: 120,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Myf.showImg(
                              ImageModel(
                                url: qualModel.imageUrl ?? "",
                                type: 'url',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  qualModel.label ?? 'Product Name',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: jsmColor,
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  File? f;
                                  var shareText =
                                      "${qualModel.label}\nRate: ₹${qualModel.s1}\nCategory: ${qualModel.category}\nMain screen: ${qualModel.mainScreen}";
                                  if (!qualModel.imageUrl.toString().contains("upload.wikimedia.org")) {
                                    f = await baseCacheManager.getSingleFile(qualModel.imageUrl!);
                                  }
                                  if (f != null) {
                                    SharePlus.instance.share(ShareParams(
                                      text: shareText,
                                      subject: "Product Share",
                                      files: f != null ? [XFile(f.path)] : [],
                                    ));
                                  } else {
                                    Myf.shareText([shareText]);
                                  }
                                },
                                icon: Icon(FontAwesomeIcons.share, color: jsmColor, size: 20),
                                tooltip: "Share",
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.currency_rupee, color: Colors.green, size: 18),
                              Text(
                                '${qualModel.s1 ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Chip(
                                  label: Text(
                                    qualModel.category ?? 'N/A',
                                    style: const TextStyle(fontSize: 13, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepPurpleAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.dashboard_customize, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  ' ${qualModel.mainScreen ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.verified, color: Colors.blue, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                ' ${qualModel.baseQual ?? 'N/A'}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.inventory_2, color: Colors.teal, size: 16),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  ' ${qualModel.packing ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.storage, color: Colors.pinkAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Stock: ${qualModel.finishStock ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

abstract class QualityNewState {}

class QualityNewInitial extends QualityNewState {}

class QualityNewLoad extends QualityNewState {
  final Widget widget;

  QualityNewLoad(this.widget);
}
