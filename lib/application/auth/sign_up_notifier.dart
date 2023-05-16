import '../../domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/view_model.dart';
import 'sign_up_ui_state.dart';

class SignUpStateNotifier extends StateNotifier<SignUpUiState> {
  final AuthRepositoryInterface _authRepo;

  SignUpStateNotifier(this._authRepo) : super(SignUpUiState.initial());

  void continueWithGoogleOnTap() async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(currentState: ViewState.loading));

      final result = await _authRepo.signingWithGoogle();

      state = result.fold(
        (left) => model.emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: ViewState.success)),
      );
    });
  }

  void continueWithFacebookOnTap() async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(currentState: ViewState.loading));

      final result = await _authRepo.signingWithFacebook();

      state = result.fold(
        (left) => model.emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: ViewState.success)),
      );
    });
  }

  void firstNameOnChanged(String input) {
    state = state.copyWith(signUpForm: state.signUpForm.copyWith(firstName: FirstName(input)));
  }

  void lastNameOnChanged(String input) {
    state = state.copyWith(signUpForm: state.signUpForm.copyWith(lastName: LastName(input)));
  }

  void emailOnChanged(String input) {
    state = state.copyWith(signUpForm: state.signUpForm.copyWith(emailAddress: Email(input)));
  }

  void phoneNumberOnChanged(String input) {
    state = state.copyWith(signUpForm: state.signUpForm.copyWith(phone: Phone(input)));
  }

  void passwordOnChanged(String input) {
    state = state.copyWith(signUpForm: state.signUpForm.copyWith(password: Password(input)));
  }

  void createAccountOnTap() {
    if (state.signUpForm.failureOption.isNone()) {}

    state = state.copyWith(showFormErrors: true);
  }
}

final signUpStateNotifierProvider = StateNotifierProvider.autoDispose<SignUpStateNotifier, SignUpUiState>((ref) {
  return SignUpStateNotifier(ref.read(authRepositoryProvider));
});
