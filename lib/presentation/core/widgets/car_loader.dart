import 'package:car_dealership/presentation/splash/widgets/splash_loader.dart';
import 'package:flutter/material.dart';

class CarLoader extends StatelessWidget {
  const CarLoader({super.key, Color? customColor})
      : _color = customColor;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(width: 150, child: SplashLoader(color: _color)),
    );
  }
}
