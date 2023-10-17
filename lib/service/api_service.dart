import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static String url = "https://bic.scopef.com:9002";

  static Future<http.Response> getRequest(String api) async {
    var requestUrl = "$url/$api";
    var response = await http.get(Uri.parse(requestUrl));
    return response;
  }

  static Future<http.Response> postRequest(String api, dynamic toJson) async {
    var requestUrl = "$url/$api";
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
}
