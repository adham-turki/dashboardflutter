import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../controller/error_controller.dart';
import '../model/api_url.dart';
import '../utils/constants/api_constants.dart';

class ApiService {
  // static String url = "https://bic.scopef.com:9002";
  final storage = const FlutterSecureStorage();

  Future<http.Response> getRequest(String api) async {
    String? token = await storage.read(key: 'jwt');
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    var requestUrl = "${ApiURL.urlServer}/$api";
    var response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode != 200) {
      ErrorController.openErrorDialog(response.statusCode, response.body);
    }
    return response;
  }

  Future<http.Response> postRequest(String api, dynamic toJson) async {
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    String? token = await storage.read(key: 'jwt');
    var requestUrl = "${ApiURL.urlServer}/$api";
    print(token);
    print(Uri.parse(requestUrl));
    print(json.encode(toJson));
    var response = await http.post(
      Uri.parse(requestUrl),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(toJson),
    );
    if (api == logInApi &&
        (response.statusCode == 400 || response.statusCode == 406)) {
      return response;
    } else if (response.statusCode != 200) {
      if (response.body == "Wrong Credentials") {
        return response;
      }
      ErrorController.openErrorDialog(
        response.statusCode,
        response.body,
      );
    }
    return response;
  }

  // Future<http.Response> postRequestForResetPassworصd(
  //     String api, dynamic toJson) async {
  //   String? token = await storage.read(key: 'jwt');
  //   if (ApiURL.urlServer == "") {
  //     await ApiService().getUrl();
  //   }
  //   var requestUrl = "${ApiURL.urlServer}/$api";

  //   var response = await http.post(
  //     Uri.parse(requestUrl),
  //     headers: {
  //       "Accept": "application/json",
  //       "content-type": "application/json",
  //       "Authorization": "Bearer $token"
  //     },
  //     body: json.encode(toJson),
  //   );
  //   return response;
  // }

  getUrl() async {
    await storage.read(key: 'api').then((value) {
      ApiURL().setUrl(value!);
    });
  }
}
