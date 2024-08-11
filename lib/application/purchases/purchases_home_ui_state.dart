import 'package:car_dealership/application/core/view_model.dart';
import '../../domain/domain.dart';

final class PurchasesHomeUiState
    extends DealershipUiState<PurchasesHomeUiState> {
  final List<CarListingDto> purchasedListings;

  const PurchasesHomeUiState(
      {super.currentState, super.error, required this.purchasedListings});

  const PurchasesHomeUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          purchasedListings: const [],
        );

  @override
  PurchasesHomeUiState copyWith(
      {ViewState? currentState,
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
