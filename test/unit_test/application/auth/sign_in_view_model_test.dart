import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/auth/sign_in/sign_in_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  group('Sign in view model test suite', () {
    late SignalListener<SignInUiState> listener;
    late AuthRepositoryInterface mockAuthRepo;

    setUpAll(() => registerFallbackValue(SignInUiState.initial()));

    setUp(() {
      setupTestLocator();
      mockAuthRepo = locator();
      listener = SignalListener();
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    test('Sign in with email and password', () async {
      when(() => mockAuthRepo.signInWithEmailPhoneAndPassword(const SignInDto(
              emailOrPhone: 'johnnydoe@gmail.com', password: 'SafePass')))
          .thenAnswer((_) => Future.value(const Right(UserDto(
              id: 'john-doe-id',
              name: 'John Doe',
              email: 'johnnydoe@gmail.com',
              phone: '09057931390'))));

      final signInVM = locator<SignInViewModel>();
      expect(signInVM.state.currentState, ViewState.idle);
      signInVM.emailOrPhoneOnChanged('johnnydoe@gmail.com');

      signInVM.loginOnTap();
      expect(signInVM.state.showFormErrors, true);

      signInVM.passwordOnChanged('SafePass');

      expect(signInVM.state.signInForm.failureOption.isNone(), true);

      var emitter = signInVM.emitter.onSignalUpdate(listener.call);

      final currState = signInVM.state;
      await signInVM.loginOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'current state is success', ViewState.success))),
      ]);

      expect(signInVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signInVM.dispose();
    });

    testWidgets('Sign in with non-existing user test', (tester) async {
      when(() => mockAuthRepo.signInWithEmailPhoneAndPassword(
          const SignInDto(
              emailOrPhone: 'johnnydoe@gmail.com',
              password: 'SafePass'))).thenAnswer(
          (invocation) => Future.value(const Left(AuthRequiredException())));

      final signInVM = locator<SignInViewModel>();

      expect(signInVM.state.currentState, ViewState.idle);
      signInVM.emailOrPhoneOnChanged('johnnydoe@gmail.com');
      signInVM.passwordOnChanged('SafePass');

      expect(signInVM.state.signInForm.failureOption.isNone(), true);

      var emitter = signInVM.emitter.onSignalUpdate(listener.call);
      final currState = signInVM.state;

      await tester.pumpWidget(const UnitTestApp());
      await signInVM.loginOnTap();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having(
                        (p0) => p0.error,
                        'Checking if we have an auth error',
                        isA<AuthRequiredException>()))),
      ]);

      expect(signInVM.state.currentState, ViewState.error);

      // dispose
      emitter();
      signInVM.dispose();
    });

    test('Sign in with Google', () async {
      when(() => mockAuthRepo.signingWithGoogle()).thenAnswer((_) =>
          Future.value(const Right(UserDto(
              id: 'google-id',
              name: 'Google User',
              email: 'google@gmail.com',
              phone: '09088293181'))));

      final signInVM = locator<SignInViewModel>();

      expect(signInVM.state.currentState, ViewState.idle);
      final currState = signInVM.state;

      var emitter = signInVM.emitter.onSignalUpdate(listener.call);
      await signInVM.continueWithGoogleOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'ViewState must be success', ViewState.success))),
      ]);

      expect(signInVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signInVM.dispose();
    });

    test('Sign in with Facebook', () async {
      when(() => mockAuthRepo.signingWithFacebook()).thenAnswer((_) =>
          Future.value(const Right(UserDto(
              id: 'facebook-id',
              name: 'Facebook User',
              email: 'facebook@gmail.com',
              phone: '09088293181'))));

      final signInVM = locator<SignInViewModel>();

      expect(signInVM.state.currentState, ViewState.idle);
      final currState = signInVM.state;

      var emitter = signInVM.emitter.onSignalUpdate(listener.call);
      await signInVM.continueWithFacebookOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>().having((p0) => p0.currentState,
                    'ViewState must be success', ViewState.success))),
      ]);

      expect(signInVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      signInVM.dispose();
    });
  });
}
