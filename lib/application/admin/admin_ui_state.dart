import '../application.dart';

final class AdminUiState extends DealershipUiStateModel<AdminUiState> {
  const AdminUiState({super.currentState, super.error});

  const AdminUiState.initial()
      : this(currentState: UiState.idle, error: const EmptyException());

  @override
  AdminUiState copyWith({UiState? currentState, DealershipException? error}) {
    return AdminUiState(
        currentState: currentState ?? this.currentState,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [currentState, error];
}
