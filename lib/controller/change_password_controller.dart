import 'dart:convert';

import '../model/receivable_management/aging_model.dart';
import '../model/change_password_model.dart';
import '../model/criteria/search_criteria.dart';
import '../service/Api.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/values.dart';
import 'error_controller.dart';

class ChangePasswordController extends Api {
  Future<bool> changePassword(ChangePasswordModel body) async {
    String api = changePasswordApi;
    await postMethods(api, body).then((value) {
      if (value.statusCode == 200) {
        ErrorController.openErrorDialog(200, value.body);

        return true;
      }
    });
    return false;
  }
}
