import 'package:bi_replicate/components/search_table/table_row_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bi_replicate/components/search_table/data_row.dart' as data_row;

class TableWidget extends StatelessWidget {
  final List<String> columnNames;
  final List<data_row.DataRow> rows;
  final Function(String, String) onRowSelected;
  const TableWidget({
    super.key,
    required this.columnNames,
    required this.rows,
    required this.onRowSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableRowWidget(rowData: columnNames, isHeader: true),
              ...rows.asMap().entries.map((entry) => TableRowWidget(
                    rowData: [
                      ...entry.value.values,
                    ],
                    isHeader: false,
                    onSelected: () {
                      onRowSelected(
                          entry.value.values[0], entry.value.values[1]);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
