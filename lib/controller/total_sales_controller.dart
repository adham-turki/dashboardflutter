import 'dart:convert';
import 'dart:typed_data';

import '../model/aging_model.dart';
import '../model/criteria/search_criteria.dart';
import '../model/total_sales_model.dart';
import '../utils/constants/Api.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/values.dart';

class TotalSalesController extends Api {
  Future<List<TotalSalesModel>> getTotalSalesMethod(
      SearchCriteria searchCriteria) async {
    var api = getTotalSales;
    List<TotalSalesModel> totalSalesList = [];
    int count = 0;
    await postMethods(api, searchCriteria.toJson()).then((response) {
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

  Future<Uint8List> exportToExcelApi(SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclTotalSales/count=${20}';
    var body = {
      "searchForm": {
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
