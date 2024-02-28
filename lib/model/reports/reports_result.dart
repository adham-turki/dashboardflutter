class ReportsResult {
  double? quantity;
  double? avgPrice;
  double? total;
  int? count;
  double? costPriceRate;
  double? totalCost;
  double? differCostSale;
  String? profitRatio;
  ReportsResult();
  ReportsResult.fromJson(Map<String, dynamic> reportsResult) {
    quantity = reportsResult['quantity'].toString() == 'null'
        ? 0.0
        : reportsResult['quantity'];
    avgPrice = reportsResult['avgPrice'].toString() == "null"
        ? 0.0
        : reportsResult['avgPrice'];
    total = reportsResult['total'].toString() == 'null'
        ? 0.0
        : reportsResult['total'];
    count = reportsResult['count'].toString() == "null"
        ? 0
        : reportsResult['count'];

    costPriceRate = reportsResult['costPriceRate'].toString() == 'null'
        ? 0.0
        : reportsResult['costPriceRate'];
    totalCost = reportsResult['totalCost'].toString() == "null"
        ? 0.0
        : reportsResult['totalCost'];
    differCostSale = reportsResult['differCostSale'].toString() == 'null'
        ? 0.0
        : reportsResult['differCostSale'];
    profitRatio = reportsResult['profitRatio'].toString() == "null"
        ? ""
        : reportsResult['profitRatio'];
  }
}
