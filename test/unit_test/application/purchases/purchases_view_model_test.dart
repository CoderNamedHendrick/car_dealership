import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/purchases/purchases_home_ui_state.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  group('Purchases home view model test suite', () {
    late SignalListener<PurchasesHomeUiState> listener;
    late CarListingInterface mockListingRepository;

    setUpAll(() => registerFallbackValue(const PurchasesHomeUiState.initial()));

    setUp(() {
      setupTestLocator();
      mockListingRepository = locator();
      listener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('fetch purchases success test', () async {
      when(() => mockListingRepository.fetchPurchasedCarListings())
          .thenAnswer((_) => Future.value(const Right([])));

      final purchasesVM = locator<PurchasesHomeViewModel>();
      var emitter = purchasesVM.emitter.onSignalUpdate(listener.call);
      final currState = purchasesVM.state;

      await purchasesVM.fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>().having(
                    (p0) => p0.currentState,
                    'current state is loading',
                    ViewState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is success',
                        ViewState.success)
                    .having((p0) => p0.purchasedListings.isEmpty,
                        'ensure the list is empty', true))),
      ]);

      expect(purchasesVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      purchasesVM.dispose();
    });

    test('fetch purchases error test', () async {
      when(() => mockListingRepository.fetchPurchasedCarListings())
          .thenAnswer((_) => Future.value(const Left(AuthRequiredException())));

      final purchasesVM = locator<PurchasesHomeViewModel>();
      var emitter = purchasesVM.emitter.onSignalUpdate(listener.call);
      final currState = purchasesVM.state;
      await purchasesVM.fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>().having(
                    (p0) => p0.currentState,
                    'current state is loading',
                    ViewState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having(
                        (p0) => p0.error,
                        'ensure the error is auth required exception',
                        isA<AuthRequiredException>()))),
      ]);

      expect(purchasesVM.state.currentState, ViewState.error);

      // dispose
      emitter();
      purchasesVM.dispose();
    });
  });
}
