import 'dart:convert';

import '../../model/criteria/search_criteria.dart';
import '../../model/sales_adminstration/sales_branches_model.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';

class SalesBranchesController {
  Future<List<SalesBranchesmodel>> getSalesByBranches(
      SearchCriteria searchCriteria) async {
    var api = salesByBranches;
    List<SalesBranchesmodel> salesBranchesList = [];

    await ApiService.postRequest(api, searchCriteria.toJson()).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        for (var totalCollection in jsonData) {
          salesBranchesList.add(SalesBranchesmodel.fromJson(totalCollection));
        }
      }
    });
    return salesBranchesList;
  }
}
