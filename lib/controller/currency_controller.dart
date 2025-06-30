import 'dart:convert';

import 'package:bi_replicate/constants/api_constants.dart';
import 'package:bi_replicate/model/currency_model.dart';
import 'package:bi_replicate/service/api_service.dart';
import 'package:bi_replicate/utils/constants/values.dart';

class CurrencyController {
  Future<CurrencyModel> getBaseCurrencyModel() async {
    try {
      var response = await ApiService().getRequest(
        getCurrenciesApi,
      );

      if (response.statusCode == statusOk) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        print("asdasdasdasdasdasdasdasd: $jsonData");
        for (var element in jsonData) {
          final currency = CurrencyModel.fromJson(element);
          if (currency.bolBasecurrency == true) {
            return currency;
          }
        }
      }
    } catch (e) {
      print("exxxxxxxxxx: $e");
    }
    return CurrencyModel(txtCode: "");
  }
}
