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

  SearchCriteria(
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
    final Map<String, dynamic> searchCriteria = <String, dynamic>{};

    searchCriteria['fromDate'] = fromDate;
    searchCriteria['toDate'] = toDate;
    searchCriteria['voucherStatus'] = voucherStatus;
    searchCriteria['rownum'] = rownum;
    searchCriteria['byCategory'] = byCategory;
    searchCriteria['branch'] = branch;
    searchCriteria['page'] = page;

    return searchCriteria;
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
