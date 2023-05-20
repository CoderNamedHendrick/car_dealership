import 'package:car_dealership/application/application.dart';
import '../../../core/presentation_mixins/mixins.dart';
import 'package:flutter/material.dart';

class ListingTile extends StatelessWidget with MIntl {
  const ListingTile({Key? key, required CarListingDto listingDto, this.listingOnTap})
      : _listingModel = listingDto,
        super(key: key);
  final CarListingDto _listingModel;
  final Function(CarListingDto)? listingOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        listingOnTap?.call(_listingModel);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Text(_listingModel.make),
      subtitle: Text(_listingModel.model),
      trailing: Text(currencyFormat.format(_listingModel.price)),
    );
  }
}
