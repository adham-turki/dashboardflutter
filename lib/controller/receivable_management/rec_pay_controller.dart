import 'dart:convert';
import '../../model/criteria/search_criteria.dart';
import '../../model/receivable_management/rec_pay_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class RecPayController extends Api {
  Future<RecPayModel> getRecPayMethod(SearchCriteria searchCriteria) async {
    var api = getRecPayList;

    late RecPayModel recPayObj;

    await postMethods(api, searchCriteria.noToDatetoJson()).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        recPayObj = RecPayModel.fromJson(jsonData);
      }
    });
    return recPayObj;
  }
}
