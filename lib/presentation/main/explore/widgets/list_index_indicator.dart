import 'package:flutter/material.dart';
import '../../../core/common.dart';

class ListIndexIndicator extends StatelessWidget {
  const ListIndexIndicator({Key? key, required this.length, int index = 0})
      : _currentIndex = index,
        super(key: key);
  final int length;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4.0,
      children: List.generate(
        length,
        (index) {
          final selected = index == _currentIndex;
          final size = selected ? 12.0 : 8.0;
          return AnimatedContainer(
            duration: Constants.shortAnimationDur,
            height: size,
            width: size,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color:
                  selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }
}
