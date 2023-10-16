import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? stockBarcode;
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
    stockBarcode = purchaseReport['stockBarcode'].toString() == "null"
        ? ""
        : purchaseReport['stockBarcode'];
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

  List<String> getAllData(List<String> columnsName, BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context);

    List<String> stringList = [];

    for (int i = 0; i < columnsName.length; i++) {
      if (columnsName[i] == '#') {
        stringList.add(dash.toString());
      } else if (columnsName[i] == locale.branch) {
        stringList.add(branch.toString());
      } else if (columnsName[i] == locale.stockCategoryLevel("1")) {
        stringList.add(stockCategories1.toString());
      } else if (columnsName[i] == locale.stockCategoryLevel("2")) {
        stringList.add(stockCategories2.toString());
      } else if (columnsName[i] == locale.stockCategoryLevel("3")) {
        stringList.add(stockCategories3.toString());
      } else if (columnsName[i] == locale.supplier("1")) {
        stringList.add(supplier1.toString());
      } else if (columnsName[i] == locale.supplier("2")) {
        stringList.add(supplier2.toString());
      } else if (columnsName[i] == locale.supplier("3")) {
        stringList.add(supplier3.toString());
      } else if (columnsName[i] == locale.stockCode) {
        stringList.add(stockCode.toString());
      } else if (columnsName[i] == locale.stockBarcode) {
        stringList.add(stockBarcode.toString());
      } else if (columnsName[i] == locale.stock) {
        stringList.add(stock.toString());
      } else if (columnsName[i] == locale.modelNo) {
        stringList.add(modelNo.toString());
      } else if (columnsName[i] == locale.qty) {
        stringList.add(quantity.toString());
      } else if (columnsName[i] == locale.averagePrice) {
        stringList.add(avgPrice.toString());
      } else if (columnsName[i] == locale.total) {
        stringList.add(total.toString());
      } else if (columnsName[i] == locale.daily) {
        stringList.add(daily.toString());
      } else if (columnsName[i] == locale.monthly) {
        stringList.add(monthly.toString());
      } else if (columnsName[i] == locale.yearly) {
        stringList.add(yearly.toString());
      } else if (columnsName[i] == locale.brand) {
        stringList.add(brand.toString());
      } else if (columnsName[i] == locale.invoice) {
        stringList.add(invoice.toString());
      }
    }

    return stringList;
  }

  List<String> getTotal(int length, double totalAmount, double qty,
      double price, BuildContext context) {
    List<String> stringList = [];

    for (int i = 0; i < length; i++) {
      if (i == length - 1) {
        stringList.add(totalAmount.toString());
      } else if (i == length - 2) {
        stringList.add(price.toString());
      } else if (i == length - 3) {
        stringList.add(qty.toString());
      } else if (i == length - 4) {
        stringList.add(AppLocalizations.of(context).totalCollections);
      } else {
        stringList.add("");
      }
    }

    return stringList;
  }
}
