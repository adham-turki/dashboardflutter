import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../components/key.dart';
import '../utils/constants/api_constants.dart';
import 'error_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CentralApiController {
  Future<String> getApi(
      String pathUrl, String server, AppLocalizations local) async {
    var api = "$pathUrl/$apiUrl/$server";
    print("center $api");
    String serverUrl = "";

    await http.get(Uri.parse(api)).then((value) {
      final context = navigatorKey.currentState!.overlay!.context;
      Navigator.pop(context);

      if (value.statusCode != 200) {
        if (value.statusCode == 204) {
          ErrorController.openErrorDialog(406, local.wrongAliasName);
        } else {
          ErrorController.openErrorDialog(value.statusCode, value.body);
        }
      } else {
        var jsonData = jsonDecode(utf8.decode(value.bodyBytes));
        serverUrl = jsonData['serverurl'];
      }
    });

    return serverUrl;
  }
}
