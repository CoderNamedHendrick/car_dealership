import 'package:signals/src/signals.dart';

extension SignalListenableX<T> on ReadonlySignal<T> {
  EffectCleanup onSignalUpdate(void Function(T? prev, T current) fn) {
    T? prev;
    return subscribe((value) {
      fn(prev, value);
      prev = value;
    });
  }
}

