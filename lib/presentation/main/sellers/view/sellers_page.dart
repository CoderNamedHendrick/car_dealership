import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart' hide ReadonlySignalUtils;

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

class Sellers extends StatelessWidget {
  const Sellers({super.key});

  @override
  Widget build(BuildContext context) {
    final exploreHomeViewModel = locator<ExploreHomeViewModel>();
    final adminActionsViewModel = locator<AdminActionsViewModel>();
    adminActionsViewModel.emitter.onSignalUpdate(context,
        (previous, next) {
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
    final adminActionUiState = adminActionsViewModel.emitter.watch(context);

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

class SellersList extends StatelessWidget {
  const SellersList({super.key});

  @override
  Widget build(BuildContext context) {
    final sellers = locator<ExploreHomeViewModel>()
        .sellersUiStateEmitter
        .select((value) => value.sellers)
        .watch(context);

    if (sellers.isEmpty) return const EmptySellers();
    return ListView.builder(
      itemCount: sellers.length,
      itemBuilder: (context, index) => SellerTile(
        seller: sellers[index],
        deleteOnPressed: (context) async {
          final deleteSeller =
              await showConfirmDeleteSellerAlert(context, sellers[index].name);

          if (deleteSeller) {
            locator<AdminActionsViewModel>().deleteSeller(sellers[index].id);
          }
        },
      ),
    );
  }
}
