import 'package:bi_replicate/components/search_table/table_row_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bi_replicate/components/search_table/data_row.dart' as data_row;

class TableWidget extends StatelessWidget {
  final List<String> columnNames;
  final List<data_row.DataRow> rows;
  final Function(String) onRowSelected;
  const TableWidget({
    super.key,
    required this.columnNames,
    required this.rows,
    required this.onRowSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          TableRowWidget(rowData: columnNames, isHeader: true),
          ...rows.asMap().entries.map((entry) => TableRowWidget(
                rowData: [
                  entry.value.check,
                  ...entry.value.values,
                ],
                isHeader: false,
                onSelected: () {
                  onRowSelected(entry.value.values.join(' '));
                },
              )),
        ],
      ),
    );
  }
}
