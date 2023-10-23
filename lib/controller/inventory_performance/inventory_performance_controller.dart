import 'dart:convert';
import '../../model/criteria/search_criteria.dart';
import '../../model/inventory_performance/inventory_performance_model.dart';
import '../../service/Api.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';

class InventoryPerformanceController {
  Future<List<InventoryPerformanceModel>> totalSellInc(
      SearchCriteria searchCriteria) async {
    List<InventoryPerformanceModel> inventoryPerformanceList = [];

    await ApiService.postRequest(
      getTotalSellInc,
      searchCriteria.toJson(),
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var elemant in jsonData) {
          //creditAmt - debitAmt
          inventoryPerformanceList
              .add(InventoryPerformanceModel.fromJson(elemant));
        }
      }
    });

    return inventoryPerformanceList;
  }

  Future<List<InventoryPerformanceModel>> totalSellDic(
      SearchCriteria searchCriteria) async {
    List<InventoryPerformanceModel> inventoryPerformanceList = [];

    await ApiService.postRequest(getTotalSellDec, searchCriteria.toJson())
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var elemant in jsonData) {
          //creditAmt - debitAmt
          inventoryPerformanceList
              .add(InventoryPerformanceModel.fromJson(elemant));
        }
      }
    });
    return inventoryPerformanceList;
  }
}
