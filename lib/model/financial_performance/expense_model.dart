class ExpensesModel {
  double? expense;
  ExpensesModel(this.expense);
  ExpensesModel.fromJson(Map<String, dynamic> expenses) {
    expense = (expenses['expense'].toString() == 'null'
        ? 0.0
        : double.parse(expenses['expense'].toString()));
  }
}
