import 'package:flutter/cupertino.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/responsive.dart';

class ChequesPayableModel {
  double? outStandingCheques;
  double? unCollectableCheques;
  double? underCollectionCheques;
  double? actualBankBalance;
  double? dueOutStandingCheques;
  double? dueInStandingCheques;
  double? finalBalance;

  ChequesPayableModel(
      this.outStandingCheques,
      this.unCollectableCheques,
      this.underCollectionCheques,
      this.actualBankBalance,
      this.dueOutStandingCheques,
      this.dueInStandingCheques,
      this.finalBalance);

  ChequesPayableModel.fromJson(Map<String, dynamic> chequesPayable) {
    outStandingCheques =
        chequesPayable['outStandingCheques'].toString() == 'null'
            ? 0.0
            : chequesPayable['outStandingCheques'];
    unCollectableCheques =
        chequesPayable['unCollectableCheques'].toString() == 'null'
            ? 0.0
            : chequesPayable['unCollectableCheques'];
    underCollectionCheques =
        chequesPayable['underCollectionCheques'].toString() == 'null'
            ? 0.0
            : chequesPayable['underCollectionCheques'];
    actualBankBalance = chequesPayable['actualBankBalance'].toString() == 'null'
        ? 0.0
        : chequesPayable['actualBankBalance'];
    dueOutStandingCheques =
        chequesPayable['dueOutStandingCheques'].toString() == 'null'
            ? 0.0
            : chequesPayable['dueOutStandingCheques'];
    dueInStandingCheques =
        chequesPayable['dueInStandingCheques'].toString() == 'null'
            ? 0.0
            : chequesPayable['dueInStandingCheques'];
    finalBalance = chequesPayable['finalBalance'].toString() == 'null'
        ? 0.0
        : chequesPayable['finalBalance'];
  }

  PlutoRow toPluto() {
    final Map<String, PlutoCell> chequesPayable = <String, PlutoCell>{};
    chequesPayable['outStandingCheques'] = PlutoCell(value: outStandingCheques);
    chequesPayable['unCollectableCheques'] =
        PlutoCell(value: unCollectableCheques);
    chequesPayable['actualBankBalance'] = PlutoCell(value: actualBankBalance);
    chequesPayable['dueOutStandingCheques'] =
        PlutoCell(value: dueOutStandingCheques);
    chequesPayable['underCollectionCheques'] =
        PlutoCell(value: underCollectionCheques);
    chequesPayable['finalBalance'] = PlutoCell(value: finalBalance);
    chequesPayable['dueInStandingCheques'] =
        PlutoCell(value: dueInStandingCheques);
    return PlutoRow(cells: chequesPayable);
  }

  static List<PlutoColumn> getColumnsChequesPayable(
      AppLocalizations localizations, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // int numberOfColumns = 4;
    // double width *0.15 = totalWidth / numberOfColumns;
    bool isDesktop = Responsive.isDesktop(context);
    bool isMobile = Responsive.isMobile(context);
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.outStandingCheques,
        field: "outStandingCheques",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.15 : width * 0.4,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.uncollectableCheques,
        field: "unCollectableCheques",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.18 : width * 0.7,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.underCollectionCheques,
        field: "underCollectionCheques",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.17 : width * 0.8,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }

  static List<PlutoColumn> getColumnsBankSettlement(
      AppLocalizations localizations, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);

    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.actualBankBalance,
        field: "actualBankBalance",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.119 : width * 0.4,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.dueOutstandingCheques,
        field: "dueOutStandingCheques",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.153 : width * 0.6,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.dueInstandingCheques,
        field: "dueInStandingCheques",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.146 : width * 0.6,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.finalBalance,
        field: "finalBalance",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.09 : width * 0.3,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }
}
