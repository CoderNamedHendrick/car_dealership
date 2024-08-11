import '../application.dart';

final class AdminUiState extends DealershipUiStateModel<AdminUiState> {
  const AdminUiState({super.uiState, super.error});

  const AdminUiState.initial()
      : this(uiState: UiState.idle, error: const EmptyException());

  @override
  AdminUiState copyWith({UiState? uiState, DealershipException? error}) {
    return AdminUiState(
        uiState: uiState ?? this.uiState,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [uiState, error];
}
