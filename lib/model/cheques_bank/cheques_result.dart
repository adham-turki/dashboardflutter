class ChequesResult {
  double? chequesAmount;
  int? count;
  ChequesResult();
  ChequesResult.fromJson(Map<String, dynamic> chequesResult) {
    chequesAmount = chequesResult['chequesAmount'].toString() == 'null'
        ? 0.0
        : chequesResult['chequesAmount'];
    count = chequesResult['count'].toString() == "null"
        ? 0
        : chequesResult['count'];
  }
}
