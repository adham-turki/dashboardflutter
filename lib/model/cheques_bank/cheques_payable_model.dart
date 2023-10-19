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
    chequesPayable['outStandingCheques'] =
        PlutoCell(value: outStandingCheques ?? "");
    chequesPayable['unCollectableCheques'] =
        PlutoCell(value: unCollectableCheques ?? "");
    chequesPayable['actualBankBalance'] =
        PlutoCell(value: actualBankBalance ?? 0);
    chequesPayable['dueOutStandingCheques'] =
        PlutoCell(value: dueOutStandingCheques ?? 0);

    chequesPayable['dueInStandingCheques'] =
        PlutoCell(value: dueInStandingCheques ?? 0);

    chequesPayable['finalBalance'] = PlutoCell(value: finalBalance ?? 0);
    return PlutoRow(cells: chequesPayable);
  }

  static List<PlutoColumn> getColumns(AppLocalizations localizations) {
    List<PlutoColumn> list = [
      PlutoColumn(
        title: localizations.outStandingCheques,
        field: "outStandingCheques",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.underCollectionCheques,
        field: "unCollectableCheques",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
      PlutoColumn(
        title: localizations.underCollectionCheques,
        field: "unCollectableCheques",
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: colColor,
      ),
    ];

    return list;
  }
}
