import 'package:empire_ios/functions/syncLocalFunction.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/widget/Skelton.dart';
import 'package:empire_ios/widget/mainScreenIcon.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailySaleGraph extends StatelessWidget {
  DailySaleGraph({Key? key, required this.UserObj}) : super(key: key);
  final UserObj;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: MainIcon.isPermission("Last_30_Days_Daily_Sales"),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: jsmColor, size: 26),
            SizedBox(width: 10),
            Text(
              'Last 30 Days Daily Sales',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: jsmColor,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.deepPurple.withOpacity(0.2),
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        initiallyExpanded: false,
        children: [
          ValueListenableBuilder<Box>(
              valueListenable: hiveMainBox.listenable(),
              builder: (context, value, child) {
                return FutureBuilder<List<DailySaleModel>>(
                    future: getLast30DaysSales(),
                    builder: (context, asyncSnapshot) {
                      List<DailySaleModel> salesData = [];
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return loadingWidget();
                      }
                      if (asyncSnapshot.hasError) {
                        return Center(child: Text('Error: ${asyncSnapshot.error}'));
                      }
                      if (asyncSnapshot.hasData) {
                        salesData = asyncSnapshot.data!;
                      }
                      if (salesData.isEmpty) {
                        return Center(
                            child: Text('No sales data available for the last 30 days.',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
                      }
                      return Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 200,
                            width: salesData.length.toDouble() * 50, // Adjust width per bar as needed
                            child: SfCartesianChart(
                              backgroundColor: Colors.transparent,
                              primaryXAxis: CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                labelRotation: -300,
                                axisLine: AxisLine(width: 1, color: Colors.grey),
                                labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 8),
                              ),
                              primaryYAxis: NumericAxis(
                                majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey),
                                axisLine: AxisLine(width: 1, color: Colors.grey),
                                labelStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 8),
                              ),
                              title: ChartTitle(
                                text: '',
                              ),
                              legend: Legend(isVisible: false),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                color: Colors.deepPurple.shade50,
                                textStyle: TextStyle(color: jsmColor, fontWeight: FontWeight.bold, fontSize: 8),
                                borderColor: jsmColor,
                                borderWidth: 1,
                                elevation: 4,
                              ),
                              zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enablePanning: true, zoomMode: ZoomMode.x),
                              series: <CartesianSeries<dynamic, dynamic>>[
                                ColumnSeries<DailySaleModel, String>(
                                  dataSource: salesData,
                                  xValueMapper: (sale, _) => Myf.dateFormateYYYYMMDD(sale.date, formate: "dd-MMM-yy"),
                                  yValueMapper: (sale, _) => sale.sales,
                                  animationDuration: 700,
                                  width: 0.7,
                                  spacing: 0.1,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment: ChartDataLabelAlignment.outer,
                                    textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 6),
                                    borderRadius: 0,
                                    color: Colors.white,
                                    opacity: 0.5,
                                  ),
                                  onPointTap: (pointInteractionDetails) {
                                    // var mainUrl = Myf.mainUrl();
                                    // var url = "$mainUrl/ALLSALE_AJXREPORT.html?";
                                    // url += "search_FromDate=${pointInteractionDetails.dataPoints![0]}&";
                                    // url += "search_ToDate=${pointInteractionDetails.dataPoints![1]}&";
                                    // MainIcon.loadUrlInWebView(context, url, UserObj);
                                  },
                                  pointColorMapper: (sale, int index) {
                                    final colors = [
                                      Colors.pink.shade400,
                                      Colors.blue.shade400,
                                      Colors.amber.shade400,
                                      Colors.teal.shade400,
                                      Colors.green.shade400
                                    ];
                                    return colors[index % colors.length];
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ],
      ),
    );
  }

  Future<List<DailySaleModel>> getLast30DaysSales() async {
    List<DailySaleModel> sales = [];
    String software_name = loginUserModel.softwareName;
    LazyBox BLS = await SyncLocalFunction.openLazyBoxCheck('BLS');
    for (var key in BLS.keys) {
      try {
        var record = await BLS.get(key);
        var date = software_name.contains("TRADING") ? (record['DATE'] ?? '') : record["DTE"];
        var b = record['BAMT'];
        var billAmt = double.tryParse(b) ?? 0.0;
        DateTime recordDate;
        try {
          recordDate = DateFormat('yyyy-MM-dd').parse(date);
        } catch (e) {
          continue;
        }
        DateTime today = DateTime.now();
        if (recordDate.isAfter(today.subtract(Duration(days: 30))) &&
            recordDate.isBefore(today.add(Duration(days: 1))) &&
            record["DT"].toString().toUpperCase().contains("OS")) {
          sales.add(DailySaleModel(date: date, sales: billAmt));
        }
      } catch (err) {}
    }
    BLS.close();
    Map<String, double> dayWiseTotals = {};
    for (var sale in sales) {
      dayWiseTotals[sale.date] = (dayWiseTotals[sale.date] ?? 0) + sale.sales;
    }
    sales = dayWiseTotals.entries.map((e) => DailySaleModel(date: e.key, sales: e.value)).toList()..sort((a, b) => a.date.compareTo(b.date));
    sales.sort((a, b) => b.date.compareTo(a.date));
    return sales;
  }
}

class DailySaleModel {
  String date;
  double sales;

  DailySaleModel({required this.date, required this.sales});

  factory DailySaleModel.fromJson(Map<String, dynamic> json) {
    return DailySaleModel(
      date: json['date'],
      sales: json['sales'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sales': sales,
    };
  }
}
