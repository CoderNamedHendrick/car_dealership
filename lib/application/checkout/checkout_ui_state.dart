import '../../domain/domain.dart';
import '../core/view_model.dart';

final class CheckoutUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final CheckoutConfigDto config;
  final CardCheckout checkoutForm;
  final bool showFormErrors;

  const CheckoutUiState({
    required this.currentState,
    required this.error,
    required this.config,
    required this.checkoutForm,
    required this.showFormErrors,
  });

  CheckoutUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          config: const CheckoutConfigDto.empty(),
          checkoutForm: CardCheckout.empty(),
          showFormErrors: false,
        );

  CheckoutUiState copyWith(
      {ViewState? currentState,
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
  List<Object?> get props => [currentState, error, config, checkoutForm, showFormErrors];
}
