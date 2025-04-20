class CustomerPointsByCustomerModel {
  String? custCode;
  String? custName;
  int? custPoints;
  int? usedPoints;
  int? remainingPoints;

  CustomerPointsByCustomerModel({
    this.custCode,
    this.custName,
    this.custPoints,
    this.usedPoints,
    this.remainingPoints,
  });

  factory CustomerPointsByCustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerPointsByCustomerModel(
      custCode: json['custCode'] ?? '',
      custName: json['custName'] ?? '',
      custPoints: json['custPoints'] ?? 0,
      usedPoints: json['usedPoints'] ?? 0,
      remainingPoints: json['remainingPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custCode': custCode,
      'custName': custName,
      'custPoints': custPoints,
      'usedPoints': usedPoints,
      'remainingPoints': remainingPoints,
    };
  }
}
