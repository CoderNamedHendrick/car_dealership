import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/home.dart';

class EmptyPurchases extends StatelessWidget {
  const EmptyPurchases({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.labelMedium,
            children: [
              TextSpan(
                  text: '🛒\n',
                  style: Theme.of(context).textTheme.displayLarge),
              TextSpan(
                text: 'No purchases yet\n',
                children: [
                  WidgetSpan(
                    child: TextButton(
                      onPressed: () => bottomNavPageIndexSignal.value = 0,
                      child: Text(
                        'Explore listings',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
