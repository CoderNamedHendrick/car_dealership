// coverage:ignore-file
import 'package:signals/signals.dart';

import 'user_table.dart';
import '../../domain/domain.dart';

// serves as our user db
final userSigningSignal = signal<SignUpDto?>(null);

final usersSigningProfilesSignal = listSignal<SignUpDto>([]);

// serves as reviewed car listing db
final reviewedCarListingsSignal = listSignal<CarReviewDto>([]);

// serves as reviewed car listing db
final reviewedSellersSignal = listSignal<SellerReviewDto>([]);

final purchasedCarsListingSignal = listSignal<PurchasedCarListingTable>([]);

final savedCarsListingSignal = listSignal<SavedCarsListingTable>([]);
