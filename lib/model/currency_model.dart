class CurrencyModel {
  final String? txtCode;
  final String? txtArabicname;
  final String? txtEnglishname;
  final String? txtEnglishunitname;
  final String? txtArabicunitname;
  final bool? bolBasecurrency;
  final int? intDecimals;
  final String? txtIsocode;

  CurrencyModel({
    this.txtCode,
    this.txtArabicname,
    this.txtEnglishname,
    this.txtEnglishunitname,
    this.txtArabicunitname,
    this.bolBasecurrency,
    this.intDecimals,
    this.txtIsocode,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      txtCode: json['txtCode'] ?? "",
      txtArabicname: json['txtArabicname'] ?? "",
      txtEnglishname: json['txtEnglishname'] ?? "",
      txtEnglishunitname: json['txtEnglishunitname'] ?? "",
      txtArabicunitname: json['txtArabicunitname'] ?? "",
      bolBasecurrency: json['bolBasecurrency'] ?? false,
      intDecimals: json['intDecimals'] as int?,
      txtIsocode: json['txtIsocode'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txtCode': txtCode,
      'txtArabicname': txtArabicname,
      'txtEnglishname': txtEnglishname,
      'txtEnglishunitname': txtEnglishunitname,
      'txtArabicunitname': txtArabicunitname,
      'bolBasecurrency': bolBasecurrency,
      'intDecimals': intDecimals,
      'txtIsocode': txtIsocode,
    };
  }
}
