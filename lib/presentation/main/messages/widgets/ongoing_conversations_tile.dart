import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/presentation/core/presentation_mixins/mixins.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/user/dtos/negotiation_dto.dart';
import 'package:flutter/material.dart';

class OngoingNegotiationsListTile extends ConsumerStatefulWidget {
  const OngoingNegotiationsListTile({Key? key, required NegotiationDto model, this.tileOnTap})
      : _model = model,
        super(key: key);
  final NegotiationDto _model;
  final Function(CarListingDto)? tileOnTap;

  @override
  ConsumerState<OngoingNegotiationsListTile> createState() => _OngoingNegotiationsListTileState();
}

class _OngoingNegotiationsListTileState extends ConsumerState<OngoingNegotiationsListTile> with MIntl {
  late final SellerDto seller;
  late final CarListingDto listing;

  @override
  void initState() {
    super.initState();

    seller = ref
        .read(exploreHomeUiStateNotifierProvider.select((value) => value.sellersUiState))
        .sellers
        .firstWhere((element) => element.id == widget._model.sellerId);

    listing = ref
        .read(exploreHomeUiStateNotifierProvider.select((value) => value.listingUiState))
        .listing
        .firstWhere((element) => element.id == widget._model.carId);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.tileOnTap?.call(listing);
      },
      title: Text(seller.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(widget._model.chats.last.message, style: Theme.of(context).textTheme.bodySmall),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vehicle: ${listing.make} ${listing.model}'),
          Text('Price: ${currencyFormat.format(widget._model.price)}'),
        ],
      ),
    );
  }
}
