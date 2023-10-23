import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/api_url.dart';

class ApiService {
  // static String url = "https://bic.scopef.com:9002";
  final storage = const FlutterSecureStorage();

  static Future<http.Response> getRequest(String api) async {
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    var requestUrl = "${ApiURL.urlServer}/$api";
    var response = await http.get(Uri.parse(requestUrl));
    return response;
  }

  static Future<http.Response> postRequest(String api, dynamic toJson) async {
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    var requestUrl = "${ApiURL.urlServer}/$api";
    print(Uri.parse(requestUrl));
    print(json.encode(toJson));
    var response = await http.post(
      Uri.parse(requestUrl),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: json.encode(toJson),
    );
    return response;
  }

  getUrl() async {
    await storage.read(key: 'api').then((value) {
      ApiURL().setUrl(value!);
    });
  }
}
