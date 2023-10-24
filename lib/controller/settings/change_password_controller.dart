import 'package:flutter/material.dart';

import '../../model/settings/change_password_model.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../error_controller.dart';

class ChangePasswordController {
  Future<bool> changePassword(
      ChangePasswordModel body, BuildContext context) async {
    String api = changePasswordApi;
    await ApiService().postRequest(api, body).then((value) {
      print(value.body);
      print(value.statusCode);
      // if (value.statusCode == 200) {
      //   ErrorController.openErrorDialog(200, value.body, context);
      //   return true;
      // }
    });
    return false;
  }
}
