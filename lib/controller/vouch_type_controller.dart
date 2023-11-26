import 'dart:convert';

import 'package:bi_replicate/model/vouch_type_model.dart';
import 'package:bi_replicate/utils/constants/api_constants.dart';

import '../service/api_service.dart';

class VouchTypeController {
  Future<List<VouchTypeModel>> getAllVouchTypes() async {
    List<VouchTypeModel> vouchTypeList = [];
    String pathUrl = getVouchTypes;
    await ApiService().getRequest(pathUrl).then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        //creditAmt - debitAmt
        vouchTypeList.add(VouchTypeModel.fromJson(elemant));
      }
    });

    return vouchTypeList;
  }
}
