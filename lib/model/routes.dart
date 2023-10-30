import 'package:bi_replicate/home.dart';
import 'package:bi_replicate/screen/login_screen.dart';
import 'package:bi_replicate/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../components/key.dart';

class AppRoutes {
  static const initialRoute = "/";
  static const loginRoute = "/login";
  static const homeScreenRoute = "/mainScreenRoute";

  static final GoRouter routes = GoRouter(
      onException: (BuildContext context, state, goRouter) =>
          const LoginScreen(),
      navigatorKey: navigatorKey,
      initialLocation: loginRoute,
      routes: <GoRoute>[
        GoRoute(
          path: initialRoute,
          builder: (BuildContext context, state) => const LoginScreen(),
          redirect: (context, state) => _redirect2(context),
        ),
        GoRoute(
          path: loginRoute,
          builder: (BuildContext context, state) => const LoginScreen(),
          redirect: (context, state) => _redirect2(context),
        ),
        GoRoute(
          path: homeScreenRoute,
          builder: (_, state) => const HomePage(),
          redirect: (context, state) => _redirect(context),
        ),
      ]);

  static Future<String?> _redirect(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    return token != null ? mainScreenRoute : loginRoute;
  }

  static Future<String?> _redirect2(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    return token == null ? loginRoute : mainScreenRoute;
  }
}
