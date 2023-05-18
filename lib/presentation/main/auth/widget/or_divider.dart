import 'package:flutter/material.dart';

import '../../../core/common.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: Constants.verticalGutter.height!),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Text(
              'Or',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
