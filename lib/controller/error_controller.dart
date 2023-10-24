import 'package:flutter/material.dart';

import '../components/key.dart';
import '../dialogs/error_dialog.dart';
import '../utils/constants/error_constant.dart';

class ErrorController {
  static openErrorDialog(int responseStatus, String errorDetails) {
    //details for each response status from the api
    if (responseStatus == 400) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error400,
          const Color.fromARGB(255, 232, 232, 23), 400);
    } else if (responseStatus == 401) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error401,
          const Color.fromARGB(255, 232, 232, 23), 401);
    } else if (responseStatus == 200) {
      dialogBasedonResponseStatus(Icons.done, errorDetails, error200,
          const Color.fromARGB(255, 81, 237, 4), 200);
    } else if (responseStatus == 405) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error405,
          const Color.fromARGB(255, 232, 232, 23), 405);
    } else if (responseStatus == 500) {
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, error500, Colors.red, 500);
    } else if (responseStatus == 406) {
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, error406, Colors.red, 406);
    } else if (responseStatus == 204) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error204,
          const Color.fromARGB(255, 232, 232, 23), 204);
    } else if (responseStatus == 404) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error404,
          const Color.fromARGB(255, 232, 232, 23), 404);
    } else if (responseStatus == 417) {
      dialogBasedonResponseStatus(
          Icons.warning, errorDetails, error417, Colors.red, 417);
    }
  }

  //dialog detail
  static dialogBasedonResponseStatus(IconData icon, String errorDetails,
      String errorTitle, Color color, int statusCode) {
    final context = navigatorKey.currentState!.overlay!.context;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return ErrorDialog(
          icon: icon,
          errorDetails: errorDetails,
          errorTitle: errorTitle,
          color: color,
          statusCode: statusCode,
        );
      },
    );
  }
}
