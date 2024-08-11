import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/auth/sign_in_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockAuthRepo = MockAuthRepo();
  group('Sign in view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<SignInUiState> listener;
    setUpAll(() => registerFallbackValue(SignInUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepo)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('Sign in with email and password', () async {
      when(() => mockAuthRepo.signInWithEmailPhoneAndPassword(
              const SignInDto(emailOrPhone: 'johnnydoe@gmail.com', password: 'SafePass')))
          .thenAnswer((_) => Future.value(const Right(
              UserDto(id: 'john-doe-id', name: 'John Doe', email: 'johnnydoe@gmail.com', phone: '09057931390'))));

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.idle);
      container.read(signInStateNotifierProvider.notifier).emailOrPhoneOnChanged('johnnydoe@gmail.com');
      container.read(signInStateNotifierProvider.notifier).loginOnTap();
      expect(container.read(signInStateNotifierProvider).showFormErrors, true);

      container.read(signInStateNotifierProvider.notifier).passwordOnChanged('SafePass');

      expect(container.read(signInStateNotifierProvider).signInForm.failureOption.isNone(), true);

      container.listen(signInStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(signInStateNotifierProvider);

      await container.read(signInStateNotifierProvider.notifier).loginOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success))),
      ]);

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.success);
    });

    testWidgets('Sign in with non-existing user test', (tester) async {
      when(() => mockAuthRepo.signInWithEmailPhoneAndPassword(
              const SignInDto(emailOrPhone: 'johnnydoe@gmail.com', password: 'SafePass')))
          .thenAnswer((invocation) => Future.value(const Left(AuthRequiredException())));

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.idle);
      container.read(signInStateNotifierProvider.notifier).emailOrPhoneOnChanged('johnnydoe@gmail.com');
      container.read(signInStateNotifierProvider.notifier).passwordOnChanged('SafePass');

      expect(container.read(signInStateNotifierProvider).signInForm.failureOption.isNone(), true);

      container.listen(signInStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(signInStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(signInStateNotifierProvider.notifier).loginOnTap();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'Checking if we have an auth error', isA<AuthRequiredException>()))),
      ]);

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.error);
    });

    test('Sign in with Google', () async {
      when(() => mockAuthRepo.signingWithGoogle()).thenAnswer((_) => Future.value(
          const Right(UserDto(id: 'google-id', name: 'Google User', email: 'google@gmail.com', phone: '09088293181'))));

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.idle);
      final currState = container.read(signInStateNotifierProvider);

      container.listen(signInStateNotifierProvider, listener.call, fireImmediately: true);
      await container.read(signInStateNotifierProvider.notifier).continueWithGoogleOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.success))),
      ]);

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.success);
    });

    test('Sign in with Facebook', () async {
      when(() => mockAuthRepo.signingWithFacebook()).thenAnswer((_) => Future.value(const Right(
          UserDto(id: 'facebook-id', name: 'Facebook User', email: 'facebook@gmail.com', phone: '09088293181'))));

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.idle);
      final currState = container.read(signInStateNotifierProvider);

      container.listen(signInStateNotifierProvider, listener.call, fireImmediately: true);
      await container.read(signInStateNotifierProvider.notifier).continueWithFacebookOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignInUiState>()),
            any(
                that: isA<SignInUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.success))),
      ]);

      expect(container.read(signInStateNotifierProvider).currentState, ViewState.success);
    });
  });
}
