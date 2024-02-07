import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:signals/signals_flutter.dart';
import '../../../../application/application.dart';
import '../../../core/common.dart';

class ListingReviewWidget extends StatelessWidget {
  const ListingReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewsUiState =
        locator<ListingViewModel>().reviewsUiStateEmitter.watch(context);

    if (reviewsUiState.currentState == ViewState.success) {
      return PhysicalModel(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(2000)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.yellowAccent),
              Text(reviewsUiState.currentCarReview.rating.toString())
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class UserListingOptions extends StatefulWidget {
  const UserListingOptions({super.key, this.contactOnTap});

  final VoidCallback? contactOnTap;

  @override
  State<UserListingOptions> createState() => _UserListingOptionsState();
}

class _UserListingOptionsState extends State<UserListingOptions> {
  late ListingViewModel _listingViewModel;

  @override
  void initState() {
    super.initState();

    _listingViewModel = locator();

    _listingViewModel.savedCarsUiStateEmitter
        .onManualSignalUpdate((previous, next) {
      if (next.currentState == ViewState.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved cars updated successfully'),
            backgroundColor: Colors.green,
            duration: Constants.snackBarDur,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedCarsUiState =
        _listingViewModel.savedCarsUiStateEmitter.watch(context);

    final contactSellerUiState =
        _listingViewModel.contactSellerUiStateEmitter.watch(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: contactSellerUiState.currentState == ViewState.loading
              ? () {}
              : widget.contactOnTap,
          child: Row(
            children: [
              Text(contactSellerUiState.isOngoingNegotiation
                  ? 'Resume Negotiation?'
                  : 'Contact Seller?'),
              Constants.horizontalGutter,
              const FaIcon(FontAwesomeIcons.facebookMessenger),
            ],
          ),
        ),
        IconButton(
          onPressed: _listingViewModel.toggleSaveListing,
          icon: AnimatedSwitcher(
            duration: Constants.shortAnimationDur,
            switchInCurve: Curves.elasticIn,
            child: () {
              if (savedCarsUiState.currentState == ViewState.loading) {
                return const LoadingHeartIcon();
              }

              return savedCarsUiState.isListingSaved
                  ? const FaIcon(FontAwesomeIcons.solidHeart,
                      key: Key('saved-listing-key'))
                  : const FaIcon(FontAwesomeIcons.heart,
                      key: Key('unsaved-listing-key'));
            }(),
          ),
        ),
      ],
    );
  }
}

class LoadingHeartIcon extends StatelessWidget {
  const LoadingHeartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey.shade400,
      child: const FaIcon(FontAwesomeIcons.heart),
    );
  }
}
