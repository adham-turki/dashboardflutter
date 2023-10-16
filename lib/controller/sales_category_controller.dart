import 'dart:convert';

import '../model/aging_model.dart';
import '../model/criteria/search_criteria.dart';
import '../model/sales_category_model.dart';
import '../utils/constants/Api.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/values.dart';

class SalesCategoryController extends Api {
  Future<List<SalesCategoryModel>> getSalesByCategory(
      SearchCriteria searchCriteria) async {
    var api = getSalesApi;
    List<SalesCategoryModel> salesCategoryList = [];

    await postMethods(api, searchCriteria.toJson()).then((response) {
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
