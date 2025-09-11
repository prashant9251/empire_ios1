import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:empire_ios/Models/JobCardReportModel.dart';
import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/functions/StickerPrintingClass.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ImageViewer/ImageViewer.dart';
import 'package:empire_ios/screen/JobCardForm/JobCardStickerPrintClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/shape/gf_icon_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class JobCardFormCubit extends Cubit<JobCardFormState> {
  List<JobCardReportModel?>? jobCardReportModelList;
  var ctrlBarcode = TextEditingController();
  BuildContext context;
  JobCardFormCubit(this.context) : super(JobCardFormInitial()) {
    ctrlBarcode.text = "1-O99-920";
  }

  searchData() async {
    if (ctrlBarcode.text.isEmpty) {
      emit(JobCardFormLoadData(Center(child: Text('Please enter a barcode to search.'))));
      return;
    }
    emit(JobCardFormLoadData(Center(child: CircularProgressIndicator())));
    await Future.delayed(Duration(seconds: 1));
    jobCardReportModelList = await searchRequest(ctrlBarcode.text);
    if (jobCardReportModelList == null) {
      emit(JobCardFormLoadData(Center(child: Text('No data found for the given barcode.'))));
      return;
    }
    Widget w = getTable(jobCardReportModelList);
    emit(JobCardFormLoadData(w));
  }

  Widget getTable(List<JobCardReportModel?>? jobCardReportModelList) {
    TextStyle headTextStyle = TextStyle(color: Colors.black);
    TextStyle tdTextStyle = TextStyle(color: Colors.black);
    var basicAuthForLocal = Myf.getBasicAuthForLocal();
    List<JobCardReportModel> docsList = [];
    for (var element in jobCardReportModelList ?? []) {
      JobCardReportModel jobCard = element;
      if (!docsList.any((doc) => doc.component == jobCard.component)) {
        docsList.add(jobCard);
      }
    }
    docsList.sort(
      (a, b) => a.component!.compareTo(b.component!),
    );
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ...docsList.map((jobCard) {
              List<JobCardReportModel?>? jobCardReportModelComponetList =
                  jobCardReportModelList?.where((item) => item?.component == jobCard.component).toList();
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobCard.component}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GFIconButton(
                            onPressed: () async {
                              Uint8List? bytes = await jobCardStickerInBytes(jobCardReportModelList ?? [], docsList);
                              // var printer = await getPrinter(context);
                              await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes!);
                              // Myf.Navi(context, TSCPrintScreen());
                            },
                            size: GFSize.SMALL,
                            borderSide: BorderSide(color: Colors.white, width: 1),
                            icon: Icon(FontAwesomeIcons.tag, color: Colors.white),
                            shape: GFIconButtonShape.square,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  FutureBuilder<Widget>(
                    future: jobCardTable(headTextStyle, jobCardReportModelComponetList, basicAuthForLocal, tdTextStyle),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return snapshot.data ?? SizedBox.shrink();
                      }
                    },
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<Widget> jobCardTable(
      TextStyle headTextStyle, List<JobCardReportModel?>? jobCardReportModelList, basicAuthForLocal, TextStyle tdTextStyle) async {
    var rows = <DataRow>[];
    var totalPendPcs = 0.0;
    var totalPendMts = 0.0;

    await Future.wait((jobCardReportModelList ?? []).map(
      (jobCardReportModel) async {
        var imgUrl = Myf.qualImgLink(QualModel(qual_path: jobCardReportModel!.PATH.toString()));
        var PendPcs = Myf.convertToDouble(jobCardReportModel.PEND_PCS ?? '0');
        totalPendPcs += PendPcs;
        var PendMts = Myf.convertToDouble(jobCardReportModel.PEND_MTS ?? '0');
        totalPendMts += PendMts;

        rows.add(DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              // Alternate row color
              return rows.length % 2 == 0 ? Colors.grey[50] : Colors.white;
            },
          ),
          cells: [
            DataCell(
              GestureDetector(
                onTap: () {
                  Myf.Navi(context, ImageViewer([imgUrl], iniIndex: 0));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl ?? '',
                    placeholder: (context, url) => SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.broken_image, color: Colors.redAccent),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    httpHeaders: {
                      "Authorization": basicAuthForLocal,
                    },
                  ),
                ),
              ),
            ),
            DataCell(
              GestureDetector(
                onTap: () async {
                  Uint8List? bytes = await jobCardSmallStickerInBytes([jobCardReportModel], [jobCardReportModel]);
                  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes!);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(6),
                      // border: Border.all(color: Colors.blueAccent, width: 1),
                    ),
                    child: Text(
                      '${jobCardReportModel.stageName ?? ''}',
                      style: tdTextStyle.copyWith(
                        // color: Colors.blue[800],
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PendPcs > 0 ? Colors.red[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${jobCardReportModel.PEND_PCS ?? '0'}',
                  style: PendPcs > 0
                      ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                      : TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PendMts > 0 ? Colors.red[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${Myf.convertToDouble(jobCardReportModel.PEND_MTS ?? '0').toStringAsFixed(2)}',
                  style: PendMts > 0
                      ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                      : TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataCell(Text(Myf.dateFormateInDDMMYYYY('${jobCardReportModel.date ?? ''}'), style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.vno ?? ''}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.refPartyName ?? ''}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.chalNo ?? ''}', style: tdTextStyle)),
            DataCell(Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PendMts > 0 ? Colors.red[50] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${jobCardReportModel.pcs ?? '0'}', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)))),
            DataCell(Text('${Myf.convertToDouble(jobCardReportModel.mts ?? '0').toStringAsFixed(2)}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.freshPcs ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.rate ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.secPcs1 ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.secPcs2 ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.lostPcs ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.lacePcs ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.trackSeries ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.component ?? '0'}', style: tdTextStyle)),
            DataCell(Text('${jobCardReportModel.pty_designNo ?? '0'}', style: tdTextStyle)),
          ],
        ));
      },
    ).toList());

    // Add total row with highlight
    rows.add(DataRow(
      color: WidgetStateProperty.all(Colors.grey[300]),
      cells: [
        DataCell(Text('Total', style: headTextStyle.copyWith(fontWeight: FontWeight.bold))),
        DataCell(Text('')),
        DataCell(Text('${totalPendPcs.toInt()}', style: headTextStyle.copyWith(color: Colors.red, fontWeight: FontWeight.bold))),
        DataCell(Text('${totalPendMts.toStringAsFixed(2)}', style: headTextStyle.copyWith(color: Colors.red, fontWeight: FontWeight.bold))),
        ...List.generate(15, (index) => DataCell(Text(''))),
      ],
    ));

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!, width: .7, style: BorderStyle.solid),
            columnSpacing: 12,
            headingRowColor: WidgetStateProperty.all(jsmColor),
            headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            dataTextStyle: TextStyle(color: Colors.black, fontSize: 12),
            columns: [
              DataColumn(label: Text('ACTION', style: headTextStyle)),
              DataColumn(label: Text('STAGE NAME', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('PEND.PCS', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('PEND.MTS', style: headTextStyle)),
              DataColumn(label: Text('DATE', style: headTextStyle)),
              DataColumn(label: Text('VNO', style: headTextStyle)),
              DataColumn(label: Text('REF PARTY', style: headTextStyle)),
              DataColumn(label: Text('CHAL_NO', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('PCS', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('MTS', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('FRESH', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('RATE', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('PLAIN', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('SECOND', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('LOST', style: headTextStyle)),
              DataColumn(numeric: true, label: Text('LACE', style: headTextStyle)),
              DataColumn(label: Text('SOURCE', style: headTextStyle)),
              DataColumn(label: Text('COMPONENT', style: headTextStyle)),
              DataColumn(label: Text('PTY_DESIGN_NO', style: headTextStyle)),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }

  Future<List<JobCardReportModel?>?> searchRequest(String barcode) async {
    var host = Myf.getLocalHostUrl();
    var basicAuthForLocal = Myf.getBasicAuthForLocal();
    List<JobCardReportModel?>? jobCardReportModel;
    var loginUrl = "${host}/GP/jobCardSearch.php?";
    Map<String, dynamic> reQobj = {};
    reQobj["Clnt"] = GLB_CURRENT_USER["CLIENTNO"];
    reQobj["Cldb"] = GLB_CURRENT_USER["encdb"];
    reQobj["api"] = GLB_CURRENT_USER["api"];
    reQobj["token"] = GLB_CURRENT_USER["Ltoken"];
    reQobj["year"] = (GLB_CURRENT_USER["yearVal"]).replaceAll("-", "");
    reQobj["barcode"] = barcode;
    var response;
    try {
      response = await Dio().post(
        loginUrl,
        data: reQobj,
        queryParameters: reQobj,
        options: Options(
          headers: {
            'Authorization': basicAuthForLocal,
          },
          receiveTimeout: Duration(seconds: 10),
          sendTimeout: Duration(seconds: 10),
        ),
      );
      if (response.statusCode == 200) {
        var res = response.data.toString();
        if (res != null) {
          var json = await jsonDecode(res);
          // logger.d(json);
          try {
            jobCardReportModel = (json as List).map((item) => JobCardReportModel.fromJson(Myf.convertMapKeysToString(item))).toList();
          } catch (e) {
            print("Error in parsing JobCardReportModel: $e");
          }
          return jobCardReportModel;
        } else {
          jobCardReportModel = [JobCardReportModel(error: 'User Not Valid')];
          return jobCardReportModel;
        }
      }
      return null;
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  // Future getPrinter(BuildContext context) async {
  //   // Printing package does not support getting a printer directly by IP.
  //   // It only lists printers discovered by the OS.
  //   // You can filter by name, but not connect by IP directly.
  //   final printers = await Printing.listPrinters();
  //   if (printers.isNotEmpty) {
  //     // Optionally, filter for TSC printers by name or model
  //     final tscPrinter = printers.firstWhere(
  //       (printer) => printer.name.toLowerCase().contains('tsc'),
  //       orElse: () => printers.first,
  //     );
  //     return tscPrinter;
  //   }
  //   return null;
  // }
}

abstract class JobCardFormState {}

class JobCardFormInitial extends JobCardFormState {}

class JobCardFormLoadData extends JobCardFormState {
  Widget widget;
  JobCardFormLoadData(this.widget);
}
