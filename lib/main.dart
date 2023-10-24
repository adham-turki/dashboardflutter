import 'package:bi_replicate/home.dart';
import 'package:bi_replicate/provider/local_provider.dart';
import 'package:bi_replicate/provider/purchase_provider.dart';
import 'package:bi_replicate/provider/sales_search_provider.dart';
import 'package:bi_replicate/provider/screen_content_provider.dart';

import 'package:bi_replicate/screen/login_screen.dart';
import 'package:bi_replicate/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/key.dart';
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
    // final provider = Provider.of<LocaleProvider>(context);

    //    Future<void> loadStoredLocale() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? storedLanguageCode = prefs.getString('selectedLanguage');

    //   if (storedLanguageCode != null) {
    //     Locale storedLocale = Locale(storedLanguageCode);
    //     provider.setLocale(storedLocale);
    //   }
    // }

    // loadStoredLocale();
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final hasToken = snapshot.data != null;
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            navigatorKey: navigatorKey,
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
            // home: hasToken ? const HomePage() : const LoginScreen(),
            initialRoute: hasToken ? mainScreenRoute : loginScreenRoute,
            routes: {
              loginScreenRoute: (context) => const LoginScreen(),
              mainScreenRoute: (context) => const HomePage(),
            },
          );
        }
      },
    );

    // return MaterialApp(
    //   navigatorKey: navigatorKey,
    //   title: 'Bi',
    //   //  navigatorKey: navigatorKey,
    //   localizationsDelegates: const [
    //     AppLocalizations.delegate,
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //   ],
    //   locale: provider.locale,
    //   supportedLocales: L10n.all,
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   initialRoute: hasToken ? mainScreenRoute : loginScreenRoute,
    //   routes: {
    //     loginScreenRoute: (context) => const LoginScreen(),
    //     mainScreenRoute: (context) => const HomePage(),
    //   },
    // );
  }

  Future<String?> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'jwt');
  }
}
