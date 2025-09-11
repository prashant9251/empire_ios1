import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/GatePassReport/GatePassReport.dart';
import 'package:flutter/material.dart';

class GatePassDateTab extends StatefulWidget {
  const GatePassDateTab({Key? key}) : super(key: key);

  @override
  State<GatePassDateTab> createState() => _GatePassDateTabState();
}

class _GatePassDateTabState extends State<GatePassDateTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _last7Days;

  @override
  void initState() {
    super.initState();
    _last7Days = List.generate(
      7,
      (index) => DateTime.now().subtract(Duration(days: 6 - index)),
    );
    _tabController = TabController(length: _last7Days.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year.toString().substring(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Gate Pass Report"),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.white,
          controller: _tabController,
          isScrollable: true,
          onTap: (value) {
            setState(() {});
          },
          tabs: _last7Days.reversed.map((date) => Tab(text: _formatDate(date))).toList(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _last7Days.reversed.map((date) => GatePassReport(dateFilter: date.toString())).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
