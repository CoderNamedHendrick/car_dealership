import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class CheckoutUiState extends DealershipUiStateModel<CheckoutUiState> {


  final CheckoutConfigDto config;
  final CardCheckout checkoutForm;
  final bool showFormErrors;

  const CheckoutUiState({
   super.currentState,
    super.error,
    required this.config,
    required this.checkoutForm,
    required this.showFormErrors,
  });

  CheckoutUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          config: const CheckoutConfigDto.empty(),
          checkoutForm: CardCheckout.empty(),
          showFormErrors: false,
        );

  @override
  CheckoutUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      CheckoutConfigDto? config,
      CardCheckout? checkoutForm,
      bool? showFormErrors}) {
    return CheckoutUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      config: config ?? this.config,
      checkoutForm: checkoutForm ?? this.checkoutForm,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get props =>
      [currentState, error, config, checkoutForm, showFormErrors];
}
