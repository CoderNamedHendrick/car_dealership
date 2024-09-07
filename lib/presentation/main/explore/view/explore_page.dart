import 'package:car_dealership/presentation/core/presentation_mixins/m_intl.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../application/application.dart';
import '../../../core/common.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      _fetchExploreData();
    });
  }

  Future<void> _fetchExploreData() async {
    await Future.wait([
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchColors(),
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchBrands(),
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchBrands(),
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchSellers(),
      ref.read(exploreHomeUiStateNotifierProvider.notifier).fetchLocations(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Explore'),
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () {
              ref
                  .read(exploreHomeUiStateNotifierProvider.notifier)
                  .setFilter(const FilterQueryDto());
              Navigator.of(context).pushNamed(ListingPage.route);
            },
            child: const Text('All Cars'),
          ),
          Constants.horizontalGutter,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchExploreData,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin,
              vertical: Constants.verticalMargin),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('By Brands',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start),
                const BrandsWidget(),
                Constants.verticalGutter18,
                Text('By Sellers',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start),
                const SellersWidget(),
                Constants.verticalGutter18,
                Text('By Location',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start),
                const LocationsWidget(),
                Constants.verticalGutter18,
                Text('By Prices',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start),
                const PricesWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandsWidget extends ConsumerWidget {
  const BrandsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(exploreHomeUiStateNotifierProvider
            .select((value) => value.brandsUiState))
        .when(
          onLoading: () => Center(
            child: PhysicalModel(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              child: const CircularProgressIndicator(),
            ),
          ),
          onError: (error) => Center(
            child: Text('An error occurred: ${error.toString()}'),
          ),
          onSuccess: (state) => Wrap(
            spacing: Constants.horizontalGutter.width!,
            runSpacing: 4,
            children: List.generate(
              state.brands.length,
              (index) => BrandChip(
                label: state.brands[index],
                onTap: () {
                  ref
                      .read(exploreHomeUiStateNotifierProvider.notifier)
                      .setFilter(FilterQueryDto(make: state.brands[index]));

                  Navigator.of(context).pushNamed(ListingPage.route);
                },
              ),
            ),
          ),
        );
  }
}

class SellersWidget extends ConsumerWidget {
  const SellersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(exploreHomeUiStateNotifierProvider
            .select((value) => value.sellersUiState))
        .when(
          onLoading: () => Center(
            child: PhysicalModel(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              child: const CircularProgressIndicator(),
            ),
          ),
          onError: (error) => Center(
            child: Text('An error occurred: ${error.toString()}'),
          ),
          onSuccess: (state) => Wrap(
            spacing: Constants.horizontalGutter.width!,
            runSpacing: 4,
            children: List.generate(
              state.sellers.length,
              (index) => BrandChip(
                label: state.sellers[index].name,
                onTap: () {
                  ref
                      .read(exploreHomeUiStateNotifierProvider.notifier)
                      .setFilter(
                          FilterQueryDto(sellerId: state.sellers[index].id));

                  Navigator.of(context).pushNamed(ListingPage.route);
                },
              ),
            ),
          ),
        );
  }
}

class LocationsWidget extends ConsumerWidget {
  const LocationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsUiState = ref.watch(exploreHomeUiStateNotifierProvider
        .select((value) => value.locationUiState));

    return locationsUiState.when(
      onLoading: () => Center(
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          child: const CircularProgressIndicator(),
        ),
      ),
      onError: (error) => Center(
        child: Text('An error occurred: ${locationsUiState.error.toString()}'),
      ),
      onSuccess: (state) => Wrap(
        spacing: Constants.horizontalGutter.width!,
        runSpacing: 4,
        children: List.generate(
          locationsUiState.locations.length,
          (index) => BrandChip(
            label: locationsUiState.locations[index],
            onTap: () {
              ref.read(exploreHomeUiStateNotifierProvider.notifier).setFilter(
                  FilterQueryDto(location: locationsUiState.locations[index]));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
        ),
      ),
    );
  }
}

class PricesWidget extends ConsumerWidget with MIntl {
  const PricesWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final uiStates = ref.watch(exploreHomeUiStateNotifierProvider);
    if ({
      uiStates.brandsUiState.uiState,
      uiStates.sellersUiState.uiState,
      uiStates.locationUiState.uiState,
    }.contains(UiState.loading)) {
      return Center(
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return Wrap(
      spacing: Constants.horizontalGutter.width!,
      runSpacing: 0,
      children: [
        BrandChip(
          label: '<=${currentFormatWithoutDecimals.format(20000)}',
          onTap: () {
            ref
                .read(exploreHomeUiStateNotifierProvider.notifier)
                .setFilter(const FilterQueryDto(maxPrice: 20000));

            Navigator.of(context).pushNamed(ListingPage.route);
          },
        ),
        BrandChip(
          label: '<=${currentFormatWithoutDecimals.format(40000)}',
          onTap: () {
            ref
                .read(exploreHomeUiStateNotifierProvider.notifier)
                .setFilter(const FilterQueryDto(maxPrice: 40000));

            Navigator.of(context).pushNamed(ListingPage.route);
          },
        ),
        BrandChip(
          label: '<=${currentFormatWithoutDecimals.format(60000)}',
          onTap: () {
            ref
                .read(exploreHomeUiStateNotifierProvider.notifier)
                .setFilter(const FilterQueryDto(maxPrice: 60000));

            Navigator.of(context).pushNamed(ListingPage.route);
          },
        ),
      ],
    );
  }
}

class BrandChip extends StatelessWidget {
  const BrandChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Chip(label: Text(label), padding: EdgeInsets.zero));
  }
}
