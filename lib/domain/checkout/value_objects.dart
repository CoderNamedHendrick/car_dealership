import 'package:car_dealership/domain/checkout/validators.dart';
import 'package:car_dealership/domain/core/value_failure.dart';
import 'package:either_dart/either.dart';

import '../core/value_object.dart';

final class CardNumber extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CardNumber(String input) => CardNumber._(cardNumberValidator(input));

  const CardNumber._(this.value);
}

final class CardExpiry extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CardExpiry(String input) => CardExpiry._(cardExpiryValidator(input));

  const CardExpiry._(this.value);
}

final class CVV extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory CVV(String input) => CVV._(cvvValidator(input));

  const CVV._(this.value);
}
