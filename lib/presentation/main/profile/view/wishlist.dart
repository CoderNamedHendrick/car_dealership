import 'package:flutter/material.dart';

class Wishlist extends StatelessWidget {
  static const route = '/home/wishlist';

  const Wishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Wishlist Page'),
      ),
    );
  }
}
