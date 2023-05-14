import 'package:car_dealership/presentation/main/home/home.dart';
import 'package:car_dealership/presentation/splash/views/splash_screen.dart';
import 'package:flutter/material.dart';

final class AppRouter {
  static final navKey = GlobalKey<NavigatorState>();

  Route<dynamic> onGenerateRoute(RouteSettings? settings) {
    return switch (settings?.name) {
      SplashScreen.route => MaterialPageRoute(builder: (_) => const SplashScreen()),
      Home.route => MaterialPageRoute(builder: (_) => const Home()),
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
