import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/responsive.dart';

class BranchModel {
  String? branchName;
  String? branchCode;

  BranchModel({this.branchName, this.branchCode});

  BranchModel.fromJson(Map<String, dynamic> branch) {
    branchName =
        branch['text'].toString() == "null" ? "" : branch['text'].toString();
    branchCode =
        branch['value'].toString() == "null" ? "" : branch['value'].toString();
  }

  // @override
  // String toString() {
  //   return "$branchCode - $branchName";
  // }
  @override
  String toString() {
    return branchName.toString();
  }

  String codeToString() {
    return "$branchCode";
  }

  BranchModel createCustCategoriesModelFromRow(PlutoRow? row) {
    return BranchModel(
      branchCode: row?.cells['branchCode']?.value as String?,
      branchName: row?.cells['branchName']?.value as String?,
    );
  }

  static List<PlutoColumn> getColumnsItems(
      AppLocalizations localizations, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);
    List<PlutoColumn> list = [
      PlutoColumn(
          // enableFilterMenuItem: false,
          readOnly: true,
          // suppressedAutoSize: true,
          title: localizations.code,
          field: "branchCode",
          type: PlutoColumnType.text(),
          width: isDesktop ? width * 0.09 : width * 0.3,
          backgroundColor: columnColors,
          enableRowChecked: true),
      PlutoColumn(
        readOnly: true,
        // suppressedAutoSize: true,
        title: localizations.itemName,
        field: "branchName",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.36 : width * .247,
        backgroundColor: columnColors,
        // enableFilterMenuItem: false,
      ),
    ];
    return list;
  }

  static List<PlutoColumn> getColumnsSuppliers(
      AppLocalizations localizations, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);
    List<PlutoColumn> list = [
      PlutoColumn(
        // enableFilterMenuItem: false,
        readOnly: true,
        // suppressedAutoSize: true,
        title: localizations.code,
        field: "branchName",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.36 : width * 0.3,
        backgroundColor: columnColors,
        // enableRowChecked: true
      ),
      PlutoColumn(
        readOnly: true,
        // suppressedAutoSize: true,
        title: localizations.itemName,
        field: "branchCode",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.09 : width * .247,
        backgroundColor: columnColors,
        // enableRowChecked: true

        // enableFilterMenuItem: false,
      ),
    ];
    return list;
  }

  PlutoRow toPluto() {
    final Map<String, PlutoCell> stockCategoriesModel = {
      'branchName': PlutoCell(value: branchName),
      'branchCode': PlutoCell(value: branchCode),
    };
    return PlutoRow(cells: stockCategoriesModel);
  }
}
