import 'package:bi_replicate/model/sales/sales_cost_based_stock_cat_db_model.dart';

class SalesCostBasedStockCategoryViewModel {
  final String stockTransBalance;
  final String stockBalance;
  final String total;
  final String percentage;
  final String stkGroupName;
  final String percentageName;

  SalesCostBasedStockCategoryViewModel({
    required this.stockTransBalance,
    required this.stockBalance,
    required this.total,
    required this.percentage,
    required this.stkGroupName,
    required this.percentageName,
  });

  factory SalesCostBasedStockCategoryViewModel.fromDBModel(
      SalesCostBasedStockCategoryDBModel dbModel) {
    return SalesCostBasedStockCategoryViewModel(
      stockTransBalance: dbModel.stockTransBalance.toStringAsFixed(2),
      stockBalance: dbModel.stockBalance.toStringAsFixed(2),
      total: dbModel.total.toStringAsFixed(2),
      percentage: "${dbModel.percentage.toStringAsFixed(2)}%",
      stkGroupName: dbModel.stkGroupName,
      percentageName: dbModel.percentageName,
    );
  }
}
