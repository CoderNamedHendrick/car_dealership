import 'package:flutter/material.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          children: [
            Text('Sellers Page'),
          ],
        ),
      ),
    );
  }
}
