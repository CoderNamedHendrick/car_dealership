import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/auth/sign_up_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockAuthRepo = MockAuthRepo();
  group('Sign up view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<SignUpUiState> listener;
    setUpAll(() => registerFallbackValue(SignUpUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepo)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose()); // ensures no state is reused between tests

    test('Signing up with email and password', () async {
      when(() => mockAuthRepo.signUpWithEmailPhoneAndPassword(
          const SignUpDto(
              name: 'John Doe',
              phone: '09057931390',
              email: 'johnnydoe@gmail.com',
              password: 'SafePass'))).thenAnswer((_) => Future.value(
          const Right(UserDto(id: 'test-id', name: 'John Doe', email: 'johnnydoe@gmail.com', phone: '09057931390'))));

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.idle);
      container.read(signUpStateNotifierProvider.notifier).firstNameOnChanged('John');
      container.read(signUpStateNotifierProvider.notifier).lastNameOnChanged('Doe');
      container.read(signUpStateNotifierProvider.notifier).emailOnChanged('johnnydoe@gmail.com');

      container.read(signUpStateNotifierProvider.notifier).createAccountOnTap();

      expect(container.read(signUpStateNotifierProvider).showFormErrors, true);
      container.read(signUpStateNotifierProvider.notifier).phoneNumberOnChanged('09057931390');
      container.read(signUpStateNotifierProvider.notifier).passwordOnChanged('SafePass');

      expect(container.read(signUpStateNotifierProvider).signUpForm.failureOption.isNone(), true);

      container.listen(signUpStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(signUpStateNotifierProvider);

      await container.read(signUpStateNotifierProvider.notifier).createAccountOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            currState.copyWith(currentState: ViewState.idle),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            currState.copyWith(currentState: ViewState.loading),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.success)))
      ]);

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.success);
    });

    testWidgets('Sign up failure test', (tester) async {
      when(() => mockAuthRepo.signUpWithEmailPhoneAndPassword(const SignUpDto(
          name: 'John Doe',
          phone: '09057931390',
          email: 'johnnydoe@gmail.com',
          password: 'SafePass'))).thenAnswer((_) => Future.value(const Left(MessageException('Server Exception'))));

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.idle);
      container.read(signUpStateNotifierProvider.notifier).firstNameOnChanged('John');
      container.read(signUpStateNotifierProvider.notifier).lastNameOnChanged('Doe');
      container.read(signUpStateNotifierProvider.notifier).emailOnChanged('johnnydoe@gmail.com');

      container.read(signUpStateNotifierProvider.notifier).createAccountOnTap();

      expect(container.read(signUpStateNotifierProvider).showFormErrors, true);
      container.read(signUpStateNotifierProvider.notifier).phoneNumberOnChanged('09057931390');
      container.read(signUpStateNotifierProvider.notifier).passwordOnChanged('SafePass');

      expect(container.read(signUpStateNotifierProvider).signUpForm.failureOption.isNone(), true);

      container.listen(signUpStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(signUpStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(signInStateNotifierProvider.notifier).loginOnTap();
      await tester.pumpAndSettle();

      await container.read(signUpStateNotifierProvider.notifier).createAccountOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            currState.copyWith(currentState: ViewState.idle),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            currState.copyWith(currentState: ViewState.loading),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.error)
                    .having((p0) => p0.error, 'Checking if we have na error', isA<DealershipException>())))
      ]);

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.error);
    });

    test('Sign up with Google', () async {
      when(() => mockAuthRepo.signingWithGoogle()).thenAnswer((_) => Future.value(
          const Right(UserDto(id: 'google-id', name: 'Google User', email: 'google@gmail.com', phone: '09088293181'))));

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.idle);
      final currState = container.read(signUpStateNotifierProvider);

      container.listen(signUpStateNotifierProvider, listener.call, fireImmediately: true);
      await container.read(signUpStateNotifierProvider.notifier).continueWithGoogleOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.success))),
      ]);

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.success);
    });

    test('Sign up with Facebook', () async {
      when(() => mockAuthRepo.signingWithFacebook()).thenAnswer((_) => Future.value(const Right(
          UserDto(id: 'facebook-id', name: 'Facebook User', email: 'facebook@gmail.com', phone: '09088293181'))));

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.idle);
      final currState = container.read(signUpStateNotifierProvider);

      container.listen(signUpStateNotifierProvider, listener.call, fireImmediately: true);
      await container.read(signUpStateNotifierProvider.notifier).continueWithFacebookOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be loading', ViewState.loading))),
        () => listener(
            any(that: isA<SignUpUiState>()),
            any(
                that: isA<SignUpUiState>()
                    .having((p0) => p0.currentState, 'ViewState must be success', ViewState.success))),
      ]);

      expect(container.read(signUpStateNotifierProvider).currentState, ViewState.success);
    });
  });
}
