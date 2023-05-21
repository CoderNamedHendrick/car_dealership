import 'package:car_dealership/presentation/core/common.dart';
import 'package:car_dealership/presentation/core/widgets/car_loader.dart';
import 'package:flutter/material.dart';

class PurchaseSuccessPage extends StatelessWidget {
  const PurchaseSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vehicle Purchased Successfully',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.surface),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.verticalGutter.height!),
                child: const CarLoader(),
              ),
              MaterialButton(
                onPressed: Navigator.of(context).pop,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
