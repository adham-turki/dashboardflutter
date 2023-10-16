class RecPayDataModel {
  String? value;
  String? date;

  RecPayDataModel(this.value, this.date);
  RecPayDataModel.fromJson(Map<String, dynamic> recPay) {
    value =
        recPay['value'].toString() == "null" ? "" : recPay['value'].toString();
    date = recPay['date'].toString() == "null" ? "" : recPay['date'].toString();
  }
}
