import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import 'package:car_dealership/presentation/core/widgets/keyboard_overlay_helper.dart';
import 'package:car_dealership/presentation/core/widgets/text_fields.dart';
import 'package:car_dealership/presentation/main/checkout/widgets/checkout_overlay_loader.dart';
import 'package:car_dealership/presentation/main/checkout/widgets/checkout_text_fields.dart';
import 'package:car_dealership/utility/signals_extension.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../../../core/common.dart';
import 'cancel_payment_dialog.dart';

Future<bool> showCheckoutDialog(BuildContext context,
    {required CheckoutConfigDto config}) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CheckoutDialog(config: config),
      ) ??
      false;
}

class _CheckoutDialog extends StatelessWidget {
  const _CheckoutDialog();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin),
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

class _DialogPage extends StatefulWidget {
  const _DialogPage();

  @override
  State<_DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<_DialogPage> {
  late CheckoutViewModel _viewModel;
  late Function() disposeEmitted;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<CheckoutViewModel>();
    disposeEmitted = _viewModel.emitter.onSignalUpdate((prev, current) {
      if (current.currentState == ViewState.success) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutOverlayLoader(
      loading:
          _viewModel.emitter.watch(context).currentState == ViewState.loading,
      child: AnimatedPhysicalModel(
        duration: Constants.mediumAnimationDur,
        shape: BoxShape.rectangle,
        elevation: 0.8,
        shadowColor: Colors.black38,
        curve: Curves.ease,
        color: Theme.of(context).colorScheme.surface,
        borderRadius:
            const BorderRadius.all(Radius.circular(Constants.borderRadius)),
        child: const Padding(
          padding: EdgeInsets.all(Constants.horizontalMargin),
          child: SingleChildScrollView(child: _CheckoutForm()),
        ),
      ),
    );
  }
}

class _CheckoutForm extends StatelessWidget with MIntl {
  const _CheckoutForm();

  @override
  Widget build(BuildContext context) {
    final checkoutVM = locator<CheckoutViewModel>();

    return Watch((_) {
      return Form(
        autovalidateMode: checkoutVM.state.showFormErrors
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Constants.borderRadius)),
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
                          checkoutVM.state.config.user.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Pay ',
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              TextSpan(
                                text: currencyFormat.format(checkoutVM
                                        .state.config.price ??
                                    checkoutVM.state.config.carListing.price),
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
              CardNumberTextField(
                label: 'CARD NUMBER',
                onChanged: checkoutVM.cardNumberOnChanged,
                validator: (_) => checkoutVM
                    .state.checkoutForm.cardNumber.failureOrNone
                    .fold(() => null, (value) => value.message),
                onEditingComplete: FocusScope.of(context).nextFocus,
                downArrowOnPressed: FocusScope.of(context).nextFocus,
              ),
              Constants.verticalGutter,
              Row(
                children: [
                  Expanded(
                    child: CardExpiryTextField(
                      label: 'CARD EXPIRY',
                      onChanged: checkoutVM.cardExpiryOnChanged,
                      validator: (_) => checkoutVM
                          .state.checkoutForm.cardExpiry.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      downArrowOnPressed: FocusScope.of(context).nextFocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                  ),
                  Constants.horizontalGutter,
                  Expanded(
                    child: NumberTextField(
                      label: 'CVV',
                      hintText: '***',
                      maxLength: 3,
                      onChanged: checkoutVM.cvvOnChanged,
                      validator: (_) => checkoutVM
                          .state.checkoutForm.cvv.failureOrNone
                          .fold(() => null, (value) => value.message),
                      onEditingComplete: FocusScope.of(context).unfocus,
                      upArrowOnPressed: FocusScope.of(context).previousFocus,
                    ),
                  ),
                ],
              ),
              Constants.verticalGutter,
              MaterialButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  checkoutVM.payOnTap();
                },
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                    'Pay ${currencyFormat.format(checkoutVM.state.config.price ?? checkoutVM.state.config.carListing.price)}'),
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
              KeyboardOverlayDistance(
                  height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      );
    });
  }
}

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key, required this.config});

  final CheckoutConfigDto config;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      locator<CheckoutViewModel>().initialiseConfig(widget.config);

      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _CheckoutDialog();
  }
}
