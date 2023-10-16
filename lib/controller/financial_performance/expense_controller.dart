import 'dart:convert';
import '../../model/criteria/search_criteria.dart';
import '../../model/financial_performance/expense_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class ExpensesController extends Api {
  var api = getExpenses;
  Future<List<ExpensesModel>> getExpense(SearchCriteria searchCriteria) async {
    List<ExpensesModel> list = [];
    await postMethods(api, searchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var elemant in jsonData) {
          list.add(ExpensesModel.fromJson(elemant));
        }
      }
    });
    return list;
  }
}
