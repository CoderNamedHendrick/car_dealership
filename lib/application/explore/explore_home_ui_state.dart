import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';
import '../core/ui_state.dart';

class ExploreHomeUiState extends Equatable {
  final FilterQueryDto filterQuery;
  final BrandsUiState brandsUiState;
  final SellersUiState sellersUiState;
  final LocationUiState locationUiState;
  final ListingUiState listingUiState;
  final PopularColorsUiState colorsUiState;

  const ExploreHomeUiState({
    required this.filterQuery,
    required this.brandsUiState,
    required this.locationUiState,
    required this.sellersUiState,
    required this.listingUiState,
    required this.colorsUiState,
  });

  const ExploreHomeUiState.initial()
      : this(
          filterQuery: const FilterQueryDto(),
          brandsUiState: const BrandsUiState.initial(),
          sellersUiState: const SellersUiState.initial(),
          locationUiState: const LocationUiState.initial(),
          listingUiState: const ListingUiState.initial(),
          colorsUiState: const PopularColorsUiState.initial(),
        );

  ExploreHomeUiState copyWith({
    FilterQueryDto? filterQuery,
    BrandsUiState? brandsUiState,
    SellersUiState? sellersUiState,
    LocationUiState? locationUiState,
    ListingUiState? listingUiState,
    PopularColorsUiState? colorsUiState,
  }) {
    return ExploreHomeUiState(
      filterQuery: filterQuery ?? this.filterQuery,
      brandsUiState: brandsUiState ?? this.brandsUiState,
      locationUiState: locationUiState ?? this.locationUiState,
      sellersUiState: sellersUiState ?? this.sellersUiState,
      listingUiState: listingUiState ?? this.listingUiState,
      colorsUiState: colorsUiState ?? this.colorsUiState,
    );
  }

  @override
  List<Object?> get props => [
        filterQuery,
        brandsUiState,
        locationUiState,
        sellersUiState,
        listingUiState,
        colorsUiState
      ];
}

final class BrandsUiState extends DealershipUiStateModel<BrandsUiState> {
  final List<String> brands;

  const BrandsUiState({
    super.currentState,
    super.error,
    required this.brands,
  });

  const BrandsUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          brands: const [],
        );

  @override
  BrandsUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<String>? brands}) {
    return BrandsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [currentState, error, brands];
}

final class SellersUiState extends DealershipUiStateModel<SellersUiState> {
  final List<SellerDto> sellers;

  const SellersUiState(
      {super.currentState, super.error, required this.sellers});

  const SellersUiState.initial()
      : this(
            currentState: UiState.idle,
            error: const EmptyException(),
            sellers: const []);

  @override
  SellersUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<SellerDto>? sellers}) {
    return SellersUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      sellers: sellers ?? this.sellers,
    );
  }

  @override
  List<Object?> get props => [currentState, error, sellers];
}

final class LocationUiState extends DealershipUiStateModel<LocationUiState> {
  final List<String> locations;

  const LocationUiState(
      {super.currentState, super.error, required this.locations});

  const LocationUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          locations: const [],
        );

  @override
  LocationUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<String>? locations}) {
    return LocationUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      locations: locations ?? this.locations,
    );
  }

  @override
  List<Object?> get props => [currentState, error, locations];
}

final class ListingUiState extends DealershipUiStateModel<ListingUiState> {
  final List<CarListingDto> listing;

  const ListingUiState(
      {super.currentState, super.error, required this.listing});

  const ListingUiState.initial()
      : this(
            currentState: UiState.idle,
            error: const EmptyException(),
            listing: const []);

  @override
  ListingUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<CarListingDto>? listing}) {
    return ListingUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      listing: listing ?? this.listing,
    );
  }

  @override
  List<Object?> get props => [currentState, error, listing];
}

final class PopularColorsUiState
    extends DealershipUiStateModel<PopularColorsUiState> {
  final List<String> colors;

  const PopularColorsUiState(
      {super.currentState, super.error, required this.colors});

  const PopularColorsUiState.initial()
      : this(
            currentState: UiState.idle,
            error: const EmptyException(),
            colors: const []);

  @override
  PopularColorsUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<String>? colors}) {
    return PopularColorsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      colors: colors ?? this.colors,
    );
  }

  @override
  List<Object?> get props => [currentState, error, colors];
}
