import 'dart:io';

import 'package:empire_ios/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/export_delegate.dart';
import 'package:flutter_to_pdf/export_frame.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class OutstandingReport extends StatefulWidget {
  const OutstandingReport({Key? key}) : super(key: key);

  @override
  State<OutstandingReport> createState() => _OutstandingReportState();
}

class _OutstandingReportState extends State<OutstandingReport> {
  final ExportDelegate exportDelegate = ExportDelegate();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: jsmColor,
        title: Text("Outstanding Report"),
      ),
      body: ExportFrame(
        frameId: 'someFrameId',
        exportDelegate: exportDelegate,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                color: jsmColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aasha silk mills",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "199, shiv shakti mkt ring road surat, 395002 24AAABFA1234C1Z5",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Sale Outstanding Report",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Invoice No', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Outstanding', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('01/01/2023')),
                        DataCell(Text('INV001')),
                        DataCell(Text('John Doe')),
                        DataCell(Text('\$1000')),
                        DataCell(Text('\$500')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('02/01/2023')),
                        DataCell(Text('INV002')),
                        DataCell(Text('Jane Smith')),
                        DataCell(Text('\$2000')),
                        DataCell(Text('\$1500')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('03/01/2023')),
                        DataCell(Text('INV003')),
                        DataCell(Text('Michael Brown')),
                        DataCell(Text('\$1500')),
                        DataCell(Text('\$1000')),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          // Handle button press
          // export the frame to a PDF Document
          final page = await exportDelegate.exportToPdfPage('someFrameId');
          final pdf = pw.Document();
          pdf.addPage(page);
          final output = await getTemporaryDirectory();
          final file = File('${output.path}/outstanding_report.pdf');
          await file.writeAsBytes(await pdf.save());
          // Open the PDF file
          OpenFilex.open(file.path).then((value) {
            if (value.type == ResultType.done) {
              print("PDF opened successfully");
            } else {
              print("Error opening PDF: ${value.message}");
            }
          });
        },
        child: Icon(Icons.picture_as_pdf, color: Colors.white),
      ),
    );
  }
}
