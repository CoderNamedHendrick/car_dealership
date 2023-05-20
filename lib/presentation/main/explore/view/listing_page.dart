import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_detail_page.dart';
import 'package:car_dealership/presentation/main/explore/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingPage extends ConsumerStatefulWidget {
  static const route = '/home/car-listing';

  const ListingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
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
    final listingUiState = ref.watch(exploreHomeUiStateNotifierProvider.select((value) => value.listingUiState));

    if (listingUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (listingUiState.currentState == ViewState.success) {
      return const Listing();
    }

    return const SizedBox.shrink();
  }
}

class Listing extends ConsumerWidget {
  const Listing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final listing = ref.watch(exploreHomeUiStateNotifierProvider.select((value) => value.listingUiState.listing));

    if (listing.isEmpty) return const EmptyCarListing();

    return ListView.builder(
      itemCount: listing.length,
      itemBuilder: (context, index) => ListingTile(
        listingDto: listing[index],
        listingOnTap: (value) {
          Navigator.of(context).pushNamed(ListingDetailPage.route, arguments: value);
        },
      ),
    );
  }
}
