import 'dart:convert';

import '../../model/financial_performance/expense_model.dart';
import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../service/Api.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class ExpensesController {
  var api = getExpenses;
  Future<List<ExpensesModel>> getExpense(SearchCriteria searchCriteria) async {
    List<ExpensesModel> list = [];
    await ApiService.postRequest(api, searchCriteria.toJson()).then((response) {
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
