import 'dart:convert';

import 'package:flutter/services.dart';

import '../../model/cheques_bank/cheques_model.dart';
import '../../model/cheques_bank/cheques_result.dart';
import '../../model/criteria/search_criteria.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class SelfChequesController extends Api {
  Future<List<ChequesModel>> getCheques(SearchCriteria searchCriteria) async {
    List<ChequesModel> chequesList = [];

    String pathUrl = getAllCheques;
    int count = 0;

    await postMethods(pathUrl, searchCriteria.chequesToJson()).then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      count = ((searchCriteria.page! - 1) * 10) + 1;

      for (var element in jsonData) {
        chequesList.add(ChequesModel.fromJson(element, count));
        count++;
      }
    });
    return chequesList;
  }

  Future<ChequesResult> getPurchaseResultMehtod(
      SearchCriteria searchCriteria) async {
    var api = getChequesResult;
    late ChequesResult chequesResult = ChequesResult();
    await postMethods(api, searchCriteria.chequesToJson()).then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        chequesResult = ChequesResult.fromJson(jsonData);
      }
    });
    return chequesResult;
  }

  Future<Uint8List> exportToExcelApi(SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclCheques/count=${10}';
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
      // print(value.statusCode);
      //   print(value.bodyBytes);
      excelByteData = value.bodyBytes;
    });

    return excelByteData;
  }
}
