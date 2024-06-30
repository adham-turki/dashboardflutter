import 'dart:async';
import 'package:bi_replicate/components/key.dart';
import 'package:bi_replicate/dialogs/login_dialog.dart';
import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/provider/local_provider.dart';
import 'package:bi_replicate/provider/purchase_provider.dart';
import 'package:bi_replicate/provider/sales_search_provider.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'model/routes.dart';
// import 'dart:html' as html;

import 'provider/reports_provider.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (e) => ScreenContentProvider()),
        ChangeNotifierProvider(create: (create) => LocaleProvider()),
        ChangeNotifierProvider(create: (create) => LocaleProvider()),
        ChangeNotifierProvider(create: (create) => SalesCriteraProvider()),
        ChangeNotifierProvider(create: (create) => PurchaseCriteraProvider()),
        ChangeNotifierProvider(create: (create) => DatesProvider()),
        ChangeNotifierProvider(create: (create) => ReportsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// void _redirect() async {
//   const storage = FlutterSecureStorage();
//   await storage.deleteAll();
// }

class _MyAppState extends State<MyApp> {
  bool temp = true;
  bool isLoginDialog = false;
  final sessionStateStream = StreamController<SessionState>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    Future<void> loadStoredLocale() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedLanguageCode = prefs.getString('selectedLanguage');

      if (storedLanguageCode != null) {
        Locale storedLocale = Locale(storedLanguageCode);
        provider.setLocale(storedLocale);
      }
    }

    if (temp) {
      loadStoredLocale();
      temp = false;
    }

    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 30),
      invalidateSessionForUserInactivity: const Duration(minutes: 30),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) async {
      const storage = FlutterSecureStorage();
      final context2 = navigatorKey.currentState!.overlay!.context;
      // stop listening, as user will already be in auth page
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout &&
          GoRouter.of(context2)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString()
                  .compareTo(loginScreenRoute) !=
              0 &&
          !isLoginDialog) {
        await storage.delete(key: "jwt").then((value) {
          // handle user  inactive timeout
          isLoginDialog = true;

          showDialog(
              context: context2,
              barrierDismissible: false,
              builder: (builder) {
                return const LoginDialog();
              }).then((value) => isLoginDialog = false);
        });
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout &&
          GoRouter.of(context2)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString()
                  .compareTo(loginScreenRoute) !=
              0 &&
          !isLoginDialog) {
        // handle user  app lost focus timeout
        const storage = FlutterSecureStorage();
        final context2 = navigatorKey.currentState!.overlay!.context;

        await storage.delete(key: "jwt").then((value) {
          isLoginDialog = true;

          showDialog(
              context: context2,
              barrierDismissible: false,
              builder: (builder) {
                return const LoginDialog();
              }).then((value) => isLoginDialog = false);
        });
      }
    });

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: MaterialApp.router(
        title: 'BI | Scope',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: provider.locale,
        supportedLocales: L10n.all,
        theme: ThemeData.light().copyWith(
            // textTheme: getFontFamily(context),
            scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.grey[600]),
        )),
        routerConfig: AppRoutes.routes,
      ),
    );
  }

  TextTheme getFontFamily(BuildContext context) {
    // Determine the current locale
    String lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    // Use different fonts based on the language
    if (lang == "ar") {
      print("arrrrrrrrrrrrrrrrr");

      // Arabic font
      return GoogleFonts.readexProTextTheme(Theme.of(context).textTheme);
      // return GoogleFonts.cairoTextTheme(Theme.of(context).textTheme);
    } else {
      print("engggggggggggg");

      // English font
      return GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    }
  }

  // Future<String?> _getToken() async {
  //   const storage = FlutterSecureStorage();
  //   return await storage.read(key: 'jwt');
  // }
}
