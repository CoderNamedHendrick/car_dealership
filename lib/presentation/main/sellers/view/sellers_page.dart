import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals/signals_flutter.dart';

import '../../../core/widgets/login_button.dart';
import '../widgets/widgets.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Sellers'),
        centerTitle: false,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
        child: Sellers(),
      ),
    );
  }
}

class Sellers extends ConsumerWidget {
  const Sellers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreHomeViewModel = locator<ExploreHomeViewModel>();
    ref.listen(adminActionsStateNotifierProvider, (previous, next) {
      if (next.currentState == ViewState.success) {
        Future.wait([
          exploreHomeViewModel.fetchBrands(),
          exploreHomeViewModel.fetchSellers(),
          exploreHomeViewModel.fetchLocations(),
          exploreHomeViewModel.fetchColors(),
        ]);
      }
    });
    final sellersUiState =
        exploreHomeViewModel.sellersUiStateEmitter.watch(context);
    final adminActionUiState = ref.watch(adminActionsStateNotifierProvider);

    if (sellersUiState.currentState == ViewState.loading ||
        adminActionUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (sellersUiState.currentState == ViewState.error) {
      return switch (sellersUiState.error) {
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

    if (sellersUiState.currentState == ViewState.success) {
      return const SellersList();
    }

    return const SizedBox.shrink();
  }
}

class SellersList extends ConsumerWidget {
  const SellersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = locator<ExploreHomeViewModel>()
        .sellersUiStateEmitter
        .watch(context)
        .sellers;

    if (sellers.isEmpty) return const EmptySellers();
    return ListView.builder(
      itemCount: sellers.length,
      itemBuilder: (context, index) => SellerTile(
        seller: sellers[index],
        deleteOnPressed: (context) async {
          final deleteSeller =
              await showConfirmDeleteSellerAlert(context, sellers[index].name);

          if (deleteSeller) {
            ref
                .read(adminActionsStateNotifierProvider.notifier)
                .deleteSeller(sellers[index].id);
          }
        },
      ),
    );
  }
}
