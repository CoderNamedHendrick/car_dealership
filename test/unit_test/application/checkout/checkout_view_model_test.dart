import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/checkout/checkout_ui_state.dart';
import 'package:car_dealership/domain/domain.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../common.dart';

void main() {
  final mockCarListingRepo = MockCarListingRepo();
  const user = UserDto(id: 'john-doe-id', name: 'John Doe', email: 'johnnydoe@gmail.com', phone: '0901089032');
  const listing = CarListingDto.empty();

  group('Checkout view model test suite', () {
    late ProviderContainer container;
    late RiverpodListener<CheckoutUiState> listener;

    setUpAll(() => registerFallbackValue(CheckoutUiState.initial()));

    setUp(() {
      container = ProviderContainer(overrides: [carListingProvider.overrideWithValue(mockCarListingRepo)]);
      listener = RiverpodListener();
    });

    tearDown(() => container.dispose());

    test('Checkout success test', () async {
      when(() => mockCarListingRepo.purchaseListing('test-car-id'))
          .thenAnswer((_) => Future.value(const Right('success')));

      final config = CheckoutConfigDto(user: user, carListing: listing.copyWith(id: 'test-car-id'));

      expect(container.read(checkoutStateNotifierProvider).currentState, ViewState.idle);
      container.read(checkoutStateNotifierProvider.notifier).initialiseConfig(config);

      expect(container.read(checkoutStateNotifierProvider).config, config);

      container.read(checkoutStateNotifierProvider.notifier).cardNumberOnChanged('0000000000000000');
      await container.read(checkoutStateNotifierProvider.notifier).payOnTap();

      expect(container.read(checkoutStateNotifierProvider).showFormErrors, true);
      expect(container.read(checkoutStateNotifierProvider).checkoutForm.failureOption.isSome(), true);

      container.read(checkoutStateNotifierProvider.notifier).cvvOnChanged('111');
      container.read(checkoutStateNotifierProvider.notifier).cardExpiryOnChanged('11/21');

      expect(container.read(checkoutStateNotifierProvider).checkoutForm.failureOption.isNone(), true);

      container.listen(checkoutStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(checkoutStateNotifierProvider);

      await container.read(checkoutStateNotifierProvider.notifier).payOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>()
                    .having((p0) => p0.currentState, 'current state is success', ViewState.success))),
      ]);

      expect(container.read(checkoutStateNotifierProvider).currentState, ViewState.success);
    });

    testWidgets('Checkout failure test', (tester) async {
      when(() => mockCarListingRepo.purchaseListing('test-car-id'))
          .thenAnswer((invocation) => Future.value(const Left(MessageException('Error'))));

      final config = CheckoutConfigDto(user: user, carListing: listing.copyWith(id: 'test-car-id'));

      expect(container.read(checkoutStateNotifierProvider).currentState, ViewState.idle);
      container.read(checkoutStateNotifierProvider.notifier).initialiseConfig(config);

      expect(container.read(checkoutStateNotifierProvider).config, config);

      container.read(checkoutStateNotifierProvider.notifier).cardNumberOnChanged('0000000000000000');
      container.read(checkoutStateNotifierProvider.notifier).cvvOnChanged('111');
      container.read(checkoutStateNotifierProvider.notifier).cardExpiryOnChanged('11/21');

      expect(container.read(checkoutStateNotifierProvider).checkoutForm.failureOption.isNone(), true);

      container.listen(checkoutStateNotifierProvider, listener.call, fireImmediately: true);
      final currState = container.read(checkoutStateNotifierProvider);

      await tester.pumpWidget(const UnitTestApp());
      await container.read(checkoutStateNotifierProvider.notifier).payOnTap();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>()
                    .having((p0) => p0.currentState, 'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>()
                    .having((p0) => p0.currentState, 'current state is error', ViewState.error)
                    .having((p0) => p0.error, 'Checking if we have an instance of message exception',
                        isA<MessageException>()))),
      ]);

      expect(container.read(checkoutStateNotifierProvider).currentState, ViewState.error);
    });
  });
}
