class SearchCriteria {
  String? fromDate;
  String? toDate;
  int? voucherStatus;
  int? rownum;
  int? byCategory;
  String? branch;
  int? page;
  List<String>? columns;
  List<String>? customColumns;
  List<String>? codesStock;

  SearchCriteria(
      {this.fromDate,
      this.toDate,
      this.voucherStatus,
      this.rownum,
      this.byCategory,
      this.branch,
      this.page,
      this.columns,
      this.customColumns,
      this.codesStock});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> searchCriteria = <String, dynamic>{};

    searchCriteria['fromDate'] = fromDate;
    searchCriteria['toDate'] = toDate;
    searchCriteria['voucherStatus'] = voucherStatus;
    searchCriteria['rownum'] = rownum;
    searchCriteria['byCategory'] = byCategory;
    searchCriteria['branch'] = branch;
    searchCriteria['page'] = page;
    searchCriteria['codesStock'] = codesStock;
    return searchCriteria;
  }

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      fromDate: json['fromDate'].toString() == "null" ? "" : json['fromDate'],
      toDate: json['toDate'].toString() == "null" ? "" : json['toDate'],
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
    final Map<String, dynamic> searchCriteria = <String, dynamic>{};

    searchCriteria['fromDate'] = fromDate;
    searchCriteria['branch'] = branch;

    searchCriteria['voucherStatus'] = voucherStatus;

    return searchCriteria;
  }

  Map<String, dynamic> statusToJson() {
    final Map<String, dynamic> searchCriteria = <String, dynamic>{};

    searchCriteria['voucherStatus'] = voucherStatus;

    return searchCriteria;
  }

  Map<String, dynamic> chequesToJson() {
    final Map<String, dynamic> searchCriteria = <String, dynamic>{};
    searchCriteria['fromDate'] = fromDate;
    searchCriteria['toDate'] = toDate;
    searchCriteria['voucherStatus'] = voucherStatus;
    searchCriteria['page'] = page;
    return searchCriteria;
  }
}
