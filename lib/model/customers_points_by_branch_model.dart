import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerPointsByBranch {
  String branchCode;
  String branchName;
  int custPoints;

  CustomerPointsByBranch({
    required this.branchCode,
    required this.branchName,
    required this.custPoints,
  });

  factory CustomerPointsByBranch.fromJson(Map<String, dynamic> json) {
    return CustomerPointsByBranch(
      branchCode: json['branchCode'] ?? '',
      branchName: json['branchName'] ?? '',
      custPoints: json['custPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchCode': branchCode,
      'branchName': branchName,
      'custPoints': custPoints,
    };
  }

  PlutoRow toPluto(int counter) {
    final Map<String, PlutoCell> inventoryPerformance = <String, PlutoCell>{};
    inventoryPerformance['counter'] = PlutoCell(value: counter);

    inventoryPerformance['branchCode'] = PlutoCell(value: branchCode ?? "");
    inventoryPerformance['branchName'] = PlutoCell(value: branchName ?? "");

    inventoryPerformance['custPoints'] = PlutoCell(value: custPoints ?? 0);

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
        textAlign: PlutoColumnTextAlign.center,
        width: isDesktop ? width * 0.05 : width * 0.1,
        backgroundColor: colColor,
        renderer: (context) {
          return toolTipWidget(context);
        },
        titleSpan: titleSpanWidget("#"),
      ),
      PlutoColumn(
        title: localizations.code,
        field: "branchCode",
        type: PlutoColumnType.text(),
        textAlign: PlutoColumnTextAlign.center,
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
        renderer: (context) {
          return toolTipWidget(context);
        },
        titleSpan: titleSpanWidget(localizations.code),
      ),
      PlutoColumn(
        title: localizations.name,
        field: "branchName",
        type: PlutoColumnType.text(),
        textAlign: PlutoColumnTextAlign.center,
        width: isDesktop ? width * 0.25 : width * 0.35,
        backgroundColor: colColor,
        renderer: (context) {
          return toolTipWidget(context);
        },
        titleSpan: titleSpanWidget(localizations.name),
      ),
      PlutoColumn(
        title: localizations.customerPoints,
        field: "custPoints",
        type: PlutoColumnType.number(),
        textAlign: PlutoColumnTextAlign.center,
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
        renderer: (context) {
          return toolTipWidget(context);
        },
        titleSpan: titleSpanWidget(localizations.customerPoints),
      ),
      // PlutoColumn(
      //   title: localizations.soldQnty,
      //   field: "outQnty",
      //   type: PlutoColumnType.number(),
      //           textAlign: PlutoColumnTextAlign.center,width: isDesktop ? width * 0.079 : width * 0.3,
      //   backgroundColor: colColor,
      //   footerRenderer: (rendererContext) {
      //     return InventoryPerformanceModel.footerRenderer(
      //         rendererContext, allOutQty);
      //   },
      // ),
    ];

    return list;
  }

  static Tooltip toolTipWidget(PlutoColumnRendererContext context) {
    return Tooltip(
      message: context.cell.value.toString(),
      child: Text(
        context.cell.value.toString(),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static TextSpan titleSpanWidget(String title) {
    return TextSpan(
      children: [
        WidgetSpan(
          child: Tooltip(
            message: title,
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
