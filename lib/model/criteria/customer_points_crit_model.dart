class CustomerPointsSearchCriteria {
  int? page;
  int? count;
  List<String>? codesBranch;
  List<String>? codesCust;
  String? fromDate;
  String? toDate;

  CustomerPointsSearchCriteria({
    this.page,
    this.count,
    this.codesBranch,
    this.codesCust,
    this.fromDate,
    this.toDate,
  });

  factory CustomerPointsSearchCriteria.fromJson(Map<String, dynamic> json) {
    return CustomerPointsSearchCriteria(
      page: json['page'] ?? 1,
      count: json['count'] ?? 0,
      codesBranch: json['codesBranch'] ?? [],
      codesCust: json['codesCust'] ?? [],
      fromDate: json['fromDate'] ?? "",
      toDate: json['toDate'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'count': count,
      'codesBranch': codesBranch,
      'codesCust': codesCust,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
}
