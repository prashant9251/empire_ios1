import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire_ios/Models/BillDetModel.dart';
import 'package:empire_ios/Models/ColorModel.dart';
import 'package:empire_ios/Models/GalleryModel.dart';
import 'package:empire_ios/Models/ImageModel.dart';
import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/EmpOrderForm/cubit/EmpOrderFormCubit.dart';
import 'package:empire_ios/screen/EmpOrderFormColor/cubit/EmpOrderFormColorState.dart';
import 'package:empire_ios/widget/BuildTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class EmpOrderFormColorCubit extends Cubit<EmpOrderFormColorState> {
  BillDetModel? billDetModel = BillDetModel();
  List<ColorModel> _list = [];
  Box? galleryBox;
  BuildContext context;
  List<GalleryModel> GALLERY_LIST = [];
  Widget widget = SizedBox.shrink();
  List<ColorModel> filteredList = [];

  var ctrlQty = TextEditingController();

  var ctrlRate = TextEditingController();

  var boolselectAll = false;

  bool isDispose = false;

  EmpOrderFormColorCubit(this.context) : super(EmpOrderFormColorStateIni()) {}

  void getData() async {
    GALLERY_LIST = [];
    galleryBox = await SyncLocalFunction.openBoxCheck("gallery");
    if (galleryBox != null) {
      GALLERY_LIST = await Future.wait(galleryBox!.values.map((e) async {
        GalleryModel galleryModel = GalleryModel.fromJson(Myf.convertMapKeysToString(e));
        return galleryModel;
      }).toList());
      GALLERY_LIST = await GALLERY_LIST.where((e) => e.value == billDetModel!.qUAL).toList();
    }

    await galleryBox!.close();
    queryData("");
  }

  queryData(String query) async {
    if (query.isNotEmpty) {
      final searchTerm = query.toUpperCase().trim();
      filteredList.clear();
      // Filter the list based on the search criteria
      GALLERY_LIST.where((element) {
        // Customize your filtering logic here, for example, filtering by a specific field like 'name'
        if ("${element.name}".toUpperCase().contains(searchTerm)) {
          filteredList.add(ColorModel(clName: element.name!.split(".").first, selected: false, url: element.url));
          return true;
        }
        return false;
      }).toList();
      loadTable();
    } else {
      // If the search query is empty, return the entire list
      // return EMP_COLOR_LIST.toList();
      filteredList = GALLERY_LIST.map((e) {
        return ColorModel(clName: e.name!.split(".").first, selected: false, url: e.url);
      }).toList();
      loadTable();
    }
    List<ColorModel> existingColorSelected = billDetModel!.colorDetails ?? [];
    filteredList.map((e) {
      existingColorSelected.map((e2) {
        if (e.clName == e2.clName) {
          e.selected = true;
          e.clQty = e2.clQty;
          e.clRmk = e2.clRmk;
        }
      }).toList();
    }).toList();
  }

  void loadTable() async {
    widget = await getViewTable();
    if (!isDispose) emit(EmpOrderFormColorStateLoadColor(widget));
  }

  selectAllInList() {
    filteredList.map((e) {
      if (e.clName == billDetModel!.qUAL) {
        e.selected = false;
      } else {
        e.selected = boolselectAll;
      }
    }).toList();
  }

  getViewTable() {
    return Container(
      width: widthResponsive(context),
      child: StreamBuilder(
          stream: somthingHaschange.stream,
          builder: (context, snapshot) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  var colorModel = filteredList[index];
                  return StreamBuilder(
                      stream: somthingHaschange.stream,
                      builder: (context, snapshot) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: colorModel.selected ? Colors.blue.shade50 : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => selectIt(colorModel),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      color: Colors.grey.shade200,
                                      child: Myf.showImg(
                                        ImageModel(
                                          url: colorModel.url,
                                          type: "url",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${Myf.getSubstring(colorModel.clName!, length: 20)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: colorModel.selected ? Colors.blue : Colors.black87,
                                                ),
                                              ),
                                            ),
                                            AnimatedSwitcher(
                                              duration: Duration(milliseconds: 200),
                                              child: colorModel.selected
                                                  ? Icon(Icons.check_circle, color: Colors.blue, key: ValueKey(true))
                                                  : Icon(Icons.radio_button_unchecked, color: Colors.grey, key: ValueKey(false)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        buildTextFormField(
                                          context,
                                          labelText: "Qty",
                                          controller: TextEditingController(text: colorModel.clQty),
                                          onChanged: (value) {
                                            colorModel.clQty = value;
                                            if (value.isNotEmpty && double.tryParse(value) != null && double.parse(value) > 0) {
                                              colorModel.selected = true;
                                            } else {
                                              colorModel.selected = false;
                                            }
                                            somthingHaschange.sink.add(true);
                                          },
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
                },
                itemCount: filteredList.length);
          }),
    );
  }

  doneSave() {
    Navigator.pop(context, filteredList);
  }

  selectIt(ColorModel colorModel) {
    final isAlreadySelected = colorModel.selected;
    if (isAlreadySelected) {
      colorModel.selected = false;
    } else {
      colorModel.selected = true;
    }
    somthingHaschange.sink.add(true);
  }
}
