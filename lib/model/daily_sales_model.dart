class DailySalesModel {
  double? dailySale;
  DailySalesModel(this.dailySale);
  DailySalesModel.fromJson(Map<String, dynamic> dailySales) {
    dailySale = dailySales['dailySale'].toString() == 'null'
        ? 0.0
        : double.parse(dailySales['dailySale'].toString());
  }
}
