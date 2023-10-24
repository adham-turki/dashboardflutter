import 'package:bi_replicate/controller/inventory_performance/inventory_performance_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/styles.dart';
import '../criteria/search_criteria.dart';

class InventoryPerformanceModel {
  String? code;
  String? name;
  double? intQty;
  double? outQty;
  List? dataInc;
  static double allOutQty = 0;
  InventoryPerformanceModel(this.code, this.name, this.intQty, this.outQty);
  InventoryPerformanceModel.fromJson(
      Map<String, dynamic> inventoryPerformance) {
    code = inventoryPerformance['stkCode'].toString() == "null"
        ? ""
        : inventoryPerformance['stkCode'].toString();
    name = inventoryPerformance['nameE'].toString() == "null"
        ? ""
        : inventoryPerformance['nameE'].toString();
    intQty = inventoryPerformance['inQnty'].toString() == "null"
        ? 0.0
        : double.parse(inventoryPerformance['inQnty'].toString());
    outQty = inventoryPerformance['outQnty'].toString() == 'null'
        ? 0.0
        : (double.parse(inventoryPerformance['outQnty'].toString()));
  }

  PlutoRow toPluto() {
    final Map<String, PlutoCell> inventoryPerformance = <String, PlutoCell>{};
    inventoryPerformance['stkCode'] = PlutoCell(value: code ?? "");
    inventoryPerformance['nameE'] = PlutoCell(value: name ?? "");

    inventoryPerformance['inQnty'] = PlutoCell(value: intQty ?? 0);
    inventoryPerformance['outQnty'] = PlutoCell(value: outQty ?? 0);
    return PlutoRow(cells: inventoryPerformance);
  }

  static List<PlutoColumn> getColumns(AppLocalizations localizations,
      BuildContext context, double screenWidth) {
    double totalWidth = MediaQuery.of(context).size.width * screenWidth;
    int numberOfColumns = 4;
    double columnWidth = totalWidth / numberOfColumns;
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.code,
        field: "stkCode",
        type: PlutoColumnType.text(),
        width: columnWidth,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.name,
        field: "nameE",
        type: PlutoColumnType.text(),
        width: columnWidth,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.currentQty,
        field: "inQnty",
        type: PlutoColumnType.number(),
        width: columnWidth,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.soldQnty,
        field: "outQnty",
        type: PlutoColumnType.number(),
        width: columnWidth,
        backgroundColor: colColor,
        footerRenderer: (rendererContext) {
          return InventoryPerformanceModel.footerRenderer(
              rendererContext, allOutQty);
        },
      ),
    ];

    return list;
  }

  double soldQntyVal() {
    // print("ListString ${widget.dataInc.length}");

    for (int i = 0; i < dataInc!.length; i++) {
      allOutQty += double.parse(dataInc![i]['outQnty'].toString());
    }
    return allOutQty;
  }

  static PlutoAggregateColumnFooter footerRenderer(
      PlutoColumnFooterRendererContext rendererContext, double valueAll) {
    return PlutoAggregateColumnFooter(
      rendererContext: rendererContext,
      formatAsCurrency: false,
      type: PlutoAggregateColumnType.sum,
      alignment: Alignment.center,
      titleSpanBuilder: (text) {
        return [
          TextSpan(
            text: text.replaceAll("\$", ""),
            children: [
              TextSpan(
                text: valueAll.toStringAsFixed(2),
              ),
            ],
            style: gridFooterStyle,
          ),
        ];
      },
    );
  }
}
