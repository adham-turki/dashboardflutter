class BranchSalesDBModel {
  final String branch;
  final String branchName;
  final double totalSales;
  final String groupCode;
  final String groupName;

  BranchSalesDBModel({
    required this.branch,
    required this.branchName,
    required this.totalSales,
    required this.groupCode,
    required this.groupName,
  });

  factory BranchSalesDBModel.fromJson(Map<String, dynamic> json) {
    return BranchSalesDBModel(
      branch: json['branch'] ?? '',
      branchName: json['branchName'] ?? '',
      totalSales: json['totalSales'] ?? 0.0,
      groupCode: json['groupCode'] ?? '',
      groupName: json['groupName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'branchName': branchName,
      'totalSales': totalSales,
      'groupCode': groupCode,
      'groupName': groupName,
    };
  }
}
