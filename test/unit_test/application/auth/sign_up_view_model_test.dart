import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/auth/sign_up/sign_up_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  group('Sign up view model test suite', () {
    late SignalListener<SignUpUiState> listener;
    late AuthRepositoryInterface mockAuthRepo;

    setUpAll(() => registerFallbackValue(SignUpUiState.initial()));

    setUp(() {
      setupTestLocator();
      mockAuthRepo = locator();
      listener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('Signing up with email and password', () async {
      when(() => mockAuthRepo.signUpWithEmailPhoneAndPassword(const SignUpDto(
              name: 'John Doe',
              phone: '09057931390',
              email: 'johnnydoe@gmail.com',
              password: 'SafePass')))
          .thenAnswer((_) => Future.value(const Right(UserDto(
              id: 'test-id',
              name: 'John Doe',
              email: 'johnnydoe@gmail.com',
              phone: '09057931390'))));

      final signUpVM = locator<SignUpViewModel>();
      expect(signUpVM.state.currentState, ViewState.idle);
      signUpVM.firstNameOnChanged('John');
      signUpVM.lastNameOnChanged('Doe');
      signUpVM.emailOnChanged('johnnydoe@gmail.com');

      signUpVM.createAccountOnTap();

      expect(signUpVM.state.showFormErrors, true);
      signUpVM.phoneNumberOnChanged('09057931390');
      signUpVM.passwordOnChanged('SafePass');

      expect(signUpVM.state.signUpForm.failureOption.isNone(), true);

      var emitter = signUpVM.emitter.onSignalUpdate(listener.call);
      final currState = signUpVM.state;

      await signUpVM.createAccountOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            currState.copyWith(currentState: ViewState.idle),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            currState.copyWith(currentState: ViewState.loading),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be success', ViewState.success)))
      ]);

      expect(signUpVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signUpVM.dispose();
    });

    testWidgets('Sign up failure test', (tester) async {
      when(() => mockAuthRepo.signUpWithEmailPhoneAndPassword(const SignUpDto(
              name: 'John Doe',
              phone: '09057931390',
              email: 'johnnydoe@gmail.com',
              password: 'SafePass')))
          .thenAnswer((_) =>
              Future.value(const Left(MessageException('Server Exception'))));

      final signUpVM = locator<SignUpViewModel>();
      expect(signUpVM.state.currentState, ViewState.idle);
      signUpVM.firstNameOnChanged('John');
      signUpVM.lastNameOnChanged('Doe');
      signUpVM.emailOnChanged('johnnydoe@gmail.com');

      signUpVM.createAccountOnTap();

      expect(signUpVM.state.showFormErrors, true);
      signUpVM.phoneNumberOnChanged('09057931390');
      signUpVM.passwordOnChanged('SafePass');

      expect(signUpVM.state.signUpForm.failureOption.isNone(), true);

      var emitter = signUpVM.emitter.onSignalUpdate(listener.call);
      final currState = signUpVM.state;

      await tester.pumpWidget(const UnitTestApp());
      await signUpVM.createAccountOnTap();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            currState.copyWith(currentState: ViewState.idle),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            currState.copyWith(currentState: ViewState.loading),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState,
                        'ViewState must be success', ViewState.error)
                    .having((p0) => p0.error, 'Checking if we have na error',
                        isA<DealershipException>())))
      ]);

      expect(signUpVM.state.currentState, ViewState.error);

      // dispose
      emitter();
      signUpVM.dispose();
    });

    test('Sign up with Google', () async {
      when(() => mockAuthRepo.signingWithGoogle()).thenAnswer((_) =>
          Future.value(const Right(UserDto(
              id: 'google-id',
              name: 'Google User',
              email: 'google@gmail.com',
              phone: '09088293181'))));

      final signUpVM = locator<SignUpViewModel>();
      expect(signUpVM.state.currentState, ViewState.idle);
      final currState = signUpVM.state;

      var emitter = signUpVM.emitter.onSignalUpdate(listener.call);
      await signUpVM.continueWithGoogleOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be success', ViewState.success))),
      ]);

      expect(signUpVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signUpVM.dispose();
    });

    test('Sign up with Facebook', () async {
      when(() => mockAuthRepo.signingWithFacebook()).thenAnswer((_) =>
          Future.value(const Right(UserDto(
              id: 'facebook-id',
              name: 'Facebook User',
              email: 'facebook@gmail.com',
              phone: '09088293181'))));

      final signUpVM = locator<SignUpViewModel>();
      expect(signUpVM.state.currentState, ViewState.idle);
      final currState = signUpVM.state;

      var emitter = signUpVM.emitter.onSignalUpdate(listener.call);
      await signUpVM.continueWithFacebookOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>().having((p0) => p0.currentState,
                    'ViewState must be success', ViewState.success))),
      ]);

      expect(signUpVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signUpVM.dispose();
    });
  });
}
