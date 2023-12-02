import 'package:car_dealership/presentation/core/presentation_mixins/m_intl.dart';
import 'package:car_dealership/presentation/main/explore/view/listing_page.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../../../application/application.dart';
import '../../../../main.dart';
import '../../../core/common.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ExploreHomeViewModel _exploreHomeViewModel;

  @override
  void initState() {
    super.initState();

    _exploreHomeViewModel = locator();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      Future.wait([
        _exploreHomeViewModel.fetchBrands(),
        _exploreHomeViewModel.fetchSellers(),
        _exploreHomeViewModel.fetchLocations(),
        _exploreHomeViewModel.fetchColors(),
      ]);
    });
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
              _exploreHomeViewModel.setFilter(const FilterQueryDto());
              Navigator.of(context).pushNamed(ListingPage.route);
            },
            child: const Text('All Cars'),
          ),
          Constants.horizontalGutter,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalMargin,
            vertical: Constants.verticalMargin),
        child: SingleChildScrollView(
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
    );
  }
}

class BrandsWidget extends StatelessWidget {
  const BrandsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final brandsUiState =
        locator<ExploreHomeViewModel>().brandsUiStateEmitter.watch(context);
    if (brandsUiState.currentState == ViewState.loading) {
      return Center(
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (brandsUiState.currentState == ViewState.error) {
      return Center(
          child: Text('An error occurred: ${brandsUiState.error.toString()}'));
    }

    if (brandsUiState.currentState == ViewState.success) {
      return Wrap(
        spacing: Constants.horizontalGutter.width!,
        runSpacing: 4,
        children: List.generate(
          brandsUiState.brands.length,
          (index) => BrandChip(
            label: brandsUiState.brands[index],
            onTap: () {
              locator<ExploreHomeViewModel>()
                  .setFilter(FilterQueryDto(make: brandsUiState.brands[index]));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class SellersWidget extends StatelessWidget {
  const SellersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sellersUiState =
        locator<ExploreHomeViewModel>().sellersUiStateEmitter.watch(context);

    if (sellersUiState.currentState == ViewState.loading) {
      return Center(
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (sellersUiState.currentState == ViewState.error) {
      return Center(
          child: Text('An error occurred: ${sellersUiState.error.toString()}'));
    }

    if (sellersUiState.currentState == ViewState.success) {
      return Wrap(
        spacing: Constants.horizontalGutter.width!,
        runSpacing: 4,
        children: List.generate(
          sellersUiState.sellers.length,
          (index) => BrandChip(
            label: sellersUiState.sellers[index].name,
            onTap: () {
              locator<ExploreHomeViewModel>().setFilter(
                  FilterQueryDto(sellerId: sellersUiState.sellers[index].id));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class LocationsWidget extends StatelessWidget {
  const LocationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locationsUiState =
        locator<ExploreHomeViewModel>().locationUiStateEmitter.watch(context);

    if (locationsUiState.currentState == ViewState.loading) {
      return Center(
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: BoxShape.circle,
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (locationsUiState.currentState == ViewState.error) {
      return Center(
          child:
              Text('An error occurred: ${locationsUiState.error.toString()}'));
    }

    if (locationsUiState.currentState == ViewState.success) {
      return Wrap(
        spacing: Constants.horizontalGutter.width!,
        runSpacing: 4,
        children: List.generate(
          locationsUiState.locations.length,
          (index) => BrandChip(
            label: locationsUiState.locations[index],
            onTap: () {
              locator<ExploreHomeViewModel>().setFilter(
                  FilterQueryDto(location: locationsUiState.locations[index]));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class PricesWidget extends StatelessWidget with MIntl {
  const PricesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final exploreViewModel = locator<ExploreHomeViewModel>();
    return Watch((_) {
      if ({
        exploreViewModel.brandsUiState.currentState,
        exploreViewModel.sellersUiState.currentState,
        exploreViewModel.locationUiState.currentState,
      }.contains(ViewState.loading)) {
        return Center(
          child: PhysicalModel(
            color: Theme.of(context).colorScheme.surfaceVariant,
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
              exploreViewModel.setFilter(const FilterQueryDto(maxPrice: 20000));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
          BrandChip(
            label: '<=${currentFormatWithoutDecimals.format(40000)}',
            onTap: () {
              exploreViewModel.setFilter(const FilterQueryDto(maxPrice: 40000));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
          BrandChip(
            label: '<=${currentFormatWithoutDecimals.format(60000)}',
            onTap: () {
              exploreViewModel.setFilter(const FilterQueryDto(maxPrice: 60000));

              Navigator.of(context).pushNamed(ListingPage.route);
            },
          ),
        ],
      );
    });
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
