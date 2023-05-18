import '../../domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/view_model.dart';
import 'sign_in_ui_state.dart';

class SignInStateNotifier extends StateNotifier<SignInUiState> {
  final AuthRepositoryInterface _authRepo;

  SignInStateNotifier(this._authRepo) : super(SignInUiState.initial());

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

  void emailOrPhoneOnChanged(String input) {
    state = state.copyWith(signInForm: state.signInForm.copyWith(emailOrPhone: EmailOrPhone(input)));
  }

  void passwordOnChanged(String input) {
    state = state.copyWith(signInForm: state.signInForm.copyWith(password: Password(input)));
  }

  void loginOnTap() async {
    if (state.signInForm.failureOption.isNone()) {
      await launch(state.ref, (model) async {
        state = model.emit(state.copyWith(currentState: ViewState.loading));
        final result = await _authRepo.signInWithEmailPhoneAndPassword(state.signInForm.toDto());

        state = result.fold(
          (left) => model.emit(state.copyWith(currentState: ViewState.error, error: left)),
          (right) => model.emit(state.copyWith(currentState: ViewState.success)),
        );
      });
      return;
    }

    state = state.copyWith(showFormErrors: true);
  }
}

final signInStateNotifierProvider = StateNotifierProvider.autoDispose<SignInStateNotifier, SignInUiState>((ref) {
  return SignInStateNotifier(ref.read(authRepositoryProvider));
});
