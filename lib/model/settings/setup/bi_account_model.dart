import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/constants/colors.dart';

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

  PlutoRow toPluto(int dash) {
    final Map<String, PlutoCell> salesReport = <String, PlutoCell>{};

    salesReport['dash'] = PlutoCell(value: dash);
    salesReport['account'] = PlutoCell(value: account ?? "");
    salesReport['accountName'] = PlutoCell(value: accountName ?? "");
    salesReport['accountType'] = PlutoCell(value: accountType ?? "");

    return PlutoRow(cells: salesReport);
  }

  // BiAccountModel fromPluto()

  static List<PlutoColumn> getColumns(
      BuildContext context, AppLocalizations localizations) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<PlutoColumn> list = [
      PlutoColumn(
        title: "#",
        field: "dash",
        type: PlutoColumnType.number(),
        width: width * 0.04,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.accountCode,
        field: "account",
        type: PlutoColumnType.text(),
        width: width * 0.13,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.accountName,
        field: "accountName",
        type: PlutoColumnType.text(),
        width: width * 0.18,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }
}
