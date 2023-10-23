import 'package:bi_replicate/home.dart';
import 'package:bi_replicate/provider/local_provider.dart';
import 'package:bi_replicate/provider/purchase_provider.dart';
import 'package:bi_replicate/provider/sales_search_provider.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';
import 'package:bi_replicate/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'l10n/l10n.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (e) => ScreenContentProvider()),
        ChangeNotifierProvider(create: (create) => LocaleProvider()),
        ChangeNotifierProvider(create: (create) => LocaleProvider()),
        ChangeNotifierProvider(create: (create) => SalesCriteraProvider()),
        ChangeNotifierProvider(create: (create) => PurchaseCriteraProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    //    Future<void> loadStoredLocale() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? storedLanguageCode = prefs.getString('selectedLanguage');

    //   if (storedLanguageCode != null) {
    //     Locale storedLocale = Locale(storedLanguageCode);
    //     provider.setLocale(storedLocale);
    //   }
    // }

    // loadStoredLocale();
    return MaterialApp(
      title: 'Bi',
      //  navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: provider.locale,
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
