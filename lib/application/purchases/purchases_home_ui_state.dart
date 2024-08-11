import 'package:car_dealership/application/core/ui_state.dart';
import '../../domain/domain.dart';

final class PurchasesHomeUiState
    extends DealershipUiStateModel<PurchasesHomeUiState> {
  final List<CarListingDto> purchasedListings;

  const PurchasesHomeUiState(
      {super.uiState, super.error, required this.purchasedListings});

  const PurchasesHomeUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          purchasedListings: const [],
        );

  @override
  PurchasesHomeUiState copyWith(
      {UiState? uiState,
      DealershipException? error,
      List<CarListingDto>? purchasedListings}) {
    return PurchasesHomeUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      purchasedListings: purchasedListings ?? this.purchasedListings,
    );
  }

  @override
  List<Object?> get props => [uiState, error, purchasedListings];
}
