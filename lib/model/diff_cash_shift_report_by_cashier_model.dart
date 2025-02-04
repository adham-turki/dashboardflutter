class DiffCashShiftReportByCashierModel {
  String user;
  int shift;
  double diffAmount;

  DiffCashShiftReportByCashierModel({
    required this.user,
    required this.shift,
    required this.diffAmount,
  });

  factory DiffCashShiftReportByCashierModel.fromJson(
          Map<String, dynamic> json) =>
      DiffCashShiftReportByCashierModel(
        user: json['user'] ?? "",
        shift: json['shift'] ?? 0,
        diffAmount: json['diffAmount'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'shift': shift,
        'diffAmount': diffAmount,
      };
}
