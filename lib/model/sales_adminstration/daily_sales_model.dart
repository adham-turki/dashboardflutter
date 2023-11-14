class DailySalesModel {
  double? dailySale;
  String? date;
  DailySalesModel(this.dailySale);
  DailySalesModel.fromJson(Map<String, dynamic> dailySales) {
    dailySale = dailySales['dailySale'].toString() == 'null'
        ? 0.0
        : double.parse(dailySales['dailySale'].toString());
    date = dailySales['date'].toString() == "null"
        ? ""
        : dailySales['date'].toString();
    //  "date": "2022-06-13"
  }
}
