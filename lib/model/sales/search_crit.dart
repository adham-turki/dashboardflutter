class SearchCriteria {
  final String branch;
  final String shiftStatus;
  final String transType;
  final String cashier;
  final String fromDate;
  final String toDate;
  String? chartType;
  String? computer;

  SearchCriteria(
      {required this.branch,
      required this.shiftStatus,
      required this.transType,
      required this.cashier,
      required this.fromDate,
      required this.toDate,
      this.chartType,
      this.computer});

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      branch: json['branch'] ?? 'all',
      shiftStatus: json['shiftStatus'] ?? 'all',
      transType: json['transType'] ?? 'all',
      cashier: json['cashier'] ?? 'all',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'shiftStatus': shiftStatus,
      'transType': transType,
      'cashier': cashier,
      'fromDate': fromDate,
      'toDate': toDate,
      'computer': computer
    };
  }
}
