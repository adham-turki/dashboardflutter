class CodeReportsModel {
  String txtReportcode;
  String txtReportnamee;
  int bolActive;
  String txtReportnamea;

  CodeReportsModel({
    required this.txtReportcode,
    required this.txtReportnamee,
    required this.bolActive,
    required this.txtReportnamea,
  });

  factory CodeReportsModel.fromJson(Map<String, dynamic> json) {
    return CodeReportsModel(
      txtReportcode: json['txtReportcode'] ?? "",
      txtReportnamee: json['txtReportnamee'] ?? "",
      bolActive: json['bolActive'] ?? 0,
      txtReportnamea: json['txtReportnamea'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtReportcode': txtReportcode,
      'txtReportnamee': txtReportnamee,
      'bolActive': bolActive,
      'txtReportnamea': txtReportnamea,
    };
  }
}
