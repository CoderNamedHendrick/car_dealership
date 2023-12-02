import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_detail_page.dart';
import 'package:car_dealership/presentation/main/explore/widgets/widget.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signals/signals_flutter.dart';

import 'listing_filter_dialog.dart';

class ListingPage extends ConsumerStatefulWidget {
  static const route = '/home/car-listing';

  const ListingPage({super.key});

  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {
  final searchController = TextEditingController();
  late FilterViewModel _filterViewModel;

  @override
  void initState() {
    super.initState();

    _filterViewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing();

      final dto = ref.read(exploreHomeUiStateNotifierProvider).filterQuery;
      final sellers = ref
          .read(exploreHomeUiStateNotifierProvider
              .select((value) => value.sellersUiState))
          .sellers;

      _filterViewModel.initialiseFilter(dto,
          sellers.firstWhereOrNull((element) => element.id == dto.sellerId));
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Listing'),
        flexibleSpace: FlexibleSpaceBar(
          title:
              Text('Listing', style: Theme.of(context).textTheme.titleMedium),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.maxFinite, 70),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalMargin, vertical: 8),
            child: SearchBar(
              controller: searchController,
              elevation: MaterialStateProperty.all(0),
              hintText: 'Search model',
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.borderRadius))),
              ),
              constraints: const BoxConstraints(maxHeight: 50),
              onChanged: (value) {
                EasyDebounce.debounce(
                    'model-search', Constants.mediumAnimationDur, () {
                  _filterViewModel.updateModel(value);

                  final filter = _filterViewModel.state.filter.toDto();
                  ref
                      .read(exploreHomeUiStateNotifierProvider.notifier)
                      .setFilter(filter);
                  ref
                      .read(exploreHomeUiStateNotifierProvider.notifier)
                      .fetchListing();
                });
              },
              trailing: [
                if (searchController.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      searchController.clear();
                      _filterViewModel.clearModelFilter();

                      final filter = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(filter);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                    icon: Icon(Icons.close,
                        color: Theme.of(context).colorScheme.onSurface),
                  )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
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
                    selected: !_filterViewModel.emitter
                        .watch(context)
                        .filter
                        .isFilterEmpty,
                    trailing: CircleAvatar(
                      maxRadius: 8,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        _filterViewModel.emitter
                            .watch(context)
                            .filter
                            .appliedFiltersCount
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    onSelected: (_) async {
                      final result = await showFilteringOptions(context);

                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(result ?? const FilterQueryDto());
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Region',
                    selected: _filterViewModel.emitter
                            .watch(context)
                            .filter
                            .location !=
                        null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Location',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider
                                    .select((value) => value.locationUiState))
                                .locations);

                        if (result == null) return;
                        _filterViewModel.updateRegion(result);
                      } else {
                        _filterViewModel.clearRegionFilter();
                      }

                      final filter = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(filter);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Price',
                    selected: _filterViewModel.emitter
                                .watch(context)
                                .filter
                                .minPrice !=
                            null ||
                        _filterViewModel.emitter
                                .watch(context)
                                .filter
                                .maxPrice !=
                            null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showRangeFilteringOptions(context,
                            title: 'Price',
                            min: 1000.0,
                            max: 100000.0,
                            range: RangeValues(
                                _filterViewModel.emitter
                                        .watch(context)
                                        .filter
                                        .minPrice ??
                                    1000,
                                _filterViewModel.emitter
                                        .watch(context)
                                        .filter
                                        .maxPrice ??
                                    100000));

                        if (result == null) return;
                        _filterViewModel.updatePrice(
                            minPrice: result.start, maxPrice: result.end);
                      } else {
                        _filterViewModel.clearPriceFilter();
                      }

                      final dto = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(dto);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Make',
                    selected:
                        _filterViewModel.emitter.watch(context).filter.make !=
                            null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Manufacturer',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider
                                    .select((value) => value.brandsUiState))
                                .brands);

                        if (result == null) return;
                        _filterViewModel.updateMake(result);
                      } else {
                        _filterViewModel.clearMakeFilter();
                      }

                      final filter = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(filter);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Seller',
                    selected:
                        _filterViewModel.emitter.watch(context).filter.seller !=
                            null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showListFilteringDialog(context,
                            title: 'Sellers',
                            filtersList: ref
                                .read(exploreHomeUiStateNotifierProvider
                                    .select((value) => value.sellersUiState))
                                .sellers
                                .map((e) => e.name)
                                .toList());

                        if (result == null) return;
                        final dto = ref
                            .read(exploreHomeUiStateNotifierProvider
                                .select((value) => value.sellersUiState))
                            .sellers
                            .firstWhere((element) => element.name == result);
                        _filterViewModel.updateSeller(dto);
                      } else {
                        _filterViewModel.clearSellerFilter();
                      }

                      final filter = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(filter);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
                    },
                  ),
                  ListingFilterChip(
                    label: 'Year of Manufacture',
                    selected: _filterViewModel.emitter
                                .watch(context)
                                .filter
                                .minYear !=
                            null ||
                        _filterViewModel.emitter
                                .watch(context)
                                .filter
                                .maxYear !=
                            null,
                    onSelected: (selected) async {
                      if (!selected) {
                        final result = await showRangeFilteringOptions(context,
                            title: 'Year of Manufacture',
                            min: 2010.0,
                            max: 2023.0,
                            divisions: 13,
                            range: RangeValues(
                                _filterViewModel.emitter
                                        .watch(context)
                                        .filter
                                        .minYear
                                        ?.toDouble() ??
                                    2010,
                                _filterViewModel.emitter
                                        .watch(context)
                                        .filter
                                        .maxYear
                                        ?.toDouble() ??
                                    2023));

                        if (result == null) return;
                        _filterViewModel.updateYear(
                            minYear: result.start.toInt(),
                            maxYear: result.end.toInt());
                      } else {
                        _filterViewModel.clearYearFilter();
                      }

                      final dto = _filterViewModel.state.filter.toDto();
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .setFilter(dto);
                      ref
                          .read(exploreHomeUiStateNotifierProvider.notifier)
                          .fetchListing();
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
  const ListingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(adminActionsStateNotifierProvider, (previous, next) {
      if (next.currentState == ViewState.success) {
        Future.wait([
          ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchBrands(),
          ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchSellers(),
          ref
              .read(exploreHomeUiStateNotifierProvider.notifier)
              .fetchLocations(),
          ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchColors(),
          ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchListing(),
        ]);
      }
    });
    final listingUiState = ref.watch(exploreHomeUiStateNotifierProvider
        .select((value) => value.listingUiState));
    final adminActionUiState = ref.watch(adminActionsStateNotifierProvider);

    if (listingUiState.currentState == ViewState.loading ||
        adminActionUiState.currentState == ViewState.loading) {
      return const Center(child: CarLoader());
    }

    if (listingUiState.currentState == ViewState.success) {
      return const Listing();
    }

    return const SizedBox.shrink();
  }
}

class Listing extends ConsumerWidget {
  const Listing({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final listing = ref.watch(exploreHomeUiStateNotifierProvider
        .select((value) => value.listingUiState.listing));

    if (listing.isEmpty) return const EmptyCarListing();

    return ListView.builder(
      itemCount: listing.length,
      itemBuilder: (context, index) => ListingTile(
        listingDto: listing[index],
        deleteOnPressed: (context) async {
          final deleteListing = await showConfirmDeleteCarListingAlert(
              context, '${listing[index].make}-${listing[index].model}');

          if (deleteListing) {
            ref
                .read(adminActionsStateNotifierProvider.notifier)
                .deleteListing(listing[index].id);
          }
        },
        listingOnTap: (value) {
          Navigator.of(context)
              .pushNamed(ListingDetailPage.route, arguments: value);
        },
      ),
    );
  }
}
