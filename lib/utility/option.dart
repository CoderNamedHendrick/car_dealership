// coverage:ignore-file
abstract class Option<E> {
  const Option();

  bool get isDefined;

  bool get isEmpty => !isDefined;

  bool isNone() => isEmpty;

  bool isSome() => isDefined;

  E getOrElse(E defaultValue);

  Option<R> map<R>(R Function(E value) f);

  Option<R> flatMap<R>(Option<R> Function(E value) f);

  R fold<R>(R Function() onEmpty, R Function(E value) onDefined);

  static Option<E> fromNullable<E>(E? value) {
    if (value != null) return Some(value);

    return const None();
  }
}

class None<E> extends Option<E> {
  const None();

  @override
  bool get isDefined => false;

  @override
  E getOrElse(E defaultValue) => defaultValue;

  @override
  Option<R> map<R>(R Function(E value) f) => const None();

  @override
  Option<R> flatMap<R>(Option<R> Function(E value) f) => const None();

  @override
  R fold<R>(R Function() onEmpty, R Function(E value) onDefined) => onEmpty();
}

class Some<E> extends Option<E> {
  final E value;

  const Some(this.value);

  @override
  bool get isDefined => true;

  @override
  E getOrElse(E defaultValue) => value;

  @override
  Option<R> map<R>(R Function(E value) f) => Some(f(value));

  @override
  Option<R> flatMap<R>(Option<R> Function(E value) f) => f(value);

  @override
  R fold<R>(R Function() onEmpty, R Function(E value) onDefined) => onDefined(value);
}
