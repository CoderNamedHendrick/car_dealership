import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';

typedef PreviousCurrentValueCallback<T> = void Function(T? previous, T current);

extension SignalListenableX<T> on ReadonlySignal<T> {
  void onSignalUpdate(
    BuildContext context,
    PreviousCurrentValueCallback<T> callback, {
    String? debugLabel,
  }) {
    T? prev;
    fn() => value;

    return listen(context, () {
      callback(prev, value);
      prev = untracked(fn);
    }, debugLabel: debugLabel);
  }

  EffectCleanup onManualSignalUpdate(
    void Function(T? previous, T next) callback, {
    String? debugLabel,
  }) {
    T? prev;
    fn() => value;

    return effect(() {
      // keep feature parity where on initialisation, previous value is false
      // when next value is the initial value.
      // also responsible for listening to the signal updates
      callback(prev, value);
      prev = untracked(fn);
    }, debugLabel: debugLabel);
  }

  ReadonlySignal<E> select<E>(E Function(T value) selector) {
    return computed(() => selector(value));
  }
}
