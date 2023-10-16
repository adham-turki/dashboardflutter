class SalesCategoryModel {
  double? creditAmt;
  double? debitAmt;
  String? categoryName;

  SalesCategoryModel(this.creditAmt, this.debitAmt, this.categoryName);

  SalesCategoryModel.fromJson(Map<String, dynamic> salesCategory) {
    creditAmt = salesCategory['creditAmt'].toString() == "null"
        ? 0.0
        : salesCategory['creditAmt'];
    debitAmt = salesCategory['debitAmt'].toString() == "null"
        ? 0.0
        : salesCategory['debitAmt'];
    categoryName = salesCategory['categoryName'].toString() == "null"
        ? ""
        : salesCategory['categoryName'];
  }
}
