import 'package:car_dealership/presentation/splash/widgets/splash_loader.dart';
import 'package:flutter/material.dart';

class CarLoader extends StatelessWidget {
  const CarLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: SizedBox(width: 150, child: SplashLoader()),
    );
  }
}
