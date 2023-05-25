import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/profile/profile_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockAuthRepository = MockAuthRepo();
  final mockListingRepository = MockCarListingRepo();
  const user = UserDto(id: 'test-user-id', name: 'Test User', email: 'testdoe@gmail.com', phone: '09078027404');

  group('Profile view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<ProfileUiState> listener;

    setUpAll(() => registerFallbackValue(const ProfileUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        carListingProvider.overrideWithValue(mockListingRepository),
      ]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('fetch user success test', () async {
      when(() => mockAuthRepository.fetchUser()).thenAnswer((_) => Future.value(const Right(user)));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await container.read(profileStateNotifierProvider.notifier).fetchUser();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success)
                    .having((p0) => p0.user, 'checking if the current user is returned', user)))
      ]);
    });

    test('fetch user failure test', () async {
      when(() => mockAuthRepository.fetchUser()).thenAnswer((_) => Future.value(const Left(AuthRequiredException())));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await container.read(profileStateNotifierProvider.notifier).fetchUser();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'checking the error in the view model', isA<AuthRequiredException>())))
      ]);
    });

    test('logout user success test', () async {
      when(() => mockAuthRepository.logout()).thenAnswer((_) => Future.value(const Right('success')));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await container.read(profileStateNotifierProvider.notifier).logout();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is idle, since it clear the vm', ViewState.idle)))
      ]);
    });

    testWidgets('logout user failure test', (tester) async {
      when(() => mockAuthRepository.logout()).thenAnswer((_) => Future.value(const Left(MessageException('error'))));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(profileStateNotifierProvider.notifier).logout();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'checking the error', isA<MessageException>())))
      ]);
    });

    test('fetch wishlist success test', () async {
      when(() => mockListingRepository.fetchSavedCarListings())
          .thenAnswer((_) => Future.value(const Right([CarListingDto.empty()])));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await container.read(profileStateNotifierProvider.notifier).fetchWishlist();

      verifyInOrder([
        () => listener(null,
            currState.copyWith(wishlistUiState: currState.wishlistUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.wishlistUiState.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.wishlistUiState.currentState, 'current state is success', ViewState.success)
                    .having(
                        (p0) => p0.wishlistUiState.savedCars.length, 'Ensuring there\'s one car listing returned', 1)))
      ]);
    });

    testWidgets('fetch wishlist failure test', (tester) async {
      when(() => mockListingRepository.fetchSavedCarListings())
          .thenAnswer((_) => Future.value(const Left(MessageException('unable to fetch wishlist'))));

      container.listen(profileStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(profileStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(profileStateNotifierProvider.notifier).fetchWishlist();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null,
            currState.copyWith(wishlistUiState: currState.wishlistUiState.copyWith(currentState: ViewState.idle))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.wishlistUiState.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.wishlistUiState.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.wishlistUiState.error, 'checking the error returned', isA<MessageException>())))
      ]);
    });
  });
}
