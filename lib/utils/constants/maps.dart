import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<String, dynamic> branchesMap = {};
Map<String, dynamic> branchesMap2 = {};

void setBranchesMap(AppLocalizations local, Map<String, dynamic> branches) {
  branchesMap.addAll({});
  branchesMap[local.all] = "";
  branchesMap.addAll(branches);
  branchesMap2[""] = local.all;
  branches.forEach((key, value) {
    branchesMap2[value] = key;
  });
}

Map<String, dynamic> getBranch() => branchesMap;
int getVoucherStatus(AppLocalizations local, String status) {
  Map<String, int> voucherStatusMap = {
    local.all: -100,
    local.posted: 0,
    local.draft: -1,
    local.canceled: 1
  };
  return voucherStatusMap[status]!;
}

getCategoryNum(String selectedCategories, AppLocalizations locale) {
  Map<String, int> byCategoryMap = {
    locale.brands: 1,
    locale.categories("1"): 2,
    locale.categories("2"): 3,
    locale.classifications: 4
  };
  return byCategoryMap[selectedCategories];
}

// List<String> getColumnsName(
//     AppLocalizations locale, List<String> columns, bool sales) {
//   Map<String, String> columnsMap = {
//     '#': "dash",
//     locale.branch: "branch",
//     locale.stockCategoryLevel("1"): "stockCategories1",
//     locale.stockCategoryLevel("2"): "stockCategories2",
//     locale.stockCategoryLevel("3"): "stockCategories3",
//     locale.supplier("1"): "supplier1",
//     locale.supplier("2"): "supplier2",
//     locale.supplier("3"): "supplier3",
//     locale.customer: "customer",
//     locale.stock: "stock",
//     locale.modelNo: "modelNo",
//     locale.qty: "quantity",
//     locale.averagePrice: sales == true ? "avgPrice" : "averagePrice",
//     locale.total: "total",
//     locale.daily: "daily",
//     locale.monthly: "monthly",
//     locale.yearly: "yearly",
//     locale.brand: "brand",
//     locale.invoice: "invoice",
//     locale.costPriceAvg: "costPriceRate",
//     locale.totalCost: "totalCost",
//     locale.diffBetCostAndSale: "differCostSale",
//     locale.profitPercent: "profitRatio"
//   };

//   List<String> columnsName = [];
//   for (int i = 0; i < columns.length; i++) {
//     columnsName.add(columnsMap[columns[i]]!);
//   }
//   return columnsName;
// }
List<String> getColumnsName(
    AppLocalizations locale, List<String> columns, bool sales) {
  Map<String, String> columnsMap = {
    '#': "dash",
    locale.branch: "branch",
    locale.stockCategoryLevel("1"): "stockCategories1",
    locale.stockCategoryLevel("2"): "stockCategories2",
    locale.stockCategoryLevel("3"): "stockCategories3",
    locale.supplier("1"): "supplier1",
    locale.supplier("2"): "supplier2",
    locale.supplier("3"): "supplier3",
    locale.customer: "customer",
    locale.stock: "stock",
    locale.modelNo: "modelNo",
    locale.qty: "quantity",
    locale.averagePrice: sales == true ? "avgPrice" : "averagePrice",
    locale.total: "total",
    locale.daily: "daily",
    locale.monthly: "monthly",
    locale.yearly: "yearly",
    locale.brand: "brand",
    locale.invoice: "invoice",
    locale.costPriceAvg: "costPriceRate",
    locale.totalCost: "totalCost",
    locale.diffBetCostAndSale: "differCostSale",
    locale.profitPercent: "profitRatio",
  };

  List<String> columnsName = [];
  for (int i = 0; i < columns.length; i++) {
    columnsName.add(columnsMap[columns[i]]!);
  }
  return columnsName;
}

List<String> getCustomColumnsName(
    AppLocalizations locale, List<String> columns, bool sales) {
  Map<String, String> columnsMap = {
    '#': "dash",
    locale.branch: locale.branch,
    locale.stockCategoryLevel("1"): locale.stockCategoryLevel("1"),
    locale.stockCategoryLevel("2"): locale.stockCategoryLevel("2"),
    locale.stockCategoryLevel("3"): locale.stockCategoryLevel("3"),
    locale.supplier("1"): locale.supplier("1"),
    locale.supplier("2"): locale.supplier("2"),
    locale.supplier("3"): locale.supplier("3"),
    locale.customer: locale.customer,
    locale.stock: locale.stock,
    locale.modelNo: locale.modelNo,
    locale.qty: locale.qty,
    locale.averagePrice:
        sales == true ? locale.averagePrice : locale.averagePrice,
    locale.total: locale.total,
    locale.daily: locale.daily,
    locale.monthly: locale.monthly,
    locale.yearly: locale.yearly,
    locale.brand: locale.brand,
    locale.invoice: locale.invoice,
    locale.costPriceAvg: locale.costPriceAvg,
    locale.totalCost: locale.totalCost,
    locale.diffBetCostAndSale: locale.diffBetCostAndSale,
    locale.profitPercent: locale.profitPercent
  };

  List<String> columnsName = [];
  for (int i = 0; i < columns.length; i++) {
    columnsName.add(columnsMap[columns[i]]!);
  }
  return columnsName;
}
