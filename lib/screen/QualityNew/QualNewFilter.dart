import 'package:empire_ios/Models/QualModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/QualityNew/QualityNew.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';

class QualFilter extends StatefulWidget {
  final List<QualModel> qualList;
  const QualFilter({Key? key, required this.qualList}) : super(key: key);

  @override
  State<QualFilter> createState() => _QualFilterState();
}

class _QualFilterState extends State<QualFilter> {
  List<String> packingList = [];
  List<String> qtList = [];
  @override
  void initState() {
    super.initState();
    packingList = widget.qualList.map((e) => e.packing).where((p) => p != null && p.isNotEmpty).toSet().cast<String>().toList();
    qtList = widget.qualList.map((e) => e.qT).where((q) => q != null && q.isNotEmpty).toSet().cast<String>().toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: const Text('Quality Filter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Base Quality',
                  border: OutlineInputBorder(),
                ),
                value: QualFilterData["base_quality"] ?? "", // Default to ALL
                items: const [
                  DropdownMenuItem(
                    value: 'N',
                    child: Text('No (BASE QUALITY)'),
                  ),
                  DropdownMenuItem(
                    value: 'Y',
                    child: Text('Yes (BASE QUALITY)'),
                  ),
                  DropdownMenuItem(
                    value: '',
                    child: Text('ALL'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    QualFilterData["base_quality"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Order By',
                  border: OutlineInputBorder(),
                ),
                value: QualFilterData["qualOrderBy"] ?? "",
                items: const [
                  DropdownMenuItem(
                    value: "",
                    child: Text('ORDER BY'),
                  ),
                  DropdownMenuItem(
                    value: "S1",
                    child: Text('RATE1'),
                  ),
                  DropdownMenuItem(
                    value: "S2",
                    child: Text('RATE2'),
                  ),
                  DropdownMenuItem(
                    value: "S3",
                    child: Text('RATE3'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    QualFilterData["qualOrderBy"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Order Option',
                  border: OutlineInputBorder(),
                ),
                value: QualFilterData["qualOrderByOption"] ?? "ASC",
                items: const [
                  DropdownMenuItem(
                    value: "ASC",
                    child: Text('ASC'),
                  ),
                  DropdownMenuItem(
                    value: "DESC",
                    child: Text('DESC'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    QualFilterData["qualOrderByOption"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Packing',
                  border: OutlineInputBorder(),
                ),
                value: QualFilterData["qualPACK"] ?? "",
                items: [
                  const DropdownMenuItem(
                    value: "",
                    child: Text('ALL'),
                  ),
                  ...packingList.map((packing) => DropdownMenuItem(
                        value: packing,
                        child: Text(packing),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    QualFilterData["qualPACK"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                value: QualFilterData["qualType"] ?? "",
                items: [
                  const DropdownMenuItem(
                    value: "",
                    child: Text('ALL'),
                  ),
                  ...qtList.map((qt) => DropdownMenuItem(
                        value: qt,
                        child: Text(qt),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    QualFilterData["qualType"] = value;
                  });
                },
              ),
            ),
            GFButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                text: "Apply Filters",
                color: jsmColor,
                shape: GFButtonShape.standard,
                size: GFSize.LARGE),
          ],
        ),
      ),
    );
  }
}
