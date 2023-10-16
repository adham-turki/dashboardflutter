import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/receivable_management/aging_model.dart';
import '../model/criteria/search_criteria.dart';
import '../model/users_model.dart';
import '../service/Api.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/values.dart';

class LoginController extends Api {
  Future<bool> logInPost(UserModel userModel) async {
    String api = logInApi;
    var response = await postMethods(api, userModel.toJson());
    print(response.statusCode);
    if (response.statusCode == statusOk) {
      String token = response.body.substring(13, response.body.length - 2);

      const storage = FlutterSecureStorage();

      await storage.write(key: 'jwt', value: token);
      return true;
    }

    return false;
  }
}
