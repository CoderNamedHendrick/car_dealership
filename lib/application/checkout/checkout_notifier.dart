import 'package:car_dealership/application/application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';
import 'checkout_ui_state.dart';

class CheckoutStateNotifier extends StateNotifier<CheckoutUiState> {
  final CarListingInterface _listingRepository;

  CheckoutStateNotifier(this._listingRepository) : super(CheckoutUiState.initial());

  void initialiseConfig(CheckoutConfigDto config) {
    state = state.copyWith(config: config);
  }

  void cardNumberOnChanged(String input) {
    state = state.copyWith(checkoutForm: state.checkoutForm.copyWith(cardNumber: CardNumber(input)));
  }

  void cardExpiryOnChanged(String input) {
    state = state.copyWith(checkoutForm: state.checkoutForm.copyWith(cardExpiry: CardExpiry(input)));
  }

  void cvvOnChanged(String input) {
    state = state.copyWith(checkoutForm: state.checkoutForm.copyWith(cvv: CVV(input)));
  }

  void payOnTap() async {
    if (state.checkoutForm.failureOption.isNone()) {
      await launch(state.ref, (model) async {
        state = model.emit(state.copyWith(currentState: ViewState.loading));
        final result = await _listingRepository.purchaseListing(state.config.carListing.id);

        state = result.fold(
          (left) => model.emit(state.copyWith(currentState: ViewState.error, error: left)),
          (right) => model.emit(state.copyWith(currentState: ViewState.success)),
        );
      });
      return;
    }

    state = state.copyWith(showFormErrors: true);
  }
}

final checkoutStateNotifierProvider = StateNotifierProvider.autoDispose<CheckoutStateNotifier, CheckoutUiState>((ref) {
  return CheckoutStateNotifier(ref.read(carListingProvider));
});
