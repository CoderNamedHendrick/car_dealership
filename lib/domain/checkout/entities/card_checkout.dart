import 'package:car_dealership/utility/option.dart';
import 'package:equatable/equatable.dart';

import '../../core/value_failure.dart';
import '../value_objects.dart';

final class CardCheckout extends Equatable {
  final CardNumber cardNumber;
  final CardExpiry cardExpiry;
  final CVV cvv;

  const CardCheckout({required this.cardNumber, required this.cardExpiry, required this.cvv});

  factory CardCheckout.empty() => CardCheckout(cardNumber: CardNumber(''), cardExpiry: CardExpiry(''), cvv: CVV(''));

  CardCheckout copyWith({CardNumber? cardNumber, CardExpiry? cardExpiry, CVV? cvv}) {
    return CardCheckout(
      cardNumber: cardNumber ?? this.cardNumber,
      cardExpiry: cardExpiry ?? this.cardExpiry,
      cvv: cvv ?? this.cvv,
    );
  }

  Option<ValueFailure<dynamic>> get failureOption => cardNumber.failureOrNone.fold(
        () => cardExpiry.failureOrNone.fold(
          () => cvv.failureOrNone.fold(
            () => const None(),
            (value) => Some(value),
          ),
          (value) => Some(value),
        ),
        (value) => Some(value),
      );

  @override
  List<Object?> get props => [cardNumber, cardExpiry, cvv];
}
