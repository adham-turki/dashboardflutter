class DropDownSearchCriteria {
  String? fromDate;
  String? toDate;
  String? nameCode;

  DropDownSearchCriteria({this.fromDate, this.toDate, this.nameCode});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> searchMap = {};
    searchMap['fromDate'] = fromDate;
    searchMap['toDate'] = toDate;
    searchMap['nameCode'] = nameCode;

    return searchMap;
  }
}
