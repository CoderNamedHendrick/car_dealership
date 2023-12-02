import 'package:car_dealership/application/application.dart';
import 'package:signals/signals_flutter.dart';
import '../../domain/domain.dart';
import 'checkout_ui_state.dart';

final class CheckoutViewModel extends DealershipViewModel {
  final CarListingInterface _listingRepository;

  CheckoutViewModel(this._listingRepository);

  final _state = signal(CheckoutUiState.initial());

  ReadonlySignal<CheckoutUiState> get emitter => _state.toReadonlySignal();

  CheckoutUiState get state => _state.toReadonlySignal().value;

  void initialiseConfig(CheckoutConfigDto config) {
    _state.value = state.copyWith(config: config);
  }

  void cardNumberOnChanged(String input) {
    _state.value = state.copyWith(
        checkoutForm:
            state.checkoutForm.copyWith(cardNumber: CardNumber(input)));
  }

  void cardExpiryOnChanged(String input) {
    _state.value = state.copyWith(
        checkoutForm:
            state.checkoutForm.copyWith(cardExpiry: CardExpiry(input)));
  }

  void cvvOnChanged(String input) {
    _state.value = state.copyWith(
        checkoutForm: state.checkoutForm.copyWith(cvv: CVV(input)));
  }

  Future<void> payOnTap() async {
    if (state.checkoutForm.failureOption.isNone()) {
      await launch(state.ref, (model) async {
        _state.value =
            model.emit(state.copyWith(currentState: ViewState.loading));
        final result = await _listingRepository
            .purchaseListing(state.config.carListing.id);

        _state.value = result.fold(
          (left) => model
              .emit(state.copyWith(currentState: ViewState.error, error: left)),
          (right) =>
              model.emit(state.copyWith(currentState: ViewState.success)),
        );
      });
      return;
    }

    _state.value = state.copyWith(showFormErrors: true);
  }

  @override
  void dispose() {
    var fn = effect(() => _state.value);
    fn();
  }
}
