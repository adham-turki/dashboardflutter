import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';

import '../../model/criteria/search_criteria.dart';
import '../../model/sales_adminstration/sales_category_model.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class SalesCategoryController {
  Future<List<SalesCategoryModel>> getSalesByCategory(
      SearchCriteria searchCriteria,
      {bool? isStart}) async {
    var api = getSalesApi;
    List<SalesCategoryModel> salesCategoryList = [];

    await ApiService()
        .postRequest(api, searchCriteria.toJson(), isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var salesCategory in jsonData) {
          salesCategoryList.add(SalesCategoryModel.fromJson(salesCategory));
        }
      }
    });
    return salesCategoryList;
  }
}
