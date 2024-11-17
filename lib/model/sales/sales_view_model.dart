import 'package:bi_replicate/model/sales_db_model.dart';

class BranchSalesViewModel {
  final String displayBranch;
  final String displayBranchName;
  final String displayTotalSales;
  final String displayGroupCode;
  final String displayGroupName;

  BranchSalesViewModel({
    required this.displayBranch,
    required this.displayBranchName,
    required this.displayTotalSales,
    required this.displayGroupCode,
    required this.displayGroupName,
  });

  factory BranchSalesViewModel.fromDBModel(BranchSalesDBModel dbModel) {
    return BranchSalesViewModel(
      displayBranch: dbModel.branch,
      displayBranchName: dbModel.branchName,
      displayTotalSales: dbModel.totalSales.toStringAsFixed(2),
      displayGroupCode: dbModel.groupCode,
      displayGroupName: dbModel.groupName,
    );
  }
}
