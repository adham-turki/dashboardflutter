import 'dart:convert';
import 'package:bi_replicate/service/api_service.dart';

import '../../../model/settings/setup/account_model.dart';
import '../../../model/settings/setup/bi_account_model.dart';
import '../../../utils/constants/api_constants.dart';

class SetupController {
  Future<List<AccountModel>> getAllAccounts() async {
    List<AccountModel> list = [];
    String pathUrl = getAccounts;
    await ApiService().getRequest(pathUrl).then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        //creditAmt - debitAmt
        list.add(AccountModel.fromJson(elemant));
      }
    });
    return list;
  }

  Future<List<BiAccountModel>> getBiAccounts() async {
    List<BiAccountModel> list = [];
    String biUrl = getBiAccount;
    await ApiService().getRequest(biUrl).then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        list.add(BiAccountModel.fromJson(elemant));
      }
    });
    return list;
  }

  Future<bool> addBiAccount(BiAccountModel account) async {
    String pURL = addAccount;
    await ApiService().postRequest(pURL, account).then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }

  Future<List<AccountModel>> getAccountSearch(
      dynamic salesSearchCriteria) async {
    var api = searchAccountApi;
    late AccountModel accountModel;

    List<AccountModel> accountModelList = [];

    await ApiService().postRequest(api, salesSearchCriteria).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        for (var ele in jsonData) {
          accountModel = AccountModel.fromJson(ele);
          accountModelList.add(accountModel);
        }
      }
    });
    return accountModelList;
  }

  Future<bool> deleteBiAccount(BiAccountModel accountModel) async {
    String dUrl = deleteAccount;
    await ApiService().postRequest(dUrl, accountModel).then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }
}
