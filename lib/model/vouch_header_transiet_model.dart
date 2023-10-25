class VouchHeaderTransietModel {
  final int paidSales;
  final double returnSales;
  final int numOfCustomers;

  VouchHeaderTransietModel({
    required this.paidSales,
    required this.returnSales,
    required this.numOfCustomers,
  });

  factory VouchHeaderTransietModel.fromJson(Map<String, dynamic> json) {
    return VouchHeaderTransietModel(
      paidSales: json['paidSales'] as int,
      returnSales: (json['returnSales'] as num).toDouble(),
      numOfCustomers: json['numOfCustomers'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paidSales': paidSales,
      'returnSales': returnSales,
      'numOfCustomers': numOfCustomers,
    };
  }
}
