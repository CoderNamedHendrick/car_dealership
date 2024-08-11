import 'dart:math';

import 'package:car_dealership/application/application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const _maxDelay = 500; // milliseconds

final _random = Random();

Future<void> randomDelay() async {
  await Future<void>.delayed(
      Duration(milliseconds: _random.nextInt(_maxDelay)));
}

void main() {
  group('Ui state mutex tests', () {
    const depositAmount = 10;
    int numOfIterations = 5;

    test('Failure test', () async {
      int balance = 0;

      Future<void> makeDeposit(int i, int deposit) async {
        await randomDelay();

        final oldBalance = balance;
        await randomDelay();

        balance = oldBalance + depositAmount;

        debugPrint('  [$i] added $depositAmount to $oldBalance -> $balance');
      }

      final operations = <Future>[];

      for (var i = 0; i < numOfIterations; i++) {
        operations.add(makeDeposit(i, depositAmount));
      }

      await Future.wait(operations);

      expect(balance == depositAmount * numOfIterations, false,
          reason: 'false because operations aren\'t atomic');
    });

    // final mutex = Mutex();
    test('Single type atomic test', () async {
      int balance = 0;
      final mutex = UiStateMutex();

      Future<void> makeDeposit(int i, int deposit) async {
        // Random delay before updating starts
        await randomDelay();

        Future<void> future() async {
          final oldBalance = balance;
          await randomDelay();

          balance = oldBalance + depositAmount;

          debugPrint('  [$i] added $depositAmount to $oldBalance -> $balance');
        }
        // Acquire the mutex before running the critical section of code

        debugPrint('write lock for $i');
        await mutex.protect(future);

        debugPrint('unlocking $i');
      }

      final operations = <Future>[];

      for (var i = 0; i < numOfIterations; i++) {
        operations.add(makeDeposit(i, depositAmount));
      }

      await Future.wait(operations);

      expect(balance == depositAmount * numOfIterations, true,
          reason:
              'with mutex lock and unlock, balance is safely updated to 50');
    });

    test('Multiple types atomic tests', () async {
      int voidBalance = 0;
      int balance = 0;
      double balanceDouble = 0.0;
      final mutex = UiStateMutex();

      // void mutex make deposit
      Future<void> makeVoidDeposit(int i, int deposit) async {
        // Random delay before updating starts
        await randomDelay();

        Future<void> future() async {
          final oldBalance = voidBalance;
          await randomDelay();

          voidBalance = oldBalance + depositAmount;

          debugPrint(
              '  [$i] added $depositAmount to $oldBalance -> $voidBalance');
        }
        // Acquire the mutex before running the critical section of code

        debugPrint('write lock for $i');
        await mutex.protect(future);

        debugPrint('unlocking $i');
      }

      // int mutex make deposit
      Future<void> makeIntDeposit(int i, int deposit) async {
        // Random delay before updating starts
        await randomDelay();

        Future<int> future() async {
          final oldBalance = balance;
          await randomDelay();

          balance = oldBalance + depositAmount;

          debugPrint('  [$i] added $depositAmount to $oldBalance -> $balance');
          return balance;
        }
        // Acquire the mutex before running the critical section of code

        debugPrint('write lock for $i');
        await mutex.protect<int>(future);

        debugPrint('unlocking $i');
      }

      // double mutex make deposit
      Future<void> makeDoubleDeposit(int i, int deposit) async {
        // Random delay before updating starts
        await randomDelay();

        Future<double> future() async {
          final oldBalance = balanceDouble;
          await randomDelay();

          balanceDouble = oldBalance + depositAmount;

          debugPrint(
              '  [$i] added $depositAmount to $oldBalance -> $balanceDouble');
          return balanceDouble;
        }
        // Acquire the mutex before running the critical section of code

        debugPrint('write lock for $i');
        await mutex.protect<double>(future);

        debugPrint('unlocking $i');
      }

      final operations = <Future>[];

      for (var i = 0; i < numOfIterations; i++) {
        operations.addAll([
          makeVoidDeposit(i, depositAmount),
          makeIntDeposit(i, depositAmount),
          makeDoubleDeposit(i, depositAmount),
        ]);
      }

      await Future.wait(operations);

      expect(voidBalance == depositAmount * numOfIterations, true,
          reason:
              'with mutex lock and unlock, void-balance is safely updated to 50');
      expect(balance == depositAmount * numOfIterations, true,
          reason:
              'with mutex lock and unlock, void-balance is safely updated to 50');
      expect(balanceDouble == depositAmount * numOfIterations, true,
          reason:
              'with mutex lock and unlock, void-balance is safely updated to 50');

      expect(mutex.atomsCleared, true,
          reason: 'Confirm all atoms are cleared from memory');
    });
  });
}
