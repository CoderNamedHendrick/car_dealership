import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/purchases/purchases_home_ui_state.dart';
import 'package:signals/signals_flutter.dart';

final class PurchasesHomeViewModel extends DealershipViewModel {
  final CarListingInterface _listingRepository;

  PurchasesHomeViewModel(this._listingRepository);

  final _state = signal(const PurchasesHomeUiState.initial());

  ReadonlySignal<PurchasesHomeUiState> get emitter => _state.toReadonlySignal();

  PurchasesHomeUiState get state => _state.toReadonlySignal().value;

  Future<void> fetchPurchases() async {
    _state.value = state.copyWith(currentState: ViewState.loading);

    final result = await _listingRepository.fetchPurchasedCarListings();

    _state.value = result.fold(
      (left) => state.copyWith(currentState: ViewState.error, error: left),
      (right) => state.copyWith(
          currentState: ViewState.success, purchasedListings: right),
    );
  }

  @override
  void dispose() {
    var fn = effect(() => _state.value);
    fn();
  }
}
