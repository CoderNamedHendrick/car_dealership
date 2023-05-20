import 'package:flutter/cupertino.dart';

abstract class Constants {
  static const longAnimationDur = Duration(milliseconds: 1300);
  static const shortAnimationDur = Duration(milliseconds: 400);

  static const snackBarDur = Duration(milliseconds: 1200);

  static const horizontalMargin = 16.0;
  static const horizontalGutter = SizedBox(width: 12.0);
  static const horizontalGutter16 = SizedBox(width: 16.0);
  static const horizontalGutter20 = SizedBox(width: 20.0);

  static const verticalGutter = SizedBox(height: 12.0);
  static const verticalGutter18 = SizedBox(height: 18.0);
  static const verticalGutter24 = SizedBox(height: 24.0);
  static const verticalMargin = 18.0;

  static const borderRadius = 8.0;
}
