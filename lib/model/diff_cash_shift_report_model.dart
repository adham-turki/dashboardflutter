class DiffCashShiftReportModel {
  String user;
  String branch;
  double diffSum;
  int diffCount;

  DiffCashShiftReportModel({
    required this.user,
    required this.branch,
    required this.diffSum,
    required this.diffCount,
  });

  factory DiffCashShiftReportModel.fromJson(Map<String, dynamic> json) =>
      DiffCashShiftReportModel(
        user: json['user'] ?? "",
        branch: json['branch'] ?? "",
        diffSum: json['diffSum'] ?? 0.0,
        diffCount: json['diffCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'branch': branch,
        'diffSum': diffSum,
        'diffCount': diffCount,
      };
}
