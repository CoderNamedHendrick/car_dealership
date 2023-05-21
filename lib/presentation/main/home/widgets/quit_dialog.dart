import 'package:flutter/material.dart';

Future<bool> showQuitAppAlert(BuildContext context) async {
  return await showDialog<bool?>(context: context, builder: (_) => const _QuitAppAlert()) ?? false;
}

class _QuitAppAlert extends StatelessWidget {
  const _QuitAppAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit App'),
      content: const Text('Are you sure you want to quit?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes')),
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
      ],
    );
  }
}
