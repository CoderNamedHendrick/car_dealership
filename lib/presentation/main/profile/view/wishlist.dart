import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart' hide ReadonlySignalUtils;

import '../../explore/view/listing_detail_page.dart';
import '../../explore/widgets/widget.dart';

class Wishlist extends StatefulWidget {
  static const route = '/home/wishlist';

  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    super.initState();
    _profileViewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _profileViewModel.fetchWishlist();
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

class ListingWidget extends StatelessWidget {
  const ListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistUiState =
        locator<ProfileViewModel>().wishlistEmitter.watch(context);

    if (wishlistUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (wishlistUiState.currentState == ViewState.success) {
      return const Listing();
    }
    return const SizedBox.shrink();
  }
}

class Listing extends StatelessWidget {
  const Listing({super.key});

  @override
  Widget build(BuildContext context) {
    final savedCars = locator<ProfileViewModel>()
        .wishlistEmitter
        .select((value) => value.savedCars)
        .watch(context);

    if (savedCars.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EmptyCarListing(customMessage: 'No cars in wishlist'),
            TextButton(
                onPressed: locator<ProfileViewModel>().fetchWishlist,
                child: const Text('Refresh')),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: savedCars.length,
      itemBuilder: (context, index) => ListingTile(
        listingDto: savedCars[index],
        listingOnTap: (value) {
          Navigator.of(context)
              .pushNamed(ListingDetailPage.route, arguments: value);
        },
      ),
    );
  }
}
