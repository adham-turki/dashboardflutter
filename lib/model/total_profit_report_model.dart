class TotalProfitReportModel {
  String code;
  String name;
  double totalSales;
  double totalProfit;
  double percentage;

  TotalProfitReportModel({
    required this.code,
    required this.name,
    required this.totalSales,
    required this.totalProfit,
    required this.percentage,
  });

  factory TotalProfitReportModel.fromJson(Map<String, dynamic> json) =>
      TotalProfitReportModel(
        code: json['code'] ?? "",
        name: json['name'] ?? "",
        totalSales: json['totalSales'] ?? 0.0,
        totalProfit: json['totalProfit'] ?? 0.0,
        percentage: json['percentage'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'totalSales': totalSales,
        'totalProfit': totalProfit,
        'percentage': percentage,
      };
}
