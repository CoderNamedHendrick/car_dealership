import 'package:car_dealership/main.dart';
import 'package:signals/signals_flutter.dart';
import '../../../../application/application.dart';
import '../../../core/common.dart';
import '../../../core/presentation_mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'change_price_dialog.dart';

class ChangeNegotiationPriceTile extends StatelessWidget with MIntl {
  const ChangeNegotiationPriceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final negotiationViewModel = locator<NegotiationViewModel>();
    return Watch((_) {
      final negotiation = negotiationViewModel.state.currentNegotiation;
      return InkResponse(
        onTap: () async {
          final result = await showChangePriceDialog(context,
              currentPrice: negotiation.price);

          if (result == null) return;
          negotiationViewModel.updateNegotiationPrice(result);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin,
              vertical: Constants.verticalGutter.height!),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.white),
              text:
                  'Current Price: ${currencyFormat.format(negotiation.price)}. Tap to change',
            ),
          ),
        ),
      );
    });
  }
}
