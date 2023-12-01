import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteCarListingAlert(BuildContext context, String car) async {
  return await showDialog(context: context, builder: (_) => _DialogView(car: car)) ?? false;
}

class _DialogView extends StatelessWidget {
  const _DialogView({required this.car});
  final String car;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Listing'),
      content: Text('Are you sure you want to delete $car from the listings? This action cannot be reverted.'),
      actions: [
        TextButton(
          onPressed: () {
            if (!context.mounted) return;
            Navigator.of(context).pop(true);
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () async {
            if (!context.mounted) return;
            Navigator.of(context).pop(false);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}
