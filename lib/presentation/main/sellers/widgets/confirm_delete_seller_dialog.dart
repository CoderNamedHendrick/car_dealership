import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteSellerAlert(BuildContext context, String sellerName) async {
  return await showDialog(context: context, builder: (_) => _DialogView(sellerName: sellerName)) ?? false;
}

class _DialogView extends StatelessWidget {
  const _DialogView({required this.sellerName});
  final String sellerName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Seller'),
      content: Text('Are you sure you want to delete $sellerName? This action cannot be reverted.'),
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
