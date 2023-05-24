// coverage:ignore-file
import 'user_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';

// serves as our user db
final userSigningProvider = StateProvider<SignUpDto?>((ref) {
  return null;
});

final usersSigningProfilesProvider = StateProvider<List<SignUpDto>>((ref) {
  return [];
});

// serves as reviewed car listing db
final reviewedCarListingsProvider = StateProvider<List<CarReviewDto>>((ref) {
  return [];
});

// serves as reviewed car listing db
final reviewedSellersProvider = StateProvider<List<SellerReviewDto>>((ref) {
  return [];
});

final purchasedCarsListingProvider = StateProvider<List<PurchasedCarListingTable>>((ref) {
  return [];
});
final savedCarsListingProvider = StateProvider<List<SavedCarsListingTable>>((ref) {
  return [];
});
