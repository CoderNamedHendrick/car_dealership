import 'package:car_dealership/application/core/ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'explore_home_ui_state.dart';

class ExploreHomeUiStateNotifier extends StateNotifier<ExploreHomeUiState> {
  final CarDealerShipInterface _dealerShipRepository;

  ExploreHomeUiStateNotifier(this._dealerShipRepository)
      : super(const ExploreHomeUiState.initial());

  void setFilter(FilterQueryDto? filterQuery) =>
      state = state.copyWith(filterQuery: filterQuery);

  Future<void> fetchBrands() async {
    await launch(state.brandsUiState.reference, (model) async {
      state = state.copyWith(
          brandsUiState: state.brandsUiState.sLoading().emitTo(model));
      final result = await _dealerShipRepository.fetchBrands();

      state = result.fold(
        (left) => state.copyWith(
            brandsUiState: state.brandsUiState
                .copyWith(currentState: UiState.error, error: left)
                .emitTo(model)),
        (right) => state.copyWith(
            brandsUiState: state.brandsUiState
                .copyWith(currentState: UiState.success, brands: right)
                .emitTo(model)),
      );
    }, displayError: false);
  }

  Future<void> fetchSellers() async {
    await launch(state.sellersUiState.reference, (model) async {
      state = state.copyWith(
          sellersUiState: state.sellersUiState.sLoading().emitTo(model));
      final result = await _dealerShipRepository.fetchSellers();

      state = result.fold(
        (left) => state.copyWith(
            sellersUiState: state.sellersUiState
                .copyWith(currentState: UiState.error, error: left)
                .emitTo(model)),
        (right) => state.copyWith(
            sellersUiState: state.sellersUiState
                .copyWith(currentState: UiState.success, sellers: right)
                .emitTo(model)),
      );
    }, displayError: false);
  }

  Future<void> fetchLocations() async {
    await launch(state.locationUiState.reference, (model) async {
      state = state.copyWith(
          locationUiState: state.locationUiState.sLoading().emitTo(model));
      final result = await _dealerShipRepository.fetchLocations();

      state = result.fold(
        (left) => state.copyWith(
            locationUiState: state.locationUiState
                .copyWith(currentState: UiState.error, error: left)
                .emitTo(model)),
        (right) => state.copyWith(
            locationUiState: state.locationUiState
                .copyWith(currentState: UiState.success, locations: right)
                .emitTo(model)),
      );
    }, displayError: false);
  }

  Future<void> fetchColors() async {
    await launch(state.colorsUiState.reference, (model) async {
      state = state.copyWith(
          colorsUiState: state.colorsUiState.sLoading().emitTo(model));
      final result = await _dealerShipRepository.fetchPopularColors();

      state = state.copyWith(
        colorsUiState: result.fold(
            (left) => state.colorsUiState
                .copyWith(currentState: UiState.error, error: left)
                .emitTo(model),
            (right) => state.colorsUiState
                .copyWith(currentState: UiState.success, colors: right)
                .emitTo(model)),
      );
    }, displayError: false);
  }

  Future<void> fetchListing() async {
    await launch(state.listingUiState.reference, (model) async {
      state = state.copyWith(
          listingUiState: model.emit(
              state.listingUiState.copyWith(currentState: UiState.loading)));
      final result =
          await _dealerShipRepository.fetchListing(state.filterQuery);

      state = result.fold(
        (left) => state.copyWith(
            listingUiState: model.emit(state.listingUiState
                .copyWith(currentState: UiState.error, error: left))),
        (right) => state.copyWith(
            listingUiState: state.listingUiState
                .copyWith(currentState: UiState.success, listing: right)),
      );
    });
  }
}

final exploreHomeUiStateNotifierProvider = StateNotifierProvider.autoDispose<
    ExploreHomeUiStateNotifier, ExploreHomeUiState>((ref) {
  return ExploreHomeUiStateNotifier(ref.read(carDealershipProvider));
});
