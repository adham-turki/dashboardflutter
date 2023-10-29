import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/key.dart';
import '../dialogs/error_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/routes.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/error_constant.dart';

class ErrorController {
  static bool temp = false;
  static openErrorDialog(int responseStatus, String errorDetails) {
    final context = navigatorKey.currentState!.overlay!.context;
    AppLocalizations locale = AppLocalizations.of(context);
    //details for each response status from the api
    if (responseStatus == 400) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, locale.error400,
          const Color.fromARGB(255, 232, 232, 23), 400);
    } else if (responseStatus == 401) {
      GoRouter.of(context).go(AppRoutes.homeScreenRoute);

      // dialogBasedonResponseStatus(Icons.warning, errorDetails, locale.error401,
      //     const Color.fromARGB(255, 232, 232, 23), 401);
    } else if (responseStatus == 200) {
      dialogBasedonResponseStatus(Icons.done, errorDetails, locale.error200,
          const Color.fromARGB(255, 81, 237, 4), 200);
    } else if (responseStatus == 405) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, locale.error405,
          const Color.fromARGB(255, 232, 232, 23), 405);
    } else if (responseStatus == 500) {
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, locale.error500, Colors.red, 500);
    } else if (responseStatus == 406) {
      dialogBasedonResponseStatus(
          Icons.error, errorDetails, locale.error406, Colors.red, 406);
    } else if (responseStatus == 204) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, locale.error204,
          const Color.fromARGB(255, 232, 232, 23), 204);
    } else if (responseStatus == 404) {
      dialogBasedonResponseStatus(Icons.warning, errorDetails, locale.error404,
          const Color.fromARGB(255, 232, 232, 23), 404);
    } else if (responseStatus == 417) {
      dialogBasedonResponseStatus(
          Icons.warning, errorDetails, locale.error417, Colors.red, 417);
    } else if (responseStatus == 0 && !ErrorController.temp) {
      ErrorController.temp = true;
      dialogBasedonResponseStatus(
          Icons.warning, errorDetails, locale.networkError, Colors.red, 0);
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
    ).then((value) {
      ErrorController.temp = false;
    });
  }
}
