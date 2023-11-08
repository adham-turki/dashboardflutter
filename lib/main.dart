import 'package:bi_replicate/provider/dates_provider.dart';
import 'package:bi_replicate/provider/local_provider.dart';
import 'package:bi_replicate/provider/purchase_provider.dart';
import 'package:bi_replicate/provider/sales_search_provider.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'model/routes.dart';

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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    // Locale newLocal = provider.locale;
    Future<void> loadStoredLocale() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedLanguageCode = prefs.getString('selectedLanguage');

      if (storedLanguageCode != null) {
        Locale storedLocale = Locale(storedLanguageCode);
        provider.setLocale(storedLocale);
        // newLocal = storedLocale;
      }
    }

    loadStoredLocale();

    return MaterialApp.router(
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
        textTheme: getFontFamily(context),
      ),
      routerConfig: AppRoutes.routes,
    );
  }

  TextTheme getFontFamily(BuildContext context) {
    // Determine the current locale
    // print(_locale.active);
    String lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    // Use different fonts based on the language
    if (lang == "ar") {
      // Arabic font
      return GoogleFonts.readexProTextTheme(Theme.of(context).textTheme);
      // return GoogleFonts.cairoTextTheme(Theme.of(context).textTheme);
    } else {
      // English font
      return GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
    }
  }

  // Future<String?> _getToken() async {
  //   const storage = FlutterSecureStorage();
  //   return await storage.read(key: 'jwt');
  // }
}
