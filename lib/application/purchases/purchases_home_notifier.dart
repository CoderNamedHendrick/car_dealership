import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import '../core/view_model.dart';
import 'purchases_home_ui_state.dart';

class PurchasesHomeStateNotifier extends StateNotifier<PurchasesHomeUiState> {
  final CarListingInterface _listingRepository;

  PurchasesHomeStateNotifier(this._listingRepository) : super(const PurchasesHomeUiState.initial()) {
    fetchPurchases();
  }

  void fetchPurchases() async {
    state = state.copyWith(currentState: ViewState.loading);

    final result = await _listingRepository.fetchPurchasedCarListings();

    state = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) => state.copyWith(currentState: ViewState.success, purchasedListings: right),
    );
  }
}

final purchasesHomeStateNotifierProvider =
    StateNotifierProvider.autoDispose<PurchasesHomeStateNotifier, PurchasesHomeUiState>((ref) {
  return PurchasesHomeStateNotifier(ref.read(carListingProvider));
});
