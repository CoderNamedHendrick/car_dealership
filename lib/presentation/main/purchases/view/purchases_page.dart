import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/widgets/widgets.dart';
import '../../explore/view/listing_detail_page.dart';
import '../../explore/widgets/widget.dart';
import '../widgets/widgets.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      locator<PurchasesHomeViewModel>().fetchPurchases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Your Purchases'),
        centerTitle: false,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
        child: Purchases(),
      ),
    );
  }
}

class Purchases extends StatelessWidget {
  const Purchases({super.key});

  @override
  Widget build(BuildContext context) {
    final purchasesUiState =
        locator<PurchasesHomeViewModel>().emitter.watch(context);

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

    if (purchasesUiState.currentState == ViewState.success) {
      return const PurchasesList();
    }

    return const SizedBox.shrink();
  }
}

class PurchasesList extends StatelessWidget {
  const PurchasesList({super.key});

  @override
  Widget build(BuildContext context) {
    final purchases = locator<PurchasesHomeViewModel>()
        .emitter
        .select((value) => value.purchasedListings)
        .watch(context);
    if (purchases.isEmpty) return const EmptyPurchases();

    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) => ListingTile(
        listingDto: purchases[index],
        listingOnTap: (value) {
          Navigator.of(context)
              .pushNamed(ListingDetailPage.route, arguments: value);
        },
      ),
    );
  }
}
