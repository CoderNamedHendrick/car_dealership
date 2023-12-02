import 'package:car_dealership/application/core/view_model.dart';
import '../../domain/domain.dart';

final class FilterUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final Filter filter;
  final int adsCount;

  const FilterUiState({required this.currentState, required this.error, required this.filter, required this.adsCount});

  const FilterUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          filter: const Filter(),
          adsCount: 0,
        );

  FilterUiState copyWith({ViewState? currentState, DealershipException? error, Filter? filter, int? adsCount}) {
    return FilterUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      filter: filter ?? this.filter,
      adsCount: adsCount ?? this.adsCount,
    );
  }

  @override
  List<Object?> get props => [currentState, error, filter];
}

final class Filter {
  final String? make;
  final String? model;
  final int? minYear;
  final int? maxYear;
  final double? minPrice;
  final double? maxPrice;
  final double? minMileage;
  final double? maxMileage;
  final String? color;
  final Transmission? transmission;
  final FuelType? fuelType;
  final Availability? availability;
  final String? location;
  final SellerDto? seller;

  const Filter({
    this.make,
    this.model,
    this.minYear,
    this.maxYear,
    this.minPrice,
    this.maxPrice,
    this.minMileage,
    this.maxMileage,
    this.color,
    this.transmission,
    this.fuelType,
    this.availability,
    this.location,
    this.seller,
  });

  Filter copyWith(
      {String? make,
      String? model,
      int? minYear,
      int? maxYear,
      double? minPrice,
      double? maxPrice,
      double? minMileage,
      double? maxMileage,
      String? color,
      Transmission? transmission,
      FuelType? fuelType,
      Availability? availability,
      String? location,
      SellerDto? seller}) {
    return Filter(
      make: make ?? this.make,
      model: model ?? this.model,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minMileage: minMileage ?? this.minMileage,
      maxMileage: maxMileage ?? this.maxMileage,
      color: color ?? this.color,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      availability: availability ?? this.availability,
      location: location ?? this.location,
      seller: seller ?? this.seller,
    );
  }

  bool get isFilterEmpty => switch ((
        make,
        model,
        minYear,
        maxYear,
        minPrice,
        maxPrice,
        minMileage,
        maxMileage,
        color,
        fuelType,
        transmission,
        availability,
        location,
        seller
      )) {
        (null, null, null, null, null, null, null, null, null, null, null, null, null, null) => true,
        _ => false,
      };

  int get appliedFiltersCount {
    int count = 0;

    if (make != null) count++;
    if (model != null) count++;
    if (minYear != null) count++;
    if (maxYear != null) count++;
    if (minPrice != null) count++;
    if (maxPrice != null) count++;
    if (minMileage != null) count++;
    if (maxMileage != null) count++;
    if (color != null) count++;
    if (transmission != null) count++;
    if (availability != null) count++;
    if (location != null) count++;
    if (seller != null) count++;
    if (fuelType != null) count++;

    return count;
  }

  FilterQueryDto toDto() {
    return FilterQueryDto(
      make: make,
      model: model,
      minYear: minYear,
      minPrice: minPrice,
      maxYear: maxYear,
      maxPrice: maxPrice,
      minMileage: minMileage,
      maxMileage: maxMileage,
      color: color,
      transmission: transmission,
      fuelType: fuelType,
      availability: availability,
      location: location,
      sellerId: seller?.id,
    );
  }
}
