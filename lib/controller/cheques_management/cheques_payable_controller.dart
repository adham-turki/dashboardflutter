import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';

import '../../model/cheques_bank/cheques_payable_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../utils/constants/api_constants.dart';

class ChequesPayableController {
  Future<ChequesPayableModel> getchequesAndBanks(
      SearchCriteria searchCriteria) async {
    ChequesPayableModel chequesPayableModel =
        ChequesPayableModel(0, 0, 0, 0, 0, 0, 0);
    await ApiService()
        .postRequest(getChequesPayable, searchCriteria.statusToJson())
        .then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      chequesPayableModel = ChequesPayableModel.fromJson(jsonData);
    });
    return chequesPayableModel;
  }
}
