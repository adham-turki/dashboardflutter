import 'package:flutter/material.dart';

import '../components/key.dart';
import '../dialogs/error_dialog.dart';
import '../utils/constants/error_constant.dart';

class ErrorController {
  static openErrorDialog(
      int responseStatus, String errorDetails, BuildContext context) {
    //details for each response status from the api
    if (responseStatus == 400) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error400,
          const Color.fromARGB(255, 232, 232, 23), 400, context);
    } else if (responseStatus == 401) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error401,
          const Color.fromARGB(255, 232, 232, 23), 401, context);
    } else if (responseStatus == 200) {
      dialogBasedonResponseStatus(Icons.done, errorDetails, error200,
          const Color.fromARGB(255, 81, 237, 4), 200, context);
    } else if (responseStatus == 405) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error405,
          const Color.fromARGB(255, 232, 232, 23), 405, context);
    } else if (responseStatus == 500) {
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, error500, Colors.red, 500, context);
    } else if (responseStatus == 406) {
      print("errorrrrrr");
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, error406, Colors.red, 406, context);
    } else if (responseStatus == 204) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error204,
          const Color.fromARGB(255, 232, 232, 23), 204, context);
    } else if (responseStatus == 404) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, error404,
          const Color.fromARGB(255, 232, 232, 23), 404, context);
    } else if (responseStatus == 417) {
      dialogBasedonResponseStatus(
          Icons.warning, errorDetails, error417, Colors.red, 417, context);
    }
  }

  //dialog detail
  static dialogBasedonResponseStatus(IconData icon, String errorDetails,
      String errorTitle, Color color, int statusCode, BuildContext context) {
    showDialog(
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
