import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';
import 'package:empire_ios/screen/ProductManagement/stockInEntry/stockInEntry.dart';
import 'package:flutter/material.dart';

class ProductManagementDrawer extends StatefulWidget {
  const ProductManagementDrawer({Key? key}) : super(key: key);

  @override
  State<ProductManagementDrawer> createState() => _ProductManagementDrawerState();
}

class _ProductManagementDrawerState extends State<ProductManagementDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: ListView(
        children: [
          SizedBox(height: 200),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text("Stock"),
            children: [
              ListTile(onTap: () => Myf.Navi(context, StockInEntry()), trailing: Icon(Icons.inbox), title: Text("Stock In Entry")),
            ],
          )
        ],
      ),
    );
  }
}
