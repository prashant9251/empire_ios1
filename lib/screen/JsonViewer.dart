import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class JsonViewer extends StatefulWidget {
  const JsonViewer({Key? key, required this.jsonString}) : super(key: key);

  final dynamic jsonString;

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Json Viewer"),
      // ),
      body: SingleChildScrollView(
        child: JsonView.map(
          widget.jsonString,
          // theme: JsonViewTheme(
          //   keyStyle: TextStyle(
          //     color: Colors.black54,
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600,
          //   ),
          //   doubleStyle: TextStyle(
          //     color: Colors.green,
          //     fontSize: 16,
          //   ),
          //   intStyle: TextStyle(
          //     color: Colors.green,
          //     fontSize: 16,
          //   ),
          //   stringStyle: TextStyle(
          //     color: Colors.green,
          //     fontSize: 16,
          //   ),
          //   boolStyle: TextStyle(
          //     color: Colors.green,
          //     fontSize: 16,
          //   ),
          //   closeIcon: Icon(
          //     Icons.close,
          //     color: Colors.green,
          //     size: 20,
          //   ),
          //   openIcon: Icon(
          //     Icons.add,
          //     color: Colors.green,
          //     size: 20,
          //   ),
          //   separator: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 8.0),
          //     child: Icon(
          //       Icons.arrow_right_alt_outlined,
          //       size: 20,
          //       color: Colors.green,
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
