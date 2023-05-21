import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_detail_page.dart';
import 'package:car_dealership/presentation/main/explore/widgets/widget.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'listing_filter_dialog.dart';

class ListingPage extends ConsumerStatefulWidget {
  static const route = '/home/car-listing';

  const ListingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();

      final dto = ref.read(exploreHomeUiStateNotifierProvider).filterQuery;
      final sellers = ref.read(exploreHomeUiStateNotifierProvider.select((value) => value.sellersUiState)).sellers;
      ref
          .read(filterStateNotifierProvider.notifier)
          .initialiseFilter(dto, sellers.firstWhereOrNull((element) => element.id == dto.sellerId));
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(filterStateNotifierProvider.select((value) => value.filter));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Listing'),
        flexibleSpace: FlexibleSpaceBar(
          title: Text('Listing', style: Theme.of(context).textTheme.titleMedium),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin, vertical: 8),
            child: SearchBar(
              controller: searchController,
              elevation: MaterialStateProperty.all(0),
              hintText: 'Search model',
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Constants.borderRadius))),
              ),
              constraints: const BoxConstraints(maxHeight: 50),
              onChanged: (value) {
                EasyDebounce.debounce('model-search', Constants.mediumAnimationDur, () {
                  ref.read(filterStateNotifierProvider.notifier).updateModel(value);

                  final filter = ref.read(filterStateNotifierProvider).filter.toDto();
                  ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(filter);
                  ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                });
              },
              trailing: [
                if (searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      searchController.clear();
                      ref.read(filterStateNotifierProvider.notifier).clearModelFilter();

                      final filter = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(filter);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                  )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Constants.verticalGutter,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ListingFilterChip(
                    leading: const Icon(Icons.filter_alt),
                    label: 'All Filters',
                    selected: !filter.isFilterEmpty,
                    trailing: CircleAvatar(
                      maxRadius: 8,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        filter.appliedFiltersCount.toString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                    ),
                    onSelected: (_) async {
                      final result = await showFilteringOptions(context);

                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(result);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Region',
                    selected: filter.location != null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Location',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider.select((value) => value.locationUiState))
                                .locations);

                        if (result == null) return;
                        ref.read(filterStateNotifierProvider.notifier).updateRegion(result);
                      } else {
                        ref.read(filterStateNotifierProvider.notifier).clearRegionFilter();
                      }

                      final filter = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(filter);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Price',
                    selected: filter.minPrice != null || filter.maxPrice != null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showRangeFilteringOptions(context,
                            title: 'Price',
                            min: 1000.0,
                            max: 100000.0,
                            range: RangeValues(filter.minPrice ?? 1000, filter.maxPrice ?? 100000));

                        if (result == null) return;
                        ref
                            .read(filterStateNotifierProvider.notifier)
                            .updatePrice(minPrice: result.start, maxPrice: result.end);
                      } else {
                        ref.read(filterStateNotifierProvider.notifier).clearPriceFilter();
                      }

                      final dto = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(dto);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Make',
                    selected: filter.make != null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Manufacturer',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider.select((value) => value.brandsUiState))
                                .brands);

                        if (result == null) return;
                        ref.read(filterStateNotifierProvider.notifier).updateMake(result);
                      } else {
                        ref.read(filterStateNotifierProvider.notifier).clearMakeFilter();
                      }

                      final filter = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(filter);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Seller',
                    selected: filter.seller != null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Sellers',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider.select((value) => value.sellersUiState))
                                .sellers
                                .map((e) => e.name)
                                .toList());

                        if (result == null) return;
                        final dto = ref
                            .read(exploreHomeUiStateNotifierProvider.select((value) => value.sellersUiState))
                            .sellers
                            .firstWhere((element) => element.name == result);
                        ref.read(filterStateNotifierProvider.notifier).updateSeller(dto);
                      } else {
                        ref.read(filterStateNotifierProvider.notifier).clearSellerFilter();
                      }

                      final filter = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(filter);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Year of Manufacture',
                    selected: filter.minYear != null || filter.maxYear != null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showRangeFilteringOptions(context,
                            title: 'Year of Manufacture',
                            min: 2010.0,
                            max: 2023.0,
                            divisions: 13,
                            range: RangeValues(filter.minYear?.toDouble() ?? 2010, filter.maxYear?.toDouble() ?? 2023));

                        if (result == null) return;
                        ref
                            .read(filterStateNotifierProvider.notifier)
                            .updateYear(minYear: result.start.toInt(), maxYear: result.end.toInt());
                      } else {
                        ref.read(filterStateNotifierProvider.notifier).clearYearFilter();
                      }

                      final dto = ref.read(filterStateNotifierProvider).filter.toDto();
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(dto);
                      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();
                    },
                  ),
                ],
              ),
            ),
            const Expanded(child: ListingWidget()),
          ],
        ),
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
