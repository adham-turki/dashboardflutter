class BranchSalesByStocksModel {
  double creditAmt;
  double debitAmt;
  String stockCode;
  String stockName;
  double? total;

  BranchSalesByStocksModel(
      {required this.creditAmt,
      required this.debitAmt,
      required this.stockCode,
      required this.stockName,
      this.total});

  factory BranchSalesByStocksModel.fromJson(Map<String, dynamic> json) =>
      BranchSalesByStocksModel(
        creditAmt: json['creditAmt'] ?? 0.0,
        debitAmt: json['debitAmt'] ?? 0.0,
        stockCode: json['stockCode'] ?? "",
        stockName: json['stockName'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'creditAmt': creditAmt,
        'debitAmt': debitAmt,
        'stockCode': stockCode,
        'stockName': stockName,
      };
}
