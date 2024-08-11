import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class SignInUiState extends DealershipFormUiStateModel<SignInUiState> {
  final SignInWithEmailPhone signInForm;

  const SignInUiState({
    super.currentState,
    super.error,
    required this.signInForm,
    super.showFormErrors,
  });

  SignInUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          signInForm: SignInWithEmailPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignInUiState copyWith({
    UiState? currentState,
    DealershipException? error,
    SignInWithEmailPhone? signInForm,
    bool? showFormErrors,
  }) {
    return SignInUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      signInForm: signInForm ?? this.signInForm,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get props => [currentState, error, signInForm, showFormErrors];
}
