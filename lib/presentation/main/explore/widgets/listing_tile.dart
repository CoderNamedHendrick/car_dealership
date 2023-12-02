import 'package:car_dealership/application/application.dart';
import 'package:car_dealership/main.dart';
import 'package:car_dealership/presentation/core/widgets/slide_to_delete_widget.dart';
import 'package:signals/signals_flutter.dart';
import '../../../core/presentation_mixins/mixins.dart';
import 'package:flutter/material.dart';

class ListingTile extends StatelessWidget with MIntl {
  const ListingTile(
      {super.key,
      required CarListingDto listingDto,
      this.listingOnTap,
      this.deleteOnPressed})
      : _listingModel = listingDto;
  final CarListingDto _listingModel;
  final Function(CarListingDto)? listingOnTap;
  final Function(BuildContext context)? deleteOnPressed;

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) {
        final isAdmin =
            locator<ProfileViewModel>().profileState.user?.isAdmin ?? false;

        return isAdmin
            ? SlideToDelete(deleteOnPressed: deleteOnPressed, child: child())
            : child();
      },
    );
  }

  Widget child() {
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
