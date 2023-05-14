import 'dart:math';

Future<void> pseudoFetchDelay() async {
  Future.delayed(Duration(seconds: Random().nextInt(4)));
}
