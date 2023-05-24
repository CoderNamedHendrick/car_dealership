import 'package:car_dealership/presentation/core/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import '../../../core/common.dart';

Future<double?> showChangePriceDialog(BuildContext context, {required double currentPrice}) async {
  return await showDialog(context: context, builder: (_) => ChangePriceDialog(currentPrice: currentPrice));
}

class ChangePriceDialog extends StatefulWidget {
  const ChangePriceDialog({Key? key, required this.currentPrice}) : super(key: key);
  final double currentPrice;

  @override
  State<ChangePriceDialog> createState() => _ChangePriceDialogState();
}

class _ChangePriceDialogState extends State<ChangePriceDialog> {
  late final priceController = TextEditingController(text: widget.currentPrice.toString());

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
        child: Align(
          child: PhysicalModel(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
            child: Padding(
              padding: const EdgeInsets.all(Constants.horizontalMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Update negotiation price', style: Theme.of(context).textTheme.titleMedium),
                  Constants.verticalGutter,
                  NumberTextField(
                    prefix: const IconButton(icon: Text('\$'), onPressed: null),
                    controller: priceController,
                  ),
                  Constants.verticalGutter,
                  ButtonBar(
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(double.tryParse(priceController.text)),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Text('Update Price'),
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
