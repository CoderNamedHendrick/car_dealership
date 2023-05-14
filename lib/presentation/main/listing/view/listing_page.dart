import 'package:car_dealership/presentation/main/listing/view/listing_detail_page.dart';
import 'package:flutter/material.dart';

class ListingPage extends StatelessWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Listings'),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListingDetailPage())),
              child: const Text('Press me'),
            ),
          ],
        ),
      ),
    );
  }
}
