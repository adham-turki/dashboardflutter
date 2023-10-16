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
        : double.parse(salesBranch['total_sales'].toString());
    salesDis = salesBranch['sales_dis'].toString() == "null"
        ? 0.0
        : double.parse(salesBranch['sales_dis'].toString());
    retSalesDis = salesBranch['ret_sales_dis'].toString() == "null"
        ? 0.0
        : double.parse(salesBranch['ret_sales_dis'].toString());
    totalReturnSales = salesBranch['total_return_sales'].toString() == "null"
        ? 0.0
        : double.parse(salesBranch['total_return_sales'].toString());
    branchCode = salesBranch['branch_code'].toString() == "null"
        ? ""
        : salesBranch['branch_code'].toString();
    namee = salesBranch['namee'].toString() == "null"
        ? ""
        : salesBranch['namee'].toString();
  }
}
