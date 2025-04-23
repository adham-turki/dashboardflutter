import 'dart:convert';

import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/criteria/customer_points_crit_model.dart';
import 'package:bi_replicate/model/customer_points_by_customer.dart';
import 'package:bi_replicate/model/customers_points_by_branch_model.dart';
import 'package:bi_replicate/service/api_service.dart';
import 'package:bi_replicate/utils/constants/values.dart';

import '../model/customer_model.dart';

class CustomerPointsController {
  Future<List<CustomerPointsByBranch>> getCustomerPointsByBranchList(
      CustomerPointsSearchCriteria searchCriteria) async {
    List<CustomerPointsByBranch> list = [];
    try {
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
    } catch (e) {
      return [];
    }
    return list;
  }

  Future<List<CustomerPointsByCustomerModel>>
      getTopPointsCustomerPointsByCustomerList(
          CustomerPointsSearchCriteria searchCriteria) async {
    List<CustomerPointsByCustomerModel> list = [];
    try {
      await ApiService()
          .postRequest(
        topCustomerPointsByCustomerApi,
        searchCriteria.toJsonForByCustomers(),
      )
          .then((response) {
        if (response.statusCode == statusOk) {
          var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
          for (var elemant in jsonData) {
            list.add(CustomerPointsByCustomerModel.fromJson(elemant));
          }
        }
      });
    } catch (e) {
      return list;
    }
    return list;
  }

  Future<List<CustomerPointsByCustomerModel>>
      getTopUsedPointsCustomerPointsByCustomerList(
          CustomerPointsSearchCriteria searchCriteria) async {
    List<CustomerPointsByCustomerModel> list = [];
    try {
      await ApiService()
          .postRequest(
        topUsedCustomerPointsByCustomerApi,
        searchCriteria.toJsonForByCustomers(),
      )
          .then((response) {
        if (response.statusCode == statusOk) {
          var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
          for (var elemant in jsonData) {
            list.add(CustomerPointsByCustomerModel.fromJson(elemant));
          }
        }
      });
    } catch (e) {
      return list;
    }
    return list;
  }

  Future<List<CustomerModel>> getCustomers(String name) async {
    List<CustomerModel> list = [];
    try {
      await ApiService().postRequest(
        getCustomerListApi,
        {"page": 1, "nameCode": name},
      ).then((response) {
        if (response.statusCode == statusOk) {
          var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

          // Safely extract the list under 'resultAjax'
          final List<dynamic> results = jsonData['resultAjax'] ?? [];

          for (var element in results) {
            list.add(CustomerModel.fromJson(element));
          }
        }
      });
    } catch (e) {
      return list;
    }
    return list;
  }
}
