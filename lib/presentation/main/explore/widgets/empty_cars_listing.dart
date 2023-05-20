import 'package:flutter/material.dart';

class EmptyCarListing extends StatelessWidget {
  const EmptyCarListing({Key? key, this.customMessage}) : super(key: key);
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelMedium,
          children: [
            TextSpan(text: '🚗\n', style: Theme.of(context).textTheme.displayLarge),
            TextSpan(text: customMessage ?? 'No cars available'),
          ],
        ),
      ),
    );
  }
}
