class TotalSalesModel {
  String? code;
  String? name;
  double? inQnty;
  double? outQnty;
  double? netSold;
  double? debit;
  double? credit;
  double? totalAmount;
  double? count;
  int? counter = 0;
  TotalSalesModel(this.code, this.name, this.inQnty, this.outQnty, this.netSold,
      this.debit, this.credit, this.totalAmount, this.count);

  TotalSalesModel.fromJson(Map<String, dynamic> totalSales, int countNum) {
    code = totalSales['code'].toString() == "null"
        ? ""
        : totalSales['code'].toString();
    name = totalSales['name'].toString() == "null"
        ? ""
        : totalSales['name'].toString();
    inQnty =
        totalSales['inQnty'].toString() == "null" ? 0.0 : totalSales['inQnty'];
    outQnty = totalSales['outQnty'].toString() == 'null'
        ? 0.0
        : totalSales['outQnty'];

    netSold = totalSales['netSold'].toString() == "null"
        ? 0.0
        : totalSales['netSold'];
    debit =
        totalSales['debit'].toString() == 'null' ? 0.0 : totalSales['debit'];
    credit =
        totalSales['credit'].toString() == "null" ? 0.0 : totalSales['credit'];
    totalAmount = totalSales['totalAmount'].toString() == 'null'
        ? 0.0
        : totalSales['totalAmount'];
    count =
        totalSales['count'].toString() == "null" ? 0.0 : totalSales['count'];
    counter = countNum;
  }

  List<String> getAllData() {
    List<String> stringList = [];
    stringList.add(counter.toString());
    stringList.add(code.toString());
    stringList.add(name.toString());
    stringList.add(inQnty.toString());
    stringList.add(outQnty.toString());
    stringList.add(netSold.toString());
    stringList.add(debit.toString());
    stringList.add(credit.toString());
    stringList.add(totalAmount.toString());

    return stringList;
  }
}
