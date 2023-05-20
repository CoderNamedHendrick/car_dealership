import 'package:car_dealership/application/core/view_model.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'explore_home_ui_state.dart';

class ExploreHomeUiStateNotifier extends StateNotifier<ExploreHomeUiState> {
  final CarDealerShipInterface _dealerShipRepository;

  ExploreHomeUiStateNotifier(this._dealerShipRepository) : super(const ExploreHomeUiState.initial()) {
    fetchBrands();
    fetchSellers();
    fetchLocations();
    fetchColors();
  }

  void setFilter(FilterQueryDto? filterQuery) => state = state.copyWith(filterQuery: filterQuery);

  void fetchBrands() async {
    state = state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.loading));
    final result = await _dealerShipRepository.fetchBrands();

    state = result.fold(
      (left) => state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.error, error: left)),
      (right) =>
          state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.success, brands: right)),
    );
  }

  void fetchSellers() async {
    state = state.copyWith(sellersUiState: state.sellersUiState.copyWith(currentState: ViewState.loading));
    final result = await _dealerShipRepository.fetchSellers();

    state = result.fold(
      (left) =>
          state.copyWith(sellersUiState: state.sellersUiState.copyWith(currentState: ViewState.error, error: left)),
      (right) => state.copyWith(
          sellersUiState: state.sellersUiState.copyWith(currentState: ViewState.success, sellers: right)),
    );
  }

  void fetchLocations() async {
    state = state.copyWith(locationUiState: state.locationUiState.copyWith(currentState: ViewState.loading));
    final result = await _dealerShipRepository.fetchLocations();

    state = result.fold(
      (left) =>
          state.copyWith(locationUiState: state.locationUiState.copyWith(currentState: ViewState.error, error: left)),
      (right) => state.copyWith(
          locationUiState: state.locationUiState.copyWith(currentState: ViewState.success, locations: right)),
    );
  }

  void fetchColors() async {
    state = state.copyWith(colorsUiState: state.colorsUiState.copyWith(currentState: ViewState.loading));
    final result = await _dealerShipRepository.fetchPopularColors();

    state = state.copyWith(
      colorsUiState: result.fold((left) => state.colorsUiState.copyWith(currentState: ViewState.error, error: left),
          (right) => state.colorsUiState.copyWith(currentState: ViewState.success, colors: right)),
    );
  }

  void fetchListing() async {
    await launch(state.listingUiState.ref, (model) async {
      state =
          state.copyWith(listingUiState: model.emit(state.listingUiState.copyWith(currentState: ViewState.loading)));
      final result = await _dealerShipRepository.fetchListing(state.filterQuery);

      state = result.fold(
        (left) => state.copyWith(
            listingUiState: model.emit(state.listingUiState.copyWith(currentState: ViewState.error, error: left))),
        (right) => state.copyWith(
            listingUiState: state.listingUiState.copyWith(currentState: ViewState.success, listing: right)),
      );
    });
  }
}

final exploreHomeUiStateNotifierProvider =
    StateNotifierProvider.autoDispose<ExploreHomeUiStateNotifier, ExploreHomeUiState>((ref) {
  return ExploreHomeUiStateNotifier(ref.read(carDealershipProvider));
});
