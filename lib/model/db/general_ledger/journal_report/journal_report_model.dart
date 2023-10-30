import 'package:bi_replicate/model/db/general_ledger/journal_report/journal_report_transiet_mode.dart';
import 'package:bi_replicate/model/db/general_ledger/gl_structure_model.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../controller/general_ledger/journal_report_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/styles.dart';
import '../../../../utils/constants/values.dart';
import '../../../criteria/journal_report_criteria.dart';

class JournalReport extends GeneralLedgerStruct {
  //These are only for the PlutoColumn
  static int totalPages = 0;
  static double allDebitSum = 0;
  static double allCreditSum = 0;
  static double allDebitInBaseCurrSum = 0;
  static double allCreditInBaseCurrSum = 0;

  JournalReport.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
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

  static List<PlutoColumn> toPlutoColumn() {
    return [
      PlutoColumn(
        title: "Date",
        field: "date",
        type: PlutoColumnType.date(),
        backgroundColor: colColor,
        width: 100,
      ),
      PlutoColumn(
        title: "Voucher",
        field: "voucher",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 100,
      ),
      PlutoColumn(
        title: "Voucher#",
        field: "voucherLink",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 120,
      ),
      PlutoColumn(
        title: "Status",
        field: "status",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 100,
      ),
      PlutoColumn(
        title: "Account",
        field: "account",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 300,
      ),
      PlutoColumn(
        title: "Reference",
        field: "reference",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 200,
      ),
      PlutoColumn(
        title: "Currency",
        field: "currencyName",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 120,
      ),
      PlutoColumn(
        title: "Debit",
        field: "debit",
        type: PlutoColumnType.number(),
        backgroundColor: colColor,
        width: 120,
        footerRenderer: (rendererContext) {
          return footerRenderer(rendererContext, allDebitSum);
        },
      ),
      PlutoColumn(
        title: "Credit",
        field: "credit",
        type: PlutoColumnType.number(),
        backgroundColor: colColor,
        width: 120,
        footerRenderer: (rendererContext) {
          return footerRenderer(rendererContext, allCreditSum);
        },
      ),
      PlutoColumn(
        title: "Debit in Base Currency",
        field: "debitInBase",
        type: PlutoColumnType.number(),
        backgroundColor: colColor,
        width: 220,
        footerRenderer: (rendererContext) {
          return footerRenderer(rendererContext, allDebitInBaseCurrSum);
        },
      ),
      PlutoColumn(
        title: "Credit in Base Currency",
        field: "creditInBase",
        type: PlutoColumnType.number(),
        backgroundColor: colColor,
        width: 220,
        footerRenderer: (rendererContext) {
          return footerRenderer(rendererContext, allCreditInBaseCurrSum);
        },
      ),
      PlutoColumn(
        title: "Comments",
        field: "comments",
        type: PlutoColumnType.text(),
        backgroundColor: colColor,
        width: 150,
      ),
    ];
  }

  static PlutoAggregateColumnFooter footerRenderer(
      PlutoColumnFooterRendererContext rendererContext, double valueAll) {
    return PlutoAggregateColumnFooter(
      rendererContext: rendererContext,
      formatAsCurrency: true,
      type: PlutoAggregateColumnType.sum,
      alignment: Alignment.center,
      titleSpanBuilder: (text) {
        return [
          TextSpan(
            text: text.replaceAll("\$", ""),
            children: [
              TextSpan(
                text: "\nAll: ${valueAll.toStringAsFixed(2)}",
              ),
            ],
            style: gridFooterStyle,
          ),
        ];
      },
    );
  }

  PlutoRow toPlutoRow() {
    final Map<String, PlutoCell> map = <String, PlutoCell>{};
    map['date'] = PlutoCell(value: referDate ?? "-");
    map['voucher'] = PlutoCell(value: voucher ?? "-");
    map['voucherLink'] = PlutoCell(value: voucherLink ?? "-");
    map['status'] = PlutoCell(value: statusName ?? "-");
    map['account'] = PlutoCell(value: accName ?? "-");
    map['reference'] = PlutoCell(value: reference1 ?? "-");
    map['currencyName'] = PlutoCell(value: currencyName ?? "-");
    map['debit'] = PlutoCell(value: debit ?? "-");
    map['credit'] = PlutoCell(value: credit ?? "-");
    map['debitInBase'] = PlutoCell(value: debitInBaseCur ?? "-");
    map['creditInBase'] = PlutoCell(value: creditInBaseCur ?? "-");
    map['comments'] = PlutoCell(value: comments ?? "-");
    return PlutoRow(cells: map);
  }

  String getStatusAsString(int status) {
    if (status == 0) {
      return posted;
    } else if (status == 1) {
      return cancelled;
    }
    return draft;
  }

  static JournalReportCriteria criteria = JournalReportCriteria(
    fromJCode: "A",
    toJCode: "C",
    fromDate: "2023-5-1",
    toDate: "2023-09-27",
    fromAccCode: "1101010301",
    toAccCode: "1101010301",
  );

  static PlutoLazyPagination lazyPaginationFooter(
      PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: 1,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: fetch,
      stateManager: stateManager,
    );
  }

  static Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request) async {
    int page = request.page;

    //To send the number of page to the JSON Object
    criteria.page = page;

    JournalReportController journalController = JournalReportController();

    List<PlutoRow> list = [];

    JournalReportTransiet trans =
        await journalController.getJournalReportData(criteria);

    allCreditInBaseCurrSum = trans.allCreditInBaseCurrSum ?? 0;
    allCreditSum = trans.allCreditSum ?? 0;
    allDebitInBaseCurrSum = trans.allDebitInBaseCurrSum ?? 0;
    allDebitSum = trans.allDebitSum ?? 0;

    int totalPage = trans.totalPage ?? 1;
    List<JournalReport> jList = trans.list ?? [];

    for (int i = 0; i < jList.length; i++) {
      list.add(jList[i].toPlutoRow());
    }

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: list,
    );
  }
}
