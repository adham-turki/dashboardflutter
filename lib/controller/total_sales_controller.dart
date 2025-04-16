import 'dart:convert';

import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/api_model.dart';
import 'package:bi_replicate/model/api_url.dart';
import 'package:bi_replicate/model/cashier_model.dart';
import 'package:bi_replicate/model/computer_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_by_cashier_model.dart';
import 'package:bi_replicate/model/diff_cash_shift_report_model.dart';
import 'package:bi_replicate/model/sales/sales_cost_based_stock_cat_db_model.dart';
import 'package:bi_replicate/model/sales/search_crit.dart';
import 'package:bi_replicate/model/stock_model.dart';
import 'package:bi_replicate/model/total_profit_report_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../model/sales/branch_model.dart';
import '../model/sales/sales_db_model.dart';

class TotalSalesController {
  final storage = const FlutterSecureStorage();

  Future<List<BranchSalesDBModel>> getCashierLogs(
      SearchCriteria searchCriteria) async {
    String? token = await storage.read(key: 'jwt');
    List<BranchSalesDBModel> list = [];
    var api = cashierLogs;
    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");
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

  Future<List<BranchSalesDBModel>> getTotalSalesByCashier(
      SearchCriteria searchCriteria) async {
    String? token = await storage.read(key: 'jwt');
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByCashier;
    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      //print("API Request: ${Uri.http(ApiURL.urlServer, api)}");
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
    String? token = await storage.read(key: 'jwt');
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByComputer;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      //print("API Request: ${Uri.http(ApiURL.urlServer, api)}");
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
    String? token = await storage.read(key: 'jwt');
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByHours;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      //print("API Request: ${Uri.http(ApiURL.urlServer, api)}");
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
    String? token = await storage.read(key: 'jwt');
    List<BranchSalesDBModel> list = [];
    var api = totalSalesByPayType;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");
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

  Future<List<SalesCostBasedStockCategoryDBModel>> getSalesCostBasedStockCat(
      SearchCriteria searchCriteria) async {
    String? token = await storage.read(key: 'jwt');
    List<SalesCostBasedStockCategoryDBModel> list = [];
    var api = salesCostBasedStockCat;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(SalesCostBasedStockCategoryDBModel.fromJson(data));
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
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.get(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      //print("API Request: ${Uri.http(ApiURL.urlServer, api)}");
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

  Future<List<StockModel>> getStocks(int page, String input) async {
    List<StockModel> stocks = [];
    var api = getStocksAPI;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(Uri.parse("${ApiURL.urlServer}${api}"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"nameCode": input, "page": page}));
      print("API : ${Uri.parse("${ApiURL.urlServer}${api}")}");
      print("API Body: ${json.encode({"nameCode": input, "page": page})}");
      print("API Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          print("stocks: ${data['txtStkcode']}");
          stocks.add(StockModel(
              txtComname: data['txtComname'],
              txtNamea: data['txtNamea'],
              txtNamee: data['txtNamee'],
              txtStkcode: data['txtStkcode']));
        }
      }
      print("stocks: ${stocks.length}");
      return stocks;
    } catch (e) {
      print("e: $e");
      return stocks;
    }
  }

  Future<List<ComputerModel>> getComputers(String input) async {
    List<ComputerModel> computersList = [];
    var api = getComputersAPI;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(Uri.parse("${ApiURL.urlServer}/${api}"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"computer": input}));
      print("API Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          print("computers: ${data['computer']}");
          computersList.add(ComputerModel(computer: data['computer']));
        }
      }
      print("computers: ${computersList.length}");
      return computersList;
    } catch (e) {
      print("e: $e");
      return computersList;
    }
  }

  Future<List<CashierModel>> getAllPOSCashiers(String input) async {
    List<CashierModel> cashiersList = [];
    var api = getPOSCashiers;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(Uri.parse("${ApiURL.urlServer}/${api}"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"cashier": input}));
      print("API Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          print("cashiersList111: ${data['txtCode']} - ${data['txtNamee']}");
          cashiersList.add(CashierModel(
              txtCode: data['txtCode'], txtNamee: data['txtNamee']));
        }
      }
      print("cashiersList: ${cashiersList.length}");
      return cashiersList;
    } catch (e) {
      print("e: $e");
      return cashiersList;
    }
  }

  Future<List<CashierModel>> getAllCashiers() async {
    List<CashierModel> cashiersList = [];
    var api = getPOSCashiers;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(Uri.parse("${ApiURL.urlServer}/${api}"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: json.encode({"cashier": ""}));
      print("API Response: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          print("cashiersList111: ${data['txtCode']} - ${data['txtNamee']}");
          cashiersList.add(CashierModel(
              txtCode: data['txtCode'], txtNamee: data['txtNamee']));
        }
      }
      print("cashiersList: ${cashiersList.length}");
      return cashiersList;
    } catch (e) {
      print("e: $e");
      return cashiersList;
    }
  }

  Future<List<DiffCashShiftReportByCashierModel>>
      getDiffCashShiftReportByCashierReportList(
          SearchCriteria searchCriteria) async {
    List<DiffCashShiftReportByCashierModel> list = [];
    var api = diffCashShiftReportByCashier;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(DiffCashShiftReportByCashierModel.fromJson(data));
        }
        print("list.length: ${list.length}");
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<DiffCashShiftReportModel>> getDiffCashShiftReportList(
      SearchCriteria searchCriteria) async {
    List<DiffCashShiftReportModel> list = [];
    var api = getDiffCashShiftReport;
    String? token = await storage.read(key: 'jwt');

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      print("response.statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(DiffCashShiftReportModel.fromJson(data));
        }
        print("list.length: ${list.length}");
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  // Future<List<TotalProfitReportModel>> getTotalProfitsReportList(
  //     SearchCriteria searchCriteria) async {
  //   List<TotalProfitReportModel> list = [];
  //   var api = totalProfits;

  //   try {
  //     var response = await http.post(
  //       Uri.parse("${ApiURL.urlServer}/${api}"),
  //       headers: {
  //         "Accept": "application/json",
  //         "content-type": "application/json",
  //       },
  //       body: json.encode(searchCriteria.toJson()),
  //     );
  //     print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

  //     print("API Request Body: ${json.encode(searchCriteria.toJson())}");
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
  //       for (var data in jsonData) {
  //         list.add(TotalProfitReportModel.fromJson(data));
  //       }
  //     }
  //     return list;
  //   } catch (e) {
  //     print("asasdasdas: $e");
  //     return list;
  //   }
  // }

  Future<List<TotalProfitReportModel>> getTotalProfitsByBranchReportList(
      SearchCriteria searchCriteria) async {
    String? token = await storage.read(key: 'jwt');
    List<TotalProfitReportModel> list = [];
    var api = totalProfitsByBranch;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(TotalProfitReportModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }

  Future<List<TotalProfitReportModel>> getTotalProfitsByCategoryReportList(
      SearchCriteria searchCriteria) async {
    String? token = await storage.read(key: 'jwt');
    List<TotalProfitReportModel> list = [];
    var api = totalProfitsByCategory;

    try {
      var response = await http.post(
        Uri.parse("${ApiURL.urlServer}/${api}"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(searchCriteria.toJson()),
      );
      print("API Request: ${Uri.parse("${ApiURL.urlServer}/${api}")}");

      print("API Request Body: ${json.encode(searchCriteria.toJson())}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in jsonData) {
          list.add(TotalProfitReportModel.fromJson(data));
        }
      }
      return list;
    } catch (e) {
      print("asasdasdas: $e");
      return list;
    }
  }
}
