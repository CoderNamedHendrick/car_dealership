import 'package:car_dealership/application/application.dart';

import '../../domain/domain.dart';

export 'listing_ui_notifier_state.dart';

final class ListingViewModel extends DealershipViewModel {
  final CarListingInterface _carListingRepo;
  final ChatRepositoryInterface _chatRepo;

  ListingViewModel(this._carListingRepo, this._chatRepo);

  @override
  void dispose() {}
}
