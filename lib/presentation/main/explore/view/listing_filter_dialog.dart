import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/main/explore/widgets/filter_screens.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart' hide ReadonlySignalUtils;

import '../../../../application/application.dart';

Future<FilterQueryDto?> showFilteringOptions(BuildContext context) async {
  return await showDialog(
      context: context, builder: (context) => const ListingFilterMenu());
}

Future<RangeValues?> showRangeFilteringOptions(BuildContext context,
    {required String title,
    required double min,
    required double max,
    required RangeValues range,
    int? divisions}) async {
  return await showDialog<RangeValues?>(
    context: context,
    builder: (_) => FilterDialogBackgroundWrapper(
      child: FilterPage(
        child: FilterSliderScreen(
            title: title,
            min: min,
            max: max,
            currentValue: range,
            divisions: divisions),
      ),
    ),
  );
}

Future<String?> showListFilteringDialog(BuildContext context,
    {required String title, required List<String> filtersList}) async {
  return await showDialog(
    context: context,
    builder: (_) => FilterDialogBackgroundWrapper(
      child: FilterPage(
          child: FilterListScreen(title: title, filtersList: filtersList)),
    ),
  );
}

class ListingFilterMenu extends StatelessWidget {
  const ListingFilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FilterDialogBackgroundWrapper(
      child: Navigator(
        onGenerateRoute: (settings) => switch (settings.name) {
          FilterSliderScreen.route => switch (settings.arguments) {
              Map info? => MaterialPageRoute<RangeValues?>(
                  builder: (_) => FilterPage(
                    child: FilterSliderScreen(
                      title: info['title'] as String,
                      min: info['min'] as double,
                      max: info['max'] as double,
                      currentValue: info['range'] as RangeValues,
                      divisions: info['divisions'] as int?,
                    ),
                  ),
                ),
              _ => MaterialPageRoute<RangeValues?>(
                  builder: (_) => const FilterPage(
                      child: Center(child: Text('Wrong route'))),
                ),
            },
          FilterListScreen.route => switch (settings.arguments) {
              Map info? => MaterialPageRoute<String?>(
                  builder: (_) => FilterPage(
                    child: FilterListScreen(
                        title: info['title'] as String,
                        filtersList: info['filterList'] as List<String>),
                  ),
                ),
              _ => MaterialPageRoute<String?>(
                  builder: (_) => const FilterPage(
                      child: Center(child: Text('Wrong route'))),
                ),
            },
          _ => MaterialPageRoute(
              builder: (_) => const FilterPage(child: FilterMenu()),
            ),
        },
      ),
    );
  }
}

class FilterDialogBackgroundWrapper extends StatelessWidget {
  const FilterDialogBackgroundWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin),
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            tween: Tween<double>(begin: 0.95, end: 1),
            builder: (context, progress, child) => Transform.scale(
              scale: progress,
              alignment: Alignment.center,
              child: child!,
            ),
            child: Container(
              color: Colors.transparent,
              child: InkWell(
                onTap: Navigator.of(context, rootNavigator: true).pop,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: PhysicalModel(
        color: Theme.of(context).colorScheme.surface,
        elevation: 2,
        borderRadius:
            const BorderRadius.all(Radius.circular(Constants.borderRadius)),
        child: child,
      ),
    );
  }
}

class FilterMenu extends StatelessWidget {
  const FilterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final filterViewModel = locator<FilterViewModel>();
    final exploreViewModel = locator<ExploreHomeViewModel>();

    final filter = locator<FilterViewModel>()
        .emitter
        .select((value) => value.filter)
        .watch(context);
    return Padding(
      padding: const EdgeInsets.all(Constants.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Filters',
                  style: Theme.of(context).textTheme.titleMedium),
              if (!filter.isFilterEmpty)
                TextButton(
                  onPressed: filterViewModel.clearFilters,
                  child: const Text('Clear filters'),
                ),
            ],
          ),
          Constants.verticalGutter18,
          FilterListTile(
            label: 'Region',
            clearFilterOnTap: filterViewModel.clearRegionFilter,
            subtitle: switch (filter.location) {
              String location => FilterSubtitle(location),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Locations',
                  'filterList': exploreViewModel.locationUiState.locations,
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateRegion(result);
            },
          ),
          FilterListTile(
            label: 'Price',
            clearFilterOnTap: filterViewModel.clearPriceFilter,
            subtitle: switch ((filter.minPrice, filter.maxPrice)) {
              (final minPrice, null) => FilterSubtitle('price >= $minPrice'),
              (null, final maxPrice?) => FilterSubtitle('price <= $maxPrice'),
              (final minPrice?, final maxPrice) =>
                FilterSubtitle(' $minPrice <= price <= $maxPrice'),
            },
            onTap: () async {
              final result = await Navigator.of(context)
                  .pushNamed<RangeValues?>(FilterSliderScreen.route,
                      arguments: {
                    'title': 'Price',
                    'min': 1000.0,
                    'max': 100000.0,
                    'range': RangeValues(
                        filterViewModel.state.filter.minPrice ?? 1000,
                        filterViewModel.state.filter.maxPrice ?? 100000),
                  });

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>()
                  .updatePrice(minPrice: result.start, maxPrice: result.end);
            },
          ),
          FilterListTile(
            label: 'Make',
            clearFilterOnTap: filterViewModel.clearMakeFilter,
            subtitle: switch (filter.make) {
              String make => FilterSubtitle(make),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Manufacturer',
                  'filterList': exploreViewModel.brandsUiState.brands,
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateMake(result);
            },
          ),
          FilterListTile(
            label: 'Seller',
            clearFilterOnTap: filterViewModel.clearSellerFilter,
            subtitle: switch (filter.seller) {
              SellerDto seller => FilterSubtitle(seller.name),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Sellers',
                  'filterList': exploreViewModel.sellersUiState.sellers
                      .map((e) => e.name)
                      .toList(),
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              final dto = exploreViewModel.sellersUiState.sellers
                  .firstWhere((element) => element.name == result);
              locator<FilterViewModel>().updateSeller(dto);
            },
          ),
          FilterListTile(
            label: 'Year of Manufacture',
            clearFilterOnTap: filterViewModel.clearYearFilter,
            subtitle: switch ((filter.minYear, filter.maxYear)) {
              (final minYear, null) => FilterSubtitle('year >= $minYear'),
              (null, final maxYear?) => FilterSubtitle('year <= $maxYear'),
              (final minYear?, final maxYear) =>
                FilterSubtitle(' $minYear <= year <= $maxYear'),
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<
                  RangeValues?>(FilterSliderScreen.route, arguments: {
                'title': 'Year of Manufacture',
                'min': 2010.0,
                'max': 2023.0,
                'divisions': 13,
                'range': RangeValues(
                    filterViewModel.state.filter.minYear?.toDouble() ?? 2010,
                    filterViewModel.state.filter.maxYear?.toDouble() ?? 2023),
              });

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateYear(
                  minYear: result.start.toInt(), maxYear: result.end.toInt());
            },
          ),
          FilterListTile(
            label: 'Mileage',
            clearFilterOnTap: filterViewModel.clearMileageFilter,
            subtitle: switch ((filter.minMileage, filter.maxMileage)) {
              (final minMileage, null) =>
                FilterSubtitle('mileage >= $minMileage'),
              (null, final maxMileage?) =>
                FilterSubtitle('mileage <= $maxMileage'),
              (final minMileage?, final maxMileage) =>
                FilterSubtitle(' $minMileage <= mileage <= $maxMileage'),
            },
            onTap: () async {
              final result = await Navigator.of(context)
                  .pushNamed<RangeValues?>(FilterSliderScreen.route,
                      arguments: {
                    'title': 'Mileage',
                    'min': 1000.0,
                    'max': 100000.0,
                    'range': RangeValues(
                        filterViewModel.state.filter.minPrice ?? 1000,
                        filterViewModel.state.filter.maxPrice ?? 100000),
                  });

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateMileage(
                  minMileage: result.start, maxMileage: result.end);
            },
          ),
          FilterListTile(
            label: 'Color',
            clearFilterOnTap: filterViewModel.clearColorFilter,
            subtitle: switch (filter.color) {
              String color => FilterSubtitle(color),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Color',
                  'filterList': exploreViewModel.colorsUiState.colors,
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateColor(result);
            },
          ),
          FilterListTile(
            label: 'Transmission',
            clearFilterOnTap: filterViewModel.clearTransmissionFilter,
            subtitle: switch (filter.transmission) {
              Transmission trans => FilterSubtitle(trans.json),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Transmission',
                  'filterList': Transmission.values.map((e) => e.json).toList(),
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>()
                  .updateTransmission(result.transmission);
            },
          ),
          FilterListTile(
            label: 'Fuel',
            clearFilterOnTap: filterViewModel.clearFuelTypeFilter,
            subtitle: switch (filter.fuelType) {
              FuelType fuel => FilterSubtitle(fuel.json),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Fuel Type',
                  'filterList': FuelType.values.map((e) => e.json).toList(),
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>().updateFuelType(result.fuelType);
            },
          ),
          FilterListTile(
            label: 'Availability',
            clearFilterOnTap: filterViewModel.clearAvailabilityFilter,
            subtitle: switch (filter.availability) {
              Availability a => FilterSubtitle(a.json),
              _ => null
            },
            onTap: () async {
              final result = await Navigator.of(context).pushNamed<String?>(
                FilterListScreen.route,
                arguments: {
                  'title': 'Availability',
                  'filterList': Availability.values.map((e) => e.json).toList(),
                },
              );

              if (!context.mounted) return;
              if (result == null) return;
              locator<FilterViewModel>()
                  .updateAvailability(result.availability);
            },
          ),
          Constants.verticalGutter18,
          if (!filter.isFilterEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AdsWidget(),
                  Constants.horizontalGutter,
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(filterViewModel.state.filter.toDto());
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class AdsWidget extends StatelessWidget {
  const AdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((_) {
      final vm = locator<FilterViewModel>();
      if (vm.state.currentState == ViewState.loading) {
        return const CircularProgressIndicator();
      }
      return Text(
        'Ads. ${vm.state.adsCount}',
        style: Theme.of(context).textTheme.labelMedium,
      );
    });
  }
}

class FilterListTile extends StatelessWidget {
  const FilterListTile({
    super.key,
    required this.label,
    this.subtitle,
    this.onTap,
    this.clearFilterOnTap,
  });

  final String label;
  final Widget? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? clearFilterOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      splashColor: Colors.black26,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
      title: Text(label),
      subtitle: subtitle,
      trailing: subtitle != null
          ? IconButton.filledTonal(
              onPressed: clearFilterOnTap,
              icon: const Icon(Icons.close),
              padding: EdgeInsets.zero,
            )
          : const Icon(Icons.add),
    );
  }
}

class FilterSubtitle extends StatelessWidget {
  const FilterSubtitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.labelSmall);
  }
}
