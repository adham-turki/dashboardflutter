class SearchCriteriaBranchesCat {
  String? fromDate;
  String? toDate;
  int? voucherStatus;
  int? rownum;
  int? byCategory;
  String? branch;
  int? page;
  List<String>? columns;
  List<String>? customColumns;

  SearchCriteriaBranchesCat(
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
    final Map<String, dynamic> SearchCriteriaBranchesCat = <String, dynamic>{};

    SearchCriteriaBranchesCat['fromDate'] = fromDate;
    SearchCriteriaBranchesCat['toDate'] = toDate;
    SearchCriteriaBranchesCat['voucherStatus'] = voucherStatus;
    SearchCriteriaBranchesCat['rownum'] = rownum;
    SearchCriteriaBranchesCat['byCategory'] = byCategory;
    SearchCriteriaBranchesCat['branch'] = branch;
    SearchCriteriaBranchesCat['page'] = page;

    return SearchCriteriaBranchesCat;
  }

  factory SearchCriteriaBranchesCat.fromJson(Map<String, dynamic> json) {
    return SearchCriteriaBranchesCat(
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
    final Map<String, dynamic> SearchCriteriaBranchesCat = <String, dynamic>{};

    SearchCriteriaBranchesCat['fromDate'] = fromDate;
    SearchCriteriaBranchesCat['branch'] = branch;

    SearchCriteriaBranchesCat['voucherStatus'] = voucherStatus;

    return SearchCriteriaBranchesCat;
  }

  Map<String, dynamic> statusToJson() {
    final Map<String, dynamic> SearchCriteriaBranchesCat = <String, dynamic>{};

    SearchCriteriaBranchesCat['voucherStatus'] = voucherStatus;

    return SearchCriteriaBranchesCat;
  }

  Map<String, dynamic> chequesToJson() {
    final Map<String, dynamic> SearchCriteriaBranchesCat = <String, dynamic>{};
    SearchCriteriaBranchesCat['fromDate'] = fromDate;
    SearchCriteriaBranchesCat['toDate'] = toDate;
    SearchCriteriaBranchesCat['voucherStatus'] = voucherStatus;
    SearchCriteriaBranchesCat['page'] = page;
    return SearchCriteriaBranchesCat;
  }
}
