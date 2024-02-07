import 'package:flutter_test/flutter_test.dart';
import 'package:signals/signals.dart';

void main() {
  group('Signal update extensions test', () {
    test('Manual signal update extension test', () {
      final valueSignal = signal(5);
      final listener = _SignalListener<int>();

      int? prev;
      fn() => valueSignal.value;

      final cleanup = effect(() {
        listener.callSignalUpdate(prev, valueSignal.value);
        prev = untracked(fn);
        // print(valueSignal.value);
      });

      expect(listener.currentPrevious, null,
          reason: 'Previous value should be null');
      expect(listener.currentNext, 5, reason: 'Signal is just initialised');

      valueSignal.value = 10;

      expect(listener.currentPrevious, 5,
          reason: 'Previous value should be null');
      expect(listener.currentNext, 10, reason: 'Next value should be 10');

      valueSignal.value = 15;

      expect(listener.currentPrevious, 10,
          reason: 'Previous value should be 10');
      expect(listener.currentNext, 15, reason: 'Next value should be §5');

      expect(valueSignal.value, 15);

      cleanup();
    });
  });
}

class _SignalListener<T> {
  T? currentPrevious;
  T? currentNext;

  void callSignalUpdate(T? previous, T next) {
    currentPrevious = previous;
    currentNext = next;
  }
}
