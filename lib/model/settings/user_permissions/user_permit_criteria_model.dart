class UserPermitCriteria {
  final String txtKey;
  final String txtReportCode;
  final String txtUserCode;
  final int bolAllowed;

  UserPermitCriteria({
    required this.txtKey,
    required this.txtReportCode,
    required this.txtUserCode,
    required this.bolAllowed,
  });

  factory UserPermitCriteria.fromJson(Map<String, dynamic> json) {
    return UserPermitCriteria(
      txtKey: json['txtKey'],
      txtReportCode: json['txtReportcode'],
      txtUserCode: json['txtUsercode'],
      bolAllowed: json['bolAllowed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtKey': txtKey,
      'txtReportcode': txtReportCode,
      'txtUsercode': txtUserCode,
      'bolAllowed': bolAllowed,
    };
  }
}
