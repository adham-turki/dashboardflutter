class ReportsResult {
  double? quantity;
  double? avgPrice;
  double? total;
  int? count;
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
  }
}
