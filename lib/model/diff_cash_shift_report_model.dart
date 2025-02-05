class DiffCashShiftReportModel {
  String user;
  String branchCode;
  String branchName;
  double diffSum;
  int diffCount;

  DiffCashShiftReportModel({
    required this.user,
    required this.branchCode,
    required this.branchName,
    required this.diffSum,
    required this.diffCount,
  });

  factory DiffCashShiftReportModel.fromJson(Map<String, dynamic> json) =>
      DiffCashShiftReportModel(
        user: json['user'] ?? "",
        branchCode: json['branchCode'] ?? "",
        branchName: json['branchName'] ?? "",
        diffSum: json['diffSum'] ?? 0.0,
        diffCount: json['diffCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'branchCode': branchCode,
        'branchName': branchName,
        'diffSum': diffSum,
        'diffCount': diffCount,
      };
}
