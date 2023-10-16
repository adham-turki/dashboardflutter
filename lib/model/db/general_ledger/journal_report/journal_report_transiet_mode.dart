import 'package:bi_replicate/model/db/general_ledger/journal_report/journal_report_model.dart';

class JournalReportTransiet {
  int? totalPage;
  double? allDebitSum;
  double? allCreditSum;
  double? allDebitInBaseCurrSum;
  double? allCreditInBaseCurrSum;
  List<JournalReport>? list;

  JournalReportTransiet({
    totalPage,
    allDebitSum,
    allCreditSum,
    allDebitInBaseCurrSum,
    allCreditInBaseCurrSum,
    list,
  });
}
