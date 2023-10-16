import 'dart:convert';

import '../../model/cheques_bank/cheques_payable_model.dart';
import '../../model/receivable_management/aging_model.dart';
import '../../model/criteria/search_criteria.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class ChequesPayableController extends Api {
  Future<ChequesPayableModel> getchequesAndBanks(
      SearchCriteria searchCriteria) async {
    ChequesPayableModel chequesPayableModel =
        ChequesPayableModel(0, 0, 0, 0, 0, 0, 0);
    await postMethods(getChequesPayable, searchCriteria.statusToJson())
        .then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      chequesPayableModel = ChequesPayableModel.fromJson(jsonData);
    });
    return chequesPayableModel;
  }
}
