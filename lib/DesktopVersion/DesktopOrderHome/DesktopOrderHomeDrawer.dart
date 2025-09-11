import 'dart:async';

import 'package:flutter/material.dart';

class DesktopOrderHomeDrawer extends StatelessWidget {
  StreamController<int> searchFilterChange;
  DesktopOrderHomeDrawer({Key? key, required this.searchFilterChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 10,
        child: Container(
          color: Colors.grey[200],
          child: ListView(
            children: [
              ListTile(
                title: Text("UNIQUE SOFTWARES"),
                subtitle: Text("softwares.unique@gmail.com"),
              ),
              SizedBox(height: 10),
              ListTile(
                onTap: () => searchFilterChange.sink.add(0),
                title: Text("Home"),
                leading: Icon(Icons.home),
              ),
              Divider(),
              ListTile(
                onTap: () => searchFilterChange.sink.add(1),
                title: Text("ITEM WISE ORDER"),
                leading: Icon(Icons.new_label),
              ),
              Divider(),
              ListTile(
                onTap: () => searchFilterChange.sink.add(2),
                title: Text("Pending Order"),
                leading: Icon(Icons.pending),
              ),
              Divider(),
              ListTile(
                onTap: () => searchFilterChange.sink.add(3),
                title: Text("Dispatch Order"),
                leading: Icon(Icons.send),
              ),
              Divider(),
            ],
          ),
        ));
  }
}
