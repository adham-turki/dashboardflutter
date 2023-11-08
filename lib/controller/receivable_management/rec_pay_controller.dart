import 'dart:convert';
import 'package:bi_replicate/service/api_service.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/receivable_management/rec_pay_model.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class RecPayController {
  Future<RecPayModel> getRecPayMethod(SearchCriteria searchCriteria,
      {bool? isStart}) async {
    var api = getRecPayList;

    late RecPayModel recPayObj;

    await ApiService()
        .postRequest(api, searchCriteria.noToDatetoJson(), isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        recPayObj = RecPayModel.fromJson(jsonData);
      }
    });
    return recPayObj;
  }
}
