import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';
import 'package:flutter/services.dart';

import '../../model/cheques_bank/cheques_model.dart';
import '../../model/cheques_bank/cheques_result.dart';
import '../../model/criteria/search_criteria.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';

class SelfChequesController {
  Future<List<ChequesModel>> getCheques(SearchCriteria searchCriteria,
      {bool? isStart}) async {
    List<ChequesModel> chequesList = [];

    String pathUrl = getAllCheques;
    int count = 0;

    await ApiService()
        .postRequest(pathUrl, searchCriteria.chequesToJson(), isStart: isStart)
        .then((response) {
      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));

        count = ((searchCriteria.page! - 1) * 10) + 1;

        for (var element in jsonData) {
          chequesList.add(ChequesModel.fromJson(element, count));
          count++;
        }
      }
    });
    return chequesList;
  }

  Future<ChequesResult?> getChequeResultMethod(SearchCriteria searchCriteria,
      {bool? isStart}) async {
    var api = getChequesResult;
    ChequesResult? chequesResult;
    await ApiService()
        .postRequest(api, searchCriteria.chequesToJson(), isStart: isStart)
        .then((response) {
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
    String eUrl = exportToExeclCheques;
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
