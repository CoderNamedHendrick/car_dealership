import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class SignInUiState extends DealershipFormUiStateModel<SignInUiState> {
  final SignInWithEmailPhone signInForm;

  const SignInUiState({
    super.uiState,
    super.error,
    required this.signInForm,
    super.showFormErrors,
  });

  SignInUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          signInForm: SignInWithEmailPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignInUiState copyWith({
    UiState? uiState,
    DealershipException? error,
    SignInWithEmailPhone? signInForm,
    bool? showFormErrors,
  }) {
    return SignInUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      signInForm: signInForm ?? this.signInForm,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get props => [uiState, error, signInForm, showFormErrors];
}
