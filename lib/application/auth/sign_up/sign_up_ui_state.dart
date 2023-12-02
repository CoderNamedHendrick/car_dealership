import '../../../domain/domain.dart';
import '../../application.dart';

final class SignUpUiState extends DealershipUiStateModel {
  @override
  final ViewState currentState;
  @override
  final DealershipException error;
  final SignUpWithEmailNPhone signUpForm;
  final bool showFormErrors;

  const SignUpUiState({
    required this.currentState,
    required this.error,
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
  List<Object?> get props => [currentState, error, signUpForm, showFormErrors];
}
