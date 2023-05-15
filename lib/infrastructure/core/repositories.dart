import 'user_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';

// serves as our user db
final userSigningProvider = StateProvider<SignUpDto?>((ref) {
  return null;
});

// serves as reviewed car listing db
final reviewedCarListingsProvider = StateProvider<List<CarReviewDto>>((ref) {
  return const [];
});

// serves as reviewed car listing db
final reviewedSellersProvider = StateProvider<List<SellerReviewDto>>((ref) {
  return const [];
});

final purchasedCarsListingProvider = StateProvider<List<PurchasedCarListingTable>>((ref) {
  return const [];
});
final savedCarsListingProvider = StateProvider<List<SavedCarsListingTable>>((ref) {
  return const [];
});
