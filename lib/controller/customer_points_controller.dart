import 'dart:convert';

import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/criteria/customer_points_crit_model.dart';
import 'package:bi_replicate/model/customer_points_by_customer.dart';
import 'package:bi_replicate/model/customers_points_by_branch_model.dart';
import 'package:bi_replicate/service/api_service.dart';
import 'package:bi_replicate/utils/constants/values.dart';

class CustomerPointsController {
  Future<List<CustomerPointsByBranch>> getCustomerPointsByBranchList(
      CustomerPointsSearchCriteria searchCriteria) async {
    List<CustomerPointsByBranch> list = [];
    await ApiService()
        .postRequest(
      customerPointsByBranchApi,
      searchCriteria.toJson(),
    )
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var elemant in jsonData) {
          list.add(CustomerPointsByBranch.fromJson(elemant));
        }
      }
    });
    return list;
  }

  Future<List<CustomerPointsByCustomerModel>> getCustomerPointsByCustomerList(
      CustomerPointsSearchCriteria searchCriteria) async {
    List<CustomerPointsByCustomerModel> list = [];
    await ApiService()
        .postRequest(
      customerPointsByCustomerApi,
      searchCriteria.toJson(),
    )
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var elemant in jsonData) {
          list.add(CustomerPointsByCustomerModel.fromJson(elemant));
        }
      }
    });
    return list;
  }
}
