import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../model/routes.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/responsive.dart';
import 'package:flutter/foundation.dart';

class LogoutTab extends StatefulWidget {
  final bool isCollapsed;
  const LogoutTab({super.key, required this.isCollapsed});

  @override
  State<LogoutTab> createState() => _LogoutTabState();
}

class _LogoutTabState extends State<LogoutTab> {
  double width = 0;
  double height = 0;
  bool isHovered = false;
  late AppLocalizations locale;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bool isDesktop = Responsive.isDesktop(context);

    bool isTablet = Responsive.isTablet(context);

    return InkWell(
      onTap: () async {
        const storage = FlutterSecureStorage();

        await storage.delete(key: "jwt");
        // storage.
        // if (kIsWeb) {
        //   // Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
        //   GoRouter.of(context).pop();
        //   GoRouter.of(context).go(AppRoutes.loginRoute);
        // } else {
        //   // Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
        //   GoRouter.of(context).pop();
        //   GoRouter.of(context).go(AppRoutes.loginRoute);
        // }

        GoRouter.of(context).go(AppRoutes.initialRoute);
        // GoRouter.of(context).pop();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: logoutTab(isDesktop, isTablet),
      ),
    );
  }

  Container logoutTab(bool isDesktop, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: getActiveColor(),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      height: height * 0.06,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: !widget.isCollapsed
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: isDesktop
                      ? width * 0.014
                      : isTablet
                          ? width * 0.015
                          : width * 0.028,
                ),
                SizedBox(
                  width: width * 0.005,
                ),
                !widget.isCollapsed
                    ? Text(
                        locale.logout,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop
                              ? width * 0.01
                              : isTablet
                                  ? width * 0.015
                                  : width * 0.028,
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  getActiveColor() {
    return isHovered ? hoverColor : primary;
  }
}
