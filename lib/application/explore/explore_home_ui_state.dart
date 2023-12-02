import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';
import '../core/view_model.dart';

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
  List<Object?> get props =>
      [filterQuery, brandsUiState, locationUiState, sellersUiState, listingUiState, colorsUiState];
}

final class BrandsUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<String> brands;

  const BrandsUiState({
    required this.currentState,
    required this.error,
    required this.brands,
  });

  const BrandsUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          brands: const [],
        );

  BrandsUiState copyWith({ViewState? currentState, DealershipException? error, List<String>? brands}) {
    return BrandsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [currentState, error, brands];
}

final class SellersUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<SellerDto> sellers;

  const SellersUiState({required this.currentState, required this.error, required this.sellers});

  const SellersUiState.initial() : this(currentState: ViewState.idle, error: const EmptyException(), sellers: const []);

  SellersUiState copyWith({ViewState? currentState, DealershipException? error, List<SellerDto>? sellers}) {
    return SellersUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      sellers: sellers ?? this.sellers,
    );
  }

  @override
  List<Object?> get props => [currentState, error, sellers];
}

final class LocationUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<String> locations;

  const LocationUiState({required this.currentState, required this.error, required this.locations});

  const LocationUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          locations: const [],
        );

  LocationUiState copyWith({ViewState? currentState, DealershipException? error, List<String>? locations}) {
    return LocationUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      locations: locations ?? this.locations,
    );
  }

  @override
  List<Object?> get props => [currentState, error, locations];
}

final class ListingUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<CarListingDto> listing;

  const ListingUiState({required this.currentState, required this.error, required this.listing});

  const ListingUiState.initial() : this(currentState: ViewState.idle, error: const EmptyException(), listing: const []);

  ListingUiState copyWith({ViewState? currentState, DealershipException? error, List<CarListingDto>? listing}) {
    return ListingUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      listing: listing ?? this.listing,
    );
  }

  @override
  List<Object?> get props => [currentState, error, listing];
}

final class PopularColorsUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<String> colors;

  const PopularColorsUiState({required this.currentState, required this.error, required this.colors});

  const PopularColorsUiState.initial()
      : this(currentState: ViewState.idle, error: const EmptyException(), colors: const []);

  PopularColorsUiState copyWith({ViewState? currentState, DealershipException? error, List<String>? colors}) {
    return PopularColorsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      colors: colors ?? this.colors,
    );
  }

  @override
  List<Object?> get props => [currentState, error, colors];
}
