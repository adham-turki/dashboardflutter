import 'package:bi_replicate/model/reports/reports_result.dart';
import 'package:bi_replicate/utils/constants/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/converters.dart';

class SalesCostReportModel {
  String? dash;
  String? branch;
  String? stockCategories1;
  String? stockCategories2;
  String? stockCategories3;
  String? supplier1;
  String? supplier2;
  String? supplier3;
  String? customer;
  String? modelNo;
  double? quantity;
  double? avgPrice;
  double? total;
  String? stock;
  String? daily;
  String? yearly;
  String? monthly;
  String? brand;
  String? invoice;
  SalesCostReportModel();

  SalesCostReportModel.fromJson(Map<String, dynamic> salesReport) {
    dash = salesReport['dash'].toString() == "null" ? "" : salesReport['dash'];
    branch =
        salesReport['branch'].toString() == "null" ? "" : salesReport['branch'];

    stockCategories1 = salesReport['stockCategories1'].toString() == "null"
        ? ""
        : salesReport['stockCategories1'];

    stockCategories2 = salesReport['stockCategories2'].toString() == "null"
        ? ""
        : salesReport['stockCategories2'];

    stockCategories3 = salesReport['stockCategories3'].toString() == "null"
        ? ""
        : salesReport['stockCategories3'];

    supplier1 = salesReport['supplier1'].toString() == "null"
        ? ""
        : salesReport['supplier1'];

    supplier2 = salesReport['supplier2'].toString() == "null"
        ? ""
        : salesReport['supplier2'];

    supplier3 = salesReport['supplier3'].toString() == "null"
        ? ""
        : salesReport['supplier3'];

    customer = salesReport['customer'].toString() == "null"
        ? ""
        : salesReport['customer'];

    stock =
        salesReport['stock'].toString() == "null" ? "" : salesReport['stock'];

    modelNo = salesReport['modelNo'].toString() == "null"
        ? ""
        : salesReport['modelNo'];

    quantity = salesReport['quantity'].toString() == "null"
        ? 0.0
        : salesReport['quantity'];

    avgPrice = salesReport['avgPrice'].toString() == "null"
        ? 0.0
        : salesReport['avgPrice'];

    total =
        salesReport['total'].toString() == "null" ? 0.0 : salesReport['total'];

    yearly =
        salesReport['yearly'].toString() == "null" ? "" : salesReport['yearly'];

    daily =
        salesReport['daily'].toString() == "null" ? "" : salesReport['daily'];

    monthly = salesReport['monthly'].toString() == "null"
        ? ""
        : salesReport['monthly'];

    brand =
        salesReport['brand'].toString() == "null" ? "" : salesReport['brand'];

    invoice = salesReport['invoice'].toString() == "null"
        ? ""
        : salesReport['invoice'];
  }
  PlutoRow toPluto() {
    final Map<String, PlutoCell> salesReport = <String, PlutoCell>{};

    salesReport['dash'] = PlutoCell(value: dash ?? "");
    salesReport['branch'] = PlutoCell(value: branch ?? "");
    salesReport['stockCategories1'] = PlutoCell(value: stockCategories1 ?? "");
    salesReport['stockCategories2'] = PlutoCell(value: stockCategories2 ?? "");
    salesReport['stockCategories3'] = PlutoCell(value: stockCategories3 ?? "");
    salesReport['supplier1'] = PlutoCell(value: supplier1 ?? "");
    salesReport['supplier2'] = PlutoCell(value: supplier2 ?? "");
    salesReport['supplier3'] = PlutoCell(value: supplier3 ?? "");
    salesReport['customer'] = PlutoCell(value: customer ?? "");
    salesReport['stock'] = PlutoCell(value: stock ?? "");
    salesReport['modelNo'] = PlutoCell(value: modelNo ?? "");
    salesReport['quantity'] = PlutoCell(value: quantity ?? 0.0);
    salesReport['avgPrice'] = PlutoCell(value: avgPrice ?? 0.0);
    salesReport['total'] = PlutoCell(value: total ?? 0.0);
    salesReport['yearly'] = PlutoCell(value: yearly ?? "");
    salesReport['daily'] = PlutoCell(value: daily ?? "");
    salesReport['monthly'] = PlutoCell(value: monthly ?? "");
    salesReport['brand'] = PlutoCell(value: brand ?? "");
    salesReport['invoice'] = PlutoCell(value: invoice ?? "");

    return PlutoRow(cells: salesReport);
  }

  static List<PlutoColumn> getColumns(
      AppLocalizations localizations,
      List<String> colsName,
      ReportsResult? reportsResult,
      BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isDesktop = Responsive.isDesktop(context);
    List<String> fieldsName = getColumnsName(localizations, colsName, true);
    List<PlutoColumn> list = [];
    if (reportsResult == null) {}
    for (int i = 0; i < colsName.length; i++) {
      list.add(PlutoColumn(
        title: colsName[i],
        field: fieldsName[i],
        type: fieldsName[i] == 'avgPrice' ||
                fieldsName[i] == 'quantity' ||
                fieldsName[i] == 'total'
            ? PlutoColumnType.number()
            : PlutoColumnType.text(),
        width: isDesktop
            ? fieldsName[i] == 'dash'
                ? width * .04
                : width * .13
            : width * 0.32,
        backgroundColor: colColor,
        footerRenderer: fieldsName[i] == 'avgPrice' && reportsResult != null
            ? (rendererContext) {
                return footerRenderer(rendererContext, reportsResult.avgPrice!);
              }
            : fieldsName[i] == 'quantity' && reportsResult != null
                ? (rendererContext) {
                    return footerRenderer(
                        rendererContext, reportsResult.quantity!);
                  }
                : fieldsName[i] == 'total' && reportsResult != null
                    ? (rendererContext) {
                        return footerRenderer(
                            rendererContext, reportsResult.total!);
                      }
                    : null,
      ));
    }

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
