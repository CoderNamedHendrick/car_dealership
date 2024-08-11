import '../application.dart';

final class AdminUiState extends DealershipUiState<AdminUiState> {
  const AdminUiState({super.currentState, super.error});

  const AdminUiState.initial()
      : this(currentState: ViewState.idle, error: const EmptyException());

  @override
  AdminUiState copyWith({ViewState? currentState, DealershipException? error}) {
    return AdminUiState(
        currentState: currentState ?? this.currentState,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [currentState, error];
}
