import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';

import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/sales_adminstration/daily_sales_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class DailySalesController {
  Future<List<DailySalesModel>> getDailySale(
      SearchCriteria searchCriteria) async {
    List<DailySalesModel> listDailySales = [];
    await ApiService()
        .postRequest(getDailySales, searchCriteria.noToDatetoJson())
        .then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        listDailySales.add(DailySalesModel.fromJson(elemant));
      }
    });
    return listDailySales;
  }
}
