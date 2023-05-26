import '../application.dart';

final class AdminUiState extends DealershipViewModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;

  const AdminUiState({required this.currentState, required this.error});

  const AdminUiState.initial() : this(currentState: ViewState.idle, error: const EmptyException());

  AdminUiState copyWith({ViewState? currentState, DealershipException? error}) {
    return AdminUiState(currentState: currentState ?? this.currentState, error: error ?? this.error);
  }

  @override
  List<Object?> get props => [currentState, error];
}
