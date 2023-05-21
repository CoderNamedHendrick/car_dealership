import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_detail_page.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_page.dart';
import 'package:car_dealership/presentation/main/negotiation/view/chat_page.dart';
import '../../../../domain/car_listings/dtos/car_listing.dart';
import '../../profile/view/wishlist.dart';
import 'package:flutter/material.dart';

class NestedRoutePage extends StatelessWidget {
  const NestedRoutePage({Key? key, required this.child, required this.nestedNavKey}) : super(key: key);
  final GlobalKey<NavigatorState> nestedNavKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: nestedNavKey,
      onGenerateRoute: (settings) => switch (settings.name) {
        Wishlist.route => MaterialPageRoute(builder: (_) => const Wishlist()),
        ListingPage.route => MaterialPageRoute(builder: (_) => const ListingPage()),
        NegotiationChatPage.route => switch (settings.arguments) {
            Map info? => MaterialPageRoute(
                builder: (_) => NegotiationChatPage(
                    listingDto: info['listing'] as CarListingDto?,
                    ongoingNegotiation: info['isOngoingNegotiation'] as bool?),
              ),
            _ => MaterialPageRoute(builder: (_) => const NegotiationChatPage()),
          },
        ListingDetailPage.route => switch (settings.arguments) {
            CarListingDto listing? => MaterialPageRoute(builder: (_) => ListingDetailPage(listingDto: listing)),
            _ => MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Vehicle not found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                        Constants.verticalGutter,
                        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Go Back')),
                      ],
                    ),
                  ),
                ),
              ),
          },
        _ => MaterialPageRoute(builder: (_) => child),
      },
    );
  }
}
