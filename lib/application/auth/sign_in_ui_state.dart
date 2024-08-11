import '../../domain/domain.dart';
import '../core/view_model.dart';

final class SignInUiState extends DealershipUiState<SignInUiState> {


  final SignInWithEmailPhone signInForm;
  final bool showFormErrors;

  const SignInUiState({
   super.currentState,
    super.error,
    required this.signInForm,
    required this.showFormErrors,
  });

  SignInUiState.initial()
      : this(
          currentState: ViewState.idle,
          error: const EmptyException(),
          signInForm: SignInWithEmailPhone.empty(),
          showFormErrors: false,
        );

  @override
  SignInUiState copyWith({
    ViewState? currentState,
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
