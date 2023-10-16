class TotalSalesResult {
  double? inQnty;
  double? outQnty;
  double? netSold;
  double? debit;
  double? credit;
  double? totalAmount;
  int? count;
  TotalSalesResult();
  TotalSalesResult.fromJson(Map<String, dynamic> totalSales) {
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
    count = totalSales['count'].toString() == "null" ? 0 : totalSales['count'];
  }
}
