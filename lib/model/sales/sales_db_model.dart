class BranchSalesDBModel {
  final String branch;
  final String branchName;
  final double totalSales;
  final String groupCode;
  final String groupName;
  final int transType;
  final int logsCount;
  final String transTypeName;

  BranchSalesDBModel({
    required this.branch,
    required this.branchName,
    required this.totalSales,
    required this.groupCode,
    required this.groupName,
    required this.transType,
    required this.logsCount,
    required this.transTypeName,
  });

  factory BranchSalesDBModel.fromJson(Map<String, dynamic> json) {
    return BranchSalesDBModel(
      branch: json['branch'] ?? '',
      branchName: json['branchName'] ?? '',
      totalSales: json['totalSales'] ?? 0.0,
      groupCode: json['groupCode'] ?? '',
      groupName: json['groupName'] ?? '',
      transType: json['transType'] ?? 0,
      logsCount: json['logsCount'] ?? 0,
      transTypeName: json['transTypeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'branchName': branchName,
      'totalSales': totalSales,
      'groupCode': groupCode,
      'groupName': groupName,
      'transType': transType,
      'logsCount': logsCount,
      'transTypeName': transTypeName,
    };
  }
}
