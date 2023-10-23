import 'package:bi_replicate/model/cheques_bank/cheques_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/styles.dart';

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

  PlutoRow toPluto() {
    final Map<String, PlutoCell> chequesModel = <String, PlutoCell>{};
    chequesModel['chequeNum'] = PlutoCell(value: chequeNum);
    chequesModel['amount'] = PlutoCell(value: amount);
    chequesModel['dueDate'] = PlutoCell(value: dueDate);
    chequesModel['bankName'] = PlutoCell(value: bankName);
    chequesModel['custSupName'] = PlutoCell(value: custSupName);
    chequesModel['curName'] = PlutoCell(value: curName);
    return PlutoRow(cells: chequesModel);
  }

  static List<PlutoColumn> getColumns(
      AppLocalizations localizations, ChequesResult? reportResult) {
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.dueDate,
        field: "dueDate",
        type: PlutoColumnType.text(),
        width: 185,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.bankName,
        field: "bankName",
        type: PlutoColumnType.text(),
        width: 185,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.supplier(""),
        field: "custSupName",
        type: PlutoColumnType.text(),
        width: 185,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.currency,
        field: "curName",
        type: PlutoColumnType.text(),
        width: 185,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.chequeNo,
        field: "chequeNum",
        type: PlutoColumnType.text(),
        width: 185,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.chequeAmount,
        field: "amount",
        type: PlutoColumnType.number(),
        width: 190,
        backgroundColor: colColor,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return ChequesModel.footerRenderer(
                    rendererContext, reportResult.chequesAmount!);
              }
            : null,
      ),
    ];
    return list;
  }

  static PlutoAggregateColumnFooter footerRenderer(
      PlutoColumnFooterRendererContext rendererContext, double valueAll) {
    return PlutoAggregateColumnFooter(
      rendererContext: rendererContext,
      formatAsCurrency: false,
      type: PlutoAggregateColumnType.sum,
      alignment: Alignment.centerLeft,
      titleSpanBuilder: (text) {
        return [
          TextSpan(
            text: valueAll.toStringAsFixed(2),
            style: gridFooterStyle,
          ),
        ];
      },
    );
  }
}
