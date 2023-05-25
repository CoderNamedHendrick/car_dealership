// coverage:ignore-file
class ValueFailure<T> {
  final T _value;
  final String _message;

  const ValueFailure(T value, String message)
      : _value = value,
        _message = message;

  T get value => _value;

  String get message => _message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ValueFailure<T> && other.value == value && other.message == message;

  @override
  int get hashCode => _value.hashCode ^ _message.hashCode;

  @override
  String toString() => 'ValueFailure(value: $_value, message: $_message)';
}
