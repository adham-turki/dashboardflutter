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
}
