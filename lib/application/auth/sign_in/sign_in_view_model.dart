import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/auth/sign_in/sign_in_ui_state.dart';
import 'package:signals/signals_flutter.dart';

import '../../../domain/domain.dart';

final class SignInViewModel {
  final AuthRepositoryInterface _authRepo;

  SignInViewModel(this._authRepo);

  final _state = signal(SignInUiState.initial());

  ReadonlySignal<SignInUiState> get emitter => _state.toReadonlySignal();

  SignInUiState get state => _state.toReadonlySignal().value;

  void emailOrPhoneOnChanged(String input) {
    _state.value = state.copyWith(
        signInForm:
            state.signInForm.copyWith(emailOrPhone: EmailOrPhone(input)));
  }

  void passwordOnChanged(String input) {
    _state.value = state.copyWith(
        signInForm: state.signInForm.copyWith(password: Password(input)));
  }

  Future<void> continueWithGoogleOnTap() async {
    await launch(state.ref, (model) async {
      _state.value =
          model.emit(state.copyWith(currentState: ViewState.loading));

      final result = await _authRepo.signingWithGoogle();

      _state.value = result.fold(
        (left) => model
            .emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: ViewState.success)),
      );
    });
  }

  Future<void> continueWithFacebookOnTap() async {
    await launch(state.ref, (model) async {
      _state.value =
          model.emit(state.copyWith(currentState: ViewState.loading));

      final result = await _authRepo.signingWithFacebook();

      _state.value = result.fold(
        (left) => model
            .emit(state.copyWith(currentState: ViewState.error, error: left)),
        (right) => model.emit(state.copyWith(currentState: ViewState.success)),
      );
    });
  }

  Future<void> loginOnTap() async {
    if (state.signInForm.failureOption.isNone()) {
      await launch(state.ref, (model) async {
        _state.value =
            model.emit(state.copyWith(currentState: ViewState.loading));
        final result = await _authRepo
            .signInWithEmailPhoneAndPassword(state.signInForm.toDto());

        _state.value = result.fold(
          (left) => model
              .emit(state.copyWith(currentState: ViewState.error, error: left)),
          (right) =>
              model.emit(state.copyWith(currentState: ViewState.success)),
        );
      });
      return;
    }

    _state.value = state.copyWith(showFormErrors: true);
  }
}
