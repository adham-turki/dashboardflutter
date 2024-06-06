class SearchCriteriaDailySales {
  String? fromDate;
  String? toDate;
  int? voucherStatus;
  int? rownum;
  int? byCategory;
  String? branch;
  int? page;
  List<String>? columns;
  List<String>? customColumns;

  SearchCriteriaDailySales(
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
    final Map<String, dynamic> searchCriteriaDailySales = <String, dynamic>{};

    searchCriteriaDailySales['fromDate'] = fromDate;
    searchCriteriaDailySales['toDate'] = toDate;
    searchCriteriaDailySales['voucherStatus'] = voucherStatus;
    searchCriteriaDailySales['rownum'] = rownum;
    searchCriteriaDailySales['byCategory'] = byCategory;
    searchCriteriaDailySales['branch'] = branch;
    searchCriteriaDailySales['page'] = page;

    return searchCriteriaDailySales;
  }

  factory SearchCriteriaDailySales.fromJson(Map<String, dynamic> json) {
    return SearchCriteriaDailySales(
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
    final Map<String, dynamic> searchCriteriaDailySales = <String, dynamic>{};

    searchCriteriaDailySales['fromDate'] = fromDate;
    searchCriteriaDailySales['branch'] = branch;

    searchCriteriaDailySales['voucherStatus'] = voucherStatus;

    return searchCriteriaDailySales;
  }

  Map<String, dynamic> statusToJson() {
    final Map<String, dynamic> searchCriteriaDailySales = <String, dynamic>{};

    searchCriteriaDailySales['voucherStatus'] = voucherStatus;

    return searchCriteriaDailySales;
  }

  Map<String, dynamic> chequesToJson() {
    final Map<String, dynamic> searchCriteriaDailySales = <String, dynamic>{};
    searchCriteriaDailySales['fromDate'] = fromDate;
    searchCriteriaDailySales['toDate'] = toDate;
    searchCriteriaDailySales['voucherStatus'] = voucherStatus;
    searchCriteriaDailySales['page'] = page;
    return searchCriteriaDailySales;
  }
}
