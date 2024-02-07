import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/profile/profile_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  const user = UserDto(
      id: 'test-user-id',
      name: 'Test User',
      email: 'testdoe@gmail.com',
      phone: '09078027404');

  group('Profile view model test suite', () {
    late SignalListener<ProfileUiState> profileListener;
    late SignalListener<WishlistUiState> wishlistListener;
    late AuthRepositoryInterface mockAuthRepository;
    late CarListingInterface mockListingRepository;

    setUpAll(() {
      registerFallbackValue(const ProfileUiState.initial());
      registerFallbackValue(const WishlistUiState.initial());
    });

    setUp(() {
      setupTestLocator();
      mockAuthRepository = locator();
      mockListingRepository = locator();
      profileListener = SignalListener();
      wishlistListener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('fetch user success test', () async {
      when(() => mockAuthRepository.fetchUser())
          .thenAnswer((_) => Future.value(const Right(user)));
      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.profileEmitter.onManualSignalUpdate(profileListener.call);
      final currState = profileVM.profileState;

      await profileVM.fetchUser();

      verifyInOrder([
        () => profileListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is success',
                        ViewState.success)
                    .having((p0) => p0.user,
                        'checking if the current user is returned', user)))
      ]);

      // dispose
      emitter();
    });

    test('fetch user failure test', () async {
      when(() => mockAuthRepository.fetchUser())
          .thenAnswer((_) => Future.value(const Left(AuthRequiredException())));
      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.profileEmitter.onManualSignalUpdate(profileListener.call);
      final currState = profileVM.profileState;

      await profileVM.fetchUser();

      verifyInOrder([
        () => profileListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having(
                        (p0) => p0.error,
                        'checking the error in the view model',
                        isA<AuthRequiredException>())))
      ]);

      // dispose
      emitter();
    });

    test('logout user success test', () async {
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) => Future.value(const Right('success')));
      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.profileEmitter.onManualSignalUpdate(profileListener.call);
      final currState = profileVM.profileState;

      await profileVM.logout();

      verifyInOrder([
        () => profileListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>().having(
                    (p0) => p0.currentState,
                    'current state is idle, since it clear the vm',
                    ViewState.idle)))
      ]);

      // dispose
      emitter();
    });

    testWidgets('logout user failure test', (tester) async {
      when(() => mockAuthRepository.logout()).thenAnswer(
          (_) => Future.value(const Left(MessageException('error'))));
      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.profileEmitter.onManualSignalUpdate(profileListener.call);
      final currState = profileVM.profileState;

      await tester.pumpWidget(const UnitTestApp());
      await profileVM.logout();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => profileListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => profileListener(
            any(that: isA<ProfileUiState>()),
            any(
                that: isA<ProfileUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having((p0) => p0.error, 'checking the error',
                        isA<MessageException>())))
      ]);

      // dispose
      emitter();
    });

    test('fetch wishlist success test', () async {
      when(() => mockListingRepository.fetchSavedCarListings()).thenAnswer(
          (_) => Future.value(const Right([CarListingDto.empty()])));
      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.wishlistEmitter.onManualSignalUpdate(wishlistListener.call);
      final currState = profileVM.wishlistState;

      await profileVM.fetchWishlist();

      verifyInOrder([
        () => wishlistListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => wishlistListener(
            any(that: isA<WishlistUiState>()),
            any(
                that: isA<WishlistUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => wishlistListener(
            any(that: isA<WishlistUiState>()),
            any(
                that: isA<WishlistUiState>()
                    .having((p0) => p0.currentState, 'current state is success',
                        ViewState.success)
                    .having((p0) => p0.savedCars.length,
                        'Ensuring there\'s one car listing returned', 1)))
      ]);

      // dispose
      emitter();
    });

    testWidgets('fetch wishlist failure test', (tester) async {
      when(() => mockListingRepository.fetchSavedCarListings()).thenAnswer(
          (_) => Future.value(
              const Left(MessageException('unable to fetch wishlist'))));

      final profileVM = locator<ProfileViewModel>();

      var emitter =
          profileVM.wishlistEmitter.onManualSignalUpdate(wishlistListener.call);
      final currState = profileVM.wishlistState;

      await tester.pumpWidget(const UnitTestApp());
      await profileVM.fetchWishlist();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => wishlistListener(
            null, currState.copyWith(currentState: ViewState.idle)),
        () => wishlistListener(
            any(that: isA<WishlistUiState>()),
            any(
                that: isA<WishlistUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => wishlistListener(
            any(that: isA<WishlistUiState>()),
            any(
                that: isA<WishlistUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having((p0) => p0.error, 'checking the error returned',
                        isA<MessageException>())))
      ]);

      // dispose
      emitter();
    });
  });
}
