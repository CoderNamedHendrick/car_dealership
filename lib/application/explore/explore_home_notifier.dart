import 'package:car_dealership/application/core/view_model.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'explore_home_ui_state.dart';

class ExploreHomeUiStateNotifier extends StateNotifier<ExploreHomeUiState> {
  final CarDealerShipInterface _dealerShipRepository;

  ExploreHomeUiStateNotifier(this._dealerShipRepository) : super(const ExploreHomeUiState.initial()) {
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

final exploreHomeUiStateNotifierProvider =
    StateNotifierProvider.autoDispose<ExploreHomeUiStateNotifier, ExploreHomeUiState>((ref) {
  return ExploreHomeUiStateNotifier(ref.read(carDealershipProvider));
});
