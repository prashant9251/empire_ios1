import 'package:flutter/material.dart';

import '../../../screen/EMPIRE/Myf.dart';
import '../OfficeClientRequestOpen.dart';

class OfficeRequestEndDrawer extends StatefulWidget {
  var drawerObj;

  var UserObj;

  OfficeRequestEndDrawer({Key? key, required this.drawerObj, this.UserObj}) : super(key: key);

  @override
  State<OfficeRequestEndDrawer> createState() => _OfficeRequestEndDrawerState();
}

class _OfficeRequestEndDrawerState extends State<OfficeRequestEndDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      child: Drawer(
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    widget.drawerObj["clnt"] = widget.drawerObj["CLNT"];
                    Myf.Navi(
                        context,
                        OfficeClientRequestOpen(
                          obj: widget.drawerObj,
                          UserObj: widget.UserObj,
                        ));
                  },
                  title: Text("${widget.drawerObj["shopName"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CLIENT : ${widget.drawerObj["CLNT"]}"),
                      Text("MOBILE : ${widget.drawerObj["MobileNo"]}"),
                      SizedBox(height: 10),
                      Text("RESPONSE", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${widget.drawerObj["response"]}")
                    ],
                  ),
                  trailing: Text("${Myf.dateFormate(widget.drawerObj["DATE"])}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
