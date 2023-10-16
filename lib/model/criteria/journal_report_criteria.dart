class JournalReportCriteria {
  String? fromJCode;
  String? toJCode;
  String? fromDate;
  String? toDate;
  String? fromAccCode;
  String? toAccCode;
  int? page;

  JournalReportCriteria({
    this.fromJCode,
    this.toJCode,
    this.fromDate,
    this.toDate,
    this.fromAccCode,
    this.toAccCode,
    this.page,
  });

  JournalReportCriteria.fromJson(Map<String, dynamic> json) {
    fromJCode = json['fromJCode'];
    toJCode = json['toJCode'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    fromAccCode = json['fromAccCode'];
    toAccCode = json['toAccCode'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fromJCode'] = fromJCode;
    data['toJCode'] = toJCode;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['fromAccCode'] = fromAccCode;
    data['toAccCode'] = toAccCode;
    data['page'] = page;
    return data;
  }
}
