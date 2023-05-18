import 'package:flutter/material.dart';

class EmptyMessages extends StatelessWidget {
  const EmptyMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelMedium,
          children: [
            TextSpan(text: '💬\n', style: Theme.of(context).textTheme.displayLarge),
            const TextSpan(text: 'No chats available'),
          ],
        ),
      ),
    );
  }
}
