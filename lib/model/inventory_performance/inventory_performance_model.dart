class InventoryPerformanceModel {
  String? code;
  String? name;
  double? intQty;
  double? outQty;
  InventoryPerformanceModel(this.code, this.name, this.intQty, this.outQty);
  InventoryPerformanceModel.fromJson(
      Map<String, dynamic> inventoryPerformance) {
    code = inventoryPerformance['stkCode'].toString() == "null"
        ? ""
        : inventoryPerformance['stkCode'].toString();
    name = inventoryPerformance['nameE'].toString() == "null"
        ? ""
        : inventoryPerformance['nameE'].toString();
    intQty = inventoryPerformance['inQnty'].toString() == "null"
        ? 0.0
        : double.parse(inventoryPerformance['inQnty'].toString());
    outQty = inventoryPerformance['outQnty'].toString() == 'null'
        ? 0.0
        : (double.parse(inventoryPerformance['outQnty'].toString()));
  }
}
