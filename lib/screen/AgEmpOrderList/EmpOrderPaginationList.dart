import 'package:empire_ios/Models/BillsModel.dart';
import 'package:flutter/material.dart';

class PaginationTable extends StatefulWidget {
  final List<BillsModel> filteredList;

  PaginationTable({required this.filteredList});

  @override
  _PaginationTableState createState() => _PaginationTableState();
}

class _PaginationTableState extends State<PaginationTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: Text('Bills Data Table'),
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (int? value) {
          setState(() {
            _rowsPerPage = value!;
          });
        },
        availableRowsPerPage: [5, 10, 20],
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        columns: [
          DataColumn(label: Text('ACTION')),
          DataColumn(label: Text('ORDER NO')),
        ],
        source: _DataSource(widget.filteredList),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  final List<BillsModel> filteredList;

  _DataSource(this.filteredList);

  @override
  DataRow? getRow(int index) {
    if (index >= filteredList.length) {
      return null;
    }
    BillsModel billsModel = BillsModel.fromJson(filteredList[index].toJson());
    return DataRow(
      cells: [
        DataCell(Text(billsModel.cNO)),
        DataCell(Text(billsModel.bill!)),
        // Add more DataCell widgets as needed
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredList.length;

  @override
  int get selectedRowCount => 0;
}
