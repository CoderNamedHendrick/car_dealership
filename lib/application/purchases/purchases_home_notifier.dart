import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import '../core/ui_state.dart';
import 'purchases_home_ui_state.dart';

class PurchasesHomeStateNotifier extends StateNotifier<PurchasesHomeUiState> {
  final CarListingInterface _listingRepository;

  PurchasesHomeStateNotifier(this._listingRepository) : super(const PurchasesHomeUiState.initial());

  Future<void> fetchPurchases() async {
    state = state.copyWith(uiState: UiState.loading);

    final result = await _listingRepository.fetchPurchasedCarListings();

    state = result.fold(
      (left) => state.copyWith(uiState: UiState.error, error: left),
      (right) => state.copyWith(uiState: UiState.success, purchasedListings: right),
    );
  }
}

final purchasesHomeStateNotifierProvider =
    StateNotifierProvider.autoDispose<PurchasesHomeStateNotifier, PurchasesHomeUiState>((ref) {
  return PurchasesHomeStateNotifier(ref.read(carListingProvider));
});
