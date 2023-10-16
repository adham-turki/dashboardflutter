import 'dart:convert';
import 'dart:typed_data';

import '../model/aging_model.dart';
import '../model/cheques_model.dart';
import '../model/criteria/search_criteria.dart';
import '../utils/constants/Api.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/values.dart';

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

  Future<Uint8List> exportToExcelApi(SearchCriteria searchCriteria) async {
    Uint8List excelByteData = Uint8List.fromList([
      0x48, 0x65, 0x6C, 0x6C,
      0x6F, // Example byte data (ASCII values for "Hello")
      // Add more bytes as needed
    ]);
    String eUrl = '$exportToExeclCheques/count=${20}';
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
