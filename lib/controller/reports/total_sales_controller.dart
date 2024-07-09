import 'dart:convert';
import 'dart:typed_data';
import 'package:bi_replicate/model/reports/total_sales/total_sales_result.dart';
import 'package:bi_replicate/service/api_service.dart';

import '../../model/criteria/search_criteria.dart';
import '../../model/reports/total_sales/total_sales_model.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class TotalSalesController {
  Future<List<TotalSalesModel>> getTotalSalesMethod(
      SearchCriteria searchCriteria,
      {bool? isStart}) async {
    var api = getTotalSales;
    List<TotalSalesModel> totalSalesList = [];
    await ApiService()
        .postRequest(api, searchCriteria.toJson(), isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var totalSales in jsonData) {
          totalSalesList.add(TotalSalesModel.fromJson(totalSales));
        }
      }
    });
    return totalSalesList;
  }

  Future<TotalSalesResult?> getTotalSalesResultMehtod(
      SearchCriteria searchCriteria,
      {bool? isStart}) async {
    var api = getTotalSalesResult;
    late TotalSalesResult? totalSalesList;

    await ApiService()
        .postRequest(api, searchCriteria.toJson(), isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        totalSalesList = TotalSalesResult.fromJson(jsonData);
      }
    });
    return totalSalesList;
  }

  Future<Uint8List> exportToExcelApi(SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclTotalSales/count=${10}';
    var body = {
      "searchForm": {
        "fromDate": searchCriteria.fromDate,
        "toDate": searchCriteria.toDate,
        "voucherStatus": searchCriteria.voucherStatus
      },
      "columns": searchCriteria.columns,
      "customColumns": searchCriteria.customColumns
    };
    await ApiService().postRequest(eUrl, body).then((value) {
      excelByteData = value.bodyBytes;
    });
    return excelByteData;
  }
}
