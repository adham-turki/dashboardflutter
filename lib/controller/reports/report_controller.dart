import 'dart:convert';
import 'dart:typed_data';
import '../../../service/api_service.dart';
import '../../../utils/constants/values.dart';
import '../../model/criteria/search_criteria.dart';
import '../../model/reports/purchase_cost_report.dart';
import '../../model/reports/reports_result.dart';
import '../../model/reports/sales_report_model/sales_cost_report.dart';
import '../../model/reports/sales_report_model/sales_report_model.dart';
import '../../model/sales_adminstration/branch_model.dart';
import '../../utils/constants/api_constants.dart';

class ReportController {
  // Future<List<BranchModel>> getSalesStkMethodInformative(
  //     dynamic salesSearchCriteria,
  //     InformativeReportProvider informativeReportProvider,
  //     {bool? isStart}) async {
  //   var api = getSalesStk;
  //   late SalesReportModel salesStkObj;
  //   List<BranchModel> salesStkList = [];
  //   await ApiService()
  //       .postRequest(api, salesSearchCriteria, isStart: isStart)
  //       .then((response) {
  //     if (response.statusCode == statusOk) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

  //       salesStkObj = SalesReportModel.fromJson(jsonData);
  //       salesStkList = salesStkObj.branchModel;
  //     }
  //     salesStkList = salesStkList
  //         .where((branch) => !informativeReportProvider.itemsList
  //             .any((item) => item.branchCode == branch.branchCode))
  //         .toList();
  //   });
  //   return salesStkList;
  // }

  // Future<List<BranchModel>> getSalesStkDocReportMethod(
  //     dynamic salesSearchCriteria, DocReportProvider informativeReportProvider,
  //     {bool? isStart}) async {
  //   var api = getSalesStk;
  //   late SalesReportModel salesStkObj;
  //   List<BranchModel> salesStkList = [];
  //   await ApiService()
  //       .postRequest(api, salesSearchCriteria, isStart: isStart)
  //       .then((response) {
  //     if (response.statusCode == statusOk) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

  //       salesStkObj = SalesReportModel.fromJson(jsonData);
  //       salesStkList = salesStkObj.branchModel;
  //     }
  //     salesStkList = salesStkList
  //         .where((branch) => !informativeReportProvider.itemsList
  //             .any((item) => item.branchCode == branch.branchCode))
  //         .toList();
  //   });
  //   return salesStkList;
  // }

  Future<List<BranchModel>> getSalesStkMethod(dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesStk;
    late SalesReportModel salesStkObj;
    List<BranchModel> salesStkList = [];
    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        salesStkObj = SalesReportModel.fromJson(jsonData);
        salesStkList = salesStkObj.branchModel;
      }
    });
    return salesStkList;
  }

  Future<List<BranchModel>> getSalesCampMethod(dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesCamp;

    late SalesReportModel salesCampObj;
    List<BranchModel> salesCampList = [];
    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCampObj = SalesReportModel.fromJson(jsonData);
        salesCampList = salesCampObj.branchModel;
      }
    });
    return salesCampList;
  }

  Future<ReportsResult?> getPurchaseResultMehtod(dynamic purchaseProvider,
      {bool? isStart}) async {
    var api = getPurchaseResult;
    ReportsResult? purchaseResult;
    await ApiService()
        .postRequest(api, purchaseProvider, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        purchaseResult = ReportsResult.fromJson(jsonData);
      }
    });
    return purchaseResult;
  }

  Future<List<BranchModel>> getSalesBranchesMethod(dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesBranches;
    late SalesReportModel salesBranchesObj;
    List<BranchModel> branchList = [];
    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesBranchesObj = SalesReportModel.fromJson(jsonData);
        branchList = salesBranchesObj.branchModel;
      }
    });
    return branchList;
  }

  Future<Uint8List> exportToExcelApi(
      SearchCriteria searchCriteria, Map<String, dynamic> searchBody) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = exportToExeclSalesReport;
    var body = {
      "mainForm": searchBody,
      "columns": searchCriteria.columns,
      "customColumns": searchCriteria.customColumns
    };
    print("search ${body}");
    await ApiService().postRequest(eUrl, body).then((value) {
      excelByteData = value.bodyBytes;
    });
    return excelByteData;
  }

  Future<ReportsResult?> getSalesResultMehtod(dynamic salesProvider,
      {bool? isStart}) async {
    var api = getSalesResult;
    late ReportsResult? salesResult;

    await ApiService()
        .postRequest(api, salesProvider, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesResult = ReportsResult.fromJson(jsonData);
      }
    });

    return salesResult;
  }

  Future<Uint8List> exportPurchaseToExcelApi(
      SearchCriteria searchCriteria, Map<String, dynamic> searchBody) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = exportToExeclPurchaseReport;
    var body = {
      "purchasesForm": searchBody,
      "columns": searchCriteria.columns,
      "customColumns": searchCriteria.customColumns
    };
    await ApiService().postRequest(eUrl, body).then((value) {
      excelByteData = value.bodyBytes;
      print("ressss ${value.statusCode}");
    });
    return excelByteData;
  }
  // Future<List<BranchModel>> getSalesBranchesMethod(dynamic salesSearchCriteria,
  //     {bool? isStart}) async {
  //   var api = getSalesBranches;
  //   late SalesReportModel salesBranchesObj;
  //   List<BranchModel> branchList = [];
  //   await ApiService()
  //       .postRequest(api, salesSearchCriteria, isStart: isStart)
  //       .then((response) {
  //     if (response.statusCode == statusOk) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
  //       salesBranchesObj = SalesReportModel.fromJson(jsonData);
  //       branchList = salesBranchesObj.branchModel;
  //     }
  //   });
  //   return branchList;
  // }

  // Future<List<BranchModel>> getSalesSuppliersMethodInformative(
  //     dynamic salesSearchCriteria,
  //     InformativeReportProvider informativeReportProvider,
  //     {bool? isStart}) async {
  //   var api = getSalesSuppliers;
  //   late SalesReportModel salesSuppliersObj;

  //   List<BranchModel> salesSuppliersList = [];

  //   await ApiService()
  //       .postRequest(api, salesSearchCriteria, isStart: isStart)
  //       .then((response) {
  //     if (response.statusCode == statusOk) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
  //       salesSuppliersObj = SalesReportModel.fromJson(jsonData);
  //       salesSuppliersList = salesSuppliersObj.branchModel;
  //       salesSuppliersList = salesSuppliersList
  //           .where((branch) => !informativeReportProvider.supplierList
  //               .any((item) => item.branchCode == branch.branchCode))
  //           .toList();
  //     }
  //   });
  //   return salesSuppliersList;
  // }

  // Future<List<BranchModel>> getSalesSuppliersMethodDoc(
  //     dynamic salesSearchCriteria, DocReportProvider doc,
  //     {bool? isStart}) async {
  //   var api = getSalesSuppliers;
  //   late SalesReportModel salesSuppliersObj;

  //   List<BranchModel> salesSuppliersList = [];

  //   await ApiService()
  //       .postRequest(api, salesSearchCriteria, isStart: isStart)
  //       .then((response) {
  //     if (response.statusCode == statusOk) {
  //       var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
  //       salesSuppliersObj = SalesReportModel.fromJson(jsonData);
  //       salesSuppliersList = salesSuppliersObj.branchModel;
  //       salesSuppliersList = salesSuppliersList
  //           .where((branch) => !doc.supplierList
  //               .any((item) => item.branchCode == branch.branchCode))
  //           .toList();
  //     }
  //   });
  //   return salesSuppliersList;
  // }

  Future<List<BranchModel>> getSalesSuppliersMethod(dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesSuppliers;
    late SalesReportModel salesSuppliersObj;

    List<BranchModel> salesSuppliersList = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesSuppliersObj = SalesReportModel.fromJson(jsonData);
        salesSuppliersList = salesSuppliersObj.branchModel;
      }
    });
    return salesSuppliersList;
  }

  Future<List<BranchModel>> getSalesCustomersMethod(dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesCustomers;
    late SalesReportModel salesCustomersObj;

    List<BranchModel> salesCustomersList = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCustomersObj = SalesReportModel.fromJson(jsonData);
        salesCustomersList = salesCustomersObj.branchModel;
      }
    });
    return salesCustomersList;
  }

  Future<List<BranchModel>> getSalesCustomersCategMethod(
      dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesCustomersCateg;
    late SalesReportModel salesCustomersCategObj;

    List<BranchModel> salesCustomersCategList = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesCustomersCategObj = SalesReportModel.fromJson(jsonData);
        salesCustomersCategList = salesCustomersCategObj.branchModel;
      }
    });
    return salesCustomersCategList;
  }

  Future<List<BranchModel>> getSalesSuppliersCategMethod(
      dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesSuppliersCateg;
    late SalesReportModel salesSuppliersCategObj;

    List<BranchModel> salesSuppliersCategList = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesSuppliersCategObj = SalesReportModel.fromJson(jsonData);
        salesSuppliersCategList = salesSuppliersCategObj.branchModel;
      }
    });
    return salesSuppliersCategList;
  }

  Future<List<BranchModel>> getSalesStkCountCateg1Method(
      dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesStkCountCateg1;
    late SalesReportModel salesStkCountCateg1Obj;

    List<BranchModel> salesStkCountCateg1List = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg1Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg1List = salesStkCountCateg1Obj.branchModel;
      }
    });
    return salesStkCountCateg1List;
  }

  Future<List<BranchModel>> getSalesStkCountCateg2Method(
      dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesStkCountCateg2;
    late SalesReportModel salesStkCountCateg2Obj;

    List<BranchModel> salesStkCountCateg2List = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg2Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg2List = salesStkCountCateg2Obj.branchModel;
      }
    });
    return salesStkCountCateg2List;
  }

  Future<List<BranchModel>> getSalesStkCountCateg3Method(
      dynamic salesSearchCriteria,
      {bool? isStart}) async {
    var api = getSalesStkCountCateg3;
    late SalesReportModel salesStkCountCateg3Obj;

    List<BranchModel> salesStkCountCateg3List = [];

    await ApiService()
        .postRequest(api, salesSearchCriteria, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        salesStkCountCateg3Obj = SalesReportModel.fromJson(jsonData);
        salesStkCountCateg3List = salesStkCountCateg3Obj.branchModel;
      }
    });
    return salesStkCountCateg3List;
  }

  Future<List<SalesCostReportModel>> postSalesCostReportMethod(
      dynamic salesProvider,
      {bool? isStart}) async {
    var api = postSalesCostReport;
    List<SalesCostReportModel> salesCostReportList = [];

    await ApiService()
        .postRequest(api, salesProvider, isStart: isStart)
        .then((response) {
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
      dynamic purchaseProvider,
      {bool? isStart}) async {
    var api = postPurchaseCostReport;
    List<PurchaseCostReportModel> purchaseCostReportList = [];

    await ApiService()
        .postRequest(api, purchaseProvider, isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        for (var purchseCostReport in jsonData) {
          purchaseCostReportList
              .add(PurchaseCostReportModel.fromJson(purchseCostReport));
        }
        print("purchaseCostReportList:${purchaseCostReportList.length}");
      }
    });
    return purchaseCostReportList;
  }
}
