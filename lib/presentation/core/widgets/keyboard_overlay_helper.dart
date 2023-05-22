import 'dart:io';
import 'package:flutter/material.dart';

class KeyboardOverlayDistance extends StatelessWidget {
  const KeyboardOverlayDistance({Key? key, this.height = 0, this.readOnly = false}) : super(key: key);
  final bool readOnly;
  final double height;

  @override
  Widget build(BuildContext context) {
    final resize = FocusScope.of(context).hasFocus && Platform.isIOS && !readOnly;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: resize ? 45 + height : height,
    );
  }
}
