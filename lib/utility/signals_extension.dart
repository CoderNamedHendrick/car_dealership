import 'package:signals/src/signals.dart';

extension SignalListenableX<T> on ReadonlySignal<T> {
  EffectCleanup onSignalUpdate(void Function(T? previous, T next) fn) {
    T? prev;
    return subscribe((value) {
      fn(prev, value);
      prev = value;
    });
  }

  ReadonlySignal<E> select<E>(E Function(T value) selector) {
    return computed(() => selector(value));
  }
}
