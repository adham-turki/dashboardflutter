class CashFlowModel {
  String? title;
  double? value;

  CashFlowModel(this.title, this.value);

  CashFlowModel.fromJson(Map<String, dynamic> cashFlow) {
    title = cashFlow['title'].toString() == "null"
        ? ""
        : cashFlow['title'].toString();
    value = cashFlow['value'].toString() == "null"
        ? 0.0
        : double.parse(cashFlow['value']);
  }
}
