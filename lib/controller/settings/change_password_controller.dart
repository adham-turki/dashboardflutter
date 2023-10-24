import 'package:flutter/material.dart';

import '../../model/settings/change_password_model.dart';
import '../../service/api_service.dart';
import '../../utils/constants/api_constants.dart';
import '../error_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordController {
  Future<bool> changePassword(
      ChangePasswordModel body, AppLocalizations locale) async {
    String api = changePasswordApi;
    await ApiService().postRequest(api, body).then((value) {
      print(value.body);
      print(value.statusCode);
      if (value.statusCode == 200) {
        ErrorController.openErrorDialog(200, locale.changeSuccessfully);
        return true;
      }
    });
    return false;
  }
}
