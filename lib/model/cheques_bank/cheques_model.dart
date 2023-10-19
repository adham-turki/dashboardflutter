import 'package:pluto_grid/pluto_grid.dart';

class ChequesModel {
  String? jCode1;
  int? vouchType1;
  int? vouchNum1;
  String? bankCode;
  int? branchNo;
  String? bankAccNo;
  String? chequeNum;
  double? amount;
  String? dueDate;
  int? status;
  String? relatedAccCode1;
  double? curRate;
  String? curCode;
  String? voucherDate1;
  String? accName;
  String? bankName;
  String? custSupCode;
  String? custSupName;
  String? curName;
  String? custCategory;
  String? voucherTypeNameE;
  String? voucherTypeNameA;
  double? balance;
  String? depositBankName;
  String? statusNameA;
  String? statusNameE;
  String? accCode;
  int? counter = 0;

  ChequesModel();

  ChequesModel.fromJson(Map<String, dynamic> json, int countNum) {
    jCode1 = json['jCode1'];
    vouchType1 = json['vouchType1'];
    vouchNum1 = json['vouchNum1'];
    bankCode = json['bankCode'];
    branchNo = json['branchNo'];
    bankAccNo = json['bankAccNo'];
    chequeNum = json['chequeNum'];
    amount = json['amount'].toDouble();
    dueDate = json['dueDate'];
    status = json['status'];
    relatedAccCode1 = json['relatedAccCode1'];
    curRate = json['curRate'].toDouble();
    curCode = json['curCode'];
    voucherDate1 = json['voucherDate1'];
    accName = json['accName'];
    bankName = json['bankName'];
    custSupCode = json['custSupCode'];
    custSupName = json['custSupName'];
    curName = json['curName'];
    custCategory = json['custCategory'];
    voucherTypeNameE = json['voucherTypeNameE'];
    voucherTypeNameA = json['voucherTypeNameA'];
    balance = json['balance'].toDouble();
    depositBankName = json['depositBankName'];
    statusNameA = json['statusNameA'];
    statusNameE = json['statusNameE'];
    accCode = json['accCode'];
    counter = countNum;
  }
  List<String> getAllData() {
    List<String> stringList = [];

    stringList.add(counter.toString());
    stringList.add(dueDate.toString());
    stringList.add(bankName.toString());
    stringList.add(custSupName.toString());
    stringList.add(curName.toString());
    stringList.add(chequeNum.toString());
    stringList.add(amount.toString());

    return stringList;
  }

  List<String> getTotal(double totalAmount) {
    List<String> stringList = [];

    stringList.add("");
    stringList.add("");
    stringList.add("");
    stringList.add("");
    stringList.add("");
    stringList.add("");
    stringList.add(totalAmount.toString());

    return stringList;
  }
}
