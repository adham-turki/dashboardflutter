class StockModel {
  String? txtStkcode;
  String? txtNamea;
  String? txtNamee;
  String? txtComname;

  StockModel({
    this.txtStkcode,
    this.txtNamea,
    this.txtNamee,
    this.txtComname,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      txtStkcode: json['txtStkcode'] ?? "",
      txtNamea: json['txtNamea'] ?? "",
      txtNamee: json['txtNamee'] ?? "",
      txtComname: json['txtComname'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtStkcode': txtStkcode,
      'txtNamea': txtNamea,
      'txtNamee': txtNamee,
      'txtComname': txtComname,
    };
  }
}
