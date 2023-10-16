import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Api {
  String url = "http://167.235.150.228:9002";
  final storage = const FlutterSecureStorage();

  Future<http.Response> postMethods(String pathUrl, dynamic body) async {
    String? token = await storage.read(key: 'jwt');
    String api = pathUrl;
    var fApi = Uri.parse("$url/$api");
    var response = await http.post(fApi,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));
    print(json.encode(body));

    if (response.statusCode != 200) {
      // ErrorController.openErrorDialog(response.statusCode, response.body);
    }
    return response;
  }

  Future<http.Response> getMethods(String pathUrl) async {
    String? token = await storage.read(key: 'jwt');

    var fApi = "$url/$pathUrl";
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    var response = await http.get(Uri.parse(fApi), headers: headers);
    if (response.statusCode != 200) {
      // ErrorController.openErrorDialog(response.statusCode, response.body);
    }
    return response;
  }
}
