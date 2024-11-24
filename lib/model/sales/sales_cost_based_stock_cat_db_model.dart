class SalesCostBasedStockCategoryDBModel {
  final double stockTransBalance;
  final double stockBalance;
  final double total;
  final double percentage;
  final String stkGroup;
  final String stkGroupName;
  final String? nameE;
  final String? stkCode;
  final String percentageName;

  SalesCostBasedStockCategoryDBModel({
    required this.stockTransBalance,
    required this.stockBalance,
    required this.total,
    required this.percentage,
    required this.stkGroup,
    required this.stkGroupName,
    this.nameE,
    this.stkCode,
    required this.percentageName,
  });

  factory SalesCostBasedStockCategoryDBModel.fromJson(
      Map<String, dynamic> json) {
    return SalesCostBasedStockCategoryDBModel(
      stockTransBalance: json['stockTransBalance'] ?? 0.0,
      stockBalance: json['stockBalance'] ?? 0.0,
      total: json['total'] ?? 0.0,
      percentage: json['percentage'] ?? 0.0,
      stkGroup: json['stkGroup'] ?? '',
      stkGroupName: json['stkGroupName'] ?? '',
      nameE: json['nameE'],
      stkCode: json['stkCode'],
      percentageName: json['percentageName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockTransBalance': stockTransBalance,
      'stockBalance': stockBalance,
      'total': total,
      'percentage': percentage,
      'stkGroup': stkGroup,
      'stkGroupName': stkGroupName,
      'nameE': nameE,
      'stkCode': stkCode,
      'percentageName': percentageName,
    };
  }
}
