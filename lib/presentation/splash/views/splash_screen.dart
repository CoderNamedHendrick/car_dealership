import 'dart:async';

import '../../main/home/home.dart';
import '../widgets/splash_loader.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pushReplacementNamed(Home.route));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Cars 101',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            // prevent repaints
            const RepaintBoundary(child: SizedBox(width: 200, child: SplashLoader())),
          ],
        ),
      ),
    );
  }
}
