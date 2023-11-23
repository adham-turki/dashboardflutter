class NewSearchCriteria {
  String fromJCode;
  String toJCode;
  String fromDate;
  String toDate;
  String fromAccCode;
  String toAccCode;
  String voucherStatus;
  String vouchType;
  String page;

  NewSearchCriteria({
    required this.fromJCode,
    required this.toJCode,
    required this.fromDate,
    required this.toDate,
    required this.fromAccCode,
    required this.toAccCode,
    required this.voucherStatus,
    required this.vouchType,
    required this.page,
  });

  factory NewSearchCriteria.fromJson(Map<String, dynamic> json) {
    return NewSearchCriteria(
      fromJCode: json['fromJCode'] ?? '',
      toJCode: json['toJCode'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      fromAccCode: json['fromAccCode'] ?? '',
      toAccCode: json['toAccCode'] ?? '',
      voucherStatus: json['voucherStatus'] ?? '',
      vouchType: json['vouchType'] ?? '',
      page: json['page'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fromJCode': fromJCode,
      'toJCode': toJCode,
      'fromDate': fromDate,
      'toDate': toDate,
      'fromAccCode': fromAccCode,
      'toAccCode': toAccCode,
      'voucherStatus': voucherStatus,
      'vouchType': vouchType,
      'page': page,
    };
    return data;
  }
}
