import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/purchases/purchases_home_ui_state.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockListingRepository = MockCarListingRepo();
  group('Purchases home view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<PurchasesHomeUiState> listener;

    setUpAll(() => registerFallbackValue(const PurchasesHomeUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [carListingProvider.overrideWithValue(mockListingRepository)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('fetch purchases success test', () async {
      when(() => mockListingRepository.fetchPurchasedCarListings()).thenAnswer((_) => Future.value(const Right([])));

      container.listen(purchasesHomeStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(purchasesHomeStateNotifierProvider);

      await container.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success)
                    .having((p0) => p0.purchasedListings.isEmpty, 'ensure the list is empty', true))),
      ]);

      expect(container.read(purchasesHomeStateNotifierProvider).currentState, ViewState.success);
    });

    test('fetch purchases error test', () async {
      when(() => mockListingRepository.fetchPurchasedCarListings())
          .thenAnswer((_) => Future.value(const Left(AuthRequiredException())));

      container.listen(purchasesHomeStateNotifierProvider, listener, fireImmediately: true);
      final currState = container.read(purchasesHomeStateNotifierProvider);
      await container.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'ensure the error is auth required exception',
                        isA<AuthRequiredException>()))),
      ]);

      expect(container.read(purchasesHomeStateNotifierProvider).currentState, ViewState.error);
    });
  });
}
