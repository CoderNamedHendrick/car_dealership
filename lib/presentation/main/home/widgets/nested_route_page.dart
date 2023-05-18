import '../../profile/view/wishlist.dart';
import 'package:flutter/material.dart';

class NestedRoutePage extends StatelessWidget {
  const NestedRoutePage({Key? key, required this.child, required this.nestedNavKey}) : super(key: key);
  final GlobalKey<NavigatorState> nestedNavKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: nestedNavKey,
      onGenerateRoute: (settings) => switch (settings.name) {
        Wishlist.route => MaterialPageRoute(builder: (_) => const Wishlist()),
        _ => MaterialPageRoute(builder: (_) => child),
      },
    );
  }
}
