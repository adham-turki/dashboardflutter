class VouchTypeModel {
  final int intVouchtype;
  final String txtEnglishname;

  VouchTypeModel({
    required this.intVouchtype,
    required this.txtEnglishname,
  });

  factory VouchTypeModel.fromJson(Map<String, dynamic> json) {
    return VouchTypeModel(
      intVouchtype: json['intVouchtype'],
      txtEnglishname: json['txtEnglishname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intVouchtype': intVouchtype,
      'txtEnglishname': txtEnglishname,
    };
  }

  @override
  String toString() {
    return txtEnglishname;
  }

  String codeToString() {
    return "${intVouchtype}";
  }
}
