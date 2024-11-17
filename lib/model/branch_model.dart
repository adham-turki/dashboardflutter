class BranchModel {
  final String txtCode;
  final String txtNamee;
  final String? txtNotes;
  final String txtCostcentercode;
  final String txtPrefix;
  final String txtWarehouse;
  final String? txtAreacode;
  final String? txtInsurancecashacc;
  final double? dblDefvatrate;
  final int? bolVatselect;
  final String txtJcode;
  final String? txtRevexpacccode1;
  final String? txtRevexpacccode2;

  BranchModel({
    required this.txtCode,
    required this.txtNamee,
    this.txtNotes,
    required this.txtCostcentercode,
    required this.txtPrefix,
    required this.txtWarehouse,
    this.txtAreacode,
    this.txtInsurancecashacc,
    this.dblDefvatrate,
    this.bolVatselect,
    required this.txtJcode,
    this.txtRevexpacccode1,
    this.txtRevexpacccode2,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      txtCode: json['txtCode'] ?? "",
      txtNamee: json['txtNamee'] ?? "",
      txtNotes: json['txtNotes'] ?? "",
      txtCostcentercode: json['txtCostcentercode'] ?? "",
      txtPrefix: json['txtPrefix'] ?? "",
      txtWarehouse: json['txtWarehouse'] ?? "",
      txtAreacode: json['txtAreacode'] ?? "",
      txtInsurancecashacc: json['txtInsurancecashacc'] ?? "",
      dblDefvatrate: double.parse((json['dblDefvatrate'] ?? "0.0").toString()),
      bolVatselect: json['bolVatselect'] ?? 0,
      txtJcode: json['txtJcode'] ?? "",
      txtRevexpacccode1: json['txtRevexpacccode1'] ?? "",
      txtRevexpacccode2: json['txtRevexpacccode2'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtCode': txtCode,
      'txtNamee': txtNamee,
      'txtNotes': txtNotes,
      'txtCostcentercode': txtCostcentercode,
      'txtPrefix': txtPrefix,
      'txtWarehouse': txtWarehouse,
      'txtAreacode': txtAreacode,
      'txtInsurancecashacc': txtInsurancecashacc,
      'dblDefvatrate': dblDefvatrate,
      'bolVatselect': bolVatselect,
      'txtJcode': txtJcode,
      'txtRevexpacccode1': txtRevexpacccode1,
      'txtRevexpacccode2': txtRevexpacccode2,
    };
  }

  @override
  String toString() {
    return txtNamee;
  }
}
