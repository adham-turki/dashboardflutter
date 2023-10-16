import 'dart:convert';

import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/inventory_performance/inventory_performance_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class InventoryPerformanceController extends Api {
  Future<List<InventoryPerformanceModel>> totalSellInc(
      SearchCriteria searchCriteria) async {
    List<InventoryPerformanceModel> inventoryPerformanceList = [];

    await postMethods(getTotalSellInc, searchCriteria.toJson())
        .then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        //creditAmt - debitAmt
        inventoryPerformanceList
            .add(InventoryPerformanceModel.fromJson(elemant));
      }
    });
    return inventoryPerformanceList;
  }

  Future<List<InventoryPerformanceModel>> totalSellDic(
      SearchCriteria searchCriteria) async {
    List<InventoryPerformanceModel> inventoryPerformanceList = [];

    await postMethods(getTotalSellDec, searchCriteria.toJson())
        .then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        //creditAmt - debitAmt
        inventoryPerformanceList
            .add(InventoryPerformanceModel.fromJson(elemant));
      }
    });
    return inventoryPerformanceList;
  }
}
