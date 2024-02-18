import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../components/key.dart';
import '../controller/error_controller.dart';
import '../model/api_url.dart';
import '../utils/constants/api_constants.dart';
import '../utils/constants/constants.dart';

class ApiService {
  // static String url = "https://bic.scopef.com:9002";
  final storage = const FlutterSecureStorage();

  Future getRequest(String api, {bool? isStart}) async {
    String? token = await storage.read(key: 'jwt');
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    var requestUrl = "${ApiURL.urlServer}/$api";

    try {
      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print(token);
      print(Uri.parse(requestUrl));
      if (response.statusCode != 200) {
        if (response.statusCode == 417 || response.statusCode == 401) {
          final context = navigatorKey.currentState!.overlay!.context;

          await storage.delete(key: "jwt").then((value) {
            if (kIsWeb) {
              // Navigator.pop(context);
              GoRouter.of(context).go(loginScreenRoute);
            } else {
              Navigator.pushReplacementNamed(context, loginScreenRoute);
            }
          });
          ErrorController.openErrorDialog(
            response.statusCode,
            response.body,
          );
        }
        // else if (response.statusCode == 401) {
        //   const storage = FlutterSecureStorage();

        //   await storage.delete(key: "jwt");

        //   final context = navigatorKey.currentState!.overlay!.context;
        //   if (kIsWeb) {
        //     print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        //     ErrorController.openErrorDialog(
        //       401,
        //       response.body,
        //     );
        //     GoRouter.of(context).go(AppRoutes.loginRoute);
        //   } else {
        //     Navigator.pushReplacementNamed(context, loginScreenRoute);
        //   }
        //   // Navigator.pushReplacementNamed(context, loginScreenRoute);
        // }
        else if (isStart == null) {
          print("inside start response ${response.statusCode}");

          ErrorController.openErrorDialog(
            response.statusCode,
            response.body,
          );
        }
      }
      return response;
    } catch (e) {
      // Handle network-related exceptions (e.g., no internet connection)
      // You can show an error message to the user or log the error.
      ErrorController.openErrorDialog(0, e.toString());

      // Handle other types of exceptions (e.g., server not reachable)
      // ErrorController.openErrorDialog(404, e);
    }
  }

  Future postRequest(String api, dynamic toJson, {bool? isStart}) async {
    if (ApiURL.urlServer == "") {
      await ApiService().getUrl();
    }
    String? token = await storage.read(key: 'jwt');
    var requestUrl = "${ApiURL.urlServer}/$api";
    print(token);
    print("req body : ${toJson}");
    print(Uri.parse(requestUrl));
    print(json.encode(toJson));
    try {
      var response = await http.post(
        Uri.parse(requestUrl),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(toJson),
      );
      print("resssssssss ${response.statusCode}");
      if (api == logInApi &&
          (response.statusCode == 400 || response.statusCode == 406)) {
        return response;
      } else if (response.statusCode != 200) {
        if (response.body == "Wrong Credentials") {
          return response;
        }

        if (response.statusCode == 417 || response.statusCode == 401) {
          final context = navigatorKey.currentState!.overlay!.context;

          await storage.delete(key: "jwt").then((value) {
            if (kIsWeb) {
              // Navigator.pop(context);
              GoRouter.of(context).go(loginScreenRoute);
            } else {
              Navigator.pushReplacementNamed(context, loginScreenRoute);
            }
          });
          ErrorController.openErrorDialog(
            response.statusCode,
            response.body,
          );
        }
        // else if (response.statusCode == 401) {
        //   const storage = FlutterSecureStorage();

        //   await storage.delete(key: "jwt");

        //   print("Iam hereeeeeee");
        //   final context = navigatorKey.currentState!.overlay!.context;
        //   if (kIsWeb) {
        //     GoRouter.of(context).go(AppRoutes.loginRoute);
        //   } else {
        //     Navigator.pushReplacementNamed(context, loginScreenRoute);
        //   }
        //   // Navigator.pushReplacementNamed(context, loginScreenRoute);
        // }
        else if (isStart == null) {
          ErrorController.openErrorDialog(
            response.statusCode,
            response.body,
          );
        }
      }
      return response;
    } catch (e) {
      // Handle network-related exceptions (e.g., no internet connection)
      // You can show an error message to the user or log the error.
      ErrorController.openErrorDialog(0, e.toString());

      // Handle other types of exceptions (e.g., server not reachable)
      // ErrorController.openErrorDialog(404, e);
    }
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
