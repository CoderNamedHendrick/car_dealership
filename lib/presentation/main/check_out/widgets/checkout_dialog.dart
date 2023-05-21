import 'package:car_dealership/presentation/core/widgets/text_field.dart';
import 'package:car_dealership/presentation/main/check_out/widgets/cancel_payment_dialog.dart';
import 'package:flutter/material.dart';

import '../../../core/common.dart';

Future<void> showCheckoutDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CheckoutDialog(),
  );
}

class CheckoutDialog extends StatelessWidget {
  const CheckoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
        child: Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filledTonal(
                    onPressed: () async {
                      final closePayment = await showCancelPaymentAlert(context);

                      if (context.mounted) {
                        if (closePayment) Navigator.of(context).pop();
                      }
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                  ),
                ),
                Constants.verticalGutter,
                Flexible(
                  child: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    tween: Tween<double>(begin: 0.95, end: 1),
                    builder: (context, progress, child) => Transform.scale(
                      scale: progress,
                      alignment: Alignment.center,
                      child: child!,
                    ),
                    child: AnimatedPhysicalModel(
                      duration: Constants.mediumAnimationDur,
                      shape: BoxShape.rectangle,
                      elevation: 0.8,
                      shadowColor: Colors.black38,
                      curve: Curves.ease,
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
                      child: Padding(
                        padding: const EdgeInsets.all(Constants.horizontalMargin),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
                                    ),
                                    child: const FlutterLogo(
                                      textColor: Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Email',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Pay ',
                                            style: Theme.of(context).textTheme.bodySmall,
                                            children: [
                                              TextSpan(text: 'price', style: Theme.of(context).textTheme.labelLarge),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Constants.verticalGutter18,
                              Text(
                                'Enter your card details to pay',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              Constants.verticalGutter,
                              DealershipTextField(
                                label: 'CARD NUMBER',
                                hintText: '0000 0000 0000 0000',
                                suffix: const Icon(Icons.credit_card),
                                onChanged: (value) {},
                              ),
                              Constants.verticalGutter,
                              Row(
                                children: [
                                  Expanded(
                                    child: DealershipTextField(
                                      label: 'CARD EXPIRY',
                                      hintText: '12/21',
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  Constants.horizontalGutter,
                                  Expanded(
                                    child: DealershipTextField(
                                      label: 'CVV',
                                      hintText: '***',
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                              Constants.verticalGutter,
                              MaterialButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                },
                                color: Theme.of(context).colorScheme.primaryContainer,
                                child: const Text('Pay price'),
                              ),
                              Constants.verticalGutter18,
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodySmall,
                                  children: const [
                                    WidgetSpan(child: Icon(Icons.lock, size: 14)),
                                    TextSpan(text: 'Secured by'),
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.labelLarge,
                                  children: const [
                                    WidgetSpan(child: FlutterLogo(size: 18)),
                                    TextSpan(text: 'Flutter Card Provider'),
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
