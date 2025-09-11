import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';

class StockInEntry extends StatefulWidget {
  const StockInEntry({Key? key}) : super(key: key);

  @override
  State<StockInEntry> createState() => _StockInEntryState();
}

class _StockInEntryState extends State<StockInEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Stock In Entry"),
        bottom: PreferredSize(preferredSize: Size.fromHeight(48.0), child: SizedBox.shrink()),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
