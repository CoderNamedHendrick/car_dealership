import 'package:car_dealership/application/core/view_model.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'listing_home_ui_state.dart';

class ListingHomeUiStateNotifier extends StateNotifier<ListingHomeUiState> {
  final CarDealerShipInterface _dealerShipRepository;

  ListingHomeUiStateNotifier(this._dealerShipRepository) : super(const ListingHomeUiState.initial()) {
    fetchBrands();
  }

  void fetchBrands() async {
    state = state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.loading));

    final result = await _dealerShipRepository.fetchBrands();

    state = result.fold(
      (left) => state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.error, error: left)),
      (right) =>
          state.copyWith(brandsUiState: state.brandsUiState.copyWith(currentState: ViewState.success, brands: right)),
    );
  }
}

final listingHomeUiStateNotifierProvider =
    StateNotifierProvider.autoDispose<ListingHomeUiStateNotifier, ListingHomeUiState>((ref) {
  return ListingHomeUiStateNotifier(ref.read(carDealershipProvider));
});
