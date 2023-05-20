import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../explore/view/listing_detail_page.dart';
import '../../explore/widgets/widget.dart';

class Wishlist extends ConsumerStatefulWidget {
  static const route = '/home/wishlist';

  const Wishlist({Key? key}) : super(key: key);

  @override
  ConsumerState<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends ConsumerState<Wishlist> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(profileStateNotifierProvider.notifier).fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
        child: ListingWidget(),
      ),
    );
  }
}

class ListingWidget extends ConsumerWidget {
  const ListingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistUiState = ref.watch(profileStateNotifierProvider.select((value) => value.wishlistUiState));

    if (wishlistUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (wishlistUiState.currentState == ViewState.success) {
      return const Listing();
    }
    return const SizedBox.shrink();
  }
}

class Listing extends ConsumerWidget {
  const Listing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCars = ref.watch(profileStateNotifierProvider.select((value) => value.wishlistUiState.savedCars));

    if (savedCars.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EmptyCarListing(customMessage: 'No cars in wishlist'),
            TextButton(
                onPressed: ref.read(profileStateNotifierProvider.notifier).fetchWishlist, child: const Text('Refresh')),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: savedCars.length,
      itemBuilder: (context, index) => ListingTile(
        listingDto: savedCars[index],
        listingOnTap: (value) {
          Navigator.of(context).pushNamed(ListingDetailPage.route, arguments: value);
        },
      ),
    );
  }
}
