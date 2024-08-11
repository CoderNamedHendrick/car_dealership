import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class SignUpUiState extends DealershipUiStateModel<SignUpUiState> {
  final SignUpWithEmailNPhone signUpForm;
  final bool showFormErrors;

  const SignUpUiState({
    super.currentState,
    super.error,
    required this.signUpForm,
    required this.showFormErrors,
  });

  SignUpUiState.initial()
      : this(
          currentState: UiState.idle,
          error: const EmptyException(),
          signUpForm: SignUpWithEmailNPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignUpUiState copyWith({
    UiState? currentState,
    DealershipException? error,
    SignUpWithEmailNPhone? signUpForm,
    bool? showFormErrors,
  }) {
    return SignUpUiState(
      currentState: currentState ?? this.currentState,
      error: error ?? this.error,
      signUpForm: signUpForm ?? this.signUpForm,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get otherProps => [signUpForm, showFormErrors];
}
