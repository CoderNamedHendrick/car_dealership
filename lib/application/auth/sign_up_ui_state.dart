import '../../domain/domain.dart';
import '../core/ui_state.dart';

final class SignUpUiState extends DealershipUiStateModel<SignUpUiState> {
  final SignUpWithEmailNPhone signUpForm;
  final bool showFormErrors;

  const SignUpUiState({
    super.uiState,
    super.error,
    required this.signUpForm,
    required this.showFormErrors,
  });

  SignUpUiState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          signUpForm: SignUpWithEmailNPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignUpUiState copyWith({
    UiState? uiState,
    DealershipException? error,
    SignUpWithEmailNPhone? signUpForm,
    bool? showFormErrors,
  }) {
    return SignUpUiState(
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      signUpForm: signUpForm ?? this.signUpForm,
      showFormErrors: showFormErrors ?? this.showFormErrors,
    );
  }

  @override
  List<Object?> get otherProps => [signUpForm, showFormErrors];
}
