import '../../sales_adminstration/branch_model.dart';

class SalesReportModel {
  int? count;
  List<BranchModel> branchModel = [];

  SalesReportModel(this.count, this.branchModel);

  SalesReportModel.fromJson(Map<String, dynamic> salesReport) {
    count =
        salesReport['count'].toString() == "null" ? 0 : salesReport['count'];

    List<Map<String, dynamic>> branch2 = [];
    List<dynamic> dynamicList = salesReport['resultAjax'];

    for (int i = 0; i < dynamicList.length; i++) {
      branch2.add(dynamicList[i]);
      branchModel.add(BranchModel.fromJson(branch2[i]));
    }
  }
}
