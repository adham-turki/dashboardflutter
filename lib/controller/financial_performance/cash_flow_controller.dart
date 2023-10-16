import 'dart:convert';

import '../../model/financial_performance/cash_flow_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class CashFlowController extends Api {
  Future<List<CashFlowModel>> getChartCash(
      SearchCriteria searchCriteria) async {
    var api = getCashFlows;
    List<CashFlowModel> cashFlowList = [];
    await postMethods(api, searchCriteria.toJson()).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var cashFlow in jsonData) {
          cashFlowList.add(CashFlowModel.fromJson(cashFlow));
        }
      }
    });
    return cashFlowList;
  }
}
