import 'package:bi_replicate/utils/constants/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/constants/colors.dart';

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
    // inventoryPerformance['stkCode'] = PlutoCell(value: code ?? "");
    // inventoryPerformance['nameE'] = PlutoCell(value: name ?? "");
    // inventoryPerformance['inQnty'] = PlutoCell(value: intQty ?? 0);
    // inventoryPerformance['outQnty'] = PlutoCell(value: outQty ?? 0);

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

    salesReport.forEach((key, value) {
      print("k $key --- val ${value.value}");
    });
    print("-------------------------------------------------------");
    return PlutoRow(cells: salesReport);
  }

  static List<PlutoColumn> getColumns(
      AppLocalizations localizations, List<String> colsName) {
    List<String> fieldsName = getColumnsName(localizations, colsName);
    List<PlutoColumn> list = [];
    for (int i = 0; i < colsName.length; i++) {
      print("i $i");
      list.add(PlutoColumn(
        title: colsName[i],
        field: fieldsName[i],
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ));
    }
    // List<PlutoColumn> list = [
    //   PlutoColumn(
    //     title: localizations.code,
    //     field: "stkCode",
    //     type: PlutoColumnType.text(),
    //     width: 150,
    //     backgroundColor: colColor,
    //   ),
    //   PlutoColumn(
    //     title: localizations.name,
    //     field: "nameE",
    //     type: PlutoColumnType.text(),
    //     width: 150,
    //     backgroundColor: colColor,
    //   ),
    //   PlutoColumn(
    //     title: localizations.currentQty,
    //     field: "inQnty",
    //     type: PlutoColumnType.number(),
    //     width: 150,
    //     backgroundColor: colColor,
    //   ),
    //   PlutoColumn(
    //     title: localizations.soldQnty,
    //     field: "outQnty",
    //     type: PlutoColumnType.number(),
    //     width: 150,
    //     backgroundColor: colColor,
    //     // footerRenderer: (rendererContext) {
    //     //   return InventoryPerformanceModel.footerRenderer(
    //     //       rendererContext, allOutQty);
    //     // },
    //   ),
    // ];

    return list;
  }

  // List<String> getAllData(List<String> columnsName, BuildContext context) {
  //   AppLocalizations locale = AppLocalizations.of(context);

  //   List<String> stringList = [];

  //   for (int i = 0; i < columnsName.length; i++) {
  //     if (columnsName[i] == '#') {
  //       stringList.add(dash.toString());
  //     } else if (columnsName[i] == locale.branch) {
  //       stringList.add(branch.toString());
  //     } else if (columnsName[i] == locale.stockCategoryLevel("1")) {
  //       stringList.add(stockCategories1.toString());
  //     } else if (columnsName[i] == locale.stockCategoryLevel("2")) {
  //       stringList.add(stockCategories2.toString());
  //     } else if (columnsName[i] == locale.stockCategoryLevel("3")) {
  //       stringList.add(stockCategories3.toString());
  //     } else if (columnsName[i] == locale.supplier("1")) {
  //       stringList.add(supplier1.toString());
  //     } else if (columnsName[i] == locale.supplier("2")) {
  //       stringList.add(supplier2.toString());
  //     } else if (columnsName[i] == locale.supplier("3")) {
  //       stringList.add(supplier3.toString());
  //     } else if (columnsName[i] == locale.customer) {
  //       stringList.add(customer.toString());
  //     } else if (columnsName[i] == locale.stock) {
  //       stringList.add(stock.toString());
  //     } else if (columnsName[i] == locale.modelNo) {
  //       stringList.add(modelNo.toString());
  //     } else if (columnsName[i] == locale.qty) {
  //       stringList.add(quantity.toString());
  //     } else if (columnsName[i] == locale.averagePrice) {
  //       stringList.add(avgPrice.toString());
  //     } else if (columnsName[i] == locale.total) {
  //       stringList.add(total.toString());
  //     } else if (columnsName[i] == locale.daily) {
  //       stringList.add(daily.toString());
  //     } else if (columnsName[i] == locale.monthly) {
  //       stringList.add(monthly.toString());
  //     } else if (columnsName[i] == locale.yearly) {
  //       stringList.add(yearly.toString());
  //     } else if (columnsName[i] == locale.brand) {
  //       stringList.add(brand.toString());
  //     } else if (columnsName[i] == locale.invoice) {
  //       stringList.add(invoice.toString());
  //     }
  //   }

  //   return stringList;
  // }

  // List<String> getTotal(int length, double totalAmount, double qty,
  //     double price, BuildContext context) {
  //   List<String> stringList = [];

  //   for (int i = 0; i < length; i++) {
  //     if (i == length - 1) {
  //       stringList.add(totalAmount.toString());
  //     } else if (i == length - 2) {
  //       stringList.add(price.toString());
  //     } else if (i == length - 3) {
  //       stringList.add(qty.toString());
  //     } else if (i == length - 4) {
  //       stringList.add(AppLocalizations.of(context).totalCollections);
  //     } else {
  //       stringList.add("");
  //     }
  //   }

  //   return stringList;
  // }
}
