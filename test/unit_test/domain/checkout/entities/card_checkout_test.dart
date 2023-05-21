import 'package:car_dealership/domain/checkout/checkout_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Card checkout domain entity tests', () {
    late CardCheckout checkout;

    setUpAll(() => checkout = CardCheckout.empty());

    test('Initialising and assigning of values', () {
      expect(checkout.failureOption.isSome(), true);

      checkout = checkout.copyWith(
        cardNumber: CardNumber('0000000000000000'),
        cardExpiry: CardExpiry('10/09'),
        cvv: CVV('121'),
      );
    });

    test('Checking the values in the entity', () {
      expect(checkout.failureOption.isNone(), true);

      expect(checkout.cardNumber.getOrCrash(), '0000000000000000');
      expect(checkout.cardExpiry.getOrCrash(), '10/09');
      expect(checkout.cvv.getOrCrash(), '121');
    });
  });
}
