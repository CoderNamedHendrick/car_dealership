import 'package:flutter/material.dart';

import '../../../core/common.dart';

Future<bool> showCancelPaymentAlert(BuildContext context) async {
  return await showDialog(context: context, builder: (_) => const CancelPaymentAlert()) ?? false;
}

class CancelPaymentAlert extends StatelessWidget {
  const CancelPaymentAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
          child: PhysicalModel(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
            child: Padding(
              padding: const EdgeInsets.all(Constants.horizontalMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Do you want to cancel payment?', style: Theme.of(context).textTheme.labelLarge),
                  Constants.verticalGutter,
                  ButtonBar(
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Text('NO'),
                      ),
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Text('YES'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
