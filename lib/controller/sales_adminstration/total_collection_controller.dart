import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';

import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/sales_adminstration/total_collection_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class TotalCollectionConroller {
  Future<List<TotalCollectionModel>> getTotalCollectionMethod(
      SearchCriteria searchCriteria) async {
    var api = getTotalCollection;
    List<TotalCollectionModel> totalCollectionList = [];

    await ApiService.postRequest(api, searchCriteria.toJson()).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var totalCollection in jsonData) {
          totalCollectionList
              .add(TotalCollectionModel.fromJson(totalCollection));
        }
      }
    });
    return totalCollectionList;
  }
}
