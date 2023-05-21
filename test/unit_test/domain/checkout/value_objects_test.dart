import 'package:car_dealership/domain/checkout/checkout_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Checkout value object test suite', () {
    test('Card Number Value Object test', () {
      CardNumber cardNumber = CardNumber('');

      expect(cardNumber.failureOrNone.isSome(), true);
      expect(cardNumber.failureOrNone.fold(() => null, (value) => value.message), 'Card number cannot be empty');

      cardNumber = CardNumber('0000 0000, 0000');

      expect(cardNumber.failureOrNone.isSome(), true);
      expect(cardNumber.failureOrNone.fold(() => null, (value) => value.message), 'Please enter a valid card number');

      cardNumber = CardNumber('0000 0000 0000 0000');
      expect(cardNumber.failureOrNone.isNone(), true);
      expect(cardNumber.getOrCrash(), '0000000000000000');
    });

    test('Card Expiry Value Object test', () {
      CardExpiry cardExpiry = CardExpiry('');

      expect(cardExpiry.failureOrNone.isSome(), true);
      expect(cardExpiry.failureOrNone.fold(() => null, (value) => value.message), 'Card expiry cannot be empty');

      cardExpiry = CardExpiry('14/20');

      expect(cardExpiry.failureOrNone.isSome(), true);
      expect(
          cardExpiry.failureOrNone.fold(() => null, (value) => value.message), 'Please enter valid card expiry date');

      cardExpiry = CardExpiry('08/21');

      expect(cardExpiry.failureOrNone.isNone(), true);
      expect(cardExpiry.getOrCrash(), '08/21');
    });

    test('CVV Value Object test', () {
      CVV cvv = CVV('');

      expect(cvv.failureOrNone.isSome(), true);
      expect(cvv.failureOrNone.fold(() => null, (value) => value.message), 'CVV cannot be empty');

      cvv = CVV('12');

      expect(cvv.failureOrNone.isSome(), true);
      expect(cvv.failureOrNone.fold(() => null, (value) => value.message), 'Please enter valid cvv');

      cvv = CVV('hne');

      expect(cvv.failureOrNone.isSome(), true);
      expect(cvv.failureOrNone.fold(() => null, (value) => value.message), 'Please enter valid cvv');

      cvv = CVV('1234');

      expect(cvv.failureOrNone.isSome(), true);
      expect(cvv.failureOrNone.fold(() => null, (value) => value.message), 'Please enter valid cvv');

      cvv = CVV('212');

      expect(cvv.failureOrNone.isNone(), true);
      expect(cvv.getOrCrash(), '212');
    });
  });
}
