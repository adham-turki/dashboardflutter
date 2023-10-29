import 'package:bi_replicate/model/reports/total_sales/total_sales_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/converters.dart';

class TotalSalesModel {
  String? code;
  String? name;
  double? inQnty;
  double? outQnty;
  double? netSold;
  double? debit;
  double? credit;
  double? totalAmount;
  double? count;
  int? counter = 0;
  TotalSalesModel(this.code, this.name, this.inQnty, this.outQnty, this.netSold,
      this.debit, this.credit, this.totalAmount, this.count);

  TotalSalesModel.fromJson(Map<String, dynamic> totalSales, int countNum) {
    code = totalSales['code'].toString() == "null"
        ? ""
        : totalSales['code'].toString();
    name = totalSales['name'].toString() == "null"
        ? ""
        : totalSales['name'].toString();
    inQnty =
        totalSales['inQnty'].toString() == "null" ? 0.0 : totalSales['inQnty'];
    outQnty = totalSales['outQnty'].toString() == 'null'
        ? 0.0
        : totalSales['outQnty'];

    netSold = totalSales['netSold'].toString() == "null"
        ? 0.0
        : totalSales['netSold'];
    debit =
        totalSales['debit'].toString() == 'null' ? 0.0 : totalSales['debit'];
    credit =
        totalSales['credit'].toString() == "null" ? 0.0 : totalSales['credit'];
    totalAmount = totalSales['totalAmount'].toString() == 'null'
        ? 0.0
        : totalSales['totalAmount'];
    count =
        totalSales['count'].toString() == "null" ? 0.0 : totalSales['count'];
    counter = countNum;
  }

  PlutoRow toPluto() {
    final Map<String, PlutoCell> totalSales = <String, PlutoCell>{};
    totalSales['code'] = PlutoCell(value: code ?? "");
    totalSales['name'] = PlutoCell(value: name ?? "");
    totalSales['inQnty'] = PlutoCell(value: inQnty ?? 0);
    totalSales['outQnty'] = PlutoCell(value: outQnty ?? 0);
    totalSales['netSold'] = PlutoCell(value: netSold ?? 0);
    totalSales['debit'] = PlutoCell(value: debit ?? 0);
    totalSales['credit'] = PlutoCell(value: credit ?? 0);
    totalSales['totalAmount'] = PlutoCell(value: totalAmount ?? 0);
    totalSales['count'] = PlutoCell(value: count ?? 0);
    return PlutoRow(cells: totalSales);
  }

  static List<PlutoColumn> getColumns(AppLocalizations localizations,
      TotalSalesResult? reportResult, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // int numberOfColumns = 4;
    // double width *0.15 = totalWidth / numberOfColumns;
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.code,
        field: "code",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.07 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.name,
        field: "name",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.14 : width * 0.3,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.returnQty,
        field: "inQnty",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.inQnty!);
              }
            : null,
      ),
      PlutoColumn(
        title: localizations.salesQty,
        field: "outQnty",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.12 : width * 0.3,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.outQnty!);
              }
            : null,
      ),
      PlutoColumn(
        title: localizations.netSalesQty,
        field: "netSold",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.12 : width * 0.3,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.netSold!);
              }
            : null,
      ),
      PlutoColumn(
        title: localizations.returnAmount,
        field: "debit",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.12 : width * 0.3,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.debit!);
              }
            : null,
      ),
      PlutoColumn(
        title: localizations.salesAmount,
        field: "credit",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.12 : width * 0.3,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.credit!);
              }
            : null,
      ),
      PlutoColumn(
        title: localizations.netSalesAmount,
        field: "totalAmount",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.5,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.totalAmount!);
              }
            : null,
      ),
    ];

    return list;
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
            text: Converters.formatNumber(valueAll),
            style: gridFooterStyle,
          ),
        ];
      },
    );
  }
}
