class DropDownSearchCriteria {
  String? fromDate;
  String? toDate;
  String? nameCode;
  int? page;

  DropDownSearchCriteria(
      {this.fromDate, this.toDate, this.nameCode, this.page});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> searchMap = {};
    searchMap['fromDate'] = fromDate;
    searchMap['toDate'] = toDate;

    searchMap['nameCode'] = nameCode;

    return searchMap;
  }

  Map<String, dynamic> toJsonBranch() {
    Map<String, dynamic> searchMap = {};

    searchMap['nameCode'] = nameCode;

    return searchMap;
  }

  Map<String, dynamic> toJson2() {
    Map<String, dynamic> searchMap = {};

    searchMap['nameCode'] = nameCode;
    searchMap['page'] = page;

    return searchMap;
  }
}
