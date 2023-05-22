import 'package:flutter/cupertino.dart';

abstract class Constants {
  static const longAnimationDur = Duration(milliseconds: 1300);
  static const mediumAnimationDur = Duration(milliseconds: 700);
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
  static const smallBorderRadius = 4.0;
}

extension SizedBoxX on SizedBox {
  operator -(SizedBox other) => switch ((width, height)) {
        (final width?, final height?) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final otherWidth?, final otherHeight?) =>
              SizedBox(height: height - otherHeight, width: width - otherWidth),
            (final otherWidth?, null) => SizedBox(width: width - otherWidth, height: height),
            (null, final otherHeight?) => SizedBox(width: width, height: height - otherHeight),
          },
        (final width?, null) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final otherWidth?, final _?) => SizedBox(height: height, width: width - otherWidth),
            (final otherWidth?, null) => SizedBox(width: width - otherWidth, height: height),
            (null, final _?) => SizedBox(width: width, height: height),
          },
        (null, final height?) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final _?, final otherHeight?) => SizedBox(height: height - otherHeight, width: width),
            (final _?, null) => SizedBox(width: width, height: height),
            (null, final otherHeight?) => SizedBox(width: width, height: height - otherHeight),
          },
        _ => throw UnimplementedError(),
      };

  operator +(SizedBox other) => switch ((width, height)) {
        (final width?, final height?) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final otherWidth?, final otherHeight?) =>
              SizedBox(height: height + otherHeight, width: width + otherWidth),
            (final otherWidth?, null) => SizedBox(width: width + otherWidth, height: height),
            (null, final otherHeight?) => SizedBox(width: width, height: height + otherHeight),
          },
        (final width?, null) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final otherWidth?, final _?) => SizedBox(height: height, width: width + otherWidth),
            (final otherWidth?, null) => SizedBox(width: width + otherWidth, height: height),
            (null, final _?) => SizedBox(width: width, height: height),
          },
        (null, final height?) => switch ((other.width, other.height)) {
            (null, null) => SizedBox(width: width, height: height),
            (final _?, final otherHeight?) => SizedBox(height: height + otherHeight, width: width),
            (final _?, null) => SizedBox(width: width, height: height),
            (null, final otherHeight?) => SizedBox(width: width, height: height + otherHeight),
          },
        _ => throw UnimplementedError(),
      };
}

final class WrongAxisArithmeticException implements Exception {
  const WrongAxisArithmeticException();

  @override
  String toString() => 'Performing operation on sized box with the wrong axis';
}
