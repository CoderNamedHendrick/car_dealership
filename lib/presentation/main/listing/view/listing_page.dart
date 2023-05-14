import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';

class ListingPage extends ConsumerWidget {
  const ListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Listings'),
        centerTitle: false,
      ),
      body: const BrandsWidget(),
    );
  }
}

class BrandsWidget extends ConsumerWidget {
  const BrandsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsUiState = ref.watch(listingHomeUiStateNotifierProvider.select((value) => value.brandsUiState));
    if (brandsUiState.currentState == ViewState.loading) {
      return PhysicalModel(
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: BoxShape.circle,
        child: const CircularProgressIndicator(),
      );
    }

    if (brandsUiState.currentState == ViewState.error) {
      return Center(child: Text('An error occurred: ${brandsUiState.error.toString()}'));
    }

    if (brandsUiState.currentState == ViewState.success) {
      return Wrap(
        spacing: Constants.horizontalGutter,
        runSpacing: Constants.verticalGutter,
        children: List.generate(
          brandsUiState.brands.length,
          (index) => Chip(label: Text(brandsUiState.brands[index])),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
