import 'package:car_dealership/application/core/view_model.dart';
import '../../domain/domain.dart';

final class PurchasesHomeUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<CarListingDto> purchasedListings;

  const PurchasesHomeUiState({required this.currentState, required this.error, required this.purchasedListings});

  const PurchasesHomeUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          purchasedListings: const [],
        );

  PurchasesHomeUiState copyWith(
      {ViewState? currentState, DealershipException? error, List<CarListingDto>? purchasedListings}) {
    return PurchasesHomeUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      purchasedListings: purchasedListings ?? this.purchasedListings,
    );
  }

  @override
  List<Object?> get props => [currentState, error, purchasedListings];
}
