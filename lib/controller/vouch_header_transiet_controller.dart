import 'dart:convert';

import 'package:bi_replicate/model/vouch_header_transiet_model.dart';

import '../service/api_service.dart';
import '../utils/constants/values.dart';

class VouchHeaderTransietController {
  Future<VouchHeaderTransietModel?> getBranch() async {
    var api = "vouchHeaderTransiet/getResults";
    VouchHeaderTransietModel? vouchHeaderTransietModel;
    await ApiService().getRequest(api).then((value) {
      if (value.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        vouchHeaderTransietModel = VouchHeaderTransietModel(
            paidSales: jsonData['paidSales'],
            returnSales: jsonData['returnSales'],
            numOfCustomers: jsonData['numOfCustomers']);
      }
    });

    return vouchHeaderTransietModel;
  }
}
