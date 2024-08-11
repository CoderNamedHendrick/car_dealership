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

      container.listen(purchasesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(purchasesHomeStateNotifierProvider);

      await container.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(uiState: UiState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.uiState, 'current state is loading', UiState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.uiState, 'current state is success', UiState.success)
                    .having((p0) => p0.purchasedListings.isEmpty, 'ensure the list is empty', true))),
      ]);

      expect(container.read(purchasesHomeStateNotifierProvider).uiState, UiState.success);
    });

    test('fetch purchases error test', () async {
      when(() => mockListingRepository.fetchPurchasedCarListings())
          .thenAnswer((_) => Future.value(const Left(AuthRequiredException())));

      container.listen(purchasesHomeStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(purchasesHomeStateNotifierProvider);
      await container.read(purchasesHomeStateNotifierProvider.notifier).fetchPurchases();

      verifyInOrder([
        () => listener(null, currState.copyWith(uiState: UiState.idle)),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.uiState, 'current state is loading', UiState.loading))),
        () => listener(
            any(that: isA<PurchasesHomeUiState>()),
            any(
                that: isA<PurchasesHomeUiState>()
                    .having((p0) => p0.uiState, 'current state is error', UiState.error)
                    .having((p0) => p0.error, 'ensure the error is auth required exception',
                        isA<AuthRequiredException>()))),
      ]);

      expect(container.read(purchasesHomeStateNotifierProvider).uiState, UiState.error);
    });
  });
}
