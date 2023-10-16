class SalesBranchesmodel {
  double? totalSales;
  double? salesDis;
  double? retSalesDis;
  double? totalReturnSales;
  String? branchCode;
  String? namee;

  SalesBranchesmodel(this.totalSales, this.salesDis, this.retSalesDis,
      this.totalReturnSales, this.branchCode, this.namee);

  SalesBranchesmodel.fromJson(Map<String, dynamic> salesBranch) {
    totalSales = salesBranch['total_sales'].toString() == "null"
        ? 0.0
        : salesBranch['total_sales'];
    salesDis = salesBranch['sales_dis'].toString() == "null"
        ? 0.0
        : salesBranch['sales_dis'];
    retSalesDis = salesBranch['ret_sales_dis'].toString() == "null"
        ? 0.0
        : salesBranch['ret_sales_dis'];
    totalReturnSales = salesBranch['total_return_sales'].toString() == "null"
        ? 0.0
        : salesBranch['total_return_sales'];
    branchCode = salesBranch['branch_code'].toString() == "null"
        ? ""
        : salesBranch['branch_code'].toString();
    namee = salesBranch['namee'].toString() == "null"
        ? ""
        : salesBranch['namee'].toString();
  }
}
