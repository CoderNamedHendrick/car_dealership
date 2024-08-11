import '../../domain/domain.dart';
import '../core/view_model.dart';

final class SignUpUiState extends DealershipUiState<SignUpUiState> {
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
          currentState: ViewState.idle,
          error: const EmptyException(),
          signUpForm: SignUpWithEmailNPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignUpUiState copyWith({
    ViewState? currentState,
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
