import 'package:car_dealership/application/application.dart';
import 'sign_up_ui_state.dart';
import 'package:signals/signals_flutter.dart';

import '../../../domain/domain.dart';

final class SignUpViewModel extends DealershipViewModel {
  final AuthRepositoryInterface _authRepo;

  SignUpViewModel(this._authRepo);

  final _state = signal(SignUpUiState.initial());

  ReadonlySignal<SignUpUiState> get emitter => _state.toReadonlySignal();

  SignUpUiState get state => _state.toReadonlySignal().value;

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

  void firstNameOnChanged(String input) {
    _state.value = state.copyWith(
        signUpForm: state.signUpForm.copyWith(firstName: FirstName(input)));
  }

  void lastNameOnChanged(String input) {
    _state.value = state.copyWith(
        signUpForm: state.signUpForm.copyWith(lastName: LastName(input)));
  }

  void emailOnChanged(String input) {
    _state.value = state.copyWith(
        signUpForm: state.signUpForm.copyWith(emailAddress: Email(input)));
  }

  void phoneNumberOnChanged(String input) {
    _state.value = state.copyWith(
        signUpForm: state.signUpForm.copyWith(phone: Phone(input)));
  }

  void passwordOnChanged(String input) {
    _state.value = state.copyWith(
        signUpForm: state.signUpForm.copyWith(password: Password(input)));
  }

  Future<void> createAccountOnTap() async {
    if (state.signUpForm.failureOption.isNone()) {
      await launch(state.ref, (model) async {
        _state.value =
            model.emit(state.copyWith(currentState: ViewState.loading));
        final result = await _authRepo
            .signUpWithEmailPhoneAndPassword(state.signUpForm.toDto());

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

  @override
  void dispose() {
    var fn = effect(() => _state.value);
    fn();
  }
}
