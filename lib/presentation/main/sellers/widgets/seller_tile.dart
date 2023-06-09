import 'package:car_dealership/application/application.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';

class SellerTile extends StatelessWidget {
  const SellerTile({
    Key? key,
    required this.seller,
    this.deleteOnPressed,
  }) : super(key: key);
  final SellerDto seller;
  final Function(BuildContext)? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return SlideToDelete(
      deleteOnPressed: deleteOnPressed,
      child: ListTile(
        title: Text(
          seller.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
