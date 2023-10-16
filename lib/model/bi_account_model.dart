class BiAccountModel {
  String? account;
  int? accountType;
  String? accountName;

  BiAccountModel({
    required this.account,
    required this.accountType,
    required this.accountName,
  });

  BiAccountModel.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    accountType = json['accountType'];
    accountName = json['accountName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'accountType': accountType,
      'accountName': accountName,
    };
  }
}
