import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import 'package:car_dealership/presentation/main/checkout/widgets/checkout_overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common.dart';
import '../../../core/widgets/text_field.dart';
import 'cancel_payment_dialog.dart';

Future<bool> showCheckoutDialog(BuildContext context, {required CheckoutConfigDto config}) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CheckoutDialog(config: config),
      ) ??
      false;
}

class _CheckoutDialog extends StatelessWidget {
  const _CheckoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
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
                  child: const _DialogPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogPage extends ConsumerWidget {
  const _DialogPage();

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(checkoutStateNotifierProvider.select((value) => value.currentState), (previous, next) {
      if (next == ViewState.success) Navigator.of(context).pop(true);
    });
    return CheckoutOverlayLoader(
      loading: ref.watch(checkoutStateNotifierProvider.select((value) => value.currentState)) == ViewState.loading,
      child: AnimatedPhysicalModel(
        duration: Constants.mediumAnimationDur,
        shape: BoxShape.rectangle,
        elevation: 0.8,
        shadowColor: Colors.black38,
        curve: Curves.ease,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(Constants.borderRadius)),
        child: const Padding(
          padding: EdgeInsets.all(Constants.horizontalMargin),
          child: SingleChildScrollView(child: _CheckoutForm()),
        ),
      ),
    );
  }
}

class _CheckoutForm extends ConsumerWidget with MIntl {
  const _CheckoutForm();

  @override
  Widget build(BuildContext context, ref) {
    final checkoutUiState = ref.watch(checkoutStateNotifierProvider);
    final config = ref.watch(checkoutStateNotifierProvider.select((value) => value.config));
    return Form(
      autovalidateMode: checkoutUiState.showFormErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: FocusTraversalGroup(
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
                        config.user.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Pay ',
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: currencyFormat.format(config.price ?? config.carListing.price),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
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
              onChanged: ref.read(checkoutStateNotifierProvider.notifier).cardNumberOnChanged,
              validator: (_) => ref
                  .read(checkoutStateNotifierProvider)
                  .checkoutForm
                  .cardNumber
                  .failureOrNone
                  .fold(() => null, (value) => value.message),
              onEditingComplete: FocusScope.of(context).nextFocus,
            ),
            Constants.verticalGutter,
            if (checkoutUiState.checkoutForm.cardNumber.isValid)
              TweenAnimationBuilder(
                tween: Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0)),
                duration: Constants.shortAnimationDur,
                curve: Curves.decelerate,
                builder: (_, progress, child) => Transform.translate(offset: progress, child: child!),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DealershipTextField(
                            label: 'CARD EXPIRY',
                            hintText: '12/21',
                            onChanged: ref.read(checkoutStateNotifierProvider.notifier).cardExpiryOnChanged,
                            validator: (_) => ref
                                .read(checkoutStateNotifierProvider)
                                .checkoutForm
                                .cardExpiry
                                .failureOrNone
                                .fold(() => null, (value) => value.message),
                            onEditingComplete: FocusScope.of(context).nextFocus,
                          ),
                        ),
                        Constants.horizontalGutter,
                        Expanded(
                          child: DealershipTextField(
                            label: 'CVV',
                            hintText: '***',
                            onChanged: ref.read(checkoutStateNotifierProvider.notifier).cvvOnChanged,
                            validator: (_) => ref
                                .read(checkoutStateNotifierProvider)
                                .checkoutForm
                                .cvv
                                .failureOrNone
                                .fold(() => null, (value) => value.message),
                            onEditingComplete: FocusScope.of(context).unfocus,
                          ),
                        ),
                      ],
                    ),
                    Constants.verticalGutter,
                  ],
                ),
              ),
            MaterialButton(
              onPressed: () {
                FocusScope.of(context).unfocus();

                ref.read(checkoutStateNotifierProvider.notifier).payOnTap();
              },
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Text('Pay ${currencyFormat.format(config.price ?? config.carListing.price)}'),
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
    );
  }
}

class CheckoutDialog extends ConsumerStatefulWidget {
  const CheckoutDialog({Key? key, required this.config}) : super(key: key);
  final CheckoutConfigDto config;

  @override
  ConsumerState<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends ConsumerState<CheckoutDialog> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.read(checkoutStateNotifierProvider.notifier).initialiseConfig(widget.config);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _CheckoutDialog();
  }
}
