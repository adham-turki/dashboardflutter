class SearchCriteriaBranches {
  String? fromDate;
  String? toDate;
  int? voucherStatus;
  int? rownum;
  int? byCategory;
  String? branch;
  int? page;
  List<String>? columns;
  List<String>? customColumns;

  SearchCriteriaBranches(
      {this.fromDate,
      this.toDate,
      this.voucherStatus,
      this.rownum,
      this.byCategory,
      this.branch,
      this.page,
      this.columns,
      this.customColumns});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> searchCriteriaBranches = <String, dynamic>{};

    searchCriteriaBranches['fromDate'] = fromDate;
    searchCriteriaBranches['toDate'] = toDate;
    searchCriteriaBranches['voucherStatus'] = voucherStatus;
    searchCriteriaBranches['rownum'] = rownum;
    searchCriteriaBranches['byCategory'] = byCategory;
    searchCriteriaBranches['branch'] = branch;
    searchCriteriaBranches['page'] = page;

    return searchCriteriaBranches;
  }

  factory SearchCriteriaBranches.fromJson(Map<String, dynamic> json) {
    return SearchCriteriaBranches(
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      voucherStatus: json['voucherStatus'],
      rownum: json['rownum'],
      byCategory: json['byCategory'],
      branch: json['branch'],
      page: json['page'],
      columns:
          json['columns'] != null ? List<String>.from(json['columns']) : null,
      customColumns: json['customColumns'] != null
          ? List<String>.from(json['customColumns'])
          : null,
    );
  }
  Map<String, dynamic> noToDatetoJson() {
    final Map<String, dynamic> searchCriteriaBranches = <String, dynamic>{};

    searchCriteriaBranches['fromDate'] = fromDate;
    searchCriteriaBranches['branch'] = branch;

    searchCriteriaBranches['voucherStatus'] = voucherStatus;

    return searchCriteriaBranches;
  }

  Map<String, dynamic> statusToJson() {
    final Map<String, dynamic> searchCriteriaBranches = <String, dynamic>{};

    searchCriteriaBranches['voucherStatus'] = voucherStatus;

    return searchCriteriaBranches;
  }

  Map<String, dynamic> chequesToJson() {
    final Map<String, dynamic> searchCriteriaBranches = <String, dynamic>{};
    searchCriteriaBranches['fromDate'] = fromDate;
    searchCriteriaBranches['toDate'] = toDate;
    searchCriteriaBranches['voucherStatus'] = voucherStatus;
    searchCriteriaBranches['page'] = page;
    return searchCriteriaBranches;
  }
}
