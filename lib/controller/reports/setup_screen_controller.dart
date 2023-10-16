import 'dart:convert';

import '../../model/account_model.dart';
import '../../model/bi_account_model.dart';
import '../../service/Api.dart';
import '../../utils/constants/api_constants.dart';

class SetupController extends Api {
  Future<List<AccountModel>> getAllAccounts() async {
    List<AccountModel> list = [];
    String pathUrl = getAccounts;
    await getMethods(pathUrl).then((response) {
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
    await getMethods(biUrl).then((response) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var elemant in jsonData) {
        list.add(BiAccountModel.fromJson(elemant));
      }
    });
    return list;
  }

  Future<bool> addBiAccount(BiAccountModel account) async {
    String pURL = addAccount;
    await postMethods(pURL, account).then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }

  Future<bool> deleteBiAccount(BiAccountModel accountModel) async {
    String dUrl = deleteAccount;
    await postMethods(dUrl, accountModel).then((value) {
      if (value.statusCode == 200) {
        return true;
      }
    });
    return false;
  }
}
