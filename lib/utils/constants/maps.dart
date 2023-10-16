import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<String, dynamic> branchesMap = {};

void setBranchesMap(AppLocalizations local, Map<String, dynamic> branches) {
  branchesMap.addAll({});
  branchesMap[local.all] = "";
  branchesMap.addAll(branches);
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

Map<String, int> byCategoryMap = {
  'Brands': 1,
  'Categorie1': 2,
  'Categorie2': 3,
  'Classification': 4
};

List<String> getColumns(AppLocalizations locale, List<String> columns) {
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
    locale.averagePrice: "averagePrice",
    locale.total: "total",
    locale.daily: "daily",
    locale.monthly: "monthly",
    locale.yearly: "yearly",
    locale.brand: "brand",
    locale.invoice: "invoice"
  };

  List<String> columnsName = [];
  for (int i = 0; i < columns.length; i++) {
    columnsName.add(columnsMap[columns[i]]!);
    print(columnsName[i]);
  }
  return columnsName;
}
