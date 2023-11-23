import 'package:pluto_grid/pluto_grid.dart';

class JournalReportsModel {
  String? jCode;
  String? accCode;
  String? accName;
  String? vatCode;
  String? rowComments;
  String? accCurCode;
  String? transCurCode;
  String? custSupName;
  String? remarks;
  String? comments;
  String? costCenetCode;
  String? reference1;
  String? totComments;
  String? abbreviation;
  int? vouchType;
  int? lineNum;
  int? rowVatType;
  int? vouchNum;
  int? status;
  String? statusName;
  String? statusNameA;
  double? debit;
  double? credit;
  double? debitVat;
  double? creditVat;
  double? accCurRate;
  double? transCurRate;
  double? prevBalance;
  double? balance;
  double? amtInBaseCur;
  double? debitInBaseCur;
  double? creditInBaseCur;
  double? balanceInBaseCur;
  String? transDate;
  String? transDateAsString;
  String? referDate;
  String? vouchTypeName;
  String? voucher;
  String? voucherTypeNameA;
  String? voucherTypeNameE;
  String? userCode;
  String? allComments;
  double? transAmount;
  String? transCurrency;
  double? transBalance;
  String? currencyName;
  String? curRateAsString;
  String? voucherLink;
  String? jcode;

  JournalReportsModel(
      {String? jCode,
      String? accCode,
      String? accName,
      String? vatCode,
      String? rowComments,
      String? accCurCode,
      String? transCurCode,
      String? custSupName,
      String? remarks,
      String? comments,
      String? costCenetCode,
      String? reference1,
      String? totComments,
      String? abbreviation,
      int? vouchType,
      int? lineNum,
      int? rowVatType,
      int? vouchNum,
      int? status,
      String? statusName,
      String? statusNameA,
      int? debit,
      int? credit,
      int? debitVat,
      int? creditVat,
      int? accCurRate,
      int? transCurRate,
      int? prevBalance,
      int? balance,
      int? amtInBaseCur,
      int? debitInBaseCur,
      int? creditInBaseCur,
      int? balanceInBaseCur,
      String? transDate,
      String? transDateAsString,
      String? referDate,
      String? vouchTypeName,
      String? voucher,
      String? voucherTypeNameA,
      String? voucherTypeNameE,
      String? userCode,
      String? allComments,
      int? transAmount,
      String? transCurrency,
      int? transBalance,
      String? currencyName,
      String? curRateAsString,
      String? voucherLink,
      String? jcode}) {
    if (jCode != null) {
      jCode = jCode;
    }
    if (accCode != null) {
      accCode = accCode;
    }
    if (accName != null) {
      accName = accName;
    }
    if (vatCode != null) {
      vatCode = vatCode;
    }
    if (rowComments != null) {
      rowComments = rowComments;
    }
    if (accCurCode != null) {
      accCurCode = accCurCode;
    }
    if (transCurCode != null) {
      transCurCode = transCurCode;
    }
    if (custSupName != null) {
      custSupName = custSupName;
    }
    if (remarks != null) {
      remarks = remarks;
    }
    if (comments != null) {
      comments = comments;
    }
    if (costCenetCode != null) {
      costCenetCode = costCenetCode;
    }
    if (reference1 != null) {
      reference1 = reference1;
    }
    if (totComments != null) {
      totComments = totComments;
    }
    if (abbreviation != null) {
      abbreviation = abbreviation;
    }
    if (vouchType != null) {
      vouchType = vouchType;
    }
    if (lineNum != null) {
      lineNum = lineNum;
    }
    if (rowVatType != null) {
      rowVatType = rowVatType;
    }
    if (vouchNum != null) {
      vouchNum = vouchNum;
    }
    if (status != null) {
      status = status;
    }
    if (statusName != null) {
      statusName = statusName;
    }
    if (statusNameA != null) {
      statusNameA = statusNameA;
    }
    if (debit != null) {
      debit = debit;
    }
    if (credit != null) {
      credit = credit;
    }
    if (debitVat != null) {
      debitVat = debitVat;
    }
    if (creditVat != null) {
      creditVat = creditVat;
    }
    if (accCurRate != null) {
      accCurRate = accCurRate;
    }
    if (transCurRate != null) {
      transCurRate = transCurRate;
    }
    if (prevBalance != null) {
      prevBalance = prevBalance;
    }
    if (balance != null) {
      balance = balance;
    }
    if (amtInBaseCur != null) {
      amtInBaseCur = amtInBaseCur;
    }
    if (debitInBaseCur != null) {
      debitInBaseCur = debitInBaseCur;
    }
    if (creditInBaseCur != null) {
      creditInBaseCur = creditInBaseCur;
    }
    if (balanceInBaseCur != null) {
      balanceInBaseCur = balanceInBaseCur;
    }
    if (transDate != null) {
      transDate = transDate;
    }
    if (transDateAsString != null) {
      transDateAsString = transDateAsString;
    }
    if (referDate != null) {
      referDate = referDate;
    }
    if (vouchTypeName != null) {
      vouchTypeName = vouchTypeName;
    }
    if (voucher != null) {
      voucher = voucher;
    }
    if (voucherTypeNameA != null) {
      voucherTypeNameA = voucherTypeNameA;
    }
    if (voucherTypeNameE != null) {
      voucherTypeNameE = voucherTypeNameE;
    }
    if (userCode != null) {
      userCode = userCode;
    }
    if (allComments != null) {
      allComments = allComments;
    }
    if (transAmount != null) {
      transAmount = transAmount;
    }
    if (transCurrency != null) {
      transCurrency = transCurrency;
    }
    if (transBalance != null) {
      transBalance = transBalance;
    }
    if (currencyName != null) {
      currencyName = currencyName;
    }
    if (curRateAsString != null) {
      curRateAsString = curRateAsString;
    }
    if (voucherLink != null) {
      voucherLink = voucherLink;
    }
    if (jcode != null) {
      jcode = jcode;
    }
  }
  PlutoRow toPluto() {
    final Map<String, PlutoCell> chequesPayable = <String, PlutoCell>{};
    chequesPayable['date'] = PlutoCell(value: referDate ?? "");
    chequesPayable['voucher'] = PlutoCell(value: voucherTypeNameE ?? "");
    chequesPayable['voucherNum'] = PlutoCell(value: voucher ?? "");
    chequesPayable['status'] = PlutoCell(value: statusName ?? "");
    chequesPayable['account'] = PlutoCell(value: accName ?? "");
    chequesPayable['refernce'] = PlutoCell(value: custSupName ?? "");
    chequesPayable['currency'] = PlutoCell(value: transCurrency ?? "");
    chequesPayable['debit'] = PlutoCell(value: debit);
    chequesPayable['credit'] = PlutoCell(value: credit);
    chequesPayable['dibc'] = PlutoCell(value: debitInBaseCur);
    chequesPayable['cibc'] = PlutoCell(value: creditInBaseCur);
    chequesPayable['comments'] = PlutoCell(value: comments ?? "");
    return PlutoRow(cells: chequesPayable);
  }

  JournalReportsModel.fromJson(Map<String, dynamic> json) {
    jCode = json['jCode'];
    accCode = json['accCode'];
    accName = json['accName'];
    vatCode = json['vatCode'];
    rowComments = json['rowComments'];
    accCurCode = json['accCurCode'];
    transCurCode = json['transCurCode'];
    custSupName = json['custSupName'];
    remarks = json['remarks'];
    comments = json['comments'];
    costCenetCode = json['costCenetCode'];
    reference1 = json['reference1'];
    totComments = json['totComments'];
    abbreviation = json['abbreviation'];
    vouchType = json['vouchType'];
    lineNum = json['lineNum'];
    rowVatType = json['rowVatType'];
    vouchNum = json['vouchNum'];
    status = json['status'];
    statusName = json['statusName'];
    statusNameA = json['statusNameA'];
    debit = json['debit'];
    credit = json['credit'];
    debitVat = json['debitVat'];
    creditVat = json['creditVat'];
    accCurRate = json['accCurRate'];
    transCurRate = json['transCurRate'];
    prevBalance = json['prevBalance'];
    balance = json['balance'];
    amtInBaseCur = json['amtInBaseCur'];
    debitInBaseCur = json['debitInBaseCur'];
    creditInBaseCur = json['creditInBaseCur'];
    balanceInBaseCur = json['balanceInBaseCur'];
    transDate = json['transDate'];
    transDateAsString = json['transDateAsString'];
    referDate = json['referDate'];
    vouchTypeName = json['vouchTypeName'];
    voucher = json['voucher'];
    voucherTypeNameA = json['voucherTypeNameA'];
    voucherTypeNameE = json['voucherTypeNameE'];
    userCode = json['userCode'];
    allComments = json['allComments'];
    transAmount = json['transAmount'];
    transCurrency = json['transCurrency'];
    transBalance = json['transBalance'];
    currencyName = json['currencyName'];
    curRateAsString = json['curRateAsString'];
    voucherLink = json['voucherLink'];
    jcode = json['jcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jCode'] = jCode;
    data['accCode'] = accCode;
    data['accName'] = accName;
    data['vatCode'] = vatCode;
    data['rowComments'] = rowComments;
    data['accCurCode'] = accCurCode;
    data['transCurCode'] = transCurCode;
    data['custSupName'] = custSupName;
    data['remarks'] = remarks;
    data['comments'] = comments;
    data['costCenetCode'] = costCenetCode;
    data['reference1'] = reference1;
    data['totComments'] = totComments;
    data['abbreviation'] = abbreviation;
    data['vouchType'] = vouchType;
    data['lineNum'] = lineNum;
    data['rowVatType'] = rowVatType;
    data['vouchNum'] = vouchNum;
    data['status'] = status;
    data['statusName'] = statusName;
    data['statusNameA'] = statusNameA;
    data['debit'] = debit;
    data['credit'] = credit;
    data['debitVat'] = debitVat;
    data['creditVat'] = creditVat;
    data['accCurRate'] = accCurRate;
    data['transCurRate'] = transCurRate;
    data['prevBalance'] = prevBalance;
    data['balance'] = balance;
    data['amtInBaseCur'] = amtInBaseCur;
    data['debitInBaseCur'] = debitInBaseCur;
    data['creditInBaseCur'] = creditInBaseCur;
    data['balanceInBaseCur'] = balanceInBaseCur;
    data['transDate'] = transDate;
    data['transDateAsString'] = transDateAsString;
    data['referDate'] = referDate;
    data['vouchTypeName'] = vouchTypeName;
    data['voucher'] = voucher;
    data['voucherTypeNameA'] = voucherTypeNameA;
    data['voucherTypeNameE'] = voucherTypeNameE;
    data['userCode'] = userCode;
    data['allComments'] = allComments;
    data['transAmount'] = transAmount;
    data['transCurrency'] = transCurrency;
    data['transBalance'] = transBalance;
    data['currencyName'] = currencyName;
    data['curRateAsString'] = curRateAsString;
    data['voucherLink'] = voucherLink;
    data['jcode'] = jcode;
    return data;
  }
}
