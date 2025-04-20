class CustomerPointsByBranch {
  String branchCode;
  String branchName;
  int custPoints;

  CustomerPointsByBranch({
    required this.branchCode,
    required this.branchName,
    required this.custPoints,
  });

  factory CustomerPointsByBranch.fromJson(Map<String, dynamic> json) {
    return CustomerPointsByBranch(
      branchCode: json['branchCode'] ?? '',
      branchName: json['branchName'] ?? '',
      custPoints: json['custPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchCode': branchCode,
      'branchName': branchName,
      'custPoints': custPoints,
    };
  }
}
