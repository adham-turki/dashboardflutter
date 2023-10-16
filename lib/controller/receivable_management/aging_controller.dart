import 'dart:convert';

import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class AgingController extends Api {
  Future<List<AgingModel>> getAgingList(SearchCriteria searchCriteria) async {
    var api = getAgingListApi;
    List<AgingModel> list = [];
    await postMethods(api, searchCriteria.statusToJson()).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        for (int i = 0; i < jsonData.length; i++) {
          list.add(AgingModel.fromJson(jsonData[i]));
        }
      }
    });

    return list;
  }
}
