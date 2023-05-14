import 'package:either_dart/either.dart';
import '../../utility/option.dart';
import 'dealership_exception.dart';
import 'value_failure.dart';

abstract class ValueObject<T> {
  const ValueObject();

  Either<ValueFailure<T>, T> get value;

  bool get isValid => value.isRight;

  T getOrCrash() => value.fold((f) => throw MessageException('Encountered a ValueFailure :: $f'), (r) => r);

  Option<T> get optionValue => value.fold((_) => const None(), (value) => Some(value));

  Option<ValueFailure<T>> get failureOrNone => value.fold(
        (left) => Some(left),
        (right) => const None(),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject($value)';
}
