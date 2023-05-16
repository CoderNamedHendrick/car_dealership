import 'package:car_dealership/presentation/main/auth/view/log_in.dart';
import 'package:car_dealership/presentation/main/auth/view/sign_up.dart';
import 'package:car_dealership/presentation/main/home/home.dart';
import 'package:car_dealership/presentation/splash/views/splash_screen.dart';
import 'package:flutter/material.dart';

import '../main/auth/view/auth_page.dart';

final class AppRouter {
  static final navKey = GlobalKey<NavigatorState>();

  Route<dynamic> onGenerateRoute(RouteSettings? settings) {
    return switch (settings?.name) {
      SplashScreen.route => MaterialPageRoute(builder: (_) => const SplashScreen()),
      Home.route => MaterialPageRoute(builder: (_) => const Home()),
      Auth.route => MaterialPageRoute(builder: (_) => const Auth()),
      Login.route => MaterialPageRoute(builder: (_) => const Login()),
      SignUp.route => MaterialPageRoute(builder: (_) => const SignUp()),
      _ => MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Undefined Route'),
            ),
          ),
        ),
    };
  }
}
