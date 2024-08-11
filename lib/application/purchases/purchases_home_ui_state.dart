import 'package:car_dealership/application/core/ui_state.dart';
import '../../domain/domain.dart';

final class PurchasesHomeUiState
    extends DealershipUiStateModel<PurchasesHomeUiState> {
  final List<CarListingDto> purchasedListings;

  const PurchasesHomeUiState(
      {super.currentState, super.error, required this.purchasedListings});

  const PurchasesHomeUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          purchasedListings: const [],
        );

  @override
  PurchasesHomeUiState copyWith(
      {UiState? currentState,
      DealershipException? error,
      List<CarListingDto>? purchasedListings}) {
    return PurchasesHomeUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      purchasedListings: purchasedListings ?? this.purchasedListings,
    );
  }

  @override
  List<Object?> get props => [currentState, error, purchasedListings];
}
