import 'package:flutter/material.dart';

class NestedRoutePage extends StatelessWidget {
  const NestedRoutePage({Key? key, required this.child, required this.nestedNavKey}) : super(key: key);
  final GlobalKey<NavigatorState> nestedNavKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: nestedNavKey,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => child),
    );
  }
}
