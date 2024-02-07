import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';

typedef PreviousCurrentValueCallback<T> = void Function(T? previous, T current);

extension SignalListenableX<T> on ReadonlySignal<T> {
  @Deprecated(
      '[onSignalUpdate] is deprecated, favour [onWidgetSignalUpdate] where you have the listener in the build method and [onManualSignalUpdate] outside the build method, preferable the initState, also note you have to dispose the Effect manually when using [onManualSignalUpdate] to listen for signal updates')
  EffectCleanup onSignalUpdate(PreviousCurrentValueCallback<T> callback) {
    T? prev;
    return subscribe((value) {
      callback(prev, value);
      prev = value;
    });
  }

  void onWidgetSignalUpdate(
    BuildContext context,
    PreviousCurrentValueCallback<T> callback, {
    String? debugLabel,
  }) {
    return listen(context, () {
      callback(previousValue == initialValue ? null : previousValue, value);
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
