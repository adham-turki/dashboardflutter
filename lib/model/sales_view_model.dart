import 'sales/sales_db_model.dart';

class BranchSalesViewModel {
  final String displayBranch;
  final String displayBranchName;
  final String displayTotalSales;
  final String displayGroupCode;
  final String displayGroupName;
  final String displayTransType;
  final String displayLogsCount;
  final String displaytransTypeName;

  BranchSalesViewModel({
    required this.displayBranch,
    required this.displayBranchName,
    required this.displayTotalSales,
    required this.displayGroupCode,
    required this.displayGroupName,
    required this.displayTransType,
    required this.displayLogsCount,
    required this.displaytransTypeName,
  });

  factory BranchSalesViewModel.fromDBModel(BranchSalesDBModel dbModel) {
    return BranchSalesViewModel(
      displayBranch: dbModel.branch,
      displayBranchName: dbModel.branchName,
      displayTotalSales: dbModel.totalSales.toStringAsFixed(2),
      displayGroupCode: dbModel.groupCode,
      displayGroupName: dbModel.groupName,
      displayTransType: dbModel.transType.toString(),
      displayLogsCount: dbModel.logsCount.toString(),
      displaytransTypeName: dbModel.transTypeName,
    );
  }
}
