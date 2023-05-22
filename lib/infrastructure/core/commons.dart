import 'dart:math';

Future<void> pseudoFetchDelay() async {
  await Future.delayed(Duration(seconds: Random().nextInt(3) + 1));
}
