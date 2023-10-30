import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../model/routes.dart';
import '../utils/constants/constants.dart';

class ErrorDialog extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String errorDetails;
  final String errorTitle;
  final int statusCode;
  const ErrorDialog(
      {Key? key,
      required this.icon,
      required this.errorDetails,
      required this.errorTitle,
      required this.color,
      required this.statusCode})
      : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool showDetails = false;

  late AppLocalizations _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.color,
                  size: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Flexible(
                  child: Text(
                    widget.errorTitle,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () async {
                    if (widget.statusCode == 401 || widget.statusCode == 417) {
                      const storage = FlutterSecureStorage();

                      await storage.delete(key: "jwt");

                      GoRouter.of(context).go(AppRoutes.loginRoute);
                      // Navigator.pushReplacementNamed(context, mainScreenRoute);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(_locale.ok),
                ),
                const SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  child: Text(
                    _locale.showDetails,
                    style: TextStyle(color: showDetails ? Colors.red : null),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              ],
            ),
            if (showDetails)
              Flexible(
                child: Text(
                  widget.errorDetails,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
