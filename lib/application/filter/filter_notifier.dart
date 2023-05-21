import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/filter/filter_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterStateNotifier extends StateNotifier<FilterUiState> {
  final CarDealerShipInterface _dealerShipRepository;

  FilterStateNotifier(this._dealerShipRepository) : super(const FilterUiState.initial());

  void clearFilters() {
    state = state.copyWith(filter: const Filter());

    fetchAds();
  }

  void initialiseFilter(FilterQueryDto dto, [SellerDto? sellerDto]) {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(model: model));
  }

  void clearModelFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(location: location));

    fetchAds();
  }

  void clearRegionFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(minPrice: minPrice, maxPrice: maxPrice));

    fetchAds();
  }

  void clearPriceFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(make: make));

    fetchAds();
  }

  void clearMakeFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(seller: sellerDto));

    fetchAds();
  }

  void clearSellerFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(minYear: minYear, maxYear: maxYear));

    fetchAds();
  }

  void clearYearFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(minMileage: minMileage, maxMileage: maxMileage));

    fetchAds();
  }

  void clearMileageFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(color: color));

    fetchAds();
  }

  void clearColorFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(transmission: transmission));

    fetchAds();
  }

  void clearTransmissionFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(fuelType: fuelType));

    fetchAds();
  }

  void clearFuelTypeFilter() {
    state = state.copyWith(
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
    state = state.copyWith(filter: state.filter.copyWith(availability: availability));

    fetchAds();
  }

  void clearAvailabilityFilter() {
    state = state.copyWith(
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
    state = state.copyWith(currentState: ViewState.loading);
    final result = await _dealerShipRepository.fetchAdsCount(state.filter.toDto());

    state = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) => state.copyWith(currentState: ViewState.success, adsCount: right),
    );
  }
}

final filterStateNotifierProvider = StateNotifierProvider.autoDispose<FilterStateNotifier, FilterUiState>((ref) {
  return FilterStateNotifier(ref.read(carDealershipProvider));
});
