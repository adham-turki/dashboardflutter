import 'package:flutter/material.dart';

class TableRowWidget extends StatefulWidget {
  final List<dynamic> rowData;
  final VoidCallback? onSelected;
  final bool isHeader;
  TableRowWidget({
    required this.rowData,
    this.onSelected,
    this.isHeader = false,
  });
  @override
  _TableRowWidgetState createState() => _TableRowWidgetState();
}

class _TableRowWidgetState extends State<TableRowWidget> {
  late List<bool> checkboxValues;
  @override
  void initState() {
    super.initState();
    // Initialize checkboxValues based on the rowData
    checkboxValues = List<bool>.generate(
        widget.rowData.length,
        (index) =>
            widget.rowData[index] is bool ? widget.rowData[index] : false);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isHeader
        ? Color(0xFFCFE4F6)
        : widget.rowData[0] != true
            ? Color(0xFFE0EAF0)
            : Colors.transparent;
    return InkWell(
      onTap: widget.onSelected,
      child: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.rowData.length, (index) {
              final item = widget.rowData[index];

              // Text data
              return Text(
                item.toString(),
                style: TextStyle(
                  fontWeight:
                      widget.isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
