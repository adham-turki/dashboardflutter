import 'package:pluto_grid/pluto_grid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/constants/colors.dart';

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
      AppLocalizations localizations) {
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.outStandingCheques,
        field: "outStandingCheques",
        type: PlutoColumnType.number(),
        width: 270,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.uncollectableCheques,
        field: "unCollectableCheques",
        type: PlutoColumnType.number(),
        width: 270,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.underCollectionCheques,
        field: "underCollectionCheques",
        type: PlutoColumnType.number(),
        width: 270,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }

  static List<PlutoColumn> getColumnsBankSettlement(
      AppLocalizations localizations) {
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.actualBankBalance,
        field: "actualBankBalance",
        type: PlutoColumnType.number(),
        width: 200,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.dueOutstandingCheques,
        field: "dueOutStandingCheques",
        type: PlutoColumnType.number(),
        width: 230,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.dueInstandingCheques,
        field: "dueInStandingCheques",
        type: PlutoColumnType.number(),
        width: 220,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.finalBalance,
        field: "finalBalance",
        type: PlutoColumnType.number(),
        width: 150,
        backgroundColor: colColor,
      ),
    ];
    return list;
  }
}
