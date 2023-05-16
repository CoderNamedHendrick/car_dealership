import 'package:flutter/material.dart';

class ListingDetailPage extends StatelessWidget {
  const ListingDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: const Text('Listing Detail'),
        centerTitle: false,
      ),
      body: const Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
