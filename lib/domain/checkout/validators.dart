import 'package:either_dart/either.dart';

import '../core/value_failure.dart';

Either<ValueFailure<String>, String> cardNumberValidator(String value) {
  String failure = '';

  final strippedValue = value.replaceAll(' ', '');
  if (!RegExp('^[0-9]{16}\$').hasMatch(strippedValue)) {
    failure = 'Please enter a valid card number';
  }

  if (strippedValue.isEmpty) {
    failure = 'Card number cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(strippedValue);
}

Either<ValueFailure<String>, String> cardExpiryValidator(String value) {
  String failure = '';

  // ensures format is {month}<12/{year}
  if (!RegExp('^(1[0-2]|0[1-9]|1[012])[/]([0-9]{2})\$').hasMatch(value)) {
    failure = 'Please enter valid card expiry date';
  }

  if (value.isEmpty) {
    failure = 'Card expiry cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}

Either<ValueFailure<String>, String> cvvValidator(String value) {
  String failure = '';

  if (!RegExp('^[0-9]{3}\$').hasMatch(value)) {
    failure = 'Please enter valid cvv';
  }

  if (value.isEmpty) {
    failure = 'CVV cannot be empty';
  }

  if (failure.isNotEmpty) return Left(ValueFailure(value, failure));
  return Right(value);
}
