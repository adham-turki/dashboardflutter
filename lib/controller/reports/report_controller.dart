import 'dart:convert';
import 'dart:typed_data';

import '../../model/criteria/search_criteria.dart';
import '../../model/reports/purchase_cost_report.dart';
import '../../model/sales_adminstration/branch_model.dart';
import '../../model/reports/sales_report_model.dart';
import '../../model/sales_adminstration/sales_cost_report.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class ReportController extends Api {
  Future<List<BranchModel>> getSalesStkMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesStk;
    late SalesReportModel salesStkObj;
    List<BranchModel> salesStkList = [];
    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkObj = SalesReportModel.fromJson(jsonData);
        salesStkList = salesStkObj.branchModel;
      }
    });
    return salesStkList;
  }

  Future<List<BranchModel>> getSalesCampMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesCamp;

    late SalesReportModel salesCampObj;
    List<BranchModel> salesCampList = [];
    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCampObj = SalesReportModel.fromJson(jsonData);
        salesCampList = salesCampObj.branchModel;
      }
    });
    return salesCampList;
  }

  Future<List<BranchModel>> getSalesBranchesMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesBranches;
    late SalesReportModel salesBranchesObj;
    List<BranchModel> branchList = [];
    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesBranchesObj = SalesReportModel.fromJson(jsonData);
        branchList = salesBranchesObj.branchModel;
      }
    });
    return branchList;
  }

  Future<List<BranchModel>> getSalesSuppliersMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesSuppliers;
    late SalesReportModel salesSuppliersObj;

    List<BranchModel> salesSuppliersList = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesSuppliersObj = SalesReportModel.fromJson(jsonData);
        salesSuppliersList = salesSuppliersObj.branchModel;
      }
    });
    return salesSuppliersList;
  }

  Future<List<BranchModel>> getSalesCustomersMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesCustomers;
    late SalesReportModel salesCustomersObj;

    List<BranchModel> salesCustomersList = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCustomersObj = SalesReportModel.fromJson(jsonData);
        salesCustomersList = salesCustomersObj.branchModel;
      }
    });
    return salesCustomersList;
  }

  Future<List<BranchModel>> getSalesCustomersCategMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesCustomersCateg;
    late SalesReportModel salesCustomersCategObj;

    List<BranchModel> salesCustomersCategList = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCustomersCategObj = SalesReportModel.fromJson(jsonData);
        salesCustomersCategList = salesCustomersCategObj.branchModel;
      }
    });
    return salesCustomersCategList;
  }

  Future<List<BranchModel>> getSalesSuppliersCategMethod(
      dynamic salesSearchCriteria) async {
    var api = getSalesSuppliersCateg;
    late SalesReportModel salesSuppliersCategObj;

    List<BranchModel> salesSuppliersCategList = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesSuppliersCategObj = SalesReportModel.fromJson(jsonData);
        salesSuppliersCategList = salesSuppliersCategObj.branchModel;
      }
    });
    return salesSuppliersCategList;
  }

  Future<List<BranchModel>> getSalesStkCountCateg1Method(
      dynamic salesSearchCriteria) async {
    var api = getSalesStkCountCateg1;
    late SalesReportModel salesStkCountCateg1Obj;

    List<BranchModel> salesStkCountCateg1List = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg1Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg1List = salesStkCountCateg1Obj.branchModel;
      }
    });
    return salesStkCountCateg1List;
  }

  Future<List<BranchModel>> getSalesStkCountCateg2Method(
      dynamic salesSearchCriteria) async {
    var api = getSalesStkCountCateg2;
    late SalesReportModel salesStkCountCateg2Obj;

    List<BranchModel> salesStkCountCateg2List = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg2Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg2List = salesStkCountCateg2Obj.branchModel;
      }
    });
    return salesStkCountCateg2List;
  }

  Future<List<BranchModel>> getSalesStkCountCateg3Method(
      dynamic salesSearchCriteria) async {
    var api = getSalesStkCountCateg3;
    late SalesReportModel salesStkCountCateg3Obj;

    List<BranchModel> salesStkCountCateg3List = [];

    await postMethods(api, salesSearchCriteria).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg3Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg3List = salesStkCountCateg3Obj.branchModel;
      }
    });
    return salesStkCountCateg3List;
  }

  Future<List<SalesCostReportModel>> postSalesCostReportMethod(
      dynamic salesProvider) async {
    var api = postSalesCostReport;
    List<SalesCostReportModel> salesCostReportList = [];

    await postMethods(api, salesProvider).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        for (var salesCostReport in jsonData) {
          salesCostReportList
              .add(SalesCostReportModel.fromJson(salesCostReport));
        }
      }
    });
    return salesCostReportList;
  }

  Future<List<PurchaseCostReportModel>> postPurchaseCostReportMethod(
      dynamic purchaseProvider) async {
    var api = postPurchaseCostReport;
    List<PurchaseCostReportModel> purchaseCostReportList = [];

    await postMethods(api, purchaseProvider).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        for (var purchseCostReport in jsonData) {
          purchaseCostReportList
              .add(PurchaseCostReportModel.fromJson(purchseCostReport));
        }
      }
    });
    return purchaseCostReportList;
  }

  Future<Uint8List> exportToExcelApi(SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclSalesReport/count=${20}';
    var body = {
      "mainForm": {
        "fromDate": searchCriteria.fromDate,
        "toDate": searchCriteria.toDate,
        "voucherStatus": searchCriteria.voucherStatus
      },
      "columns": searchCriteria.columns,
      "customColumns": searchCriteria.customColumns
    };
    await postMethods(eUrl, body).then((value) {
      excelByteData = value.bodyBytes;
    });
    return excelByteData;
  }

  Future<Uint8List> exportPurchaseToExcelApi(
      SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclPurchaseReport/count=${20}';
    var body = {
      "purchasesForm": {
        "fromDate": searchCriteria.fromDate,
        "toDate": searchCriteria.toDate,
        "voucherStatus": searchCriteria.voucherStatus
      },
      "columns": searchCriteria.columns,
      "customColumns": searchCriteria.customColumns
    };
    await postMethods(eUrl, body).then((value) {
      excelByteData = value.bodyBytes;
    });
    return excelByteData;
  }
}
