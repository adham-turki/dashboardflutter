import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/api_url.dart';

class ApiService {
  // static String url = "https://bic.scopef.com:9002";
  final storage = const FlutterSecureStorage();

  Future<http.Response> getRequest(String api) async {
    String? token = await storage.read(key: 'jwt');
    print("ttttttt: ${token}");
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
    return response;
  }

  Future<http.Response> postRequest(String api, dynamic toJson) async {
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    String? token = await storage.read(key: 'jwt');
    print("ttttttt: ${token}");
    var requestUrl = "${ApiURL.urlServer}/$api";
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
    return response;
  }

  Future<http.Response> postRequestForResetPassword(
      String api, dynamic toJson) async {
    String? token = await storage.read(key: 'jwt');
    print("ttttttt: ${token}");
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
        "Authorization": "Bearer $token"
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
