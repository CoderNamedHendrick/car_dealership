import 'package:car_dealership/application/application.dart';
import 'package:signals/signals_flutter.dart';

import 'explore_home_ui_state.dart';

export 'package:car_dealership/domain/car_listings/car_listing_domain.dart';

final class ExploreHomeViewModel {
  final CarDealerShipInterface _dealerShipRepository;

  ExploreHomeViewModel(this._dealerShipRepository);

  final _filterQuery = signal(const FilterQueryDto());
  final _brandsUiState = signal(const BrandsUiState.initial());
  final _sellersUiState = signal(const SellersUiState.initial());
  final _locationUiState = signal(const LocationUiState.initial());
  final _listingUiState = signal(const ListingUiState.initial());
  final _colorsUiState = signal(const PopularColorsUiState.initial());

  FilterQueryDto get filterQuery => _filterQuery.toReadonlySignal().value;

  ReadonlySignal<BrandsUiState> get brandsUiStateEmitter =>
      _brandsUiState.toReadonlySignal();

  ReadonlySignal<SellersUiState> get sellersUiStateEmitter =>
      _sellersUiState.toReadonlySignal();

  ReadonlySignal<LocationUiState> get locationUiStateEmitter =>
      _locationUiState.toReadonlySignal();

  ReadonlySignal<ListingUiState> get listingUiStateEmitter =>
      _listingUiState.toReadonlySignal();

  ReadonlySignal<PopularColorsUiState> get colorsUiStateEmitter =>
      _colorsUiState.toReadonlySignal();

  BrandsUiState get brandsUiState => _brandsUiState.toReadonlySignal().value;

  SellersUiState get sellersUiState => _sellersUiState.toReadonlySignal().value;

  LocationUiState get locationUiState =>
      _locationUiState.toReadonlySignal().value;

  ListingUiState get listingUiState => _listingUiState.toReadonlySignal().value;

  PopularColorsUiState get colorsUiState =>
      _colorsUiState.toReadonlySignal().value;

  void setFilter(FilterQueryDto? filterQuery) =>
      _filterQuery.value = filterQuery ?? this.filterQuery;

  Future<void> fetchBrands() async {
    _brandsUiState.value =
        brandsUiState.copyWith(currentState: ViewState.loading);
    final result = await _dealerShipRepository.fetchBrands();

    _brandsUiState.value = result.fold(
      (left) =>
          brandsUiState.copyWith(currentState: ViewState.error, error: left),
      (right) => brandsUiState.copyWith(
          currentState: ViewState.success, brands: right),
    );
  }

  Future<void> fetchSellers() async {
    _sellersUiState.value =
        sellersUiState.copyWith(currentState: ViewState.loading);
    final result = await _dealerShipRepository.fetchSellers();

    _sellersUiState.value = result.fold(
      (left) =>
          sellersUiState.copyWith(currentState: ViewState.error, error: left),
      (right) => sellersUiState.copyWith(
          currentState: ViewState.success, sellers: right),
    );
  }

  Future<void> fetchLocations() async {
    _locationUiState.value =
        locationUiState.copyWith(currentState: ViewState.loading);
    final result = await _dealerShipRepository.fetchLocations();

    _locationUiState.value = result.fold(
      (left) =>
          locationUiState.copyWith(currentState: ViewState.error, error: left),
      (right) => locationUiState.copyWith(
          currentState: ViewState.success, locations: right),
    );
  }

  Future<void> fetchColors() async {
    _colorsUiState.value =
        colorsUiState.copyWith(currentState: ViewState.loading);
    final result = await _dealerShipRepository.fetchPopularColors();

    _colorsUiState.value = result.fold(
      (left) =>
          colorsUiState.copyWith(currentState: ViewState.error, error: left),
      (right) => colorsUiState.copyWith(
          currentState: ViewState.success, colors: right),
    );
  }

  Future<void> fetchListing() async {
    await launch(listingUiState.ref, (model) async {
      _listingUiState.value =
          model.emit(listingUiState.copyWith(currentState: ViewState.loading));
      final result = await _dealerShipRepository.fetchListing(filterQuery);

      _listingUiState.value = model.emit(result.fold(
        (left) =>
            listingUiState.copyWith(currentState: ViewState.error, error: left),
        (right) => listingUiState.copyWith(
            currentState: ViewState.success, listing: right),
      ));
    });
  }
}
