import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/application/checkout/checkout_ui_state.dart';
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
      id: 'john-doe-id',
      name: 'John Doe',
      email: 'johnnydoe@gmail.com',
      phone: '0901089032');
  const listing = CarListingDto.empty();

  group('Checkout view model test suite', () {
    late SignalListener<CheckoutUiState> listener;
    late CarListingInterface mockCarListingRepo;

    setUpAll(() => registerFallbackValue(CheckoutUiState.initial()));

    setUp(() {
      setupTestLocator();
      mockCarListingRepo = locator();
      listener = SignalListener();
    });

    tearDown(() async => await GetIt.I.reset());

    test('Checkout success test', () async {
      when(() => mockCarListingRepo.purchaseListing('test-car-id'))
          .thenAnswer((_) => Future.value(const Right('success')));

      final checkoutVM = locator<CheckoutViewModel>();

      final config = CheckoutConfigDto(
          user: user, carListing: listing.copyWith(id: 'test-car-id'));

      expect(checkoutVM.state.currentState, ViewState.idle);
      checkoutVM.initialiseConfig(config);

      expect(checkoutVM.state.config, config);

      checkoutVM.cardNumberOnChanged('0000000000000000');
      await checkoutVM.payOnTap();

      expect(checkoutVM.state.showFormErrors, true);
      expect(checkoutVM.state.checkoutForm.failureOption.isSome(), true);

      checkoutVM.cvvOnChanged('111');
      checkoutVM.cardExpiryOnChanged('11/21');

      expect(checkoutVM.state.checkoutForm.failureOption.isNone(), true);

      var emitter = checkoutVM.emitter.onSignalUpdate(listener.call);
      final currState = checkoutVM.state;

      await checkoutVM.payOnTap();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>().having((p0) => p0.currentState,
                    'current state is success', ViewState.success))),
      ]);

      expect(checkoutVM.state.currentState, ViewState.success);

      // dispose
      emitter();
      checkoutVM.dispose();
    });

    testWidgets('Checkout failure test', (tester) async {
      when(() => mockCarListingRepo.purchaseListing('test-car-id')).thenAnswer(
          (invocation) => Future.value(const Left(MessageException('Error'))));

      final checkoutVM = locator<CheckoutViewModel>();

      final config = CheckoutConfigDto(
          user: user, carListing: listing.copyWith(id: 'test-car-id'));

      expect(checkoutVM.state.currentState, ViewState.idle);
      checkoutVM.initialiseConfig(config);

      expect(checkoutVM.state.config, config);

      checkoutVM.cardNumberOnChanged('0000000000000000');
      checkoutVM.cvvOnChanged('111');
      checkoutVM.cardExpiryOnChanged('11/21');

      expect(checkoutVM.state.checkoutForm.failureOption.isNone(), true);

      var emitter = checkoutVM.emitter.onSignalUpdate(listener.call);
      final currState = checkoutVM.state;

      await tester.pumpWidget(const UnitTestApp());
      await checkoutVM.payOnTap();
      await tester.pumpAndSettle();

      verifyInOrder([
        () => listener(null, currState.copyWith(currentState: ViewState.idle)),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>().having((p0) => p0.currentState,
                    'current state is loading', ViewState.loading))),
        () => listener(
            any(that: isA<CheckoutUiState>()),
            any(
                that: isA<CheckoutUiState>()
                    .having((p0) => p0.currentState, 'current state is error',
                        ViewState.error)
                    .having(
                        (p0) => p0.error,
                        'Checking if we have an instance of message exception',
                        isA<MessageException>()))),
      ]);

      expect(checkoutVM.state.currentState, ViewState.error);

      // dispose
      emitter();
      checkoutVM.dispose();
    });
  });
}
