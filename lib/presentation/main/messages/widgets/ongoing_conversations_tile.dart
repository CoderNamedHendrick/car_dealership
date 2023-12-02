import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';

import '../../../../domain/user/dtos/negotiation_dto.dart';
import 'package:flutter/material.dart';

class OngoingNegotiationsListTile extends StatefulWidget {
  const OngoingNegotiationsListTile(
      {super.key, required NegotiationDto model, this.tileOnTap})
      : _model = model;
  final NegotiationDto _model;
  final Function(CarListingDto)? tileOnTap;

  @override
  State<OngoingNegotiationsListTile> createState() =>
      _OngoingNegotiationsListTileState();
}

class _OngoingNegotiationsListTileState
    extends State<OngoingNegotiationsListTile> with MIntl {
  late final SellerDto seller;
  late final CarListingDto listing;

  @override
  void initState() {
    super.initState();

    seller = locator<ExploreHomeViewModel>()
        .sellersUiState
        .sellers
        .firstWhere((element) => element.id == widget._model.sellerId);

    final dto = locator<MessagesViewModel>()
        .state
        .listings
        .firstWhere((element) => element.id == widget._model.carId);

    listing = locator<PurchasesHomeViewModel>()
        .state
        .purchasedListings
        .firstWhere((element) => element.id == dto.id, orElse: () => dto);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.tileOnTap?.call(listing);
      },
      title: Text(seller.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: widget._model.chats.isEmpty
          ? null
          : Text(widget._model.chats.last.message,
              style: Theme.of(context).textTheme.bodySmall),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vehicle: ${listing.make} ${listing.model}'),
          Text('Price: ${currencyFormat.format(widget._model.price)}'),
        ],
      ),
    );
  }
}
