import 'dart:convert';

import 'package:bi_replicate/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/api_url.dart';
import '../../model/login/users_model.dart';
import '../../model/payload_model.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/values.dart';
import '../error_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginController {
  Future<bool> logInPost(UserModel userModel, AppLocalizations local) async {
    String api = logInApi;
    print("reqBody: ${userModel.toJson()}");

    var response = await ApiService().postRequest(api, userModel.toJson());

    print("code: ${response.statusCode}");
    print("body: ${response.body}");
    if (response.statusCode == statusOk) {
      String token = response.body.substring(13, response.body.length - 2);
      print("tokeeeen : :$token");
      const storage = FlutterSecureStorage();

      await storage.write(key: 'jwt', value: token);
      await storage.write(key: 'user', value: userModel.userName);

      await getExpDate(token, storage);
      return true;
    } else {
      if (response.statusCode == 400 || response.statusCode == 406) {
        ErrorController.dialogBasedonResponseStatus(Icons.warning,
            local.wronUserNameOrPass, local.wrongInput, Colors.red, 400);
      }
      ApiURL().setUrl("");
    }

    return false;
  }

  Future<void> getExpDate(String token, FlutterSecureStorage storage) async {
    final encodedPayload = token.split('.')[1];
    final payloadData =
        utf8.fuse(base64).decode(base64.normalize(encodedPayload));
    final payLoad = PayloadModel.fromJson(jsonDecode(payloadData));
    DateTime expDateTime =
        DateTime.fromMillisecondsSinceEpoch(payLoad.exp! * 1000);
    await storage.write(key: "expDate", value: expDateTime.toString());
  }
}
