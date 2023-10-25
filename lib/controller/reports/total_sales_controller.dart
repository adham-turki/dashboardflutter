import 'dart:convert';
import 'dart:typed_data';
import 'package:bi_replicate/model/reports/total_sales/total_sales_result.dart';
import 'package:bi_replicate/service/api_service.dart';

import '../../model/criteria/search_criteria.dart';
import '../../model/reports/total_sales/total_sales_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class TotalSalesController {
  Future<List<TotalSalesModel>> getTotalSalesMethod(
      SearchCriteria searchCriteria) async {
    var api = getTotalSales;
    List<TotalSalesModel> totalSalesList = [];
    int count = 0;
    await ApiService()
        .postRequest(api, searchCriteria.toJson())
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        count = ((searchCriteria.page! - 1) * 10) + 1;
        for (var totalSales in jsonData) {
          totalSalesList.add(TotalSalesModel.fromJson(totalSales, count));
          count++;
        }
      }
    });
    return totalSalesList;
  }

  Future<TotalSalesResult> getTotalSalesResultMehtod(
      SearchCriteria searchCriteria) async {
    var api = getTotalSalesResult;
    late TotalSalesResult totalSalesList = TotalSalesResult();
    print("body ${searchCriteria.toJson()}");

    await ApiService()
        .postRequest(api, searchCriteria.toJson())
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
      print(value.bodyBytes);
      excelByteData = value.bodyBytes;
    });
    return excelByteData;
  }
}
