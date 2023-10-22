import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/constants/colors.dart';

class AccountModel {
  final String? txtCode;
  final String? txtArabicName;
  final String? txtEnglishName;
  final int? intLevel;
  final bool? bolIsParent;
  final String? txtParentCode;
  final String? txtParentName;
  final String? txtTreeNode;
  final int? intType;
  final int? intCategory;
  final String? txtCurCode;
  final double? dblCredit;
  final double? dblDebit;
  final double? dblOpenCredit;
  final double? dblOpenDebit;
  final double? dblMaxDebit;
  final double? dblMaxCredit;
  final double? dblBudget;
  final String? datCreationDate;
  final String? datOpenDate;
  final String? datCloseDate;
  final bool? bolHasTransactions;
  final bool? bolActive;
  final int? intStatus;
  final bool? bolProject;
  final bool? bolCostCenter;
  final bool? bolDepartment;
  final bool? bolBank;
  final String? txtNotes;
  final String? txtRestrictedJCode;
  final String? txtRank;
  final bool? bolBalanceSheet;
  final bool? bolIncomeAndExpenditure;
  final bool? bolProfitAndLoss;
  final String? txtClassificationCode;
  final int? bolCurrVariance;
  final int? bolRestrictedCurTransaction;

  AccountModel({
    required this.txtCode,
    this.txtArabicName,
    required this.txtEnglishName,
    required this.intLevel,
    required this.bolIsParent,
    required this.txtParentCode,
    required this.txtParentName,
    required this.txtTreeNode,
    required this.intType,
    required this.intCategory,
    required this.txtCurCode,
    this.dblCredit,
    this.dblDebit,
    required this.dblOpenCredit,
    required this.dblOpenDebit,
    required this.dblMaxDebit,
    required this.dblMaxCredit,
    required this.dblBudget,
    required this.datCreationDate,
    required this.datOpenDate,
    required this.datCloseDate,
    required this.bolHasTransactions,
    required this.bolActive,
    this.intStatus,
    required this.bolProject,
    required this.bolCostCenter,
    required this.bolDepartment,
    required this.bolBank,
    this.txtNotes,
    required this.txtRestrictedJCode,
    this.txtRank,
    required this.bolBalanceSheet,
    required this.bolIncomeAndExpenditure,
    required this.bolProfitAndLoss,
    this.txtClassificationCode,
    required this.bolCurrVariance,
    required this.bolRestrictedCurTransaction,
  });
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      txtCode: json['txtCode'],
      txtArabicName: json['txtArabicname'],
      txtEnglishName: json['txtEnglishname'],
      intLevel: json['intLevel'],
      bolIsParent: json['bolIsparent'],
      txtParentCode: json['txtParentcode'],
      txtParentName: json['txtParentName'],
      txtTreeNode: json['txtTreenode'],
      intType: json['intType'],
      intCategory: json['intCategory'],
      txtCurCode: json['txtCurcode'],
      dblCredit: json['dblCredit'],
      dblDebit: json['dblDebit'],
      dblOpenCredit: json['dblOpencredit'],
      dblOpenDebit: json['dblOpendebit'],
      dblMaxDebit: json['dblMaxdebit'],
      dblMaxCredit: json['dblMaxcredit'],
      dblBudget: json['dblBudget'],
      datCreationDate: json['datCreationdate'],
      datOpenDate: json['datOpendate'],
      datCloseDate: json['datClosedate'],
      bolHasTransactions: json['bolHastransactions'],
      bolActive: json['bolActive'],
      intStatus: json['intStatus'],
      bolProject: json['bolProject'],
      bolCostCenter: json['bolCostcenter'],
      bolDepartment: json['bolDepartment'],
      bolBank: json['bolBank'],
      txtNotes: json['txtNotes'],
      txtRestrictedJCode: json['txtRestrictedjcode'],
      txtRank: json['txtRank'],
      bolBalanceSheet: json['bolBalancesheet'],
      bolIncomeAndExpenditure: json['bolIncomeandexpenditure'],
      bolProfitAndLoss: json['bolProfitandloss'],
      txtClassificationCode: json['txtClassificationcode'],
      bolCurrVariance: json['bolCurrvariance'],
      bolRestrictedCurTransaction: json['bolRestrictedcurtransaction'],
    );
  }
  static List<PlutoColumn> getColumns(
      BuildContext context, AppLocalizations localizations) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.dueDate,
        field: "#",
        type: PlutoColumnType.number(),
        width: width * 0.13,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.bankName,
        field: "Account Code",
        type: PlutoColumnType.text(),
        width: width * 0.13,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.supplier(""),
        field: "Account Name",
        type: PlutoColumnType.text(),
        width: width * 0.13,
        backgroundColor: colColor,
      ),
      // PlutoColumn(
      //   title: localizations.chequeAmount,
      //   field: "amount",
      //   type: PlutoColumnType.number(),
      //   width: 190,
      //   backgroundColor: colColor,
      //   // footerRenderer: (rendererContext) {
      //   //   return ChequesModel.footerRenderer(rendererContext, allAmount);
      //   // },
      // ),
    ];
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'txtCode': txtCode,
      'txtArabicname': txtArabicName,
      'txtEnglishName': txtEnglishName,
      'intLevel': intLevel,
      'bolIsparent': bolIsParent,
      'txtParentcode': txtParentCode,
      'txtParentName': txtParentName,
      'txtTreenode': txtTreeNode,
      'intType': intType,
      'intCategory': intCategory,
      'txtCurcode': txtCurCode,
      'dblCredit': dblCredit,
      'dblDebit': dblDebit,
      'dblOpencredit': dblOpenCredit,
      'dblOpendebit': dblOpenDebit,
      'dblMaxdebit': dblMaxDebit,
      'dblMaxcredit': dblMaxCredit,
      'dblBudget': dblBudget,
      'datCreationdate': datCreationDate!,
      'datOpendate': datOpenDate!,
      'datClosedate': datCloseDate!,
      'bolHastransactions': bolHasTransactions,
      'bolActive': bolActive,
      'intStatus': intStatus,
      'bolProject': bolProject,
      'bolCostcenter': bolCostCenter,
      'bolDepartment': bolDepartment,
      'bolBank': bolBank,
      'txtNotes': txtNotes,
      'txtRestrictedjcode': txtRestrictedJCode,
      'txtRank': txtRank,
      'bolBalancesheet': bolBalanceSheet,
      'bolIncomeandexpenditure': bolIncomeAndExpenditure,
      'bolProfitandloss': bolProfitAndLoss,
      'txtClassificationcode': txtClassificationCode,
      'bolCurrvariance': bolCurrVariance,
      'bolRestrictedcurtransaction': bolRestrictedCurTransaction,
    };
  }

  @override
  String toString() {
    return "$txtEnglishName";
  }
}
