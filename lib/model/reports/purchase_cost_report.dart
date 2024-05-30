import 'package:bi_replicate/model/reports/reports_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/maps.dart';
import '../../utils/constants/responsive.dart';
import '../../utils/constants/styles.dart';
import '../../utils/func/converters.dart';

class PurchaseCostReportModel {
  String? dash;
  String? branch;
  String? stockCategories1;
  String? stockCategories2;
  String? stockCategories3;
  String? supplier1;
  String? supplier2;
  String? supplier3;
  String? stockCode;
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
  PurchaseCostReportModel();

  PurchaseCostReportModel.fromJson(Map<String, dynamic> purchaseReport) {
    dash = purchaseReport['dash'].toString() == "null"
        ? ""
        : purchaseReport['dash'];
    branch = purchaseReport['branch'].toString() == "null"
        ? ""
        : purchaseReport['branch'];

    stockCategories1 = purchaseReport['stockCategories1'].toString() == "null"
        ? ""
        : purchaseReport['stockCategories1'];

    stockCategories2 = purchaseReport['stockCategories2'].toString() == "null"
        ? ""
        : purchaseReport['stockCategories2'];

    stockCategories3 = purchaseReport['stockCategories3'].toString() == "null"
        ? ""
        : purchaseReport['stockCategories3'];

    supplier1 = purchaseReport['supplier1'].toString() == "null"
        ? ""
        : purchaseReport['supplier1'];

    supplier2 = purchaseReport['supplier2'].toString() == "null"
        ? ""
        : purchaseReport['supplier2'];

    supplier3 = purchaseReport['supplier3'].toString() == "null"
        ? ""
        : purchaseReport['supplier3'];

    stockCode = purchaseReport['stockCode'].toString() == "null"
        ? ""
        : purchaseReport['stockCode'];
    stock = purchaseReport['stock'].toString() == "null"
        ? ""
        : purchaseReport['stock'];

    modelNo = purchaseReport['modelNo'].toString() == "null"
        ? ""
        : purchaseReport['modelNo'];

    quantity = purchaseReport['quantity'].toString() == "null"
        ? 0.0
        : purchaseReport['quantity'];

    avgPrice = purchaseReport['averagePrice'].toString() == "null"
        ? 0.0
        : purchaseReport['averagePrice'];

    total = purchaseReport['total'].toString() == "null"
        ? 0.0
        : purchaseReport['total'];

    yearly = purchaseReport['yearly'].toString() == "null"
        ? ""
        : purchaseReport['yearly'];

    daily = purchaseReport['daily'].toString() == "null"
        ? ""
        : purchaseReport['daily'];

    monthly = purchaseReport['monthly'].toString() == "null"
        ? ""
        : purchaseReport['monthly'];

    brand = purchaseReport['brand'].toString() == "null"
        ? ""
        : purchaseReport['brand'];

    invoice = purchaseReport['invoice'].toString() == "null"
        ? ""
        : purchaseReport['invoice'];
  }

  PlutoRow toPluto() {
    final Map<String, PlutoCell> purchaseReport = <String, PlutoCell>{};

    purchaseReport['dash'] = PlutoCell(value: dash ?? "");
    purchaseReport['branch'] = PlutoCell(value: branch ?? "");
    purchaseReport['stockCategories1'] =
        PlutoCell(value: stockCategories1 ?? "");
    purchaseReport['stockCategories2'] =
        PlutoCell(value: stockCategories2 ?? "");
    purchaseReport['stockCategories3'] =
        PlutoCell(value: stockCategories3 ?? "");
    purchaseReport['supplier1'] = PlutoCell(value: supplier1 ?? "");
    purchaseReport['supplier2'] = PlutoCell(value: supplier2 ?? "");
    purchaseReport['supplier3'] = PlutoCell(value: supplier3 ?? "");
    purchaseReport['stock'] = PlutoCell(value: stock ?? "");
    purchaseReport['modelNo'] = PlutoCell(value: modelNo ?? "");
    purchaseReport['quantity'] = PlutoCell(value: quantity ?? 0.0);
    purchaseReport['averagePrice'] = PlutoCell(value: avgPrice ?? 0.0);
    purchaseReport['total'] = PlutoCell(value: total ?? 0.0);
    purchaseReport['yearly'] = PlutoCell(value: yearly ?? "");
    purchaseReport['daily'] = PlutoCell(value: daily ?? "");
    purchaseReport['monthly'] = PlutoCell(value: monthly ?? "");
    purchaseReport['brand'] = PlutoCell(value: brand ?? "");
    purchaseReport['invoice'] = PlutoCell(value: invoice ?? "");

    return PlutoRow(cells: purchaseReport);
  }

  static List<PlutoColumn> getColumns(
      AppLocalizations localizations,
      List<String> colsName,
      ReportsResult? reportsResult,
      BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isDesktop = Responsive.isDesktop(context);
    List<String> fieldsName = getColumnsName(localizations, colsName, false);
    List<PlutoColumn> list = [];
    for (int i = 0; i < colsName.length; i++) {
      list.add(PlutoColumn(
        title: colsName[i],
        field: fieldsName[i],
        type: fieldsName[i] == 'averagePrice' ||
                fieldsName[i] == 'quantity' ||
                fieldsName[i] == 'total'
            ? PlutoColumnType.number()
            : PlutoColumnType.text(),
        width: isDesktop
            ? fieldsName[i] == 'dash'
                ? width * .04
                : width * .13
            : width * 0.36,
        backgroundColor: columnColors,
        footerRenderer: fieldsName[i] == 'averagePrice' && reportsResult != null
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
