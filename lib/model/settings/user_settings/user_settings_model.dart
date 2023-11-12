class UserSettingsModel {
  String txtKey;
  String txtReportcode;
  String txtUsercode;
  String txtFiltercode;
  String txtFiltervalue;

  UserSettingsModel({
    required this.txtKey,
    required this.txtReportcode,
    required this.txtUsercode,
    required this.txtFiltercode,
    required this.txtFiltervalue,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      txtKey: json['txtKey'],
      txtReportcode: json['txtReportcode'],
      txtUsercode: json['txtUsercode'],
      txtFiltercode: json['txtFiltercode'],
      txtFiltervalue: json['txtFiltervalue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtKey': txtKey,
      'txtReportcode': txtReportcode,
      'txtUsercode': txtUsercode,
      'txtFiltercode': txtFiltercode,
      'txtFiltervalue': txtFiltervalue,
    };
  }
}
