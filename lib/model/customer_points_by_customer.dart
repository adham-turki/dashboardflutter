import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerPointsByCustomerModel {
  String? custCode;
  String? custName;
  int? custPoints;
  int? usedPoints;
  int? remainingPoints;

  CustomerPointsByCustomerModel({
    this.custCode,
    this.custName,
    this.custPoints,
    this.usedPoints,
    this.remainingPoints,
  });

  factory CustomerPointsByCustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerPointsByCustomerModel(
      custCode: json['custCode'] ?? '',
      custName: json['custName'] ?? '',
      custPoints: json['custPoints'] ?? 0,
      usedPoints: json['usedPoints'] ?? 0,
      remainingPoints: json['remainingPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custCode': custCode,
      'custName': custName,
      'custPoints': custPoints,
      'usedPoints': usedPoints,
      'remainingPoints': remainingPoints,
    };
  }

  PlutoRow toPluto(int counter) {
    final Map<String, PlutoCell> inventoryPerformance = <String, PlutoCell>{};
    inventoryPerformance['counter'] = PlutoCell(value: counter);

    inventoryPerformance['custCode'] = PlutoCell(value: custCode ?? "");
    inventoryPerformance['custName'] = PlutoCell(value: custName ?? "");

    inventoryPerformance['custPoints'] = PlutoCell(value: custPoints ?? 0);
    inventoryPerformance['usedPoints'] = PlutoCell(value: usedPoints ?? 0);
    inventoryPerformance['remainingPoints'] =
        PlutoCell(value: remainingPoints ?? 0);

    return PlutoRow(cells: inventoryPerformance);
  }

  static List<PlutoColumn> getColumns(
      AppLocalizations localizations, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // int numberOfColumns = 4;
    // double width *0.15 = totalWidth / numberOfColumns;
    bool isDesktop = Responsive.isDesktop(context);
    List<PlutoColumn> list = [
      PlutoColumn(
        title: "#",
        field: "counter",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.05 : width * 0.1,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.code,
        field: "custCode",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.name,
        field: "custName",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.15 : width * 0.35,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.customerPoints,
        field: "custPoints",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.usedPoints,
        field: "usedPoints",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.remainingPoints,
        field: "remainingPoints",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
      ),
    ];

    return list;
  }
}
