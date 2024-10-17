class SalesCategoryModel {
  double? creditAmt;
  double? debitAmt;
  String? categoryName;

  SalesCategoryModel(this.creditAmt, this.debitAmt, this.categoryName);

  SalesCategoryModel.fromJson(Map<String, dynamic> salesCategory) {
    creditAmt = salesCategory['creditAmt'].toString() == "null"
        ? 0.0
        : (salesCategory['creditAmt'] is int)
            ? (salesCategory['creditAmt'] as int).toDouble()
            : (salesCategory['creditAmt'] as double);
    debitAmt = salesCategory['creditAmt'].toString() == "null"
        ? 0.0
        : (salesCategory['debitAmt'] is int)
            ? (salesCategory['debitAmt'] as int).toDouble()
            : (salesCategory['debitAmt'] as double);
    categoryName = salesCategory['categoryName'].toString() == "null"
        ? ""
        : salesCategory['categoryName'];
  }
}
