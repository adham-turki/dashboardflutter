import 'dart:convert';

import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/api_model.dart';
import 'package:bi_replicate/model/sales/search_crit.dart';

import 'package:http/http.dart' as http;

import '../model/sales/branch_model.dart';
import '../model/sales/sales_db_model.dart';

class TotalSalesController {
  Future<List<BranchSalesDBModel>> getTotalSalesByCashier(
      SearchCriteria searchCriteria) async {
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByCashier;
    try {
      var response = await http.post(
        Uri.http(ApiModel.url, api),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.http(ApiModel.url, api)}");
      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(BranchSalesDBModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<BranchSalesDBModel>> getTotalSalesByComputer(
      SearchCriteria searchCriteria) async {
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByComputer;

    try {
      print(Uri.http(ApiModel.url, api));
      var response = await http.post(
        Uri.http(ApiModel.url, api),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.http(ApiModel.url, api)}");
      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(BranchSalesDBModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<BranchSalesDBModel>> getTotalSalesByHours(
      SearchCriteria searchCriteria) async {
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByHours;

    try {
      print(Uri.http(ApiModel.url, api));
      var response = await http.post(
        Uri.http(ApiModel.url, api),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.http(ApiModel.url, api)}");
      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(BranchSalesDBModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<BranchSalesDBModel>> getTotalSalesByPaymentTypes(
      SearchCriteria searchCriteria) async {
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByPayType;

    try {
      print(Uri.http(ApiModel.url, api));
      var response = await http.post(
        Uri.http(ApiModel.url, api),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.http(ApiModel.url, api)}");
      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(BranchSalesDBModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<BranchModel>> getAllBranches() async {
    List<BranchModel> branchesList = [];
    var api = getBranches;
    try {
      var response = await http.get(
        Uri.http(ApiModel.url, api),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
      );
      print("API Request: ${Uri.http(ApiModel.url, api)}");
      print("API Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          branchesList.add(BranchModel.fromJson(data));
        }
      }
      print("branchesList: ${branchesList.length}");
      return branchesList;
    } catch (e) {
      print("e: $e");
      return branchesList;
    }
  }
}
