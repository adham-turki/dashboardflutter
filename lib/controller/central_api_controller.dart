import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants/api_constants.dart';
import 'error_controller.dart';

class CentralApiController {
  Future<String> getApi(String pathUrl, String server) async {
    var api = "$pathUrl/$apiUrl/$server";
    print("center $api");
    var response = await http.get(Uri.parse(api));
    print("res ${response.statusCode}");
    var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    String serverUrl = jsonData['serverurl'];
    print("serverrrrrrrr ${jsonData['serverurl']}");

    if (response.statusCode != 200) {
      ErrorController.openErrorDialog(response.statusCode, response.body);
    }
    print("serverrrrrr $serverUrl");
    return serverUrl;
  }
}
