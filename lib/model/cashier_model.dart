class CashierModel {
  final String txtCode;
  final String txtNamee;

  CashierModel({
    required this.txtCode,
    required this.txtNamee,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      txtCode: json['txtCode'] ?? "",
      txtNamee: json['txtNamee'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtCode': txtCode,
      'txtNamee': txtNamee,
    };
  }

  @override
  String toString() {
    return txtNamee;
  }
}
