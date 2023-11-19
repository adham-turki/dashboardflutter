class UserReportSettingsModel {
  String txtKey;
  String txtReportcode;
  String txtUsercode;
  String txtJsoncrit;
  int bolAutosave;

  UserReportSettingsModel(
      {required this.txtKey,
      required this.txtReportcode,
      required this.txtUsercode,
      required this.txtJsoncrit,
      required this.bolAutosave});

  factory UserReportSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserReportSettingsModel(
      txtKey: json['txtKey'] ?? "",
      txtReportcode: json['txtReportcode'] ?? "",
      txtUsercode: json['txtUsercode'] ?? "",
      txtJsoncrit: json['txtJsoncrit'] ?? "",
      bolAutosave: json['bolAutosave'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtKey': txtKey,
      'txtReportcode': txtReportcode,
      'txtUsercode': txtUsercode,
      'txtJsoncrit': txtJsoncrit,
      'bolAutosave': bolAutosave,
    };
  }
}
