import 'dart:convert';

import 'package:bi_replicate/model/criteria/journal_report_criteria.dart';
import 'package:bi_replicate/model/db/general_ledger/journal_report/journal_report_transiet_mode.dart';
import 'package:bi_replicate/model/db/general_ledger/gl_structure_model.dart';
import 'package:bi_replicate/service/api_service.dart';
import 'package:bi_replicate/utils/constants/paths.dart';
import 'package:http/http.dart' as http;

import '../../model/db/general_ledger/journal_report/journal_report_model.dart';

class JournalReportController {
  Future<JournalReportTransiet> getJournalReportData(
      JournalReportCriteria criteria) async {
    List<JournalReport> list = [];
    http.Response response =
        await ApiService().postRequest(journalReportApi, criteria);
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    for (var data in jsonData['list']) {
      list.add(JournalReport.fromJson(data));
    }
    int totalPages = jsonData['totalPages'];
    double allDebitSum = jsonData['allDebitSum'];
    double allCreditSum = jsonData['allCreditSum'];
    double allDebitInBaseCurrSum = jsonData['allDebitInBaseCurrSum'];
    double allCreditInBaseCurrSum = jsonData['allCreditInBaseCurrSum'];

    JournalReportTransiet journalReport = JournalReportTransiet();
    journalReport.totalPage = totalPages;
    journalReport.allDebitSum = allDebitSum;
    journalReport.allCreditSum = allCreditSum;
    journalReport.allDebitInBaseCurrSum = allDebitInBaseCurrSum;
    journalReport.allCreditInBaseCurrSum = allCreditInBaseCurrSum;
    journalReport.list = list;
    return journalReport;
  }
}
