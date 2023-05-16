import 'package:equatable/equatable.dart';
import '../../domain/core/core.dart';
import '../core/view_model.dart';

class ExploreHomeUiState extends Equatable {
  final BrandsUiState brandsUiState;

  const ExploreHomeUiState({required this.brandsUiState});

  const ExploreHomeUiState.initial() : this(brandsUiState: const BrandsUiState.initial());

  ExploreHomeUiState copyWith({BrandsUiState? brandsUiState}) {
    return ExploreHomeUiState(brandsUiState: brandsUiState ?? this.brandsUiState);
  }

  @override
  List<Object?> get props => [brandsUiState];
}

final class BrandsUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final List<String> brands;

  const BrandsUiState({
    required this.currentState,
    required this.error,
    required this.brands,
  });

  const BrandsUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          brands: const [],
        );

  BrandsUiState copyWith({ViewState? currentState, DealershipException? error, List<String>? brands}) {
    return BrandsUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [currentState, error, brands];
}
