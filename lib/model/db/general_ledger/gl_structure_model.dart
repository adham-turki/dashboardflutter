import 'package:bi_replicate/controller/general_ledger/journal_report_controller.dart';
import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:bi_replicate/utils/constants/styles.dart';
import 'package:bi_replicate/utils/constants/values.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../criteria/journal_report_criteria.dart';

class GeneralLedgerStruct {
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

  GeneralLedgerStruct(
      {jCode,
      accCode,
      accName,
      vatCode,
      rowComments,
      accCurCode,
      transCurCode,
      custSupName,
      remarks,
      comments,
      costCenetCode,
      reference1,
      totComments,
      abbreviation,
      vouchType,
      lineNum,
      rowVatType,
      vouchNum,
      status,
      statusName,
      statusNameA,
      debit,
      credit,
      debitVat,
      creditVat,
      accCurRate,
      transCurRate,
      prevBalance,
      balance,
      amtInBaseCur,
      debitInBaseCur,
      creditInBaseCur,
      balanceInBaseCur,
      transDate,
      transDateAsString,
      referDate,
      vouchTypeName,
      voucher,
      voucherTypeNameA,
      voucherTypeNameE,
      userCode,
      allComments,
      transAmount,
      transCurrency,
      transBalance,
      currencyName,
      curRateAsString,
      voucherLink,
      jcode});
}
