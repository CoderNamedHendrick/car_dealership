import 'package:car_dealership/application/application.dart';
import 'package:signals/signals_flutter.dart';
import 'filter_ui_state.dart';

final class FilterViewModel {
  final CarDealerShipInterface _dealerShipRepository;

  FilterViewModel(this._dealerShipRepository);

  final _state = signal(const FilterUiState.initial());

  ReadonlySignal<FilterUiState> get emitter => _state;

  FilterUiState get state => _state.value;

  void clearFilters() {
    _state.value = state.copyWith(filter: const Filter());

    fetchAds();
  }

  void initialiseFilter(FilterQueryDto dto, [SellerDto? sellerDto]) {
    _state.value = state.copyWith(
        filter: Filter(
      make: dto.make,
      model: dto.model,
      minYear: dto.minYear,
      maxYear: dto.maxYear,
      minPrice: dto.minPrice,
      maxPrice: dto.maxPrice,
      minMileage: dto.minMileage,
      maxMileage: dto.maxMileage,
      color: dto.color,
      transmission: dto.transmission,
      fuelType: dto.fuelType,
      availability: dto.availability,
      location: dto.location,
      seller: sellerDto,
    ));

    fetchAds();
  }

  void updateModel(String model) {
    _state.value = state.copyWith(filter: state.filter.copyWith(model: model));
  }

  void clearModelFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        location: state.filter.location,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );
  }

  void updateRegion(String location) {
    _state.value =
        state.copyWith(filter: state.filter.copyWith(location: location));

    fetchAds();
  }

  void clearRegionFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updatePrice({double? minPrice, double? maxPrice}) {
    _state.value = state.copyWith(
        filter: state.filter.copyWith(minPrice: minPrice, maxPrice: maxPrice));

    fetchAds();
  }

  void clearPriceFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateMake(String make) {
    _state.value = state.copyWith(filter: state.filter.copyWith(make: make));

    fetchAds();
  }

  void clearMakeFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateSeller(SellerDto sellerDto) {
    _state.value =
        state.copyWith(filter: state.filter.copyWith(seller: sellerDto));

    fetchAds();
  }

  void clearSellerFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateYear({int? minYear, int? maxYear}) {
    _state.value = state.copyWith(
        filter: state.filter.copyWith(minYear: minYear, maxYear: maxYear));

    fetchAds();
  }

  void clearYearFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateMileage({double? minMileage, double? maxMileage}) {
    _state.value = state.copyWith(
        filter: state.filter
            .copyWith(minMileage: minMileage, maxMileage: maxMileage));

    fetchAds();
  }

  void clearMileageFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateColor(String color) {
    _state.value = state.copyWith(filter: state.filter.copyWith(color: color));

    fetchAds();
  }

  void clearColorFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateTransmission(Transmission transmission) {
    _state.value = state.copyWith(
        filter: state.filter.copyWith(transmission: transmission));

    fetchAds();
  }

  void clearTransmissionFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void updateFuelType(FuelType fuelType) {
    _state.value =
        state.copyWith(filter: state.filter.copyWith(fuelType: fuelType));

    fetchAds();
  }

  void clearFuelTypeFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        availability: state.filter.availability,
        location: state.filter.location,
        seller: state.filter.seller,
      ),
    );

    fetchAds();
  }

  void updateAvailability(Availability availability) {
    _state.value = state.copyWith(
        filter: state.filter.copyWith(availability: availability));

    fetchAds();
  }

  void clearAvailabilityFilter() {
    _state.value = state.copyWith(
      filter: Filter(
        make: state.filter.make,
        model: state.filter.model,
        minYear: state.filter.minYear,
        maxYear: state.filter.maxYear,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minMileage: state.filter.minMileage,
        maxMileage: state.filter.maxMileage,
        color: state.filter.color,
        transmission: state.filter.transmission,
        location: state.filter.location,
        seller: state.filter.seller,
        fuelType: state.filter.fuelType,
      ),
    );

    fetchAds();
  }

  void fetchAds() async {
    _state.value = state.copyWith(currentState: ViewState.loading);
    final result =
        await _dealerShipRepository.fetchAdsCount(state.filter.toDto());

    _state.value = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) =>
          state.copyWith(currentState: ViewState.success, adsCount: right),
    );
  }
}
