import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/constants/colors.dart';

class InventoryPerformanceModel {
  String? code;
  String? name;
  double? intQty;
  double? outQty;
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

  Map<String, PlutoCell> toPluto() {
    final Map<String, PlutoCell> inventoryPerformance = <String, PlutoCell>{};
    inventoryPerformance['stkCode'] = PlutoCell(value: code);
    inventoryPerformance['nameE'] = PlutoCell(value: name);
    inventoryPerformance['inQnty'] = PlutoCell(value: intQty);
    inventoryPerformance['outQnty'] = PlutoCell(value: outQty);
    return inventoryPerformance;
  }

  static List<PlutoColumn> getColumns(AppLocalizations localizations) {
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.code,
        field: "code",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.name,
        field: "name",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.currentQty,
        field: "intQty",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.soldQnty,
        field: "outQty",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
    ];

    return list;
  }
}
