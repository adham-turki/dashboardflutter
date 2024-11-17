class SearchCriteria {
  final String branch;
  final String shiftStatus;
  final String fromDate;
  final String toDate;

  SearchCriteria({
    required this.branch,
    required this.shiftStatus,
    required this.fromDate,
    required this.toDate,
  });

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      branch: json['branch'] ?? 'all',
      shiftStatus: json['shiftStatus'] ?? 'all',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'shiftStatus': shiftStatus,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
}
