import '../widgets/widgets.dart';
import '../../../../application/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';

class PurchasesPage extends StatelessWidget {
  const PurchasesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Your Purchases'),
        centerTitle: false,
      ),
      body: const Purchases(),
    );
  }
}

class Purchases extends ConsumerWidget {
  const Purchases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesUiState = ref.watch(purchasesHomeStateNotifierProvider);

    if (purchasesUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (purchasesUiState.currentState == ViewState.error) {
      return switch (purchasesUiState.error) {
        AuthRequiredException() => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  const AuthRequiredException().toString(),
                ),
                Constants.verticalGutter,
                const LoginButton(),
              ],
            ),
          ),
        _ => const SizedBox.shrink(),
      };
    }

    if (purchasesUiState.currentState == ViewState.success) return const PurchasesList();

    return const SizedBox.shrink();
  }
}

class PurchasesList extends ConsumerWidget {
  const PurchasesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    if (ref.watch(purchasesHomeStateNotifierProvider).purchasedListings.isEmpty) {
      return const EmptyPurchases();
    }
    return const Center(child: Text('Logged In successfully'));
  }
}
